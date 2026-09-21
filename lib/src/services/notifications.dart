import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Daily 8 PM check-in reminder. iOS-only in practice; guarded so the web
/// demo and tests never touch the platform channel.
class NotificationService {
  NotificationService({this.enabled = !kIsWeb});

  final bool enabled;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (!enabled || _initialized) return;
    try {
      tzdata.initializeTimeZones();
      const settings = InitializationSettings(
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      );
      await _plugin.initialize(settings);
      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService.init failed: $e');
    }
  }

  Future<void> requestPermission() async {
    if (!enabled) return;
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: false, sound: false);
    } catch (e) {
      debugPrint('NotificationService.requestPermission failed: $e');
    }
  }

  /// Schedules (or replaces) the daily reminder at [hour]:00 local time.
  /// Title/body are passed in by the caller so the notification matches the
  /// user's language.
  Future<void> scheduleDaily({
    String title = 'DayZero',
    String body = 'How was today? A quick check-in keeps your streak alive.',
    int hour = 20,
  }) async {
    if (!enabled || !_initialized) return;
    try {
      await _plugin.cancel(1);
      var location = tz.local;
      try {
        final name = await FlutterTimezone.getLocalTimezone();
        location = tz.getLocation(name);
      } catch (_) {}
      final now = tz.TZDateTime.now(location);
      var scheduled = tz.TZDateTime(
          location, now.year, now.month, now.day, hour, 0, 0);
      if (!scheduled.isAfter(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      const details = NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentSound: false,
        ),
      );
      await _plugin.zonedSchedule(
        1,
        title,
        body,
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('NotificationService.scheduleDaily failed: $e');
    }
  }

  Future<void> cancel() async {
    if (!enabled) return;
    try {
      await _plugin.cancel(1);
    } catch (e) {
      debugPrint('NotificationService.cancel failed: $e');
    }
  }
}
