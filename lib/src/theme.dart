import 'package:flutter/material.dart';

/// DayZero palette: calm deep greens over warm neutrals. Deliberately soft —
/// the app is a companion during high-stress moments.
const kDeepGreen = Color(0xFF0B3D2E);
const kLeafGreen = Color(0xFF146A4F);
const kSage = Color(0xFF8FBF9F);
const kWarmBackground = Color(0xFFF6F4EE);
const kDarkBackground = Color(0xFF101714);

/// Premium theme presets. Each defines a seed color and a light surface.
class ThemePreset {
  const ThemePreset(this.seed, this.surface);

  final Color seed;
  final Color surface;
}

const kThemePresets = <String, ThemePreset>{
  'sage': ThemePreset(kLeafGreen, kWarmBackground),
  'forest': ThemePreset(Color(0xFF1B4332), Color(0xFFEDF3EC)),
  'ocean': ThemePreset(Color(0xFF0B5563), Color(0xFFEBF3F5)),
  'rose': ThemePreset(Color(0xFFAD3A6B), Color(0xFFF8F0F3)),
  // #A8461A: keeps the warm sunset feel with a safer white-on contrast
  // margin (5.9:1 vs the borderline 4.5:1 of #C4551D).
  'sunset': ThemePreset(Color(0xFFA8461A), Color(0xFFF9F1E9)),
  'violet': ThemePreset(Color(0xFF5B3AA8), Color(0xFFF2EFF8)),
};

/// Body font options (all OFL-licensed, bundled locally).
const kFontFamilies = <String, String>{
  'roboto': 'Roboto',
  'nunito': 'DayZeroNunito',
  'lora': 'Lora',
  'space': 'SpaceGrotesk',
};

/// Text color swatches offered in settings. Each entry is a
/// (light-mode, dark-mode) pair: dark mode needs light variants to clear
/// WCAG AA against the dark surface (dark-on-dark would be invisible).
const kTextColorOptions = <String, (Color?, Color?)>{
  'auto': (null, null),
  'ink': (Color(0xFF1A1A1A), Color(0xFFE8E6E1)),
  'brown': (Color(0xFF3E2723), Color(0xFFE0C9C0)),
  'navy': (Color(0xFF0D3B66), Color(0xFF9EC5FF)),
  'forest': (Color(0xFF1B5E20), Color(0xFFA5D6A7)),
  'crimson': (Color(0xFFB71C1C), Color(0xFFFF8A80)),
  'teal': (Color(0xFF006064), Color(0xFF80CBC4)),
  'violet': (Color(0xFF4A148C), Color(0xFFCE93D8)),
  'slate': (Color(0xFF37474F), Color(0xFFB0BEC5)),
};

/// SOS button semantic pair. Warm amber (not alarm red — peak-craving users
/// need a lifeline, not a threat cue) with contrast-safe text:
///  - light mode: amber fill + dark-amber text (6.9:1) + a subtle border so
///    the button shape reads against the light background (WCAG 1.4.11)
///  - dark mode: lighter amber glow + darker text (8.4:1)
const kSosLightFill = Color(0xFFF9A825);
const kSosLightText = Color(0xFF3E2A00);
const kSosBorder = Color(0xFFC98600);
const kSosDarkFill = Color(0xFFE8A33D);
const kSosDarkText = Color(0xFF2E1F00);

/// Foreground for text/buttons on [bg]: dark text when the background is
/// light enough that white would fail contrast (covers custom hues in the
/// yellow range, where white-on-yellow drops below WCAG AA).
Color onSeed(Color bg) {
  return bg.computeLuminance() > 0.35
      ? const Color(0xFF06301F)
      : Colors.white;
}

ThemeData buildDayZeroTheme(
  Brightness brightness, {
  String preset = 'sage',
  Color? seedOverride,
  String fontCode = 'roboto',
  String textColorCode = 'auto',
}) {
  final isDark = brightness == Brightness.dark;
  final p = kThemePresets[preset] ?? kThemePresets['sage']!;
  final seed = seedOverride ?? p.seed;
  // No `primary:` override: ColorScheme.fromSeed already computes a lighter,
  // desaturated primary for dark mode (WCAG-safe on dark surfaces).
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: brightness,
    surface: isDark ? kDarkBackground : p.surface,
  );
  final fontFamily = kFontFamilies[fontCode] ?? 'Roboto';
  // Text colors are brightness-paired; dark mode picks the light variant.
  final pair = kTextColorOptions[textColorCode] ?? (null, null);
  final textColor = isDark ? pair.$2 : pair.$1;
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: isDark ? kDarkBackground : p.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
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
        backgroundColor: seed,
        // Dark text on light custom hues (yellows), white on dark seeds —
        // keeps WCAG AA for every slider position.
        foregroundColor: onSeed(seed),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(
            fontFamily: fontFamily,
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
  final bodyColor = textColor ?? scheme.onSurface;
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: bodyColor,
      displayColor: bodyColor,
    ),
  );
}

/// Display numbers in the big counters with the active theme font.
TextStyle displayFont(BuildContext context, {double size = 64}) => TextStyle(
      // ThemeData doesn't expose fontFamily; the text theme carries it.
      fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: size,
      color: Theme.of(context).colorScheme.onSurface,
    );
