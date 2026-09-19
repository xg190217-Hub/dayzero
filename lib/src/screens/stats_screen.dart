import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../logic/progress.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/habit_icon.dart';
import 'paywall_screen.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: state.habits.isEmpty
          ? Center(child: Text(l10n.statsNoData))
          : _StatsBody(habit: state.habits.first),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.habit});

  final dynamic habit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final checkIns = state.checkInsFor(habit.id as int);
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
              habit.type.nameKey == 'habit_custom'
                  ? habit.name as String
                  : _label(l10n, habit.type.nameKey as String),
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
                const SizedBox(height: 4),
                Text(
                  '${summary.checkInCount} ${l10n.statsCheckins}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline),
                ),
                const SizedBox(height: 16),
                if (summary.isEmpty)
                  Text(l10n.statsNoData)
                else
                  Column(
                    children: [
                      _chart(
                        context,
                        title: l10n.statsMood,
                        color: kLeafGreen,
                        values: _last7(context, checkIns, state, (c) => c.mood
                            .toDouble()),
                        maxY: 5,
                        now: state.now,
                      ),
                      const SizedBox(height: 16),
                      _chart(
                        context,
                        title: l10n.statsCraving,
                        color: const Color(0xFFE57373),
                        values: _last7(context, checkIns, state, (c) => c
                            .craving
                            .toDouble()),
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

  String _label(AppLocalizations l10n, String key) {
    switch (key) {
      case 'habit_alcohol':
        return l10n.habit_alcohol;
      case 'habit_smoking':
        return l10n.habit_smoking;
      case 'habit_vaping':
        return l10n.habit_vaping;
      case 'habit_sugar':
        return l10n.habit_sugar;
      case 'habit_caffeine':
        return l10n.habit_caffeine;
      case 'habit_social':
        return l10n.habit_social;
      default:
        return key;
    }
  }

  /// Last 7 days of a metric, oldest first, null when missing.
  List<double?> _last7(BuildContext context, dynamic checkIns, AppState state,
      double Function(dynamic) pick) {
    final result = <double?>[];
    for (var i = 6; i >= 0; i--) {
      final day = DateTime(state.now.year, state.now.month, state.now.day)
          .subtract(Duration(days: i));
      final key = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      dynamic found;
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
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i > 6) return const SizedBox.shrink();
                      // Labels derive from the same clock as the data.
                      final day = DateTime(now.year, now.month, now.day)
                          .subtract(Duration(days: 6 - i));
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
