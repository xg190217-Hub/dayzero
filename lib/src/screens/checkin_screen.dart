import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../logic/progress.dart';
import '../models/habit.dart';
import '../services/audio_service.dart';
import '../state/app_state.dart';
import '../widgets/habit_icon.dart';
import 'sos_screen.dart';


/// App Store numeric ID. Set after the App Store Connect record is created
/// (the rating prompt stays disabled until then).
const int kAppStoreId = 0;

/// Daily check-in: mood, craving level, trigger and an optional note.
class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key, required this.habit});

  final Habit habit;

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  int _mood = 3;
  double _craving = 2;
  String? _trigger;
  final TextEditingController _note = TextEditingController();
  bool _saving = false;

  // Vector mood faces: never tofu, render everywhere, and carry color +
  // shape semantics (color-blind safe — no color-only coding).
  static const _moodIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];
  static const _moodColors = [
    Color(0xFFC62828),
    Color(0xFFEF6C00),
    Color(0xFFF9A825),
    Color(0xFF9CCC65),
    Color(0xFF2E7D32),
  ];

  static const _triggers = [
    'trigger_stress',
    'trigger_social',
    'trigger_boredom',
    'trigger_habit_loop',
    'trigger_negative',
    'trigger_celebration',
    'trigger_none',
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    final existing = state.checkInToday(widget.habit.id!);
    if (existing != null) {
      _mood = existing.mood;
      _craving = existing.craving.toDouble();
      _trigger = existing.trigger;
      _note.text = existing.note ?? '';
    }
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final state = context.read<AppState>();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    // Capture the navigator NOW: this screen pops right after saving, and a
    // deactivated context would make the snackbar action throw and stick.
    final navigator = Navigator.of(context);
    await state.saveCheckIn(
      habit: widget.habit,
      mood: _mood,
      craving: _craving.round(),
      trigger: _trigger,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    if (!mounted) return;
    // Small reward sound (silently skipped when audio is unavailable).
    context.read<AudioService>().play('sounds/chime.wav');
    // Monitoring must close the loop into feedback: compare this week's
    // average craving with last week's (Harkin 2016: monitoring+feedback
    // d=.42 vs monitoring alone d=.25).
    final insight = _insight(l10n, state);
    messenger.showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(insight == null ? l10n.checkinDone : '$l10n.checkinDone\n$insight'),
      // One-tap way back in when the user wants to adjust their entry.
      action: SnackBarAction(
        label: l10n.settingsEditHabit,
        onPressed: () {
          navigator.push(MaterialPageRoute(
              builder: (_) => CheckInScreen(habit: widget.habit)));
        },
      ),
    ));

    // A strong craving is the exact moment the SOS screen exists for.
    // Fifth check-in = habit forming. The moment users feel the value is the
    // moment they leave reviews (disabled until the ASC App ID is known).
    final totalCheckIns = state.checkInsFor(widget.habit.id!).length;
    if (kAppStoreId != 0 && totalCheckIns == 5) {
      await _maybeAskForRating();
      if (!mounted) return;
    }

    if (_craving.round() >= 4) {
      final goSos = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.favorite, color: Color(0xFFE57373)),
          title: Text(l10n.checkinOfferSos),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.homeSOS),
            ),
          ],
        ),
      );
      if (goSos == true && mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => SosScreen(habit: widget.habit)));
        return;
      }
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkinTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // Which habit this check-in belongs to (matters with 2+ habits).
          Row(
            children: [
              HabitIcon(type: widget.habit.type, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _habitLabel(l10n, widget.habit),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.checkinMood,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (i) {
                      final selected = i + 1 == _mood;
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => setState(() => _mood = i + 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : scheme.outlineVariant,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            _moodIcons[i],
                            size: 28,
                            color: selected
                                ? _moodColors[i]
                                : scheme.outlineVariant,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.checkinCraving,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18)),
                      Text('${_craving.round()}/5',
                          style: TextStyle(color: scheme.outline)),
                    ],
                  ),
                  Slider(
                    value: _craving,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    activeColor: widget.habit.type.color,
                    onChanged: (v) => setState(() => _craving = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.checkinTrigger,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _triggers.map((key) {
                      final selected = _trigger == key;
                      return ChoiceChip(
                        label: Text(_triggerLabel(l10n, key)),
                        selected: selected,
                        onSelected: (_) => setState(
                            () => _trigger = selected ? null : key),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _note,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: l10n.checkinNote,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white))
                : Text(l10n.save),
          ),
        ],
      ),
    );
  }

  /// "本周渴求均值 3.2/5，低于上周 4.1——在变好" — or null when there is
  /// not enough history for a comparison.
  String? _insight(AppLocalizations l10n, AppState state) {
    final checkIns = state.checkInsFor(widget.habit.id!);
    final now = state.now;
    final thisWeek =
        averageOver(checkIns, now, endDaysAgo: 0, windowDays: 7, pick: (c) => c.craving.toDouble());
    if (thisWeek == null) return null;
    final lastWeek =
        averageOver(checkIns, now, endDaysAgo: 7, windowDays: 7, pick: (c) => c.craving.toDouble());
    if (lastWeek == null) {
      return l10n.insightNoCompare(thisWeek.toStringAsFixed(1));
    }
    final nowS = thisWeek.toStringAsFixed(1);
    final prevS = lastWeek.toStringAsFixed(1);
    return thisWeek <= lastWeek
        ? l10n.insightBetter(nowS, prevS)
        : l10n.insightWorse(nowS, prevS);
  }

  Future<void> _maybeAskForRating() async {
    final l10n = AppLocalizations.of(context);
    final go = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary),
        title: Text(l10n.rateTitle),
        content: Text(l10n.rateBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.rateLater),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.rateAction),
          ),
        ],
      ),
    );
    if (go == true) {
      await launchUrl(
        Uri.parse('https://apps.apple.com/app/id$kAppStoreId'),
        mode: LaunchMode.externalApplication,
      );
    }
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

  String _triggerLabel(AppLocalizations l10n, String key) {
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
}
