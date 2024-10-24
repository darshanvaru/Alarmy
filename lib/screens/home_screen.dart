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
            // Open the AddAlarm page as a draggable sheet
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, // Allow full-screen height
              backgroundColor: Colors.transparent, // Transparent background
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.95, // Adjust initial size
                  minChildSize: 0.3,     // Minimum height on drag down
                  maxChildSize: 0.95,     // Full-screen on drag up
                  builder: (BuildContext context, ScrollController scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B1B1B),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController, // Enable scrolling
                        child: const AddAlarm(), // AddAlarm widget as a sheet
                      ),
                    );
                  },
                );
              },
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(Icons.add, size: 40),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
