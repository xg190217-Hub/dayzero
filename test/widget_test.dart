import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dayzero/src/app.dart';
import 'package:dayzero/src/models/habit.dart';
import 'package:dayzero/src/screens/checkin_screen.dart';
import 'package:dayzero/src/db/database.dart';
import 'package:dayzero/src/services/audio_service.dart';
import 'package:dayzero/src/services/iap_service.dart';
import 'package:dayzero/src/services/notifications.dart';
import 'package:dayzero/src/state/app_state.dart';

/// Functional widget tests.
///
/// Two recipes from the previous projects, wired in from the start:
///  - All database work runs inside tester.runAsync(): the FakeAsync test
///    clock would otherwise deadlock the ffi database.
///  - The clock is fixed so day-based rendering never drifts across runs.
///  - pumpAndSettle is avoided around busy spinners (infinite animations).
void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  Future<AppState> makeState(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await tester.runAsync(SharedPreferences.getInstance);
    final db = (await tester.runAsync(() => openAppDatabase(
        inMemoryDatabasePath,
        factory: databaseFactoryFfi)))!;
    // sqflite reuses open databases per path — close it so tests never
    // share one :memory: store.
    addTearDown(() async {
      await tester.runAsync(db.close);
    });
    final state = AppState(
      db: db,
      prefs: prefs!,
      clock: () => DateTime(2026, 9, 19, 20, 0),
    );
    await tester.runAsync(state.load);
    return state;
  }

  Widget wrap(AppState state) {
    final audio = FakeAudioService();
    final iap = IapService(enabled: false);
    final notifications = NotificationService(enabled: false);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        Provider<AudioService>.value(value: audio),
        ChangeNotifierProvider<IapService>.value(value: iap),
        Provider<NotificationService>.value(value: notifications),
      ],
      child: const DayZeroApp(),
    );
  }

  /// Dismisses the milestone celebration dialog that pops up right after a
  /// habit is added (the "first hour" badge unlocks immediately).
  Future<void> dismissCelebration(WidgetTester tester) async {
    await tester.pumpAndSettle();
    if (find.text('Done').evaluate().isNotEmpty) {
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
    }
  }

  /// Phone-sized viewport so whole screens (including bottom buttons) are
  /// built by lazy ListViews.
  void usePhoneView(WidgetTester tester) {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('fresh install shows onboarding', (tester) async {
    final state = await makeState(tester);
    await tester.pumpWidget(wrap(state));
    await tester.pumpAndSettle();

    expect(find.text('A fresh start begins today'), findsOneWidget);
    expect(find.textContaining('quit'), findsWidgets);
  });

  testWidgets('habit shows on home screen with day counter', (tester) async {
    usePhoneView(tester);
    final state = await makeState(tester);
    await tester.runAsync(() => state.addHabit(
          type: HabitType.alcohol,
          name: 'Alcohol',
          quitDate: DateTime(2026, 9, 16),
          dailySpend: 10,
        ));
    await tester.pumpWidget(wrap(state));
    await dismissCelebration(tester);

    // No check-ins yet → the run timer shows 0:00:00 and invites the
    // first check-in.
    expect(find.text('0h 0m 0s'), findsOneWidget);
    expect(find.text('Check in to start your timer'), findsOneWidget);
    // Money saved = 3 × 10.
    expect(find.textContaining('saved'), findsOneWidget);
  });

  testWidgets('check-in flow persists to the database', (tester) async {
    usePhoneView(tester);
    final state = await makeState(tester);
    await tester.runAsync(() => state.addHabit(
          type: HabitType.smoking,
          name: 'Smoking',
          quitDate: DateTime(2026, 9, 19),
        ));
    await tester.pumpWidget(wrap(state));
    await dismissCelebration(tester);

    // Open the check-in screen and save with defaults.
    await tester.tap(find.text('Check in today').first);
    await tester.pumpAndSettle();
    await dismissCelebration(tester);
    await tester.pumpAndSettle();
    expect(find.text('Daily check-in'), findsOneWidget,
        reason: 'check-in screen should be open');
    // The save button sits below the fold of the lazy ListView.
    final list = find.descendant(
      of: find.byType(CheckInScreen),
      matching: find.byType(Scrollable),
    );
    await tester.dragUntilVisible(
        find.text('Save'), list, const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    // Let the real database write finish (fake clock can't drive it).
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    // The live run timer ticks every second — pumpAndSettle would never
    // settle, so use fixed pumps and dismiss the milestone celebration.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    if (find.text('Done').evaluate().isNotEmpty) {
      await tester.tap(find.text('Done'));
      await tester.pump(const Duration(milliseconds: 300));
    }

    expect(state.checkIns.length, 1);
    expect(state.checkIns.first.mood, 3);
    expect(state.checkIns.first.craving, 2);
  });
}

/// No-op audio: audioplayers has no host in flutter_test and a real player
/// would leave pending timers behind.
class FakeAudioService extends AudioService {
  @override
  Future<bool> init() async {
    status = AudioStatus.ready;
    return true;
  }

  @override
  Future<void> play(String assetPath) async {}

  @override
  Future<void> loop(String assetPath) async {}

  @override
  Future<void> stop() async {}
}
