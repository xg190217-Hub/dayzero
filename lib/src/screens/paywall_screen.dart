import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../services/iap_service.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'settings_screen.dart' show kPrivacyUrl, kTermsUrl;

/// Premium paywall. Compliance built in:
///  - prices + periods shown for every tier
///  - Restore Purchases button
///  - auto-renewal disclosure incl. the 24h cancellation rule
///  - Terms of Use and Privacy Policy links inside the app
///    (Schedule 2 §3.8(b): StoreKit dialogs alone are not enough)
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String _selected = 'dayzero_yearly';
  bool _busy = false;

  static const _tiers = <(String, String, String, String?)>[
    ('dayzero_weekly', 'premiumWeekly', 'premiumPerWeek', null),
    ('dayzero_monthly', 'premiumMonthly', 'premiumPerMonth', null),
    ('dayzero_yearly', 'premiumYearly', 'premiumPerYear', 'premiumBestValue'),
    ('dayzero_lifetime', 'premiumLifetime', 'premiumOnce', null),
  ];

  Future<void> _buy() async {
    final l10n = AppLocalizations.of(context);
    final iap = context.read<IapService>();
    final state = context.read<AppState>();
    setState(() => _busy = true);

    if (!iap.enabled) {
      // Web demo: premium is already unlocked in demo mode.
      setState(() => _busy = false);
      return;
    }

    var ok = false;
    if (_selected == 'dayzero_lifetime') {
      ok = await iap.buyLifetime();
    } else {
      ok = await iap.buySubscription(_selected);
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.buyError)));
    } else if (state.premium && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _restore() async {
    final l10n = AppLocalizations.of(context);
    final iap = context.read<IapService>();
    final state = context.read<AppState>();
    if (!iap.enabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.demoMode)));
      return;
    }
    setState(() => _busy = true);
    await iap.restore();
    // Give the purchase stream a moment to deliver restored entitlements.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _busy = false);
    if (state.premium) {
      // Restored: leave the paywall.
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.restoreDone)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.restoreNothing)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final iap = context.watch<IapService>();
    final state = context.watch<AppState>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.premiumTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kLeafGreen, kDeepGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Icon(Icons.spa, color: Colors.white, size: 44),
                const SizedBox(height: 12),
                Text(
                  l10n.premiumSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'DayZeroNunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final (key, feature) in const [
            ('premiumFeature1', Icons.all_inclusive),
            ('premiumFeature2', Icons.insights),
            ('premiumFeature3', Icons.graphic_eq),
            ('premiumFeature4', Icons.palette),
          ])
            _featureRow(context, l10n, key, feature),
          const SizedBox(height: 16),
          Text(
            l10n.premiumFreeNote,
            style: TextStyle(color: scheme.outline, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          // Tier cards.
          for (final tier in _tiers) ...[
            _tierCard(context, l10n, iap, tier),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _busy ? null : _buy,
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white))
                : Text(l10n.premiumSubscribe),
          ),
          TextButton(
            onPressed: _busy ? null : _restore,
            child: Text(l10n.premiumRestore),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.premiumAutoRenew,
            style: TextStyle(color: scheme.outline, fontSize: 11, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.premiumTermsLinks(
                l10n.termsLink, l10n.privacyLink),
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.outline, fontSize: 11, height: 1.4),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _open(kTermsUrl),
                child: Text(l10n.termsLink),
              ),
              TextButton(
                onPressed: () => _open(kPrivacyUrl),
                child: Text(l10n.privacyLink),
              ),
            ],
          ),
          if (state.demoMode)
            Center(
              child: Text(
                l10n.demoMode,
                style: TextStyle(color: scheme.outline, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _featureRow(BuildContext context, AppLocalizations l10n, String key,
      IconData icon) {
    String label;
    switch (key) {
      case 'premiumFeature1':
        label = l10n.premiumFeature1;
      case 'premiumFeature2':
        label = l10n.premiumFeature2;
      case 'premiumFeature3':
        label = l10n.premiumFeature3;
      default:
        label = l10n.premiumFeature4;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: kLeafGreen, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }

  Widget _tierCard(BuildContext context, AppLocalizations l10n,
      IapService iap, (String, String, String, String?) tier) {
    final (id, nameKey, perKey, badgeKey) = tier;
    final selected = _selected == id;
    final scheme = Theme.of(context).colorScheme;
    final price = iap.products[id]?.price ?? _placeholderPrice(id, context);

    String name;
    switch (nameKey) {
      case 'premiumWeekly':
        name = l10n.premiumWeekly;
      case 'premiumMonthly':
        name = l10n.premiumMonthly;
      case 'premiumLifetime':
        name = l10n.premiumLifetime;
      default:
        name = l10n.premiumYearly;
    }
    String per;
    switch (perKey) {
      case 'premiumPerWeek':
        per = l10n.premiumPerWeek;
      case 'premiumPerMonth':
        per = l10n.premiumPerMonth;
      case 'premiumOnce':
        per = l10n.premiumOnce;
      default:
        per = l10n.premiumPerYear;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _selected = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? kLeafGreen.withValues(alpha: 0.10)
              : scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? kLeafGreen : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? kLeafGreen : scheme.outlineVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(name,
                  style: const TextStyle(
                      fontFamily: 'DayZeroNunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ),
            if (badgeKey != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9A825),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.premiumBestValue,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            const SizedBox(width: 8),
            Text(
              '$price$per',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// Prices shown before StoreKit has loaded (offline / first frame).
  /// English screens show USD, everything else falls back to CNY.
  String _placeholderPrice(String id, BuildContext context) {
    final isEn = Localizations.localeOf(context).languageCode == 'en';
    if (isEn) {
      switch (id) {
        case 'dayzero_weekly':
          return r'$2.99';
        case 'dayzero_monthly':
          return r'$6.99';
        case 'dayzero_yearly':
          return r'$34.99';
        default:
          return r'$69.99';
      }
    }
    switch (id) {
      case 'dayzero_weekly':
        return '¥18';
      case 'dayzero_monthly':
        return '¥45';
      case 'dayzero_yearly':
        return '¥268';
      default:
        return '¥598';
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri);
    }
  }
}
