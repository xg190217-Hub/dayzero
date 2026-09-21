/// A recorded slip/relapse event. Kept separate from check-ins: a lapse is
/// the data point that powers relapse prevention — triggers, frequency and
/// the reframing flow ("one slip doesn't erase progress").
class Lapse {
  Lapse({
    this.id,
    required this.habitId,
    required this.date,
    this.trigger,
    this.note,
  });

  final int? id;
  final int habitId;

  /// Local calendar day (yyyy-mm-dd).
  final String date;
  final String? trigger;
  final String? note;

  Map<String, Object?> toRow() => {
        'id': id,
        'habit_id': habitId,
        'date': date,
        'trigger': trigger,
        'note': note,
      };

  factory Lapse.fromRow(Map<String, Object?> row) => Lapse(
        id: row['id'] as int?,
        habitId: row['habit_id'] as int,
        date: row['date'] as String,
        trigger: row['trigger'] as String?,
        note: row['note'] as String?,
      );
}
