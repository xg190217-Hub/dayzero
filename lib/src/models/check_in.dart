/// One daily check-in for one habit.
class CheckIn {
  CheckIn({
    this.id,
    required this.habitId,
    required this.date,
    required this.mood,
    required this.craving,
    this.trigger,
    this.note,
  });

  final int? id;
  final int habitId;

  /// Local calendar day (yyyy-mm-dd), not a timestamp: one check-in per day.
  final String date;

  /// Mood 1 (worst) – 5 (best).
  final int mood;

  /// Craving intensity 0 (none) – 5 (extreme).
  final int craving;

  /// Trigger key such as `trigger_stress`, or null.
  final String? trigger;
  final String? note;

  CheckIn copyWith({
    int? mood,
    int? craving,
    String? trigger,
    String? note,
  }) {
    return CheckIn(
      id: id,
      habitId: habitId,
      date: date,
      mood: mood ?? this.mood,
      craving: craving ?? this.craving,
      trigger: trigger ?? this.trigger,
      note: note ?? this.note,
    );
  }

  Map<String, Object?> toRow() => {
        'id': id,
        'habit_id': habitId,
        'date': date,
        'mood': mood,
        'craving': craving,
        'trigger': trigger,
        'note': note,
      };

  factory CheckIn.fromRow(Map<String, Object?> row) => CheckIn(
        id: row['id'] as int?,
        habitId: row['habit_id'] as int,
        date: row['date'] as String,
        mood: row['mood'] as int,
        craving: row['craving'] as int,
        trigger: row['trigger'] as String?,
        note: row['note'] as String?,
      );

  /// YYYY-MM-DD for the given date (local time).
  static String dateKey(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }
}
