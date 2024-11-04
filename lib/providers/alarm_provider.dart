import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/alarm_model.dart';
import '../services/notification_service.dart';

class AlarmProvider extends ChangeNotifier {
  final List<AlarmModel> _alarms = [];
  final NotificationService _notificationService = NotificationService();

  List<AlarmModel> get alarms => _alarms;

  // Load alarms from local storage
  Future<void> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmsString = prefs.getString('alarms');

    if (alarmsString != null) {
      final List<dynamic> alarmsJson = json.decode(alarmsString);
      _alarms.clear();
      _alarms.addAll(alarmsJson.map((json) => AlarmModel.fromMap(json)).toList());
      notifyListeners();
    }
  }

  // Save alarms to local storage
  Future<void> saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> alarmsMap = _alarms.map((alarm) => alarm.toMap()).toList();
    await prefs.setString('alarms', json.encode(alarmsMap));
  }

  Future<void> addAlarm(AlarmModel alarm) async {
    _alarms.add(alarm);
    if (alarm.isEnabled) {
      debugPrint('Scheduling alarm notification');
      await _notificationService.scheduleAlarm(alarm);
    }
    await saveAlarms(); // Save alarms after adding
    notifyListeners();
  }

  Future<void> toggleAlarm(String alarmId, bool isEnabled) async {
    debugPrint('Toggling alarm: $alarmId to $isEnabled');
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
        await _notificationService.cancelAlarm(alarm.id);
      }

      await saveAlarms(); // Save alarms after toggling
      notifyListeners();
    }
  }

  Future<void> updateAlarm(AlarmModel updatedAlarm) async {
    debugPrint('Updating alarm: ${updatedAlarm.id}');
    final alarmIndex = _alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
    if (alarmIndex != -1) {
      _alarms[alarmIndex] = updatedAlarm;

      if (updatedAlarm.isEnabled) {
        debugPrint('Rescheduling alarm notification');
        await _notificationService.scheduleAlarm(updatedAlarm);
      } else {
        debugPrint('Cancelling alarm notification');
        await _notificationService.cancelAlarm(updatedAlarm.id);
      }

      await saveAlarms(); // Save alarms after updating
      notifyListeners();
    }
  }

  Future<void> deleteAlarm(String alarmId) async {
    debugPrint('Deleting alarm: $alarmId');
    _alarms.removeWhere((alarm) => alarm.id == alarmId);
    await _notificationService.cancelAlarm(alarmId);
    await saveAlarms(); // Save alarms after deleting
    notifyListeners();
  }
}
