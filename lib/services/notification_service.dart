import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/alarm_model.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    // Initialize settings for Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Create InitializationSettings instance
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: null, // Set to null since you are not targeting iOS
    );

    // Initialize the notifications plugin
    await _notifications.initialize(initializationSettings);
  }

  Future<void> scheduleAlarm(AlarmModel alarm) async {
    final now = DateTime.now();
    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.time.hour,
      alarm.time.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Handle repeating days
    if (alarm.selectedDays.contains(true)) {
      while (!alarm.selectedDays[scheduledDate.weekday % 7]) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('holiday'),
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      actions: [
        AndroidNotificationAction('snooze', 'Snooze'),
        AndroidNotificationAction('stop', 'Stop'),
      ],
    );

    // Since you're focusing on Android, you can omit iOS details
    final details = NotificationDetails(android: androidDetails);

    debugPrint('Scheduling notification for ${tz.TZDateTime.from(scheduledDate, tz.local)}');

    try {
      await _notifications.zonedSchedule(
        int.parse(alarm.id),
        'Alarm',
        alarm.title.isNotEmpty ? alarm.title : 'Time to wake up!',
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: alarm.selectedDays.contains(true)
            ? DateTimeComponents.dayOfWeekAndTime
            : DateTimeComponents.time,
        payload: alarm.id,
      );
      debugPrint('Alarm scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling alarm: $e');
    }
  }

  Future<void> cancelAlarm(String alarmId) async {
    debugPrint('Cancelling alarm: $alarmId');
    await _notifications.cancel(int.parse(alarmId));
  }

  Future<void> checkPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    debugPrint('Pending notifications: ${pending.length}');
    for (var notification in pending) {
      debugPrint('Pending notification: ${notification.id}');
    }
  }
}
