import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../logic/progress.dart';
import '../models/check_in.dart';
import '../models/habit.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/habit_icon.dart';
import '../widgets/habit_selector.dart';
import 'checkin_screen.dart';
import 'paywall_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _habitIndex = 0;
  int _rangeDays = 7;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    if (state.habits.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.statsTitle)),
        body: Center(child: Text(l10n.statsNoData)),
      );
    }
    final habit = state.habits[_habitIndex.clamp(0, state.habits.length - 1)];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: Column(
        children: [
          if (state.habits.length > 1)
            HabitSelector(
              habits: state.habits,
              index: _habitIndex,
              onChanged: (i) => setState(() => _habitIndex = i),
            ),
          Expanded(
            child: _StatsBody(
              habit: habit,
              rangeDays: _rangeDays,
              onRangeChanged: (days) {
                if (days == 30 && !state.isPremium) {
                  // The 30-day view is the premium stats unlock.
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const PaywallScreen()));
                  return;
                }
                setState(() => _rangeDays = days);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({
    required this.habit,
    required this.rangeDays,
    required this.onRangeChanged,
  });

  final Habit habit;
  final int rangeDays;
  final ValueChanged<int> onRangeChanged;

  String _label(AppLocalizations l10n, Habit h) {
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
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final checkIns = state.checkInsFor(habit.id!);
    final summary = weeklySummary(checkIns, state.now);
    final days = daysFree(habit, state.now);
    final streak = currentStreak(checkIns, state.now);
    final best = bestStreak(checkIns);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Row(
          children: [
            HabitIcon(type: habit.type, size: 36),
            const SizedBox(width: 10),
            Text(
              _label(l10n, habit),
              style: const TextStyle(
                  fontFamily: 'DayZeroNunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _statCard(context, '${days}', l10n.statsTotalFree),
            const SizedBox(width: 10),
            _statCard(context, '$streak', l10n.statsStreak),
            const SizedBox(width: 10),
            _statCard(context, '$best', l10n.statsBestStreak),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.statsWeeklyReport,
                    style: const TextStyle(
                        fontFamily: 'DayZeroNunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 18)),
                const SizedBox(height: 8),
                // 7-day view is free; the 30-day view is Premium.
                // Own row: it must never squeeze the title on narrow phones.
                SegmentedButton<int>(
                  segments: [
                    ButtonSegment(value: 7, label: Text(l10n.statsView7)),
                    ButtonSegment(
                      value: 30,
                      // Emoji lock: zero layout cost, never overflows.
                      label: Text(
                        state.isPremium
                            ? l10n.statsView30
                            : '${l10n.statsView30} 🔒',
                      ),
                    ),
                  ],
                  selected: {rangeDays},
                  onSelectionChanged: (s) => onRangeChanged(s.first),
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${summary.checkInCount} ${l10n.statsCheckins}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline),
                ),
                const SizedBox(height: 16),
                if (checkIns.isEmpty)
                  // A friendly, actionable empty state instead of grey text.
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Icon(Icons.insights,
                          size: 48,
                          color: Theme.of(context)
                              .colorScheme
                              .outlineVariant),
                      const SizedBox(height: 12),
                      Text(
                        l10n.statsNoData,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        icon: const Icon(Icons.edit_note),
                        label: Text(l10n.homeCheckIn),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    CheckInScreen(habit: habit))),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _chart(
                        context,
                        title: l10n.statsMood,
                        color: kLeafGreen,
                        values: _lastN(checkIns, state, (c) => c.mood
                            .toDouble(), rangeDays),
                        maxY: 5,
                        now: state.now,
                      ),
                      const SizedBox(height: 16),
                      _chart(
                        context,
                        title: l10n.statsCraving,
                        color: const Color(0xFFE57373),
                        values: _lastN(checkIns, state, (c) => c
                            .craving
                            .toDouble(), rangeDays),
                        maxY: 5,
                        now: state.now,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!state.isPremium) ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline, color: kLeafGreen),
              title: Text(l10n.settingsPremium),
              subtitle: Text(l10n.premiumFeature2),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PaywallScreen())),
            ),
          ),
        ],
      ],
    );
  }

  /// Last [n] days of a metric, oldest first, null when missing.
  List<double?> _lastN(List<CheckIn> checkIns, AppState state,
      double Function(CheckIn) pick, int n) {
    final result = <double?>[];
    for (var i = n - 1; i >= 0; i--) {
      final day = DateTime(state.now.year, state.now.month, state.now.day)
          .subtract(Duration(days: i));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      CheckIn? found;
      for (final c in checkIns) {
        if (c.date == key) {
          found = c;
          break;
        }
      }
      result.add(found == null ? null : pick(found));
    }
    return result;
  }

  Widget _statCard(BuildContext context, String value, String label) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Text(value, style: displayFont(context, size: 26)),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chart(
    BuildContext context, {
    required String title,
    required Color color,
    required List<double?> values,
    required double maxY,
    required DateTime now,
  }) {
    final n = values.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.4),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    // Show roughly 7 day labels regardless of range.
                    interval: n > 14 ? (n / 7).floorToDouble() : 1,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i > n - 1) return const SizedBox.shrink();
                      // Labels derive from the same clock as the data.
                      final day = DateTime(now.year, now.month, now.day)
                          .subtract(Duration(days: n - 1 - i));
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < values.length; i++)
                      if (values[i] != null)
                        FlSpot(i.toDouble(), values[i]!),
                  ],
                  isCurved: true,
                  color: color,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) =>
                        FlDotCirclePainter(
                      radius: 3,
                      color: color,
                      strokeWidth: 0,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
