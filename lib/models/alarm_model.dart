import 'package:flutter/material.dart';

class Alarm {
  final TimeOfDay time;
  bool isActive;
  final String tone;

  Alarm({required this.time, this.isActive = true, this.tone = 'Default'});
}
