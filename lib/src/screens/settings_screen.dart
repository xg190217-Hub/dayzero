import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../models/habit.dart';
import '../models/if_then_plan.dart';

import '../services/notifications.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/edit_habit_sheet.dart';
import '../widgets/habit_icon.dart';
import 'onboarding_screen.dart';
import 'paywall_screen.dart';

/// Support / privacy / terms URLs. Replace with the final hosted pages
/// before release (see store/ directory).
const kPrivacyUrl = 'https://xg190217-hub.github.io/dayzero/privacy';
const kTermsUrl = 'https://xg190217-hub.github.io/dayzero/terms';
const kSupportUrl = 'https://xg190217-hub.github.io/dayzero/support';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          if (!state.isPremium)
            Card(
              child: ListTile(
                leading: Icon(Icons.workspace_premium,
                    color: Theme.of(context).colorScheme.primary),
                title: Text(l10n.settingsPremium,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(l10n.premiumSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PaywallScreen())),
              ),
            ),
          if (state.isPremium)
            Card(
              child: ListTile(
                leading: Icon(Icons.verified, color: Theme.of(context).colorScheme.primary),
                title: Text(l10n.settingsPremium),
                subtitle: Text(l10n.settingsPremiumActive),
              ),
            ),
          // Appearance customization (part of the paywall's feature list).
          if (state.isPremium)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.palette_outlined, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(l10n.settingsThemes,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...kThemePresets.keys.map((code) {
                          final preset = kThemePresets[code]!;
                          final selected = state.themeCode == code;
                          return ChoiceChip(
                            avatar: CircleAvatar(
                              backgroundColor: preset.seed,
                              radius: 10,
                            ),
                            label: Text(_themeLabel(l10n, code)),
                            selected: selected,
                            onSelected: (_) => state.setTheme(code),
                          );
                        }),
                        // Fully custom: hue slider dialog.
                        ChoiceChip(
                          avatar: CircleAvatar(
                            backgroundColor: HSLColor.fromAHSL(
                                    1,
                                    state.customHue.toDouble(),
                                    0.55,
                                    0.35)
                                .toColor(),
                            radius: 10,
                          ),
                          label: Text(l10n.theme_custom),
                          selected: state.themeCode == 'custom',
                          onSelected: (_) => _customThemeDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.text_fields, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(l10n.settingsFont,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: kFontFamilies.entries.map((entry) {
                        final selected = state.fontCode == entry.key;
                        return ChoiceChip(
                          avatar: Text('Aa',
                              style: TextStyle(
                                fontFamily: entry.value,
                                fontWeight: FontWeight.w700,
                              )),
                          label: Text(entry.value
                              .replaceFirst('DayZero', '')
                              .replaceFirst('Space', 'Space ')),
                          selected: selected,
                          onSelected: (_) => state.setFont(entry.key),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.format_color_text, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(l10n.settingsTextColor,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kTextColorOptions.entries.map((entry) {
                        final selected = state.textColorCode == entry.key;
                        final isDark = Theme.of(context).brightness ==
                            Brightness.dark;
                        // Brightness-paired: the swatch shows the color that
                        // will actually be used in the current mode.
                        final swatch = isDark ? entry.value.$2 : entry.value.$1;
                        return GestureDetector(
                          onTap: () => state.setTextColor(entry.key),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: swatch ??
                                  Theme.of(context).colorScheme.onSurface,
                              border: Border.all(
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                width: selected ? 3 : 1,
                              ),
                            ),
                            child: swatch == null
                                ? Icon(Icons.text_fields,
                                    size: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          _section(context, l10n.settingsHabits, [
            ...state.habits.map((h) => ListTile(
                  leading: HabitIcon(type: h.type, size: 32),
                  title: Text(_habitLabel(l10n, h)),
                  subtitle: Text(
                      '${h.quitDate.year}-${h.quitDate.month.toString().padLeft(2, '0')}-${h.quitDate.day.toString().padLeft(2, '0')}'),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => EditHabitSheet(habit: h),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDeleteHabit(context, h),
                  ),
                )),
            ListTile(
              leading: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              title: Text(l10n.homeAddHabit),
              onTap: () {
                if (state.canAddHabit) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const OnboardingScreen(addMode: true)));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const PaywallScreen()));
                }
              },
            ),
            // Currency symbol for the money-saved counters.
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: Text(l10n.homeMoneySaved),
              trailing: DropdownButton<String>(
                value: state.currencySymbol,
                underline: const SizedBox.shrink(),
                items: const ['¥', r'$', '€', '£', '₹', '₩', '฿', 'R\$']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) async {
                  if (v != null) await state.setCurrency(v);
                },
              ),
            ),
          ]),
          _section(context, l10n.plansTitle, [
            if (state.plans.isEmpty)
              ListTile(
                leading: Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary),
                title: Text(l10n.plansEmpty),
              ),
            ...state.plans.map((p) => ListTile(
                  leading: Icon(Icons.route, color: Theme.of(context).colorScheme.primary),
                  title: Text(
                      '${l10n.plansWhen} ${_triggerLabel(l10n, p.trigger)} → ${p.action}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      final updated = List.of(state.plans)..remove(p);
                      await state.setPlans(updated);
                    },
                  ),
                )),
            ListTile(
              leading: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              title: Text(l10n.plansAdd),
              onTap: () => _addPlanDialog(context),
            ),
          ]),
          _section(context, l10n.settingsReasons, [
            ...state.reasons.map((r) => ListTile(
                  leading: Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary),
                  title: Text(r),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      final updated = List.of(state.reasons)..remove(r);
                      await state.setReasons(updated);
                    },
                  ),
                )),
            ListTile(
              leading: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              title: Text(l10n.addReason),
              onTap: () => _addReasonDialog(context),
            ),
          ]),
          _section(context, l10n.settingsNotifications, [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: Text(l10n.settingsNotifications),
              subtitle: Text(l10n.settingsNotificationsTime(state.reminderHour)),
              value: state.notificationsEnabled,
              onChanged: (v) async {
                final notifications = context.read<NotificationService>();
                await state.setNotifications(v);
                if (v) {
                  await notifications.requestPermission();
                  await notifications.scheduleDaily(
                    title: l10n.appTitle,
                    body: l10n.notifBody,
                    hour: state.reminderHour,
                  );
                } else {
                  await notifications.cancel();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(l10n.settingsNotifications),
              trailing: Text(
                '${state.reminderHour.toString().padLeft(2, '0')}:00',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onTap: () async {
                final notifications = context.read<NotificationService>();
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: state.reminderHour, minute: 0),
                );
                if (picked != null) {
                  await state.setReminderHour(picked.hour);
                  if (state.notificationsEnabled) {
                    await notifications.scheduleDaily(
                      title: l10n.appTitle,
                      body: l10n.notifBody,
                      hour: picked.hour,
                    );
                  }
                }
              },
            ),
          ]),
          _section(context, l10n.settingsLanguage, [
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.settingsLanguage),
              trailing: DropdownButton<String>(
                value: state.localeCode,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(
                      value: 'system', child: Text(l10n.language_system)),
                  DropdownMenuItem(
                      value: 'en', child: Text(l10n.language_en)),
                  DropdownMenuItem(
                      value: 'zh', child: Text(l10n.language_zh)),
                  DropdownMenuItem(
                      value: 'ja', child: Text(l10n.language_ja)),
                  DropdownMenuItem(
                      value: 'de', child: Text(l10n.language_de)),
                  DropdownMenuItem(
                      value: 'fr', child: Text(l10n.language_fr)),
                  DropdownMenuItem(
                      value: 'es', child: Text(l10n.language_es)),
                  DropdownMenuItem(
                      value: 'pt', child: Text(l10n.language_pt)),
                  DropdownMenuItem(
                      value: 'ru', child: Text(l10n.language_ru)),
                  DropdownMenuItem(
                      value: 'ko', child: Text(l10n.language_ko)),
                  DropdownMenuItem(
                      value: 'it', child: Text(l10n.language_it)),
                  DropdownMenuItem(
                      value: 'ar', child: Text(l10n.language_ar)),
                  DropdownMenuItem(
                      value: 'tr', child: Text(l10n.language_tr)),
                ],
                onChanged: (v) async {
                  if (v != null) await state.setLocale(v);
                },
              ),
            ),
          ]),
          _section(context, l10n.settingsAbout, [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(l10n.settingsExport),
              subtitle: Text(l10n.settingsExportDesc),
              onTap: () => _export(context),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(l10n.settingsPrivacy),
              onTap: () => _open(kPrivacyUrl),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l10n.settingsTerms),
              onTap: () => _open(kTermsUrl),
            ),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: Text(l10n.settingsSupport),
              onTap: () => _open(kSupportUrl),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.settingsAbout),
              subtitle: Text(l10n.settingsAboutBody),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined,
                  color: Colors.redAccent),
              title: Text(l10n.settingsDeleteData,
                  style: const TextStyle(color: Colors.redAccent)),
              onTap: () => _confirmDeleteAll(context),
            ),
          ]),
          if (state.demoMode)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Text(
                  l10n.demoMode,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
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

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        Card(
          child: Column(
            children: [for (final c in children) c],
          ),
        ),
      ],
    );
  }

  String _themeLabel(AppLocalizations l10n, String code) {
    switch (code) {
      case 'sage':
        return l10n.theme_sage;
      case 'forest':
        return l10n.theme_forest;
      case 'ocean':
        return l10n.theme_ocean;
      case 'rose':
        return l10n.theme_rose;
      case 'sunset':
        return l10n.theme_sunset;
      case 'violet':
        return l10n.theme_violet;
      default:
        return l10n.theme_custom;
    }
  }

  /// Hue-slider dialog: pick any color on the wheel, live preview included.
  Future<void> _customThemeDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final state = context.read<AppState>();
    var hue = state.customHue;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final color =
                HSLColor.fromAHSL(1, hue.toDouble(), 0.55, 0.35).toColor();
            return AlertDialog(
              title: Text(l10n.theme_custom),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: hue.toDouble(),
                    min: 0,
                    max: 360,
                    activeColor: color,
                    onChanged: (v) {
                      hue = v.round();
                      setDialogState(() {});
                      state.setCustomHue(hue);
                    },
                  ),
                  Text(
                    'HUE $hue°',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    state.setTheme('custom');
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
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

  /// if-then editor: pick a concrete trigger, write the concrete action.
  Future<void> _addPlanDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    var trigger = 'trigger_stress';
    const triggers = [
      'trigger_stress',
      'trigger_social',
      'trigger_boredom',
      'trigger_habit_loop',
      'trigger_negative',
      'trigger_celebration',
    ];
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(l10n.plansAdd),
          // Scrollable: long trigger translations + accessibility text
          // scaling must never push the actions off a small screen.
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.plansWhen,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: triggers.map((key) {
                    final selected = trigger == key;
                    return ChoiceChip(
                      label: Text(_triggerLabel(l10n, key)),
                      selected: selected,
                      onSelected: (_) => setDialogState(() => trigger = key),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.plansAction,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(true),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    if (saved == true && controller.text.trim().isNotEmpty) {
      if (!context.mounted) return;
      final state = context.read<AppState>();
      await state.setPlans([
        ...state.plans,
        IfThenPlan(trigger: trigger, action: controller.text.trim()),
      ]);
    }
  }

  Future<void> _addReasonDialog(BuildContext context) async {
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).addReason),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).reasonPlaceholder,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text(AppLocalizations.of(context).save),
          ),
        ],
      ),
    );
    if (text != null && text.isNotEmpty) {
      if (!context.mounted) return;
      final state = context.read<AppState>();
      await state.setReasons([...state.reasons, text]);
    }
  }

  Future<void> _export(BuildContext context) async {
    final state = context.read<AppState>();
    final data = state.exportJson();
    await SharePlus.instance.share(ShareParams(
      files: [
        XFile.fromData(
          Uint8List.fromList(utf8.encode(data)),
          mimeType: 'application/json',
          name: 'dayzero-export.json',
        ),
      ],
    ));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).exportDone)));
  }

  Future<void> _confirmDeleteHabit(BuildContext context, Habit habit) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_habitLabel(l10n, habit)),
        content: Text(l10n.deleteHabitConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (!context.mounted) return;
      await context.read<AppState>().deleteHabit(habit);
    }
  }

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsDeleteData),
        content: Text(l10n.deleteAllConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (!context.mounted) return;
      final state = context.read<AppState>();
      for (final h in List.of(state.habits)) {
        await state.deleteHabit(h);
      }
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri);
    }
  }
}
