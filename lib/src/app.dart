import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import 'screens/main_shell.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_state.dart';
import 'theme.dart';

class DayZeroApp extends StatelessWidget {
  const DayZeroApp({super.key});

  static const supportedLocales = [
    Locale('en'),
    Locale('zh'),
    Locale('ja'),
    Locale('de'),
    Locale('fr'),
    Locale('es'),
    Locale('pt'),
    Locale('ru'),
    Locale('ko'),
    Locale('it'),
    Locale('ar'),
    Locale('tr'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        Locale? locale;
        if (state.localeCode != 'system') {
          locale = Locale(state.localeCode);
        }
        // 'custom' theme: the hue slider drives the seed color directly.
        final seedOverride = state.themeCode == 'custom'
            ? HSLColor.fromAHSL(1, state.customHue.toDouble(), 0.55, 0.35)
                .toColor()
            : null;
        return MaterialApp(
          title: 'DayZero',
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: supportedLocales,
          theme: buildDayZeroTheme(
            Brightness.light,
            preset: state.themeCode,
            seedOverride: seedOverride,
            fontCode: state.fontCode,
            textColorCode: state.textColorCode,
          ),
          darkTheme: buildDayZeroTheme(
            Brightness.dark,
            preset: state.themeCode,
            seedOverride: seedOverride,
            fontCode: state.fontCode,
            textColorCode: state.textColorCode,
          ),
          themeMode: ThemeMode.system,
          home: state.loaded
              ? (state.habits.isEmpty
                  ? const OnboardingScreen()
                  : const MainShell())
              : const _BootScreen(),
        );
      },
    );
  }
}

/// Visible boot status: initialization steps are observable and time-bounded
/// (silent failure is the most expensive failure).
class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            SizedBox(height: 16),
            Text('DayZero'),
          ],
        ),
      ),
    );
  }
}
