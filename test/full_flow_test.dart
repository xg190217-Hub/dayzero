import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dayzero/src/app.dart';
import 'package:dayzero/src/db/database.dart';
import 'package:dayzero/src/models/check_in.dart';
import 'package:dayzero/src/models/habit.dart';
import 'package:dayzero/src/models/if_then_plan.dart';
import 'package:dayzero/src/screens/checkin_screen.dart';
import 'package:dayzero/src/services/audio_service.dart';
import 'package:dayzero/src/services/iap_service.dart';
import 'package:dayzero/src/services/notifications.dart';
import 'package:dayzero/src/state/app_state.dart';

/// Cross-feature sweep: every screen exercised through the real UI,
/// wired together the way a user actually walks the app.
///
/// Same recipes as widget_test.dart: DB work inside runAsync (the fake
/// test clock would deadlock ffi sqflite), a fixed injectable clock, and
/// fixed pumps instead of pumpAndSettle wherever an infinite animation or
/// the live run ticker is on screen. Long lists are lazy — every target
/// below the fold needs a dragUntilVisible first.
void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  /// Scrolls the on-stage vertical ListView so [target] is visible (lazy
  /// lists only build widgets near the viewport), then aligns it fully
  /// into the viewport so taps land. No-op when already visible. `.last`
  /// skips any horizontal selector ListView above it.
  Future<void> reveal(WidgetTester tester, Finder target,
      {bool up = false}) async {
    final step = Offset(0, up ? 300 : -300);
    for (var i = 0; i < 20 && target.evaluate().isEmpty; i++) {
      await tester.drag(find.byType(ListView).last, step);
      await tester.pump();
    }
    if (target.evaluate().isNotEmpty) {
      await tester.ensureVisible(target.first);
      await tester.pump();
    }
  }

  /// Pops the topmost route directly (finding the right "Back" tooltip is
  /// ambiguous when two pushed routes both contribute one).
  Future<void> goBack(WidgetTester tester) async {
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// The check-in screen's Save button sits below the fold: scroll to it,
  /// tap it, let the real DB write finish, then dismiss whatever dialog
  /// pops up (SOS offer on craving ≥4, milestone celebration).
  Future<void> saveCheckIn(WidgetTester tester,
      {int mood = 3, bool cravingHigh = false, String? trigger,
      String? note}) async {
    await tester.tap(find.text('Check in today').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    if (mood != 3) {
      await tester.tap(find.byIcon(
          [Icons.sentiment_very_dissatisfied, Icons.sentiment_dissatisfied,
           Icons.sentiment_neutral, Icons.sentiment_satisfied,
           Icons.sentiment_very_satisfied][mood - 1]));
      await tester.pump();
    }
    if (cravingHigh) {
      // Default 2 → drag far right clamps to the maximum (5).
      await tester.drag(find.byType(Slider), const Offset(200, 0));
      await tester.pump();
    }
    if (trigger != null) {
      await tester.tap(find.text(trigger));
      await tester.pump();
    }
    final list = find.descendant(
      of: find.byType(CheckInScreen),
      matching: find.byType(Scrollable),
    );
    if (note != null) {
      // The note field sits near the fold of the lazy ListView — scroll it
      // into existence before typing.
      await tester.dragUntilVisible(
          find.byType(TextField), list, const Offset(0, -200));
      await tester.pump();
      await tester.enterText(find.byType(TextField).last, note);
      await tester.pump();
    }
    await tester.dragUntilVisible(
        find.text('Save'), list, const Offset(0, -300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Save'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // A strong craving offers the SOS screen; decline it here.
    if (find.text('That craving looks strong. Need help right now?')
        .evaluate()
        .isNotEmpty) {
      await tester.tap(find.text('Cancel'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }
    // Milestone celebration dialog.
    for (var i = 0; i < 2 && find.text('Done').evaluate().isNotEmpty; i++) {
      await tester.tap(find.text('Done'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  testWidgets(
      'full journey: onboarding → check-in → tabs → stats → milestones → '
      'settings → paywall → relapse → SOS → delete',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final prefs = await tester.runAsync(SharedPreferences.getInstance);
    final db = (await tester.runAsync(() => openAppDatabase(
        inMemoryDatabasePath,
        factory: databaseFactoryFfi)))!;
    addTearDown(() async {
      await tester.runAsync(db.close);
    });
    final now = DateTime(2026, 9, 22, 14, 0);
    final state = AppState(db: db, prefs: prefs!, clock: () => now);
    await tester.runAsync(state.load);
    final audio = FakeAudioService();
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        Provider<AudioService>.value(value: audio),
        ChangeNotifierProvider<IapService>.value(
            value: IapService(enabled: false)),
        Provider<NotificationService>.value(
            value: NotificationService(enabled: false)),
      ],
      child: const DayZeroApp(),
    ));
    await tester.pumpAndSettle();

    // ---- Onboarding: welcome → choose → date → spend → reasons.
    expect(find.text('A fresh start begins today'), findsOneWidget);
    await tester.tap(find.text('Start my journey'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('What do you want to quit?'), findsOneWidget);
    await tester.tap(find.text('Alcohol')); // deselect the preset
    await tester.tap(find.text('Smoking'));
    await tester.pump();
    await tester.tap(find.text('My own habit'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Gaming');
    await tester.tap(find.text('Start my journey'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('When is your quit day?'), findsOneWidget);
    await tester.tap(find.text('Today'));
    await tester.pump();
    await tester.tap(find.text('Start my journey'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('How much did it cost you?'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '20');
    await tester.tap(find.text('Start my journey'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Why do you want to quit?'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'For my family');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'To save money');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.text('Start my journey'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pumpAndSettle();

    // ---- Home: two habits, idle timer, money chip.
    expect(find.textContaining('Check in to start your timer'), findsOneWidget);
    expect(find.text('Smoking'), findsOneWidget); // habit tab
    expect(find.text('Gaming'), findsOneWidget);
    expect(find.textContaining('saved'), findsOneWidget);
    expect(state.habits.length, 2);

    // ---- Check-in with high craving: SOS offer appears, declined.
    await saveCheckIn(tester,
        mood: 5, cravingHigh: true, trigger: 'Stress', note: 'Tough day');
    expect(state.checkIns.length, 1);
    expect(state.checkIns.first.mood, 5);
    expect(state.checkIns.first.craving, 5);
    expect(state.checkIns.first.trigger, 'trigger_stress');
    expect(state.checkIns.first.note, 'Tough day');
    expect(find.textContaining('Check in to start your timer'), findsNothing);
    expect(find.text("Edit today's check-in"), findsOneWidget);

    // ---- Habit tabs switch the counter (Gaming still idle).
    await tester.tap(find.text('Gaming'));
    await tester.pump();
    expect(find.textContaining('Check in to start your timer'), findsOneWidget);
    await tester.tap(find.text('Smoking'));
    await tester.pump();
    expect(find.text("Edit today's check-in"), findsOneWidget);

    // ---- Stats: 30-day view, then the locked trigger teaser below.
    await tester.tap(find.text('Your progress'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('7-day view'), findsOneWidget);
    await tester.tap(find.text('30-day view'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await reveal(tester, find.text('Top triggers'));
    expect(find.text('Top triggers'), findsOneWidget);
    expect(find.text('Unlock trigger insights with Premium'), findsOneWidget);

    // ---- Milestones: first hour earned (quit date was this morning).
    await tester.tap(find.text('Milestones'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Unlocked'), findsOneWidget);
    expect(find.text('Coming up'), findsOneWidget);

    // ---- Settings, top to bottom: paywall → currency → delete habit →
    // plans → reasons → notifications → delete all.
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('My habits'), findsOneWidget);

    // Paywall from the settings upsell card.
    await tester.tap(find.text('DayZero Premium'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Unlimited habits'), findsOneWidget);
    expect(find.text('Trigger insights: see what tempts you most'),
        findsOneWidget);
    expect(find.text('Weekly'), findsOneWidget);
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('Yearly'), findsOneWidget);
    await reveal(tester, find.text('Lifetime'));
    expect(find.text('Lifetime'), findsOneWidget);
    await tester.tap(find.text('Lifetime'));
    await tester.pump();
    await reveal(tester, find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await reveal(tester, find.text('Restore purchases'));
    await tester.tap(find.text('Restore purchases'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('Web demo mode'), findsOneWidget);
    await goBack(tester);
    // Let the demo-mode snackbar expire so it never covers list items.
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(milliseconds: 600));

    // Currency dropdown (habits section, near the top).
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text(r'$').last);
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump();
    expect(state.currencySymbol, r'$');

    // Delete the Gaming habit.
    await reveal(tester, find.widgetWithText(ListTile, 'Gaming'), up: true);
    await tester.tap(find.descendant(
      of: find.widgetWithText(ListTile, 'Gaming'),
      matching: find.byIcon(Icons.delete_outline),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Delete this habit and all its history?'),
        findsOneWidget);
    await tester.tap(find.text('Confirm'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(state.habits.length, 1);

    // Add an if-then coping plan.
    await reveal(tester, find.text('Add a plan'));
    await tester.pump();
    await tester.tap(find.text('Add a plan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byType(TextField).last, 'go for a walk');
    await tester.tap(find.text('Save'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(state.plans.length, 1);
    await reveal(tester, find.textContaining('go for a walk'), up: true);
    expect(find.textContaining('go for a walk'), findsOneWidget);

    // Remove a reason.
    await reveal(tester, find.widgetWithText(ListTile, 'For my family'));
    await tester.pump();
    await tester.tap(find.descendant(
      of: find.widgetWithText(ListTile, 'For my family'),
      matching: find.byIcon(Icons.close),
    ));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump();
    expect(state.reasons, ['To save money']);

    // Notification switch.
    await reveal(tester, find.byType(SwitchListTile));
    await tester.pump();
    await tester.tap(find.byType(SwitchListTile));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump();
    expect(state.notificationsEnabled, isFalse);

    // ---- Relapse: restart path clears today's check-in and idles.
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('DayZero'),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // The relapse button sits at the bottom of the home list.
    await reveal(tester, find.text('I slipped'));
    await tester.tap(find.text('I slipped'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Slipped?'), findsOneWidget);
    await tester.tap(find.text('Social occasions'));
    await tester.pump();
    await tester.tap(find.text('Record the slip and restart the counter'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // The home list was scrolled to the relapse button — scroll back up
    // so the counter card is built again.
    await reveal(tester, find.textContaining('Check in to start your timer'), up: true);
    expect(find.textContaining('Check in to start your timer'), findsOneWidget);
    expect(state.lapses.length, 1);
    expect(state.lapses.first.trigger, 'trigger_social');
    expect(state.habits.first.quitDate, now);

    // ---- Quick re-check-in right after the restart (the snackbar that
    // used to eat the Save tap is gone) and let the snackbar expire.
    await saveCheckIn(tester);
    expect(find.textContaining('Check in to start your timer'), findsNothing);
    expect(state.hasRunStarted(state.habits.first.id!), isTrue);
    await tester.pump(const Duration(seconds: 6));
    await tester.pump(const Duration(milliseconds: 600));

    // ---- SOS: patterns, free audio, locked ambient → paywall,
    // distraction game, urge surfing, plans & reasons cards.
    await tester.tap(find.text('Craving SOS'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    expect(find.text('Breathe with me'), findsOneWidget);
    expect(find.text('4-4-6 Calm'), findsOneWidget);
    expect(find.text('4-7-8 Deep'), findsOneWidget);
    expect(find.text('5-5 Balanced'), findsOneWidget);
    expect(find.text('4-4-4 Box'), findsOneWidget);
    await tester.tap(find.text('4-7-8 Deep'));
    await tester.pump();
    await tester.tap(find.byTooltip('Breathe with me'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // Ambient library is premium: free users get the paywall.
    await tester.tap(find.byIcon(Icons.lock_outline));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await reveal(tester, find.text('Restore purchases'));
    expect(find.text('Restore purchases'), findsOneWidget);
    await goBack(tester);
    // Distraction game: 10 taps finish it.
    await reveal(tester, find.text('Do it again'));
    await tester.pump();
    await tester.tap(find.text('Do it again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('taps left'), findsOneWidget);
    await reveal(tester, find.byIcon(Icons.touch_app));
    for (var i = 0; i < 10; i++) {
      await tester.tap(find.byIcon(Icons.touch_app));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(find.text('You made it through. The craving has passed.'),
        findsOneWidget);
    // Urge surfing view.
    await tester.tap(find.text('Ride the wave'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('taps left'), findsNothing);
    await tester.tap(find.text('90-second distraction'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // Coping plan and remaining reason are shown in the SOS context.
    await reveal(tester, find.textContaining('go for a walk'), up: true);
    expect(find.textContaining('go for a walk'), findsOneWidget);
    expect(find.textContaining('To save money'), findsOneWidget);
    // Done exits SOS.
    await reveal(tester, find.text('Done'));
    await tester.pump();
    await tester.tap(find.text('Done'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // ---- Stats trigger card CTA opens the paywall.
    await tester.tap(find.text('Your progress'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await reveal(tester, find.text('DayZero Premium'));
    await tester.pump();
    await tester.tap(find.text('DayZero Premium'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await reveal(tester, find.text('Restore purchases'));
    expect(find.text('Restore purchases'), findsOneWidget);
    await goBack(tester);

    // ---- Delete everything: back to onboarding.
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await reveal(tester, find.text('Delete all data'));
    await tester.pump();
    await tester.tap(find.text('Delete all data'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(
        find.text(
            'Delete ALL habits and their entire history? This cannot be undone.'),
        findsOneWidget);
    await tester.tap(find.text('Confirm'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(state.habits, isEmpty);
    expect(find.text('A fresh start begins today'), findsOneWidget);
  });

  testWidgets('premium (demo mode) unlocks habits, insights, ambient, themes',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({'demoMode': true});
    final prefs = await tester.runAsync(SharedPreferences.getInstance);
    final db = (await tester.runAsync(() => openAppDatabase(
        inMemoryDatabasePath,
        factory: databaseFactoryFfi)))!;
    addTearDown(() async {
      await tester.runAsync(db.close);
    });
    final now = DateTime(2026, 9, 19, 20, 0);
    final state = AppState(db: db, prefs: prefs!, clock: () => now);
    await tester.runAsync(state.load);
    await tester.runAsync(() => state.addHabit(
          type: HabitType.alcohol,
          name: 'Alcohol',
          quitDate: DateTime(2026, 9, 16),
          dailySpend: 10,
        ));
    await tester.runAsync(() => state.addHabit(
          type: HabitType.smoking,
          name: 'Smoking',
          quitDate: DateTime(2026, 9, 19),
        ));
    // Backdated history with triggers (the state API always stamps today).
    final alcoholId = state.habits.first.id!;
    for (final (date, trigger) in [
      ('2026-09-17', 'trigger_stress'),
      ('2026-09-18', 'trigger_social'),
      ('2026-09-19', 'trigger_stress'),
    ]) {
      await tester.runAsync(() => db.insert('check_ins', CheckIn(
            habitId: alcoholId,
            date: date,
            mood: 3,
            craving: 2,
            trigger: trigger,
          ).toRow()));
    }
    await tester.runAsync(state.load); // re-read from the DB
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        Provider<AudioService>.value(value: FakeAudioService()),
        ChangeNotifierProvider<IapService>.value(
            value: IapService(enabled: false)),
        Provider<NotificationService>.value(
            value: NotificationService(enabled: false)),
      ],
      child: const DayZeroApp(),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(state.isPremium, isTrue);

    // ---- Stats: trigger insights show real data, no lock.
    await tester.tap(find.text('Your progress'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await reveal(tester, find.text('Top triggers'));
    expect(find.text('Top triggers'), findsOneWidget);
    expect(find.textContaining('Stress'), findsOneWidget);
    expect(find.text('Unlock trigger insights with Premium'), findsNothing);

    // ---- Third habit via the + button (premium removes the cap).
    await tester.tap(find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('DayZero'),
    ));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Sugar'));
    await tester.pump();
    await tester.tap(find.text('Start my journey'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Today'));
    await tester.pump();
    await tester.tap(find.text('Start my journey'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Start my journey')); // spend page: keep 0
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(state.habits.length, 3);

    // ---- SOS: the ambient library is unlocked.
    await tester.tap(find.text('Craving SOS'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.tap(find.byIcon(Icons.waves_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Music box'), findsOneWidget);
    expect(find.text('Rain'), findsOneWidget);
    expect(find.text('Ocean waves'), findsOneWidget);
    expect(find.text('Campfire'), findsOneWidget);
    await tester.tap(find.text('Rain'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(state.ambientCode, 'rain');
    expect(find.byIcon(Icons.waves), findsOneWidget); // now playing
    // Switching to a different sound keeps it playing (the button now shows
    // the playing Icons.waves, not the outlined idle one).
    await tester.tap(find.byIcon(Icons.waves));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Ocean waves'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(state.ambientCode, 'ocean');
    // Exit SOS.
    await reveal(tester, find.text('Done'));
    await tester.pump();
    await tester.tap(find.text('Done'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // ---- Settings: themes / fonts / text colors are visible and usable.
    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Themes'), findsOneWidget);
    expect(find.textContaining('Premium active'), findsOneWidget);
    await tester.tap(find.text('Ocean'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump();
    expect(state.themeCode, 'ocean');
    // Custom theme via the hue dialog.
    await tester.tap(find.text('Custom'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.drag(find.byType(Slider), const Offset(80, 0));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump();
    expect(state.themeCode, 'custom');
    // Font.
    await reveal(tester, find.text('Nunito'));
    await tester.pump();
    await tester.tap(find.text('Nunito'));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)));
    await tester.pump();
    expect(state.fontCode, 'nunito');
    await reveal(tester, find.text('Text color'));
    expect(find.text('Text color'), findsOneWidget);
  });

  testWidgets('settings and data survive a reload', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await tester.runAsync(SharedPreferences.getInstance);
    final db = (await tester.runAsync(() => openAppDatabase(
        inMemoryDatabasePath,
        factory: databaseFactoryFfi)))!;
    addTearDown(() async {
      await tester.runAsync(db.close);
    });
    final now = DateTime(2026, 9, 19, 20, 0);
    final state = AppState(db: db, prefs: prefs!, clock: () => now);
    await tester.runAsync(state.load);
    await tester.runAsync(() => state.addHabit(
          type: HabitType.alcohol,
          name: 'Alcohol',
          quitDate: DateTime(2026, 9, 18),
        ));
    await tester.runAsync(() => state.saveCheckIn(
          habit: state.habits.first,
          mood: 4,
          craving: 2,
          trigger: 'trigger_stress',
        ));
    await tester.runAsync(() => state.setPremium(true));
    await tester.runAsync(() => state.setTheme('ocean'));
    await tester.runAsync(() => state.setLocale('zh'));
    await tester.runAsync(() => state.setCurrency(r'$'));
    await tester.runAsync(() => state.setReasons(['For my family']));
    await tester.runAsync(() => state.setPlans([
          IfThenPlan(trigger: 'trigger_stress', action: 'go for a walk'),
        ]));
    await tester.runAsync(() => state.setNotifications(false));

    // A second AppState on the same store simulates a cold app restart.
    final reboot = AppState(db: db, prefs: prefs, clock: () => now);
    await tester.runAsync(reboot.load);

    expect(reboot.premium, isTrue);
    expect(reboot.themeCode, 'ocean');
    expect(reboot.localeCode, 'zh');
    expect(reboot.currencySymbol, r'$');
    expect(reboot.reasons, ['For my family']);
    expect(reboot.plans.length, 1);
    expect(reboot.plans.first.action, 'go for a walk');
    expect(reboot.notificationsEnabled, isFalse);
    expect(reboot.habits.length, 1);
    expect(reboot.checkIns.length, 1);
    expect(reboot.checkIns.first.trigger, 'trigger_stress');
    expect(reboot.unlocked, isNotEmpty); // 1h + 1d milestones persisted
  });

  testWidgets('language switch rebuilds the whole app', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final prefs = await tester.runAsync(SharedPreferences.getInstance);
    final db = (await tester.runAsync(() => openAppDatabase(
        inMemoryDatabasePath,
        factory: databaseFactoryFfi)))!;
    addTearDown(() async {
      await tester.runAsync(db.close);
    });
    final state = AppState(
        db: db, prefs: prefs!, clock: () => DateTime(2026, 9, 19, 20, 0));
    await tester.runAsync(state.load);
    await tester.runAsync(() => state.addHabit(
          type: HabitType.alcohol,
          name: 'Alcohol',
          quitDate: DateTime(2026, 9, 19),
        ));
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        Provider<AudioService>.value(value: FakeAudioService()),
        ChangeNotifierProvider<IapService>.value(
            value: IapService(enabled: false)),
        Provider<NotificationService>.value(
            value: NotificationService(enabled: false)),
      ],
      child: const DayZeroApp(),
    ));
    await tester.pumpAndSettle();

    await tester.runAsync(() => state.setLocale('zh'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('设置'), findsOneWidget); // nav destination
    expect(find.text('今日打卡'), findsOneWidget); // check-in button
    await tester.tap(find.text('设置'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await reveal(tester, find.text('语言'));
    expect(find.text('语言'), findsWidgets); // section header + tile title
    await reveal(tester, find.text('导出我的数据'));
    expect(find.text('导出我的数据'), findsOneWidget);
    expect(find.text('删除全部数据'), findsOneWidget);
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
