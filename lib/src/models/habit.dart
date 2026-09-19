import 'package:flutter/material.dart';

/// Built-in habit categories. Each carries a l10n key for its name and a
/// visual identity (icon + color) so onboarding can render without assets.
enum HabitType {
  alcohol('habit_alcohol', Icons.local_bar, Color(0xFF7C4DFF)),
  smoking('habit_smoking', Icons.smoking_rooms, Color(0xFFE64A19)),
  vaping('habit_vaping', Icons.vape_free, Color(0xFF00BFA5)),
  sugar('habit_sugar', Icons.cake, Color(0xFFF06292)),
  caffeine('habit_caffeine', Icons.local_cafe, Color(0xFF8D6E63)),
  social('habit_social', Icons.phone_iphone, Color(0xFF29B6F6)),
  custom('habit_custom', Icons.flag, Color(0xFF66BB6A));

  const HabitType(this.nameKey, this.icon, this.color);

  final String nameKey;
  final IconData icon;
  final Color color;

  static HabitType fromKey(String key) =>
      HabitType.values.firstWhere((t) => t.name == key,
          orElse: () => HabitType.custom);
}

/// A quit habit tracked by the app.
class Habit {
  Habit({
    this.id,
    required this.type,
    required this.name,
    required this.quitDate,
    this.dailySpend = 0,
    this.dailyAmount = 0,
    this.createdAt,
  });

  final int? id;

  /// [HabitType.custom] uses [name]; built-in types keep their l10n key too
  /// so a renamed display language still resolves.
  final HabitType type;
  final String name;

  /// When the current streak started (quit date or last reset). Stored as
  /// milliseconds since epoch, truncated to the start of the local day.
  final DateTime quitDate;

  /// Optional daily monetary cost used for the "money saved" counter.
  final double dailySpend;

  /// Optional daily amount consumed (cigarettes, drinks, cups…) for context.
  final double dailyAmount;

  final DateTime? createdAt;

  Habit copyWith({
    int? id,
    HabitType? type,
    String? name,
    DateTime? quitDate,
    double? dailySpend,
    double? dailyAmount,
  }) {
    return Habit(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      quitDate: quitDate ?? this.quitDate,
      dailySpend: dailySpend ?? this.dailySpend,
      dailyAmount: dailyAmount ?? this.dailyAmount,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toRow() => {
        'id': id,
        'type': type.name,
        'name': name,
        'quit_date': quitDate.millisecondsSinceEpoch,
        'daily_spend': dailySpend,
        'daily_amount': dailyAmount,
        'created_at': (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
      };

  factory Habit.fromRow(Map<String, Object?> row) => Habit(
        id: row['id'] as int?,
        type: HabitType.fromKey(row['type'] as String),
        name: row['name'] as String,
        quitDate: DateTime.fromMillisecondsSinceEpoch(row['quit_date'] as int),
        dailySpend: (row['daily_spend'] as num?)?.toDouble() ?? 0,
        dailyAmount: (row['daily_amount'] as num?)?.toDouble() ?? 0,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            row['created_at'] as int? ?? 0),
      );

  @override
  bool operator ==(Object other) =>
      other is Habit && other.id == id && other.name == name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
