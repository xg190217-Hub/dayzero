import '../models/check_in.dart';
import '../models/habit.dart';

/// Whole days from [start]'s calendar day to [end]'s calendar day (exclusive
/// end counts as "in progress" only once its day begins).
int daysBetween(DateTime start, DateTime end) {
  final s = DateTime(start.year, start.month, start.day);
  final e = DateTime(end.year, end.month, end.day);
  return e.difference(s).inDays;
}

/// Total days free for [habit] as of [now] (>= 0).
int daysFree(Habit habit, DateTime now) {
  final d = daysBetween(habit.quitDate, now);
  return d < 0 ? 0 : d;
}

/// Money saved: daily spend × full days free.
double moneySaved(Habit habit, DateTime now) =>
    daysFree(habit, now) * habit.dailySpend;

/// Current check-in streak: consecutive days ending today, or yesterday if
/// today's check-in hasn't happened yet (the streak is still alive).
int currentStreak(List<CheckIn> checkIns, DateTime now) {
  final days = checkIns.map((c) => c.date).toSet();
  var cursor = DateTime(now.year, now.month, now.day);
  if (!days.contains(CheckIn.dateKey(cursor))) {
    // Not checked in today: yesterday's run still counts.
    cursor = cursor.subtract(const Duration(days: 1));
  }
  var streak = 0;
  while (days.contains(CheckIn.dateKey(cursor))) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

/// Best streak ever across the full history.
int bestStreak(List<CheckIn> checkIns) {
  final days = checkIns.map((c) => c.date).toSet().toList()..sort();
  var best = 0;
  var run = 0;
  DateTime? prev;
  for (final key in days) {
    final date = DateTime.parse(key);
    if (prev != null &&
        date.difference(prev).inDays == 1) {
      run++;
    } else {
      run = 1;
    }
    if (run > best) best = run;
    prev = date;
  }
  return best;
}

/// Check-ins within the last [lookbackDays] calendar days (inclusive today).
List<CheckIn> recentCheckIns(
    List<CheckIn> checkIns, DateTime now, int lookbackDays) {
  final cutoff = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: lookbackDays - 1));
  return checkIns.where((c) {
    final date = DateTime.parse(c.date);
    return !date.isBefore(cutoff);
  }).toList();
}

/// Average of [pick] over check-ins within the window from
/// [endDaysAgo] days ago back to [endDaysAgo + windowDays] days ago.
/// Returns null when the window has no check-ins.
double? averageOver(
  List<CheckIn> checkIns,
  DateTime now, {
  required int endDaysAgo,
  required int windowDays,
  required double Function(CheckIn) pick,
}) {
  final start = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: endDaysAgo + windowDays - 1));
  final end = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: endDaysAgo));
  final values = <double>[];
  for (final c in checkIns) {
    final date = DateTime.parse(c.date);
    if (!date.isBefore(start) && !date.isAfter(end)) {
      values.add(pick(c));
    }
  }
  if (values.isEmpty) return null;
  return values.reduce((a, b) => a + b) / values.length;
}

class WeeklySummary {
  const WeeklySummary({
    required this.checkInCount,
    required this.avgMood,
    required this.avgCraving,
    required this.bestDay,
  });

  final int checkInCount;
  final double? avgMood;
  final double? avgCraving;

  /// The most recent day with a check-in, or null.
  final DateTime? bestDay;

  bool get isEmpty => checkInCount == 0;
}

/// Summary of the last 7 days of check-ins.
WeeklySummary weeklySummary(List<CheckIn> checkIns, DateTime now) {
  final recent = recentCheckIns(checkIns, now, 7);
  if (recent.isEmpty) {
    return const WeeklySummary(
        checkInCount: 0, avgMood: null, avgCraving: null, bestDay: null);
  }
  final moodAvg =
      recent.map((c) => c.mood).reduce((a, b) => a + b) / recent.length;
  final cravingAvg =
      recent.map((c) => c.craving).reduce((a, b) => a + b) / recent.length;
  DateTime? best;
  var bestMood = -1;
  for (final c in recent) {
    if (c.mood > bestMood) {
      bestMood = c.mood;
      best = DateTime.parse(c.date);
    }
  }
  return WeeklySummary(
    checkInCount: recent.length,
    avgMood: moodAvg,
    avgCraving: cravingAvg,
    bestDay: best,
  );
}
