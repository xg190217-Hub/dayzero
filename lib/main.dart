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

  final prefs = await SharedPreferences.getInstance();
  final audio = AudioService();
  final iap = IapService();
  final notifications = NotificationService();

  // Open the database per platform. Web uses the main-thread ffi factory
  // (no worker / COOP-COEP server needed); desktop uses winsqlite3 via ffi.
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
