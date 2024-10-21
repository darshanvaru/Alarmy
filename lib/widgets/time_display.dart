import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // For date/time formatting

class TimeDisplay extends StatefulWidget {
  @override
  _TimeDisplayState createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  String _currentTime = '';
  String _currentDate = '';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime(); // Initial call to set the time
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('hh:mm:ss a').format(now); // E.g., "08:30:45 PM"
      _currentDate = DateFormat.yMMMMd().format(now);      // E.g., "October 21, 2024"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _currentTime,
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        Text(
          _currentDate,
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ],
    );
  }
}
