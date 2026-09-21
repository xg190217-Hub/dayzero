import 'dart:convert';

/// An if-then implementation intention: "When [trigger], I will [action]".
/// The single highest-evidence behavior-change technique (Gollwitzer &
/// Sheeran meta-analysis: d = 0.65) — but only when the plan names a
/// concrete situational cue, which is exactly what this model forces.
class IfThenPlan {
  IfThenPlan({required this.trigger, required this.action});

  /// Trigger key (e.g. trigger_stress) — a concrete situation.
  final String trigger;
  final String action;

  IfThenPlan copyWith({String? trigger, String? action}) => IfThenPlan(
        trigger: trigger ?? this.trigger,
        action: action ?? this.action,
      );

  Map<String, String> toJson() => {'trigger': trigger, 'action': action};

  factory IfThenPlan.fromJson(Map<String, dynamic> json) => IfThenPlan(
        trigger: json['trigger'] as String,
        action: json['action'] as String,
      );

  static String encodeList(List<IfThenPlan> plans) =>
      jsonEncode(plans.map((p) => p.toJson()).toList());

  static List<IfThenPlan> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => IfThenPlan.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
