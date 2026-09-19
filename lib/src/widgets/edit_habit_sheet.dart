import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../state/app_state.dart';
import 'habit_icon.dart';

/// Bottom sheet to edit a habit: quit date, daily spend, daily amount and
/// (for custom habits) the name. The onboarding promises "you can change it
/// later" — this is that promise, kept.
class EditHabitSheet extends StatefulWidget {
  const EditHabitSheet({super.key, required this.habit});

  final Habit habit;

  @override
  State<EditHabitSheet> createState() => _EditHabitSheetState();
}

class _EditHabitSheetState extends State<EditHabitSheet> {
  late DateTime _quitDate;
  late TextEditingController _spend;
  late TextEditingController _amount;
  late TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _quitDate = widget.habit.quitDate;
    _spend = TextEditingController(
        text: widget.habit.dailySpend > 0
            ? widget.habit.dailySpend.toStringAsFixed(0)
            : '');
    _amount = TextEditingController(
        text: widget.habit.dailyAmount > 0
            ? widget.habit.dailyAmount.toStringAsFixed(0)
            : '');
    _name = TextEditingController(text: widget.habit.name);
  }

  @override
  void dispose() {
    _spend.dispose();
    _amount.dispose();
    _name.dispose();
    super.dispose();
  }

  String _habitLabel(AppLocalizations l10n, Habit h) {
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

  Future<void> _save() async {
    final state = context.read<AppState>();
    final spend = double.tryParse(_spend.text) ?? 0;
    final amount = double.tryParse(_amount.text) ?? 0;
    var habit = widget.habit.copyWith(
      quitDate: _quitDate,
      dailySpend: spend,
      dailyAmount: amount,
    );
    if (habit.type == HabitType.custom && _name.text.trim().isNotEmpty) {
      habit = habit.copyWith(name: _name.text.trim());
    }
    await state.updateHabit(habit);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final h = widget.habit;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HabitIcon(type: h.type, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _habitLabel(l10n, h),
                    style: const TextStyle(
                        fontFamily: 'DayZeroNunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(l10n.onboardingDateTitle),
              subtitle: Text(
                  '${_quitDate.year}-${_quitDate.month.toString().padLeft(2, '0')}-${_quitDate.day.toString().padLeft(2, '0')}'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _quitDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 3650)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _quitDate = picked);
              },
            ),
            TextField(
              controller: _spend,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.onboardingSpendTitle,
                suffixText: l10n.perDay,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.dailyAmountLabel,
                suffixText: l10n.perDay,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            if (h.type == HabitType.custom) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: l10n.customHabitName,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _save,
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
