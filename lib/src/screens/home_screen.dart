import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../data/health_timeline.dart';
import '../data/milestones.dart';
import '../l10n_helpers.dart';
import '../logic/progress.dart';
import '../models/habit.dart';
import '../services/audio_service.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/habit_icon.dart';
import 'checkin_screen.dart';
import 'onboarding_screen.dart';
import 'paywall_screen.dart';
import 'sos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _habitIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    if (state.habits.isEmpty) {
      return const OnboardingScreen();
    }
    // Celebrate freshly unlocked milestones once per session.
    if (state.newlyUnlocked.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _celebrate(l10n, state);
      });
    }
    final habit = state.habits[_habitIndex.clamp(0, state.habits.length - 1)];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: state.canAddHabit ? const Icon(Icons.add) : const Icon(Icons.lock_outline),
            tooltip: l10n.homeAddHabit,
            onPressed: () {
              if (state.canAddHabit) {
                _addHabit(context, state);
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PaywallScreen()));
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          if (state.habits.length > 1) _habitTabs(state),
          const SizedBox(height: 12),
          _dayCounterCard(l10n, habit),
          const SizedBox(height: 12),
          _actionRow(l10n, state, habit),
          const SizedBox(height: 24),
          _healthTimeline(l10n, state, habit),
          const SizedBox(height: 24),
          _nextMilestone(l10n, state, habit),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => _relapseDialog(l10n, state, habit),
            icon: const Icon(Icons.refresh),
            label: Text(l10n.homeRelapse),
          ),
        ],
      ),
    );
  }

  Widget _habitTabs(AppState state) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.habits.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final h = state.habits[i];
          final selected = i == _habitIndex;
          return ChoiceChip(
            avatar: HabitIcon(type: h.type, size: 22),
            label: Text(_habitLabel(context, h)),
            selected: selected,
            onSelected: (_) => setState(() => _habitIndex = i),
          );
        },
      ),
    );
  }

  String _habitLabel(BuildContext context, Habit h) {
    final l10n = AppLocalizations.of(context);
    if (h.type != HabitType.custom) {
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
          break;
      }
    }
    return h.name;
  }

  Widget _dayCounterCard(AppLocalizations l10n, Habit habit) {
    final state = context.watch<AppState>();
    final days = daysFree(habit, state.now);
    final elapsed = state.now.difference(habit.quitDate);
    // Day zero shows hours+minutes: "0 days" reads as failure on launch day.
    // Future quit dates clamp to zero instead of going negative.
    final label = days == 0 && !elapsed.isNegative
        ? _hoursLabel(l10n, elapsed)
        : days == 1
            ? l10n.homeDaysSinceOne
            : '$days ${l10n.homeDaysSince}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(label, style: displayFont(context, size: 44)),
            // A live streak badge: the single strongest retention hook.
            if (_streak(state, habit) >= 2) ...[
              const SizedBox(height: 6),
              Text(
                '🔥 ${l10n.homeStreak(_streak(state, habit))}',
                style: const TextStyle(
                    fontFamily: 'DayZeroNunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              '${habit.quitDate.year}-${habit.quitDate.month.toString().padLeft(2, '0')}-${habit.quitDate.day.toString().padLeft(2, '0')}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
            if (habit.dailySpend > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: kSage.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${l10n.homeMoneySaved}: ${_money(habit.dailySpend * days)}',
                  style: const TextStyle(
                      fontFamily: 'DayZeroNunito',
                      fontWeight: FontWeight.w700,
                      color: kDeepGreen),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _streak(AppState state, Habit habit) =>
      currentStreak(state.checkInsFor(habit.id!), state.now);

  String _hoursLabel(AppLocalizations l10n, Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return '$h${l10n.hourUnit} $m${l10n.minuteUnit} ${l10n.homeTimeFree}';
  }

  String _money(double value) {
    final state = context.read<AppState>();
    final v = value.round();
    return '${state.currencySymbol}$v';
  }

  Widget _actionRow(AppLocalizations l10n, AppState state, Habit habit) {
    final checked = state.checkInToday(habit.id!) != null;
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            icon: Icon(checked ? Icons.check_circle : Icons.edit_note),
            label: Text(checked ? l10n.checkinTitle : l10n.homeCheckIn),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CheckInScreen(habit: habit)));
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.tonalIcon(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .errorContainer,
              foregroundColor:
                  Theme.of(context).colorScheme.onErrorContainer,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.favorite),
            label: Text(l10n.homeSOS),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SosScreen(habit: habit)));
            },
          ),
        ),
      ],
    );
  }

  Widget _healthTimeline(
      AppLocalizations l10n, AppState state, Habit habit) {
    final steps = kHealthTimeline[habit.type] ?? const [];
    if (steps.isEmpty) return const SizedBox.shrink();
    final days = daysFree(habit, state.now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.homeHealthTimeline,
            style: const TextStyle(
                fontFamily: 'DayZeroNunito',
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: steps.map((step) {
                // Duration-based: sub-day facts (20 min, 8 h) unlock on the
                // first day instead of waiting for a full 24 h to pass.
                final reached = state.now.difference(habit.quitDate) >= step.duration;
                return _timelineRow(l10n, state, step, reached, days);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _timelineRow(AppLocalizations l10n, AppState state,
      HealthStep step, bool reached, int days) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Icon(
            reached ? Icons.check_circle : Icons.radio_button_unchecked,
            color: reached ? kLeafGreen : Theme.of(context).colorScheme.outlineVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.healthLabel(step.labelKey),
              style: TextStyle(
                fontSize: 14,
                height: 1.3,
                color: reached
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextMilestone(
      AppLocalizations l10n, AppState state, Habit habit) {
    final days = daysFree(habit, state.now);
    final achieved = state.unlocked[habit.id] ?? const <String>{};
    Milestone? next;
    for (final m in kTimeMilestones) {
      if (!achieved.contains(m.key)) {
        next = m;
        break;
      }
    }
    if (next == null) return const SizedBox.shrink();
    final remaining = (next.at - days).round();
    final label = l10n.milestoneLabel(next.key);
    return Card(
      child: ListTile(
        leading: Icon(next.icon, color: kLeafGreen),
        title: Text(l10n.homeNextMilestone),
        subtitle: Text('$label · ${l10n.homeIn} $remaining ${l10n.dayUnit}'),
      ),
    );
  }

  /// Shows a celebration for milestones unlocked by the latest action and
  /// plays the chime (part of the premium feature set, but milestones
  /// themselves stay free).
  void _celebrate(AppLocalizations l10n, AppState state) {
    final fresh = state.takeNewlyUnlocked();
    if (fresh.isEmpty || !mounted) return;
    context.read<AudioService>().play('sounds/chime.wav');
    final labels = fresh.map(l10n.milestoneLabel).join(' · ');
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.emoji_events, color: Color(0xFFF9A825), size: 44),
        title: Text(l10n.milestonesTitle),
        content: Text(labels, textAlign: TextAlign.center),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.done),
          ),
        ],
      ),
    );
  }

  void _relapseDialog(AppLocalizations l10n, AppState state, Habit habit) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.relapseTitle),
        content: Text(l10n.relapseBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.relapseKeep),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await state.resetQuitDate(habit);
            },
            child: Text(l10n.relapseRestart),
          ),
        ],
      ),
    );
  }

  void _addHabit(BuildContext context, AppState state) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const OnboardingScreen(addMode: true)));
  }
}
