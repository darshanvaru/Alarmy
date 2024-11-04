import 'package:flutter/material.dart';

class AlarmModel {
  final String id;
  final TimeOfDay time;
  late final String title;
  final List<bool> selectedDays;
  final bool isEnabled;
  final bool isVibrate;
  final String ringtone;
  final String snoozeOption;

  AlarmModel({
    required this.id,
    required this.time,
    required this.title,
    required this.selectedDays,
    required this.isEnabled,
    required this.isVibrate,
    required this.ringtone,
    required this.snoozeOption,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hour': time.hour,
      'minute': time.minute,
      'title': title,
      'selectedDays': selectedDays,
      'isEnabled': isEnabled,
      'vibrate': isVibrate,
      'ringtone': ringtone,
      'snoozeOption': snoozeOption,
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'],
      time: TimeOfDay(hour: map['hour'], minute: map['minute']),
      title: map['title'],
      selectedDays: List<bool>.from(map['selectedDays']),
      isEnabled: map['isEnabled'],
      isVibrate: map['vibrate'],
      ringtone: map['ringtone'],
      snoozeOption: map['snoozeOption'],
    );
  }
}
