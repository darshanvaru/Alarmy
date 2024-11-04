import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler
import '../models/alarm_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // Initialize settings for Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Create InitializationSettings instance
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: null,
    );

    // Initialize the notifications plugin
    await _notifications.initialize(initializationSettings);
  }

  Future<void> scheduleAlarm(AlarmModel alarm) async {
    // Check if notification permission is granted
    final notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      // If not granted, request permission
      await Permission.notification.request();
      if (!await Permission.notification.isGranted) {
        debugPrint('Notification permission is still not granted.');
        return; // Exit if permission is not granted
      }
    }
    final now = DateTime.now();
    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.time.hour,
      alarm.time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (alarm.selectedDays.contains(true)) {
      while (!alarm.selectedDays[scheduledDate.weekday % 7]) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }

    var androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(alarm.ringtone),
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      actions: [
        const AndroidNotificationAction('snooze', 'Snooze'),
        const AndroidNotificationAction('stop', 'Stop'),
      ],
    );

    final details = NotificationDetails(android: androidDetails);

    debugPrint('Scheduling notification for ${tz.TZDateTime.from(scheduledDate, tz.local)}');

    try {
      await _notifications.zonedSchedule(
        int.parse(alarm.id),
        'Alarm',
        alarm.title.isNotEmpty ? alarm.title : '',
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

  Future<void> cancelAllNotifications() async {
    debugPrint('Cancelling all notifications');
    await _notifications.cancelAll();
  }

  Future<void> checkPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    debugPrint('Pending notifications: ${pending.length}');
    for (var notification in pending) {
      debugPrint('Pending notification: ${notification.id}');
    }
  }
}
