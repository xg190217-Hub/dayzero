import 'package:flutter/material.dart';

/// DayZero palette: calm deep greens over warm neutrals. Deliberately soft —
/// the app is a companion during high-stress moments.
const kDeepGreen = Color(0xFF0B3D2E);
const kLeafGreen = Color(0xFF146A4F);
const kSage = Color(0xFF8FBF9F);
const kWarmBackground = Color(0xFFF6F4EE);
const kDarkBackground = Color(0xFF101714);

ThemeData buildDayZeroTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: kLeafGreen,
    brightness: brightness,
    primary: kLeafGreen,
    surface: isDark ? kDarkBackground : kWarmBackground,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: isDark ? kDarkBackground : kWarmBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'DayZeroNunito',
        fontWeight: FontWeight.w700,
        fontSize: 22,
        color: scheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: isDark ? const Color(0xFF1A2420) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kLeafGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
            fontFamily: 'DayZeroNunito',
            fontWeight: FontWeight.w700,
            fontSize: 16),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: isDark ? const Color(0xFF16201C) : Colors.white,
      indicatorColor: kSage.withValues(alpha: 0.35),
      labelTextStyle: WidgetStatePropertyAll(TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      )),
    ),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),
  );
}

/// Display numbers in the big counters with the rounded display font.
TextStyle displayFont(BuildContext context, {double size = 64}) => TextStyle(
      fontFamily: 'DayZeroNunito',
      fontWeight: FontWeight.w700,
      fontSize: size,
      color: Theme.of(context).colorScheme.onSurface,
    );
