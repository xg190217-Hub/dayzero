import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../models/habit.dart';

import '../services/notifications.dart';
import '../state/app_state.dart';
import '../theme.dart';
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
                leading: const Icon(Icons.workspace_premium,
                    color: kLeafGreen),
                title: const Text('DayZero Premium',
                    style: TextStyle(
                        fontFamily: 'DayZeroNunito',
                        fontWeight: FontWeight.w700)),
                subtitle: Text(l10n.premiumSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const PaywallScreen())),
              ),
            ),
          if (state.isPremium)
            Card(
              child: ListTile(
                leading: const Icon(Icons.verified, color: kLeafGreen),
                title: Text(l10n.settingsPremium),
                subtitle: Text(l10n.settingsPremiumActive),
              ),
            ),
          const SizedBox(height: 12),
          _section(context, l10n.settingsHabits, [
            ...state.habits.map((h) => ListTile(
                  leading: HabitIcon(type: h.type, size: 32),
                  title: Text(_habitLabel(l10n, h)),
                  subtitle: Text(
                      '${h.quitDate.year}-${h.quitDate.month.toString().padLeft(2, '0')}-${h.quitDate.day.toString().padLeft(2, '0')}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDeleteHabit(context, h),
                  ),
                )),
            ListTile(
              leading: const Icon(Icons.add, color: kLeafGreen),
              title: Text(l10n.homeAddHabit),
              enabled: state.canAddHabit,
              onTap: state.canAddHabit
                  ? () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const OnboardingScreen(addMode: true)))
                  : null,
            ),
          ]),
          _section(context, l10n.settingsNotifications, [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: Text(l10n.settingsNotifications),
              subtitle: Text(l10n.settingsNotificationsDesc),
              value: state.notificationsEnabled,
              onChanged: (v) async {
                await state.setNotifications(v);
                final notifications = context.read<NotificationService>();
                if (v) {
                  await notifications.requestPermission();
                  await notifications.scheduleDaily();
                } else {
                  await notifications.cancel();
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
                  const DropdownMenuItem(
                      value: 'system', child: Text('System')),
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
      await context.read<AppState>().deleteHabit(habit);
    }
  }

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsDeleteData),
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
