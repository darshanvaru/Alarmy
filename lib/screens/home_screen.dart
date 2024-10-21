import 'package:flutter/material.dart';
import '../widgets/time_display.dart';
import 'alarm_setting.dart';
import 'alarm_management.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm Clock'),
      ),
      body: Center( // Center the content vertically and horizontally
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content vertically
          children: [
            TimeDisplay(),
            SizedBox(height: 30), // Add spacing between widgets
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmSettingScreen()),
                );
              },
              child: Text('Set New Alarm'),
            ),
            SizedBox(height: 10), // Spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmManagementScreen()),
                );
              },
              child: Text('Manage Alarms'),
            ),
          ],
        ),
      ),
    );
  }
}
