import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dayzero/src/db/database.dart';
import 'package:dayzero/src/logic/progress.dart';
import 'package:dayzero/src/models/habit.dart';
import 'package:dayzero/src/state/app_state.dart';

/// A clock that tests can advance: the run timer and milestone evaluation
/// both read from it, so time travel is trivial.
class MutableClock {
  MutableClock(this.value);
  DateTime value;
  DateTime call() => value;
}

void main() {
  setUpAll(sqfliteFfiInit);

  Future<(AppState, MutableClock)> makeState(
      {DateTime? start, double dailySpend = 0}) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = await openAppDatabase(inMemoryDatabasePath,
        factory: databaseFactoryFfi);
    // sqflite reuses open databases per path — without closing, tests would
    // share one :memory: store and leak achievements into each other.
    addTearDown(db.close);
    final clock = MutableClock(start ?? DateTime(2026, 9, 19, 0, 0));
    final state = AppState(db: db, prefs: prefs, clock: clock.call);
    await state.load();
    await state.addHabit(
      type: HabitType.alcohol,
      name: 'Alcohol',
      quitDate: clock.value,
      dailySpend: dailySpend,
    );
    return (state, clock);
  }

  Set<String> unlockedFor(AppState state, int habitId) =>
      state.unlocked[habitId] ?? const <String>{};

  group('run-start guard', () {
    test('no milestones before the first check-in', () async {
      final (state, _) = await makeState();
      expect(unlockedFor(state, state.habits.first.id!), isEmpty);
    });

    test('first check-in at t=0 unlocks nothing (not even 1h)', () async {
      final (state, clock) = await makeState();
      await state.saveCheckIn(habit: state.habits.first, mood: 3, craving: 2);
      expect(unlockedFor(state, state.habits.first.id!), isEmpty);
      // But the timer started: quitDate is now the exact check-in moment.
      expect(
          state.habits.first.quitDate.difference(clock.value).inSeconds.abs(),
          lessThan(2));
    });
  });

  group('time milestones', () {
    test('1 hour needs a real hour', () async {
      final (state, clock) = await makeState();
      await state.saveCheckIn(habit: state.habits.first, mood: 3, craving: 2);
      clock.value = clock.value.add(const Duration(minutes: 59));
      await state.saveCheckIn(habit: state.habits.first, mood: 3, craving: 2);
      expect(unlockedFor(state, state.habits.first.id!),
          isNot(contains('milestone_1h')));

      clock.value = clock.value.add(const Duration(minutes: 2));
      await state.saveCheckIn(habit: state.habits.first, mood: 3, craving: 2);
      expect(
          unlockedFor(state, state.habits.first.id!), contains('milestone_1h'));
    });

    test('day thresholds unlock at 1/3/7/14/30/90/180/365 days', () async {
      final (state, clock) = await makeState();
      final habit = state.habits.first;

      final cases = <(Duration, String)>[
        (const Duration(days: 1), 'milestone_1d'),
        (const Duration(days: 3), 'milestone_3d'),
        (const Duration(days: 7), 'milestone_1w'),
        (const Duration(days: 14), 'milestone_2w'),
        (const Duration(days: 30), 'milestone_1m'),
        (const Duration(days: 90), 'milestone_3m'),
        (const Duration(days: 180), 'milestone_6m'),
        (const Duration(days: 365), 'milestone_1y'),
      ];
      for (final (offset, key) in cases) {
        clock.value = DateTime(2026, 9, 19, 20, 0).add(offset);
        await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
        expect(unlockedFor(state, habit.id!), contains(key),
            reason: 'after $offset');
        // Nothing unlocks EARLY: a threshold must not appear before its time.
        if (key == 'milestone_1d') {
          expect(unlockedFor(state, habit.id!),
              isNot(contains('milestone_3d')));
        }
        if (key == 'milestone_1w') {
          expect(unlockedFor(state, habit.id!),
              isNot(contains('milestone_1m')));
        }
      }
    });

    test('1y unlocks only after a full year', () async {
      final (state, clock) = await makeState();
      final habit = state.habits.first;
      clock.value = DateTime(2026, 9, 19, 0, 0)
          .add(const Duration(days: 364));
      await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      expect(unlockedFor(state, habit.id!), isNot(contains('milestone_1y')));

      clock.value = DateTime(2026, 9, 19, 0, 0)
          .add(const Duration(days: 365));
      await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      expect(unlockedFor(state, habit.id!), contains('milestone_1y'));
    });
  });

  group('money milestones', () {
    test('100 / 1000 / 10000 saved', () async {
      final (state, clock) = await makeState(dailySpend: 10);
      final habit = state.habits.first;
      final cases = <(Duration, String)>[
        (const Duration(days: 10), 'milestone_money1'),
        (const Duration(days: 100), 'milestone_money2'),
        (const Duration(days: 1000), 'milestone_money3'),
      ];
      for (final (offset, key) in cases) {
        clock.value = DateTime(2026, 9, 19, 20, 0).add(offset);
        await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
        expect(unlockedFor(state, habit.id!), contains(key),
            reason: 'after $offset');
      }
    });
  });

  group('streak milestones', () {
    test('7 and 30 consecutive check-in days', () async {
      final (state, clock) = await makeState();
      final habit = state.habits.first;
      // 30 consecutive days ending Sep 19.
      for (var i = 0; i < 30; i++) {
        clock.value = DateTime(2026, 9, 19 - (29 - i), 20, 0);
        await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      }
      // Re-evaluate with the clock on the latest day (streaks count
      // backwards from "now").
      clock.value = DateTime(2026, 9, 19, 20, 0);
      await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      final set = unlockedFor(state, habit.id!);
      expect(set, contains('milestone_streak7'));
      expect(set, contains('milestone_streak30'));
    });

    test('streak milestone only counts consecutive days', () async {
      final (state, clock) = await makeState();
      final habit = state.habits.first;
      // 8 consecutive days ending Sep 19, then a gap, then older days.
      for (final day in [12, 13, 14, 15, 16, 17, 18, 19, 8, 9, 10]) {
        clock.value = DateTime(2026, 9, day, 20, 0);
        await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      }
      clock.value = DateTime(2026, 9, 19, 20, 0);
      await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      // Streak from Sep 19 backwards: 19..12 = 8 days (gap at 11).
      expect(unlockedFor(state, habit.id!),
          contains('milestone_streak7'));
      expect(unlockedFor(state, habit.id!),
          isNot(contains('milestone_streak30')));
    });
  });

  group('break and restart', () {
    test('check-in after a 24h+ gap restarts the timer from zero', () async {
      final (state, clock) = await makeState();
      final habit = state.habits.first;
      clock.value = DateTime(2026, 9, 19, 20, 0);
      await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      final firstRunStart = state.habits.first.quitDate;

      // 25 hours later: run is broken.
      clock.value = DateTime(2026, 9, 20, 21, 0);
      expect(state.isRunBroken(habit.id!), isTrue);

      // Fresh check-in restarts the timer at the new moment.
      await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      expect(state.habits.first.quitDate, isNot(firstRunStart));
      expect(state.isRunBroken(habit.id!), isFalse);
      // The 25h run earned 'first hour' — the badge SURVIVES the break
      // (it was truly earned), while the NEXT milestone's countdown
      // restarts from the new run (days reset to zero).
      final set = unlockedFor(state, habit.id!);
      expect(set, contains('milestone_1h'));
      expect(daysFree(state.habits.first, clock.value), 0);
    });

    test('relapse restart clears today and idles until the next check-in',
        () async {
      final (state, clock) = await makeState();
      final habit = state.habits.first;
      clock.value = DateTime(2026, 9, 19, 20, 0);
      await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      // Two days later the user lapses and restarts.
      clock.value = DateTime(2026, 9, 21, 10, 23);
      await state.saveCheckIn(habit: habit, mood: 2, craving: 4);
      await state.recordLapse(habit, trigger: 'trigger_stress');
      await state.resetQuitDate(habit);

      // Today's check-in is cleared → "check in today" shows again.
      expect(state.checkInToday(habit.id!), isNull);
      // The timer idles (not started) instead of ticking from 10:23.
      expect(state.hasRunStarted(habit.id!), isFalse);
      expect(daysFree(state.habits.first, clock.value), 0);

      // The NEXT check-in starts the new run at that exact moment.
      clock.value = DateTime(2026, 9, 21, 14, 0);
      await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      expect(state.hasRunStarted(habit.id!), isTrue);
      expect(state.habits.first.quitDate, DateTime(2026, 9, 21, 14, 0));
      expect(daysFree(state.habits.first, clock.value), 0);
    });

    test('relapse keep-going records the lapse and keeps the clock running',
        () async {
      final (state, clock) = await makeState();
      final habit = state.habits.first;
      clock.value = DateTime(2026, 9, 19, 20, 0);
      await state.saveCheckIn(habit: habit, mood: 3, craving: 2);
      final runStart = state.habits.first.quitDate;
      clock.value = DateTime(2026, 9, 20, 9, 0);
      await state.recordLapse(habit, trigger: 'trigger_social');
      // Timer keeps counting from the original run start.
      expect(state.habits.first.quitDate, runStart);
      expect(state.lapsesFor(habit.id!).length, 1);
      // 13 hours later but on the NEXT calendar day → 1 whole day counted.
      expect(daysFree(state.habits.first, clock.value), 1);
    });

    test('backdated quit date is NOT overridden by the first check-in',
        () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final db = await openAppDatabase(inMemoryDatabasePath,
          factory: databaseFactoryFfi);
      final clock = MutableClock(DateTime(2026, 9, 19, 20, 0));
      final state = AppState(db: db, prefs: prefs, clock: clock.call);
      await state.load();
      await state.addHabit(
        type: HabitType.smoking,
        name: 'Smoking',
        quitDate: DateTime(2026, 9, 10), // quit 9 days ago, on purpose
      );
      await state.saveCheckIn(habit: state.habits.first, mood: 3, craving: 2);
      // The quit date stays backdated: real progress is preserved.
      expect(state.habits.first.quitDate, DateTime(2026, 9, 10));
    });
  });
}
