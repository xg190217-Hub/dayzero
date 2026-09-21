import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../data/milestones.dart';
import '../logic/progress.dart';
import '../models/check_in.dart';
import '../models/habit.dart';
import '../models/if_then_plan.dart';
import '../models/lapse.dart';

/// Free tier: up to 2 habits. Premium removes the cap and unlocks advanced
/// stats, the full audio library and themes.
const int kFreeHabitLimit = 2;

/// Injectable clock so tests and the screenshot pipeline run on a fixed date
/// (golden tests otherwise drift across days).
typedef Clock = DateTime Function();

/// Global app state: habits, check-ins, achievements, premium and settings.
class AppState extends ChangeNotifier {
  AppState({
    required sqflite.Database db,
    required SharedPreferences prefs,
    Clock? clock,
  })  : _db = db,
        _prefs = prefs,
        _clock = clock ?? DateTime.now;

  final sqflite.Database _db;
  final SharedPreferences _prefs;
  final Clock _clock;

  final List<Habit> habits = [];
  final List<CheckIn> checkIns = [];
  final List<Lapse> lapses = [];

  /// habitId -> set of unlocked milestone keys (time/money/streak combined).
  final Map<int, Set<String>> unlocked = {};

  /// Keys unlocked by the latest mutation (used for celebration UI).
  Set<String> newlyUnlocked = {};

  bool premium = false;
  bool demoMode = false;
  bool notificationsEnabled = true;

  /// Hour of the daily check-in reminder (24h clock).
  int reminderHour = 20;
  String localeCode = 'system';
  String themeCode = 'sage';

  /// Hue (0-360) used when [themeCode] is 'custom'.
  int customHue = 150;

  /// Body font selection (see kFontFamilies in theme.dart).
  String fontCode = 'roboto';

  /// Text color selection (see kTextColorOptions in theme.dart).
  String textColorCode = 'auto';

  /// Currency symbol for the "money saved" counters.
  String currencySymbol = '¥';
  List<String> reasons = [];

  /// If-then coping plans: the app's strongest evidence-based mechanism.
  List<IfThenPlan> plans = [];

  bool loaded = false;

  DateTime get now => _clock();

  bool get isPremium => premium || demoMode;

  bool get atHabitLimit => habits.length >= kFreeHabitLimit;

  bool get canAddHabit => isPremium || habits.length < kFreeHabitLimit;

  /// All check-ins for one habit.
  List<CheckIn> checkInsFor(int habitId) =>
      checkIns.where((c) => c.habitId == habitId).toList();

  CheckIn? checkInToday(int habitId) {
    final key = CheckIn.dateKey(now);
    for (final c in checkIns) {
      if (c.habitId == habitId && c.date == key) return c;
    }
    return null;
  }

  // ---------------------------------------------------------------- loading

  Future<void> load() async {
    premium = _prefs.getBool('premium') ?? false;
    demoMode = _prefs.getBool('demoMode') ?? false;
    notificationsEnabled = _prefs.getBool('notifications') ?? true;
    reminderHour = _prefs.getInt('reminderHour') ?? 20;
    localeCode = _prefs.getString('locale') ?? 'system';
    themeCode = _prefs.getString('theme') ?? 'sage';
    customHue = _prefs.getInt('customHue') ?? 150;
    fontCode = _prefs.getString('font') ?? 'roboto';
    textColorCode = _prefs.getString('textColor') ?? 'auto';
    currencySymbol = _prefs.getString('currency') ?? '¥';
    reasons = _prefs.getStringList('reasons') ?? [];
    plans = IfThenPlan.decodeList(_prefs.getString('plans'));

    final habitRows = await _db.query('habits', orderBy: 'created_at ASC');
    habits
      ..clear()
      ..addAll(habitRows.map(Habit.fromRow));
    final checkInRows = await _db.query('check_ins');
    checkIns
      ..clear()
      ..addAll(checkInRows.map(CheckIn.fromRow));
    final lapseRows = await _db.query('lapses');
    lapses
      ..clear()
      ..addAll(lapseRows.map(Lapse.fromRow));
    final achievementRows = await _db.query('achievements');
    unlocked.clear();
    for (final row in achievementRows) {
      final habitId = row['habit_id'] as int;
      unlocked.putIfAbsent(habitId, () => {}).add(row['key'] as String);
    }
    // Catch-up evaluation for pre-existing data (e.g. an app update):
    // persisted achievements are filled in silently, no celebration spam.
    _evaluateMilestones(celebrate: false);
    loaded = true;
    notifyListeners();
  }

  // ----------------------------------------------------------------- habits

  Future<Habit> addHabit({
    required HabitType type,
    required String name,
    required DateTime quitDate,
    double dailySpend = 0,
    double dailyAmount = 0,
  }) async {
    final habit = Habit(
      type: type,
      name: name,
      quitDate: _startOfDay(quitDate),
      dailySpend: dailySpend,
      dailyAmount: dailyAmount,
      createdAt: now,
    );
    final id = await _db.insert('habits', habit.toRow());
    habits.add(habit.copyWith(id: id));
    _evaluateMilestones();
    notifyListeners();
    return habits.last;
  }

  Future<void> updateHabit(Habit habit) async {
    await _db.update(
      'habits',
      habit.toRow(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
    final i = habits.indexWhere((h) => h.id == habit.id);
    if (i >= 0) {
      habits[i] = habit;
      _evaluateMilestones();
      notifyListeners();
    }
  }

  /// Lapses for one habit (newest first).
  List<Lapse> lapsesFor(int habitId) {
    final list = lapses.where((l) => l.habitId == habitId).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// Records a slip with its trigger and an optional note. Keeping the
  /// history (instead of just resetting) is the data basis for relapse
  /// prevention: triggers repeat, and seeing the pattern is the fix.
  Future<void> recordLapse(Habit habit,
      {String? trigger, String? note}) async {
    final lapse = Lapse(
      habitId: habit.id!,
      date: CheckIn.dateKey(now),
      trigger: trigger,
      note: note,
    );
    final id = await _db.insert('lapses', lapse.toRow());
    lapses.add(Lapse(
      id: id,
      habitId: lapse.habitId,
      date: lapse.date,
      trigger: lapse.trigger,
      note: lapse.note,
    ));
    notifyListeners();
  }

  /// Restarts the counter (relapse handling).
  Future<void> resetQuitDate(Habit habit) async {
    await updateHabit(habit.copyWith(quitDate: _startOfDay(now)));
  }

  Future<void> deleteHabit(Habit habit) async {
    await _db
        .delete('habits', where: 'id = ?', whereArgs: [habit.id]);
    await _db
        .delete('check_ins', where: 'habit_id = ?', whereArgs: [habit.id]);
    await _db
        .delete('achievements', where: 'habit_id = ?', whereArgs: [habit.id]);
    habits.removeWhere((h) => h.id == habit.id);
    checkIns.removeWhere((c) => c.habitId == habit.id);
    unlocked.remove(habit.id);
    notifyListeners();
  }

  // -------------------------------------------------------------- check-ins

  /// Saves (or updates) today's check-in for [habit].
  Future<CheckIn> saveCheckIn({
    required Habit habit,
    required int mood,
    required int craving,
    String? trigger,
    String? note,
  }) async {
    final key = CheckIn.dateKey(now);
    final existing = checkInToday(habit.id!);
    if (existing != null) {
      final updated = existing.copyWith(
          mood: mood, craving: craving, trigger: trigger, note: note);
      await _db.update('check_ins', updated.toRow(),
          where: 'id = ?', whereArgs: [updated.id]);
      final i = checkIns.indexWhere((c) => c.id == existing.id);
      checkIns[i] = updated;
      _evaluateMilestones();
      notifyListeners();
      return updated;
    }
    final checkIn = CheckIn(
      habitId: habit.id!,
      date: key,
      mood: mood,
      craving: craving,
      trigger: trigger,
      note: note,
    );
    final id = await _db.insert('check_ins', checkIn.toRow());
    checkIns.add(CheckIn(
      id: id,
      habitId: checkIn.habitId,
      date: checkIn.date,
      mood: checkIn.mood,
      craving: checkIn.craving,
      trigger: checkIn.trigger,
      note: checkIn.note,
    ));
    _evaluateMilestones();
    notifyListeners();
    return checkIns.last;
  }

  // ----------------------------------------------------------- achievements

  /// Recomputes which milestones each habit has reached and persists newly
  /// unlocked ones. [newlyUnlocked] collects the fresh keys for celebration.
  void _evaluateMilestones({bool celebrate = true}) {
    if (celebrate) newlyUnlocked = {};
    for (final habit in habits) {
      final set = unlocked.putIfAbsent(habit.id!, () => {});
      final days = daysFree(habit, now);
      final money = moneySaved(habit, now);
      final streak = currentStreak(checkInsFor(habit.id!), now);

      void check(String key, bool reached) {
        if (reached && !set.contains(key)) {
          set.add(key);
          if (celebrate) newlyUnlocked.add(key);
          _db
              .insert('achievements', {
                'habit_id': habit.id,
                'key': key,
                'achieved_at': now.millisecondsSinceEpoch,
              })
              .then((_) {}, onError: (_) {});
        }
      }

      for (final m in kTimeMilestones) {
        check(m.key, days >= m.at);
      }
      for (final m in kMoneyMilestones) {
        if (habit.dailySpend > 0) check(m.key, money >= m.at);
      }
      kStreakMilestones.forEach((key, threshold) {
        check(key, streak >= threshold);
      });
    }
  }

  /// Keys newly unlocked during the last mutation, then clears them.
  Set<String> takeNewlyUnlocked() {
    final result = newlyUnlocked;
    newlyUnlocked = {};
    return result;
  }

  // --------------------------------------------------------------- settings

  Future<void> setPremium(bool value) async {
    premium = value;
    await _prefs.setBool('premium', value);
    notifyListeners();
  }

  Future<void> setDemoMode(bool value) async {
    demoMode = value;
    await _prefs.setBool('demoMode', value);
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    notificationsEnabled = value;
    await _prefs.setBool('notifications', value);
    notifyListeners();
  }

  Future<void> setReminderHour(int hour) async {
    reminderHour = hour;
    await _prefs.setInt('reminderHour', hour);
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    localeCode = code;
    await _prefs.setString('locale', code);
    notifyListeners();
  }

  Future<void> setTheme(String code) async {
    themeCode = code;
    await _prefs.setString('theme', code);
    notifyListeners();
  }

  Future<void> setCurrency(String symbol) async {
    currencySymbol = symbol;
    await _prefs.setString('currency', symbol);
    notifyListeners();
  }

  Future<void> setCustomHue(int hue) async {
    customHue = hue;
    await _prefs.setInt('customHue', hue);
    notifyListeners();
  }

  Future<void> setFont(String code) async {
    fontCode = code;
    await _prefs.setString('font', code);
    notifyListeners();
  }

  Future<void> setTextColor(String code) async {
    textColorCode = code;
    await _prefs.setString('textColor', code);
    notifyListeners();
  }

  Future<void> setReasons(List<String> value) async {
    reasons = List.of(value);
    await _prefs.setStringList('reasons', reasons);
    notifyListeners();
  }

  Future<void> setPlans(List<IfThenPlan> value) async {
    plans = List.of(value);
    await _prefs.setString('plans', IfThenPlan.encodeList(plans));
    notifyListeners();
  }

  // ----------------------------------------------------------------- export

  /// Full JSON export of everything (habits + check-ins + achievements).
  String exportJson() {
    final data = {
      'app': 'DayZero',
      'exported_at': now.toIso8601String(),
      'habits': habits.map((h) => {
            'type': h.type.name,
            'name': h.name,
            'quit_date': h.quitDate.toIso8601String(),
            'daily_spend': h.dailySpend,
            'daily_amount': h.dailyAmount,
            'created_at': h.createdAt?.toIso8601String(),
            'achievements':
                (unlocked[h.id] ?? const <String>{}).toList()..sort(),
            'check_ins': checkInsFor(h.id!).map((c) => {
                  'date': c.date,
                  'mood': c.mood,
                  'craving': c.craving,
                  'trigger': c.trigger,
                  'note': c.note,
                }).toList(),
          }).toList(),
      'reasons': reasons,
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  DateTime _startOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day);
}
