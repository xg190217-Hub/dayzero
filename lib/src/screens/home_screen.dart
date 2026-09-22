import 'dart:async';

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

  /// Live 1-second tick for the run timer. Runs only while an active run
  /// is displayed; cancelled otherwise (and in dispose).
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    if (state.habits.isEmpty) {
      return const OnboardingScreen();
    }
    final activeHabit =
        state.habits[_habitIndex.clamp(0, state.habits.length - 1)];
    // Keep the seconds ticking only while a run is live.
    final runLive = state.hasRunStarted(activeHabit.id!) &&
        !state.isRunBroken(activeHabit.id!);
    if (runLive && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else if (!runLive && _ticker != null) {
      _ticker!.cancel();
      _ticker = null;
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
    final scheme = Theme.of(context).colorScheme;
    // The number is the hero, the unit is its caption. Rendering them as one
    // string once produced a broken Chinese singular ("天自由" with no
    // number); split, the count is always visible and every language works.
    // The run timer: starts at 0:00:00 at the FIRST check-in moment,
    // becomes 1天0时0分0秒 after 24h, and shows "已中断" when the last
    // check-in is more than 24h old.
    final started = state.hasRunStarted(habit.id!);
    final broken = started && state.isRunBroken(habit.id!);
    final String hero;
    final String? caption;
    if (!started) {
      hero =
          '0${l10n.hourUnit} 0${l10n.minuteUnit} 0${l10n.secondUnit}';
      caption = l10n.timerNotStarted;
    } else if (broken) {
      hero = l10n.timerBroken;
      caption = l10n.timerBrokenHint;
    } else {
      final elapsed = state.now.difference(habit.quitDate);
      final d = elapsed.inDays;
      final h = elapsed.inHours % 24;
      final m = elapsed.inMinutes % 60;
      final sec = elapsed.inSeconds % 60;
      hero = d > 0
          ? '$d${l10n.dayUnit} $h${l10n.hourUnit} $m${l10n.minuteUnit} $sec${l10n.secondUnit}'
          : '$h${l10n.hourUnit} $m${l10n.minuteUnit} $sec${l10n.secondUnit}';
      caption = '$days ${l10n.homeDaysSince}';
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              hero,
              textAlign: TextAlign.center,
              style: displayFont(context, size: broken ? 44 : 40)
                  .copyWith(color: broken ? const Color(0xFFB71C1C) : scheme.primary),
            ),
            const SizedBox(height: 2),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: scheme.outline),
            ),
            // Identity framing (evidence: identity predicts long-term
            // maintenance — "I don't smoke" beats "I'm quitting").
            if (days >= 1 && _identityLabel(l10n, habit) != null) ...[
              const SizedBox(height: 6),
              Text(
                l10n.identityLine('${days + 1}', _identityLabel(l10n, habit)!),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: scheme.primary,
                ),
              ),
            ],
            // A live streak badge: the single strongest retention hook.
            if (_streak(state, habit) >= 2) ...[
              const SizedBox(height: 10),
              Text(
                '🔥 ${l10n.homeStreak(_streak(state, habit))}',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event, size: 14, color: scheme.outline),
                const SizedBox(width: 4),
                Text(
                  '${habit.quitDate.year}-${habit.quitDate.month.toString().padLeft(2, '0')}-${habit.quitDate.day.toString().padLeft(2, '0')}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.outline),
                ),
              ],
            ),
            if (habit.dailySpend > 0) ...[
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  // Theme-derived so every preset tints this chip coherently.
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${l10n.homeMoneySaved}: ${_money(habit.dailySpend * days)}',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimaryContainer),
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

  /// Identity noun for the habit ("a non-smoker"), null for custom habits.
  String? _identityLabel(AppLocalizations l10n, Habit habit) {
    switch (habit.type) {
      case HabitType.smoking:
        return l10n.identity_smoking;
      case HabitType.alcohol:
        return l10n.identity_alcohol;
      case HabitType.vaping:
        return l10n.identity_vaping;
      case HabitType.sugar:
        return l10n.identity_sugar;
      case HabitType.caffeine:
        return l10n.identity_caffeine;
      case HabitType.social:
        return l10n.identity_social;
      case HabitType.custom:
        return null;
    }
  }

  String _money(double value) {
    final state = context.read<AppState>();
    final v = value.round();
    return '${state.currencySymbol}$v';
  }

  Widget _actionRow(AppLocalizations l10n, AppState state, Habit habit) {
    final checked = state.checkInToday(habit.id!) != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            // After checking in, the button explicitly becomes the edit
            // entry point: the label says so instead of relying on a
            // subtle icon change.
            icon: Icon(checked ? Icons.edit : Icons.edit_note),
            label: Text(checked ? l10n.checkinEditLabel : l10n.homeCheckIn),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CheckInScreen(habit: habit)));
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.tonalIcon(
            // Warm amber, not alarm red: someone at peak craving needs a
            // welcoming lifeline, not an error signal. Brightness-paired
            // fill/text keep WCAG AA in both modes, and the light-mode
            // border keeps the button shape readable (1.4.11 ≥3:1).
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? kSosDarkFill : kSosLightFill,
              foregroundColor: isDark ? kSosDarkText : kSosLightText,
              side: isDark
                  ? null
                  : const BorderSide(color: kSosBorder, width: 1.5),
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
            color: reached ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
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
        leading: Icon(next.icon, color: Theme.of(context).colorScheme.primary),
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
        // A milestone is an emotional peak: make it feel like a ceremony.
        // Darker gradient + dark trophy keep ≥3:1 on every stop.
        icon: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFE8A33D), Color(0xFFC04000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.emoji_events,
              color: Color(0xFF3E2A00), size: 40),
        ),
        title: Text(l10n.milestonesTitle, textAlign: TextAlign.center),
        content: Text(
          labels,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
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
    String? trigger;
    final noteController = TextEditingController();
    const triggers = [
      'trigger_stress',
      'trigger_social',
      'trigger_boredom',
      'trigger_habit_loop',
      'trigger_negative',
      'trigger_celebration',
      'trigger_none',
    ];
    String triggerLabel(String key) {
      switch (key) {
        case 'trigger_stress':
          return l10n.trigger_stress;
        case 'trigger_social':
          return l10n.trigger_social;
        case 'trigger_boredom':
          return l10n.trigger_boredom;
        case 'trigger_habit_loop':
          return l10n.trigger_habit_loop;
        case 'trigger_negative':
          return l10n.trigger_negative;
        case 'trigger_celebration':
          return l10n.trigger_celebration;
        default:
          return l10n.trigger_none;
      }
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(l10n.relapseTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.relapseBody),
              const SizedBox(height: 12),
              // Attribution matters more than the reset: "what triggered
              // it" turns a lapse into data for the next plan.
              Text(l10n.checkinTrigger,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: triggers.map((key) {
                  final selected = trigger == key;
                  return ChoiceChip(
                    label: Text(triggerLabel(key)),
                    selected: selected,
                    onSelected: (_) => setDialogState(() =>
                        trigger = selected ? null : key),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: l10n.checkinNote,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await state.recordLapse(habit,
                    trigger: trigger,
                    note: noteController.text.trim().isEmpty
                        ? null
                        : noteController.text.trim());
              },
              child: Text(l10n.relapseRecordKeep),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await state.recordLapse(habit,
                    trigger: trigger,
                    note: noteController.text.trim().isEmpty
                        ? null
                        : noteController.text.trim());
                await state.resetQuitDate(habit);
              },
              child: Text(l10n.relapseRecordRestart),
            ),
          ],
        ),
      ),
    );
  }

  void _addHabit(BuildContext context, AppState state) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const OnboardingScreen(addMode: true)));
  }
}
