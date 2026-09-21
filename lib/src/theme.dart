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
  'sunset': ThemePreset(Color(0xFFC4551D), Color(0xFFF9F1E9)),
  'violet': ThemePreset(Color(0xFF5B3AA8), Color(0xFFF2EFF8)),
};

/// Body font options (all OFL-licensed, bundled locally).
const kFontFamilies = <String, String>{
  'roboto': 'Roboto',
  'nunito': 'DayZeroNunito',
  'lora': 'Lora',
  'space': 'SpaceGrotesk',
};

/// Text color swatches offered in settings. 'auto' = theme-defined color.
const kTextColorOptions = <String, Color?>{
  'auto': null,
  'ink': Color(0xFF1A1A1A),
  'brown': Color(0xFF3E2723),
  'navy': Color(0xFF0D3B66),
  'violet': Color(0xFF4A148C),
  'forest': Color(0xFF1B5E20),
  'crimson': Color(0xFFB71C1C),
  'teal': Color(0xFF006064),
  'slate': Color(0xFF37474F),
};

ThemeData buildDayZeroTheme(
  Brightness brightness, {
  String preset = 'sage',
  Color? seedOverride,
  String fontCode = 'roboto',
  Color? textColor,
}) {
  final isDark = brightness == Brightness.dark;
  final p = kThemePresets[preset] ?? kThemePresets['sage']!;
  final seed = seedOverride ?? p.seed;
  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: brightness,
    primary: seed,
    surface: isDark ? kDarkBackground : p.surface,
  );
  final fontFamily = kFontFamilies[fontCode] ?? 'Roboto';
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
        foregroundColor: Colors.white,
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
