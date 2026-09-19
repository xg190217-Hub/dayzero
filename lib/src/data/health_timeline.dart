import '../models/habit.dart';

/// A single recovery fact that becomes visible [after] a duration of quitting.
class HealthStep {
  const HealthStep(this.duration, this.labelKey);

  final Duration duration;
  final String labelKey;
}

/// Public-health recovery milestones per habit type. Durations are counted
/// from the quit date (or the latest counter reset). Facts are general,
/// widely published health information — not medical advice.
const Map<HabitType, List<HealthStep>> kHealthTimeline = {
  HabitType.smoking: [
    HealthStep(Duration(minutes: 20), 'health_smoking_20m'),
    HealthStep(Duration(hours: 8), 'health_smoking_8h'),
    HealthStep(Duration(days: 1), 'health_smoking_24h'),
    HealthStep(Duration(days: 2), 'health_smoking_48h'),
    HealthStep(Duration(days: 3), 'health_smoking_72h'),
    HealthStep(Duration(days: 30), 'health_smoking_1m'),
    HealthStep(Duration(days: 365), 'health_smoking_1y'),
  ],
  HabitType.vaping: [
    HealthStep(Duration(days: 1), 'health_vaping_24h'),
    HealthStep(Duration(days: 2), 'health_vaping_48h'),
    HealthStep(Duration(days: 3), 'health_vaping_72h'),
    HealthStep(Duration(days: 7), 'health_vaping_1w'),
    HealthStep(Duration(days: 30), 'health_vaping_1m'),
  ],
  HabitType.alcohol: [
    HealthStep(Duration(days: 1), 'health_alcohol_24h'),
    HealthStep(Duration(days: 2), 'health_alcohol_48h'),
    HealthStep(Duration(days: 7), 'health_alcohol_1w'),
    HealthStep(Duration(days: 14), 'health_alcohol_2w'),
    HealthStep(Duration(days: 30), 'health_alcohol_1m'),
    HealthStep(Duration(days: 90), 'health_alcohol_3m'),
    HealthStep(Duration(days: 365), 'health_alcohol_1y'),
  ],
  HabitType.sugar: [
    HealthStep(Duration(days: 1), 'health_sugar_1d'),
    HealthStep(Duration(days: 3), 'health_sugar_3d'),
    HealthStep(Duration(days: 14), 'health_sugar_2w'),
    HealthStep(Duration(days: 30), 'health_sugar_1m'),
    HealthStep(Duration(days: 90), 'health_sugar_3m'),
  ],
  HabitType.caffeine: [
    HealthStep(Duration(days: 1), 'health_caffeine_1d'),
    HealthStep(Duration(days: 3), 'health_caffeine_3d'),
    HealthStep(Duration(days: 7), 'health_caffeine_1w'),
    HealthStep(Duration(days: 14), 'health_caffeine_2w'),
    HealthStep(Duration(days: 30), 'health_caffeine_1m'),
  ],
  HabitType.social: [
    HealthStep(Duration(days: 1), 'health_social_1d'),
    HealthStep(Duration(days: 3), 'health_social_3d'),
    HealthStep(Duration(days: 7), 'health_social_1w'),
    HealthStep(Duration(days: 14), 'health_social_2w'),
    HealthStep(Duration(days: 30), 'health_social_1m'),
  ],
  HabitType.custom: [],
};
