import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:alarmclock/screens/add_alarm_screen.dart';
import 'package:alarmclock/utils/alarm_tile.dart';
import 'package:alarmclock/providers/alarm_provider.dart';
import 'package:alarmclock/widgets/analog_clock.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Alarm"),
      ),
      body: Column(
        children: [
          // Analog Clock covering upper 40% of the screen
          Expanded(
            flex: 3,
            child: Center(
              child: AnalogClock(),
            ),
          ),
          const SizedBox(height: 20),

          // Alarms List covering the remaining 60% of the screen
          Expanded(
            flex: 6,
            child: Consumer<AlarmProvider>(
              builder: (context, alarmProvider, child) {
                if (alarmProvider.alarms.isEmpty) {
                  return const Center(
                    child: Text(
                      'No alarms set',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: alarmProvider.alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarmProvider.alarms[index];
                    return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              initialChildSize: 0.95,
                              minChildSize: 0.3,
                              maxChildSize: 0.95,
                              builder: (BuildContext context, ScrollController scrollController) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1B1B1B),
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                                  ),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: AddAlarm(alarm: alarm), // Pass the alarm to edit
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: AlarmTile(
                        id: alarm.id,
                        time: alarm.time.format(context),
                        days: _getDaysString(alarm.selectedDays),
                        title: alarm.title,
                        isEnabled: alarm.isEnabled,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 80,
        width: 150,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FloatingActionButton(
            onPressed: () {
              // Show AddAlarm as a bottom sheet for adding new alarms
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.95,
                    minChildSize: 0.3,
                    maxChildSize: 0.95,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: const AddAlarm(), // No alarm passed for new alarm
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  String _getDaysString(List<bool> days) {
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final selectedDays = <String>[];

    for (var i = 0; i < days.length; i++) {
      if (days[i]) {
        selectedDays.add(dayNames[i]);
      }
    }

    if (selectedDays.isEmpty) {
      return 'Once';
    } else if (selectedDays.length == 7) {
      return 'Every day';
    } else if (selectedDays.length == 5 &&
        Set.from(selectedDays).containsAll({'Mon', 'Tue', 'Wed', 'Thu', 'Fri'})) {
      return 'Weekdays';
    } else {
      return selectedDays.join(', ');
    }
  }

  Future<void> _cancelAllNotifications() async {
    final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
    await notifications.cancelAll();
    debugPrint("Cancelled all notifications");
    final pending = await notifications.pendingNotificationRequests();
    debugPrint('Pending notifications: ${pending.length}');
  }

  Future<void> _showAllNotifications() async {
    final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();
    final pending = await notifications.pendingNotificationRequests();
    debugPrint('Pending notifications: ${pending.length}');
  }
}
