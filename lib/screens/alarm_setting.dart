import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../services/alarm_service.dart';

class AlarmSettingScreen extends StatefulWidget {
  @override
  _AlarmSettingScreenState createState() => _AlarmSettingScreenState();
}

class _AlarmSettingScreenState extends State<AlarmSettingScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedTone = 'Default';

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  void _saveAlarm() {
    Alarm newAlarm = Alarm(time: selectedTime, tone: selectedTone);
    AlarmService.addAlarm(newAlarm);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Alarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Time: ${selectedTime.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            ListTile(
              title: Text('Alarm Tone: $selectedTone'),
              trailing: Icon(Icons.music_note),
              onTap: () {
                // Implement tone selection logic here
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAlarm,
              child: Text('Save Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}
