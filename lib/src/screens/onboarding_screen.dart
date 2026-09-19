import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/habit_icon.dart';

/// Five quick steps: welcome → pick habits → quit date → daily spend →
/// reasons. Everything except habit selection is optional; the app works with
/// sensible defaults.
///
/// With [addMode] the flow adds a habit to an existing setup and pops back
/// instead of landing on the home screen.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.addMode = false});

  final bool addMode;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  Set<HabitType> _selected = {HabitType.alcohol};
  DateTime _quitDate = DateTime.now();
  final TextEditingController _spend = TextEditingController();
  final TextEditingController _customName = TextEditingController();
  final TextEditingController _reason = TextEditingController();
  final List<String> _reasons = [];

  @override
  void initState() {
    super.initState();
    if (widget.addMode) {
      _selected = {};
      _page = 1; // Skip the welcome step when adding from the home screen.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _spend.dispose();
    _customName.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final state = context.read<AppState>();
    for (final type in _selected) {
      final name = type == HabitType.custom
          ? (_customName.text.trim().isEmpty ? 'My habit' : _customName.text.trim())
          : type.nameKey;
      await state.addHabit(
        type: type,
        name: name,
        quitDate: _quitDate,
        dailySpend: double.tryParse(_spend.text) ?? 0,
      );
    }
    if (_reasons.isNotEmpty) {
      await state.setReasons(_reasons);
    }
    if (widget.addMode && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots.
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? kLeafGreen : scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _welcomePage(l10n),
                  _choosePage(l10n),
                  _datePage(l10n),
                  _spendPage(l10n),
                  _reasonsPage(l10n),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  if (_page > 0)
                    TextButton(
                      onPressed: () {
                        _controller.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut);
                        setState(() => _page--);
                      },
                      child: Text(l10n.skip),
                    )
                  else
                    const SizedBox(width: 64),
                  const Spacer(),
                  FilledButton(
                    style: FilledButton.styleFrom(
                        minimumSize: const Size(160, 52)),
                    onPressed: () async {
                      if (_page < 4) {
                        if (_page == 1 && _selected.isEmpty) return;
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut);
                        setState(() => _page++);
                      } else {
                        await _finish();
                      }
                    },
                    child: Text(_page < 4
                        ? l10n.startJourney
                        : l10n.startJourney),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _welcomePage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: kLeafGreen,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(Icons.spa, color: Colors.white, size: 52),
          ),
          const SizedBox(height: 28),
          Text(l10n.onboardingWelcomeTitle,
              textAlign: TextAlign.center, style: displayFont(context, size: 32)),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingWelcomeBody,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.notMedicalAdvice,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _choosePage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingChooseTitle, style: displayFont(context, size: 28)),
          const SizedBox(height: 8),
          Text(l10n.onboardingChooseBody,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: HabitType.values.map((type) {
              final selected = _selected.contains(type);
              return _HabitOption(
                type: type,
                selected: selected,
                label: type == HabitType.custom
                    ? l10n.habit_custom
                    : _habitName(l10n, type),
                onTap: () => setState(() {
                  if (selected) {
                    _selected.remove(type);
                  } else {
                    _selected.add(type);
                  }
                }),
              );
            }).toList(),
          ),
          if (_selected.contains(HabitType.custom)) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _customName,
              decoration: InputDecoration(
                hintText: l10n.customHabitName,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _habitName(AppLocalizations l10n, HabitType type) {
    switch (type) {
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
        return l10n.habit_custom;
    }
  }

  Widget _datePage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingDateTitle, style: displayFont(context, size: 28)),
          const SizedBox(height: 8),
          Text(l10n.onboardingDateBody,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.play_circle_outline,
                        color: kLeafGreen),
                    title: Text(l10n.today),
                    trailing: _quitDate.day == DateTime.now().day
                        ? const Icon(Icons.check_circle, color: kLeafGreen)
                        : null,
                    onTap: () => setState(() => _quitDate = DateTime.now()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.event, color: kLeafGreen),
                    title: Text(
                        '${_quitDate.year}-${_quitDate.month.toString().padLeft(2, '0')}-${_quitDate.day.toString().padLeft(2, '0')}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _quitDate,
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 10)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _quitDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _spendPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingSpendTitle, style: displayFont(context, size: 28)),
          const SizedBox(height: 8),
          Text(l10n.onboardingSpendBody,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          TextField(
            controller: _spend,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: l10n.currencyPlaceholder,
              suffixText: l10n.perDay,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reasonsPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingReasonsTitle,
              style: displayFont(context, size: 28)),
          const SizedBox(height: 8),
          Text(l10n.onboardingReasonsBody,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          if (_reasons.isNotEmpty)
            ..._reasons.map((r) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: kLeafGreen),
                    title: Text(r),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _reasons.remove(r)),
                    ),
                  ),
                )),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _reason,
                  decoration: InputDecoration(
                    hintText: l10n.reasonPlaceholder,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_reason.text.trim().isEmpty) return;
                  setState(() {
                    _reasons.add(_reason.text.trim());
                    _reason.clear();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HabitOption extends StatelessWidget {
  const _HabitOption({
    required this.type,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final HabitType type;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? type.color.withValues(alpha: 0.18)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? type.color : Theme.of(context).colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HabitIcon(type: type, size: 22),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontFamily: 'DayZeroNunito', fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
