import 'package:flutter/material.dart';
import '../models/alarm_model.dart';

class AlarmTile extends StatefulWidget {
  final Alarm alarm;
  AlarmTile({required this.alarm});

  @override
  _AlarmTileState createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Alarm at ${widget.alarm.time.format(context)}'),
      subtitle: Text('Tone: ${widget.alarm.tone}'),
      trailing: Switch(
        value: widget.alarm.isActive,
        onChanged: (bool value) {
          setState(() {
            widget.alarm.isActive = value;
          });
        },
      ),
    );
  }
}
