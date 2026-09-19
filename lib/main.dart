import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app.dart';
import 'src/db/database.dart';
import 'src/services/audio_service.dart';
import 'src/services/iap_service.dart';
import 'src/services/notifications.dart';
import 'src/state/app_state.dart';

Future<void> main() async {
  // First line of main(): every platform-channel call below depends on it.
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await _boot();
  } catch (e, stack) {
    // Boot failures must be VISIBLE, never a silent white screen.
    debugPrint('DayZero boot failed: $e\n$stack');
    runApp(BootErrorApp(error: e));
  }
}

Future<void> _boot() async {
  final prefs = await SharedPreferences.getInstance();
  final audio = AudioService();
  final iap = IapService();
  final notifications = NotificationService();

  // Open the database per platform. Web uses the main-thread ffi factory
  // (no worker / COOP-COEP server needed) and needs sqlite3.wasm served
  // next to index.html; desktop uses winsqlite3 via ffi.
  final db = await openAppDatabase(await _resolveDbPath());

  final state = AppState(db: db, prefs: prefs);
  await state.load();

  // Web demo: premium features are unlocked so the whole app can be
  // exercised without StoreKit.
  if (kIsWeb) {
    await state.setDemoMode(true);
  }

  // Initializations are observable and time-bounded; failures degrade to a
  // silent no-op instead of blocking the app.
  await Future.wait([
    audio.init(),
    iap.init(),
    notifications.init(),
  ]);

  // Re-assert the daily reminder if enabled (permission is requested at
  // onboarding completion; re-scheduling is idempotent and repairs the
  // schedule after reinstalls).
  if (!kIsWeb && state.notificationsEnabled) {
    await notifications.scheduleDaily();
  }

  iap.onGranted = (productId) async {
    await state.setPremium(true);
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        Provider<AudioService>.value(value: audio),
        Provider<IapService>.value(value: iap),
        Provider<NotificationService>.value(value: notifications),
      ],
      child: const DayZeroApp(),
    ),
  );
}

/// Rendered when boot throws — the user sees the failure instead of a blank
/// page (a boot screen with no error state cost us days on the last project).
class BootErrorApp extends StatelessWidget {
  const BootErrorApp({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text('DayZero failed to start',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> _resolveDbPath() async {
  if (kIsWeb) return 'dayzero_web.db';
  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux) {
    // Desktop dev: keep the ffi database in the working directory.
    return defaultDbPath('.');
  }
  // Mobile: sqflite's platform documents dir.
  final docs = await getApplicationDocumentsDirectory();
  return defaultDbPath(docs.path);
}
