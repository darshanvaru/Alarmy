import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/alarm_provider.dart';
import '../models/alarm_model.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isVibrate = true;
  String ringtone = "Holiday"; // Default ringtone
  String snoozeOption = "5 minutes, 3 times"; // Default snooze option
  String repeatOption = 'Ring once';
  List<bool> selectedDays = List.filled(7, false);
  List<bool> customSelectedDays = List.filled(7, false);
  bool isSnoozeExpanded = false;
  String alarmTitle = ""; // To track the state of snooze options

  // Function to handle the time change from Cupertino Picker
  void _onTimeChanged(DateTime newTime) {
    setState(() {
      selectedTime = TimeOfDay(hour: newTime.hour, minute: newTime.minute);
    });
  }

  // Function to handle selection of repeat options
  void _handleRepeatOption(String option) {
    setState(() {
      repeatOption = option;
      if (option == 'Workdays') {
        selectedDays = [false, true, true, true, true, true, false];
      } else if (option == 'Ring once') {
        selectedDays = List.filled(7, false); // No days selected
      }
    });
  }



  // Function to build the day selection row for Custom and Workdays
  Widget _buildDaySelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        return GestureDetector(
          onTap: () {
            if (repeatOption == 'Custom') {
              setState(() {
                customSelectedDays[index] = !customSelectedDays[index];
              });
            }
          },
          child: CircleAvatar(
            backgroundColor: repeatOption == 'Custom'
                ? customSelectedDays[index] ? Colors.blue : Colors.grey[800]
                : selectedDays[index] ? Colors.blue : Colors.grey[800],
            child: Text(
              ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index],
              style: TextStyle(
                color: repeatOption == 'Custom'
                    ? customSelectedDays[index] ? Colors.white : Colors.grey[400]
                    : selectedDays[index] ? Colors.white : Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // AppBar with functional Cancel and Done buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text("Cancel",
                    style: TextStyle(fontSize: 18, color: Colors.blue)
                ),
              ),
              TextButton(
                onPressed: () {
                  // Create new alarm and save it
                  final newAlarm = AlarmModel(
                    id: (DateTime.now().millisecondsSinceEpoch % 2147483647).toString(),
                    time: selectedTime,
                    title: alarmTitle,
                    selectedDays: repeatOption == 'Custom'
                        ? customSelectedDays
                        : selectedDays,
                    isEnabled: true,
                    isVibrate: isVibrate,
                    ringtone: ringtone,
                    snoozeOption: snoozeOption,
                  );

                  // Add alarm using provider
                  Provider.of<AlarmProvider>(context, listen: false)
                      .addAlarm(newAlarm);

                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text("Done",
                    style: TextStyle(fontSize: 18, color: Colors.blue)
                ),
              ),
            ],
          ),

          // Your existing time picker
          SizedBox(
            height: 150,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.time,
              use24hFormat: false,
              onDateTimeChanged: _onTimeChanged,
            ),
          ),

          const SizedBox(height: 20),

          // repeat options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOptionButton("Ring once", repeatOption == "Ring once"),
              _buildOptionButton("Workdays", repeatOption == "Workdays"),
              _buildOptionButton("Custom", repeatOption == "Custom"),
            ],
          ),

          const SizedBox(height: 20),

          // repeat days section
          if (repeatOption == 'Custom' || repeatOption == 'Workdays') ...[
            const Text(
              "Repeat",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildDaySelection(),
            const SizedBox(height: 20),
          ],

          // Modified alarm title field to save the value
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Alarm name',
              hintStyle: TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              setState(() {
                alarmTitle = value;
              });
            },
          ),

          const SizedBox(height: 10),

          // settings items (ringtone, isVibrate, snooze)
          GestureDetector(
            onTap: () {},
            child: _buildSettingsItem(
              "Ringtone",
              ringtone,
              trailing: Icons.keyboard_arrow_right_rounded,
            ),
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                isVibrate = !isVibrate;
              });
            },
            child: _buildSettingsItem(
              "isVibrate",
              isVibrate ? "On" : "Off",
              trailingSwitch: true,
            ),
          ),

          const SizedBox(height: 10),

          // Keep your existing snooze section
          GestureDetector(
            onTap: () {
              setState(() {
                isSnoozeExpanded = !isSnoozeExpanded;
              });
            },
            child: _buildSettingsItem(
              "Snooze",
              snoozeOption,
              trailing: Icons.keyboard_arrow_down_rounded,
            ),
          ),

          // Keep your existing expandable snooze options
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            height: isSnoozeExpanded ? 185 : 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text("5 minutes, 3 times"),
                    onTap: () {
                      setState(() {
                        snoozeOption = "5 minutes, 3 times";
                        isSnoozeExpanded = false;
                      });
                    },
                  ),
                  ListTile(
                    title: const Text("10 minutes, 2 times"),
                    onTap: () {
                      setState(() {
                        snoozeOption = "10 minutes, 2 times";
                        isSnoozeExpanded = false;
                      });
                    },
                  ),
                  ListTile(
                    title: const Text("15 minutes, 1 time"),
                    onTap: () {
                      setState(() {
                        snoozeOption = "15 minutes, 1 time";
                        isSnoozeExpanded = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Keep your existing helper widget methods
  Widget _buildOptionButton(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _handleRepeatOption(text),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
      String title,
      String subtitle, {
        IconData? trailing,
        bool trailingSwitch = false,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Main title
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),

              //subtitle
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),

          //trailing Icon
          if (trailing != null)
            Icon(
              trailing,
              color: Colors.grey[400],
            ),

          //trailing switch
          if (trailingSwitch)
            Switch(
              value: isVibrate,
              onChanged: (value) {
                setState(() {
                  isVibrate = value;
                });
              },
              activeColor: Colors.blue,
            ),
        ],
      ),
    );
  }
}
