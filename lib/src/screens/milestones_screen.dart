import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../data/milestones.dart';
import '../l10n_helpers.dart';
import '../logic/progress.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/habit_icon.dart';

class MilestonesScreen extends StatelessWidget {
  const MilestonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.milestonesTitle)),
      body: state.habits.isEmpty
          ? Center(child: Text(l10n.statsNoData))
          : _MilestonesBody(habit: state.habits.first),
    );
  }
}

class _MilestonesBody extends StatelessWidget {
  const _MilestonesBody({required this.habit});

  final dynamic habit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final scheme = Theme.of(context).colorScheme;
    final achieved = state.unlocked[habit.id as int] ?? const <String>{};
    final days = daysFree(habit, state.now);
    final checkIns = state.checkInsFor(habit.id as int);
    final streak = currentStreak(checkIns, state.now);
    final money = moneySaved(habit, state.now);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Row(
          children: [
            HabitIcon(type: habit.type, size: 36),
            const SizedBox(width: 10),
            Text(
              habit.name as String,
              style: const TextStyle(
                  fontFamily: 'DayZeroNunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(l10n.milestonesUnlocked,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: scheme.outline)),
        const SizedBox(height: 8),
        _badgeGrid(context, l10n, achieved, true, habit, days, streak, money),
        const SizedBox(height: 16),
        Text(l10n.milestonesLocked,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: scheme.outline)),
        const SizedBox(height: 8),
        _badgeGrid(context, l10n, achieved, false, habit, days, streak, money),
      ],
    );
  }

  Widget _badgeGrid(
    BuildContext context,
    AppLocalizations l10n,
    Set<String> achieved,
    bool unlockedOnly,
    dynamic habit,
    int days,
    int streak,
    double money,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final entries = <(String, IconData, bool, String?)>[];

    for (final m in kTimeMilestones) {
      final done = achieved.contains(m.key);
      final remaining =
          (m.at - days).round() <= 0 ? null : '${(m.at - days).round()}${l10n.dayUnit}';
      entries.add((m.key, m.icon, done, done ? null : remaining));
    }
    for (final m in kMoneyMilestones) {
      final done = achieved.contains(m.key);
      final remaining = money >= m.at
          ? null
          : '${(m.at - money).round()}';
      entries.add((m.key, m.icon, done, done ? null : remaining));
    }
    kStreakMilestones.forEach((key, threshold) {
      final done = achieved.contains(key);
      final remaining = streak >= threshold
          ? null
          : '${threshold - streak}${l10n.dayUnit}';
      entries.add((key, Icons.local_fire_department, done,
          done ? null : remaining));
    });

    final visible = entries
        .where((e) => e.$3 == unlockedOnly)
        .toList();

    if (visible.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          l10n.statsNoData,
          style: TextStyle(color: scheme.outline),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: visible.map((e) {
        final (key, icon, _, remaining) = e;
        return Container(
          width: 96,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: unlockedOnly
                ? kLeafGreen.withValues(alpha: 0.12)
                : scheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: unlockedOnly ? kLeafGreen : scheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: unlockedOnly
                    ? kLeafGreen
                    : scheme.outlineVariant,
                size: 26,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.milestoneLabel(key),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: unlockedOnly ? scheme.onSurface : scheme.outline,
                ),
              ),
              if (remaining != null) ...[
                const SizedBox(height: 2),
                Text(
                  remaining,
                  style: TextStyle(
                      fontSize: 10, color: scheme.outline),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
