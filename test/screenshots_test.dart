// App Store screenshot generator.
//
// Regenerate with:
//   GEN_SCREENSHOTS=1 node tools/fj.js test --update-goldens test/screenshots_test.dart
//
// Renders the real UI at the exact sizes App Store Connect requires for
// iPhone (6.9" = 1320x2868, the only required set since Apple auto-scales
// it for smaller devices; 6.5" = 1242x2688 as the optional legacy set).
// Real Roboto/Nunito glyphs are loaded so text renders correctly, plus
// Noto Sans SC for CJK and Arial for Cyrillic/Arabic.
//
// Skipped by default (no GEN_SCREENSHOTS env var): golden rendering is not
// pixel-stable across platforms, so plain `flutter test` stays green.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dayzero/src/app.dart';
import 'package:dayzero/src/db/database.dart';
import 'package:dayzero/src/services/audio_service.dart';
import 'package:dayzero/src/services/iap_service.dart';
import 'package:dayzero/src/services/notifications.dart';
import 'package:dayzero/src/state/app_state.dart';

Future<void> _loadFonts() async {
  final dir = Directory('test/assets/fonts');
  const families = {
    'Roboto': {
      400: 'roboto-latin-400-normal.ttf',
      500: 'roboto-latin-500-normal.ttf',
      700: 'roboto-latin-700-normal.ttf',
    },
    'DayZeroNunito': {
      400: 'nunito-latin-400-normal.ttf',
      500: 'nunito-latin-500-normal.ttf',
      700: 'nunito-latin-700-normal.ttf',
    },
  };
  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final weight in entry.value.entries) {
      final bytes = await File('${dir.path}/${weight.value}').readAsBytes();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  }
  // Extra glyph coverage, same family so they act as fallbacks.
  // Order matters: seguiemj must come BEFORE NotoSansSC, which declares
  // monochrome glyphs for some emoji codepoints and would otherwise
  // shadow the color versions (mood faces rendered as thin outlines).
  for (final path in [
    'C:/Windows/Fonts/seguiemj.ttf', // color emoji: 🔥 😖😕😐🙂😄 …
    'C:/Windows/Fonts/NotoSansSC-VF.ttf', // CJK + kana + hangul
    'C:/Windows/Fonts/arial.ttf', // Cyrillic + Arabic
  ]) {
    final loader = FontLoader('Roboto');
    final bytes = await File(path).readAsBytes();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }
  {
    final loader = FontLoader('MaterialIcons');
    final bytes = await File(
      'C:/flutter/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
    ).readAsBytes();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    await loader.load();
  }
}

/// Seeds a believable demo state: one smoking habit quit 47 days ago with a
/// daily spend, two weeks of check-ins for the charts, and a few reasons for
/// the SOS screen. History rows are inserted with explicit dates (the state
/// API always stamps "today", which would collapse the chart to one point).
Future<AppState> _makeState(WidgetTester tester, {String locale = 'en'}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await tester.runAsync(SharedPreferences.getInstance);
  final db = (await tester.runAsync(
      () => openAppDatabase(inMemoryDatabasePath, factory: databaseFactoryFfi)))!;

  final habitId = (await tester.runAsync(() => db.insert('habits', {
        'type': 'smoking',
        'name': 'Smoking',
        'quit_date': DateTime(2026, 8, 3).millisecondsSinceEpoch, // 47 days
        'daily_spend': 30.0,
        'daily_amount': 20.0,
        'created_at': DateTime(2026, 8, 3).millisecondsSinceEpoch,
      })))!;
  // Two weeks of history, deliberately excluding today so the home screen
  // still shows the "Check in today" call-to-action.
  for (var i = 14; i >= 1; i--) {
    final day = DateTime(2026, 9, 19 - i);
    final key =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    await tester.runAsync(() => db.insert('check_ins', {
          'habit_id': habitId,
          'date': key,
          'mood': 2 + (i % 4), // 2..5
          'craving': 2 + (i % 3),
          'trigger': i % 5 == 0 ? 'trigger_stress' : 'trigger_none',
          'note': null,
        }));
  }

  final state = AppState(
    db: db,
    prefs: prefs!,
    clock: () => DateTime(2026, 9, 19, 20, 0),
  );
  await tester.runAsync(state.load);
  await tester.runAsync(() => state.setLocale(locale));
  await tester.runAsync(() => state.setReasons([
        'My family',
        'Better health',
        'Saving money',
      ]));
  return state;
}

Widget _wrap(AppState state) {
  final audio = AudioService();
  final iap = IapService(enabled: false);
  final notifications = NotificationService(enabled: false);
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: state),
      Provider<AudioService>.value(value: audio),
      ChangeNotifierProvider<IapService>.value(value: iap),
      Provider<NotificationService>.value(value: notifications),
    ],
    child: const DayZeroApp(),
  );
}

/// Fixed pumps instead of pumpAndSettle: the home run timer ticks every
/// second, so pumpAndSettle would never settle.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 450));
}

/// Pumps two settle frames first so fonts are fully rasterized.
Future<void> _shot(WidgetTester tester, String label) async {
  await tester.pump(const Duration(milliseconds: 150));
  await tester.pump(const Duration(milliseconds: 150));
  await expectLater(find.byType(DayZeroApp), matchesGoldenFile(label));
}

/// The six store screenshots for one surface size.
Future<void> _renderSet(
    WidgetTester tester, Size physical, String subdir, String locale) async {
  tester.view.physicalSize = physical;
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
  final state = await _makeState(tester, locale: locale);
  final prefix = 'screenshots/$subdir/';

  // 1 — Home: the day counter + money saved hero.
  await tester.pumpWidget(_wrap(state));
  await _settle(tester);
  await _shot(tester, '${prefix}01_home.png');

  // 2 — Check-in: mood, craving and triggers. Icon finders are
  // locale-independent (the screenshot set renders in EN and ZH).
  await tester.tap(find.byIcon(Icons.edit_note).first);
  await _settle(tester);
  await _shot(tester, '${prefix}02_checkin.png');
  await tester.tap(find.byType(BackButton).first);
  await _settle(tester);

  // 3 — SOS: the breathing circle. The animation loops forever, so use
  // fixed pumps instead of pumpAndSettle.
  await tester.tap(find.byIcon(Icons.favorite).first);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
  await _shot(tester, '${prefix}03_sos.png');
  await tester.tap(find.byType(BackButton).first);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 600));
  await _settle(tester);

  // 4 — Stats: weekly charts with two weeks of data.
  await tester.tap(find.byIcon(Icons.insights_outlined));
  await _settle(tester);
  await _shot(tester, '${prefix}04_stats.png');

  // 5 — Milestones: unlocked and upcoming badges.
  await tester.tap(find.byIcon(Icons.emoji_events_outlined));
  await _settle(tester);
  await _shot(tester, '${prefix}05_milestones.png');

  // 6 — Paywall: premium tiers and compliance links.
  await tester.tap(find.byIcon(Icons.settings_outlined));
  await _settle(tester);
  await tester.tap(find.byIcon(Icons.workspace_premium).first);
  await _settle(tester);
  await _shot(tester, '${prefix}06_paywall.png');
}

void main() {
  final generating = Platform.environment['GEN_SCREENSHOTS'] == '1';

  setUpAll(() async {
    sqfliteFfiInit();
    // Fonts must load BEFORE the tests render (tearDownAll would be too
    // late — every glyph would render as a tofu block).
    await _loadFonts();
  });

  testWidgets('screenshots @6.9 EN (1320x2868, required set)', (tester) async {
    await _renderSet(tester, const Size(1320, 2868), '6.9_en', 'en');
  }, skip: !generating);

  testWidgets('screenshots @6.9 ZH (1320x2868, zh-Hans store)', (tester) async {
    await _renderSet(tester, const Size(1320, 2868), '6.9_zh', 'zh');
  }, skip: !generating);

  testWidgets('screenshots @6.5 EN (1242x2688, legacy set)', (tester) async {
    await _renderSet(tester, const Size(1242, 2688), '6.5_en', 'en');
  }, skip: !generating);
}
