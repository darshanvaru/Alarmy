import 'package:alarmclock/screens/add_alarm.dart';
import 'package:alarmclock/utils/alarm_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List alarms = [
    ["04:20", "Mon to Fri", "WakeUp!", true],
    ["06:00", "EveryDay", "", false],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarm"),
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          return AlarmTile(
            time: alarms[index][0],
            days: alarms[index][1],
            title: alarms[index][2],
            isSelected: alarms[index][3],
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            // Show the full-screen modal bottom sheet
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, // Allow full-screen height
              backgroundColor: Colors.transparent, // Transparent background
              builder: (BuildContext context) {
                return AddAlarm(); // Your AddAlarm widget
              },
            );
          },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
            ),
          child: const Icon(Icons.add, size: 40,)
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
