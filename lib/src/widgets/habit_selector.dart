import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/habit.dart';
import 'habit_icon.dart';

/// Horizontal habit switcher shared by the stats and milestones screens.
class HabitSelector extends StatelessWidget {
  const HabitSelector({
    super.key,
    required this.habits,
    required this.index,
    required this.onChanged,
  });

  final List<Habit> habits;
  final int index;
  final ValueChanged<int> onChanged;

  String _label(BuildContext context, Habit h) {
    final l10n = AppLocalizations.of(context);
    switch (h.type) {
      case HabitType.alcohol:
        return l10n.habit_alcohol;
      case HabitType.smoking:
        return l10n.habit_smoking;
      case HabitType.vaping:
        return l10n.habit_vaping;
      case HabitType.sugar:
        return l10n.habit_sugar;
      case HabitType.caffeine:
        return l10n.habit_caffeine;
      case HabitType.social:
        return l10n.habit_social;
      case HabitType.custom:
        return h.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: habits.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final h = habits[i];
          return ChoiceChip(
            avatar: HabitIcon(type: h.type, size: 22),
            label: Text(_label(context, h)),
            selected: i == index,
            onSelected: (_) => onChanged(i),
          );
        },
      ),
    );
  }
}
