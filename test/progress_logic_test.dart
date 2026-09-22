import 'package:flutter_test/flutter_test.dart';
import 'package:dayzero/src/logic/progress.dart';
import 'package:dayzero/src/models/check_in.dart';
import 'package:dayzero/src/models/habit.dart';

void main() {
  final today = DateTime(2026, 9, 19, 14, 30); // fixed clock, late afternoon

  Habit habit({int daysAgo = 0, double spend = 10}) => Habit(
        id: 1,
        type: HabitType.alcohol,
        name: 'Alcohol',
        quitDate: DateTime(2026, 9, 19 - daysAgo),
        dailySpend: spend,
      );

  group('daysBetween / daysFree', () {
    test('same day is zero days', () {
      expect(daysBetween(DateTime(2026, 9, 19), today), 0);
    });

    test('counts whole days, ignoring time of day', () {
      expect(daysBetween(DateTime(2026, 9, 17, 23, 59), today), 2);
      expect(daysBetween(DateTime(2026, 9, 17, 0, 1), today), 2);
    });

    test('future quit date clamps to zero', () {
      expect(daysFree(habit(daysAgo: -3), today), 0);
    });

    test('money saved multiplies full days', () {
      expect(moneySaved(habit(daysAgo: 10), today), 100);
      expect(moneySaved(habit(daysAgo: 0), today), 0);
    });
  });

  group('streaks', () {
    List<CheckIn> checkIns(List<String> dates) =>
        dates.map((d) => CheckIn(habitId: 1, date: d, mood: 3, craving: 1)).toList();

    test('current streak counts backwards from today', () {
      final cis = checkIns(['2026-09-19', '2026-09-18', '2026-09-17']);
      expect(currentStreak(cis, today), 3);
    });

    test('streak survives a missing today if yesterday exists', () {
      final cis = checkIns(['2026-09-18', '2026-09-17']);
      expect(currentStreak(cis, today), 2);
    });

    test('gap breaks the streak', () {
      final cis = checkIns(['2026-09-19', '2026-09-17']);
      expect(currentStreak(cis, today), 1);
    });

    test('best streak is the longest run anywhere', () {
      final cis = checkIns([
        '2026-09-10', '2026-09-11', '2026-09-12', // run of 3
        '2026-09-19',
      ]);
      expect(bestStreak(cis), 3);
    });

    test('empty history has zero streaks', () {
      expect(currentStreak(const [], today), 0);
      expect(bestStreak(const []), 0);
    });
  });

  group('weekly summary', () {
    test('averages mood and craving over the last 7 days', () {
      final cis = [
        CheckIn(habitId: 1, date: '2026-09-19', mood: 5, craving: 1),
        CheckIn(habitId: 1, date: '2026-09-18', mood: 1, craving: 5),
      ];
      final s = weeklySummary(cis, today);
      expect(s.checkInCount, 2);
      expect(s.avgMood, 3);
      expect(s.avgCraving, 3);
      expect(s.bestDay, DateTime(2026, 9, 19));
    });

    test('ignores entries older than 7 days', () {
      final cis = [CheckIn(habitId: 1, date: '2026-09-01', mood: 5, craving: 0)];
      expect(weeklySummary(cis, today).isEmpty, isTrue);
    });
  });

  group('trigger breakdown', () {
    CheckIn ci(String date, {String? trigger}) => CheckIn(
        habitId: 1, date: date, mood: 3, craving: 2, trigger: trigger);

    test('counts and sorts triggers, most frequent first', () {
      final cis = [
        ci('2026-09-17', trigger: 'trigger_stress'),
        ci('2026-09-18', trigger: 'trigger_social'),
        ci('2026-09-19', trigger: 'trigger_stress'),
      ];
      expect(triggerBreakdown(cis), [
        ('trigger_stress', 2),
        ('trigger_social', 1),
      ]);
    });

    test('missing trigger counts as trigger_none', () {
      expect(triggerBreakdown([ci('2026-09-19')]), [
        ('trigger_none', 1),
      ]);
    });

    test('empty history yields empty breakdown', () {
      expect(triggerBreakdown(const []), isEmpty);
    });
  });
}
