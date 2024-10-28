// import 'package:alarmclock/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../services/notification_service.dart';

class AlarmProvider extends ChangeNotifier {
  final List<AlarmModel> _alarms = [];
  final NotificationService _notificationService = NotificationService();

  List<AlarmModel> get alarms => _alarms;

  Future<void> addAlarm(AlarmModel alarm) async {
    _alarms.add(alarm);
    if (alarm.isEnabled) {
      debugPrint('Scheduling alarm notification');
      await _notificationService.scheduleAlarm(alarm);
      await _notificationService.checkPendingNotifications();
    }
    notifyListeners();
  }

  Future<void> toggleAlarm(String alarmId, bool isEnabled) async {
    debugPrint('Toggling alarm: $alarmId to $isEnabled');
    print("------------------------------------------------");
    print(_alarms);
    print("------------------------------------------------");
    final alarmIndex = _alarms.indexWhere((alarm) => alarm.id == alarmId);
    if (alarmIndex != -1) {
      final alarm = _alarms[alarmIndex];
      final updatedAlarm = AlarmModel(
        id: alarm.id,
        time: alarm.time,
        title: alarm.title,
        selectedDays: alarm.selectedDays,
        isEnabled: isEnabled,
        isVibrate: alarm.isVibrate,
        ringtone: alarm.ringtone,
        snoozeOption: alarm.snoozeOption,
      );

      _alarms[alarmIndex] = updatedAlarm;

      if (isEnabled) {
        debugPrint('Scheduling alarm notification after toggle');
        await _notificationService.scheduleAlarm(updatedAlarm);
      } else {
        debugPrint('Cancelling alarm notification');
        await _notificationService.cancelAlarm(alarmId);
      }

      await _notificationService.checkPendingNotifications();
      notifyListeners();
    }
  }

  Future<void> deleteAlarm(String alarmId) async {
    debugPrint('Deleting alarm: $alarmId');
    _alarms.removeWhere((alarm) => alarm.id == alarmId);
    await _notificationService.cancelAlarm(alarmId);
    notifyListeners();
  }
}