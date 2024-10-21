import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../services/alarm_service.dart';
import '../widgets/alarm_tile.dart';

class AlarmManagementScreen extends StatefulWidget {
  @override
  _AlarmManagementScreenState createState() => _AlarmManagementScreenState();
}

class _AlarmManagementScreenState extends State<AlarmManagementScreen> {
  @override
  Widget build(BuildContext context) {
    List<Alarm> alarms = AlarmService.getAlarms();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Alarms'),
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          return AlarmTile(alarm: alarms[index]);
        },
      ),
    );
  }
}
