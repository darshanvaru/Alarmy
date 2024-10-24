import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  TimeOfDay selectedTime = TimeOfDay.now();
  bool vibrate = true;
  String ringtone = "Holiday"; // Default ringtone
  String snoozeOption = "5 minutes, 3 times"; // Default snooze option
  String repeatOption = 'Ring once';
  List<bool> selectedDays = List.filled(7, false);
  List<bool> customSelectedDays = List.filled(7, false);
  bool isSnoozeExpanded = false; // To track the state of snooze options

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
        mainAxisSize: MainAxisSize.min, // Make sure the sheet takes up only the space needed
        children: [
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOptionButton("Ring once", repeatOption == "Ring once"),
              _buildOptionButton("Workdays", repeatOption == "Workdays"),
              _buildOptionButton("Custom", repeatOption == "Custom"),
            ],
          ),

          const SizedBox(height: 20),

          // Repeat Days (Custom or Workdays)
          if (repeatOption == 'Custom' || repeatOption == 'Workdays') ...[
            const Text(
              "Repeat",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildDaySelection(),
            const SizedBox(height: 20),
          ],

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
              // Handle the alarm name input
            },
          ),

          const SizedBox(height: 10),

          // Ringtone selection
          GestureDetector(
            onTap: () {},
            child: _buildSettingsItem(
              "Ringtone",
              ringtone,
              trailing: Icons.keyboard_arrow_right_rounded,
            ),
          ),
          const SizedBox(height: 10),

          // Vibrate option
          GestureDetector(
            onTap: () {
              setState(() {
                vibrate = !vibrate; // Toggle vibrate option directly
              });
            },
            child: _buildSettingsItem(
              "Vibrate",
              vibrate ? "On" : "Off",
              trailingSwitch: true,
            ),
          ),
          const SizedBox(height: 10),

          // Snooze selection
          GestureDetector(
            onTap: () {
              setState(() {
                isSnoozeExpanded = !isSnoozeExpanded; // Toggle snooze options
              });
            },
            child: _buildSettingsItem(
              "Snooze",
              snoozeOption,
              trailing: Icons.keyboard_arrow_down_rounded,
            ),
          ),

          // Expandable Snooze Options with Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.grey[800], // Background color for the expanded area
              borderRadius: BorderRadius.circular(10),
            ),
            height: isSnoozeExpanded ? 185 : 0, // Adjust height based on expansion
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    title: Text("5 minutes, 3 times"),
                    onTap: () {
                      setState(() {
                        snoozeOption = "5 minutes, 3 times";
                      });
                      setState(() {
                        isSnoozeExpanded = false; // Collapse after selection
                      });
                    },
                  ),
                  ListTile(
                    title: Text("10 minutes, 2 times"),
                    onTap: () {
                      setState(() {
                        snoozeOption = "10 minutes, 2 times";
                      });
                      setState(() {
                        isSnoozeExpanded = false; // Collapse after selection
                      });
                    },
                  ),
                  ListTile(
                    title: Text("15 minutes, 1 time"),
                    onTap: () {
                      setState(() {
                        snoozeOption = "15 minutes, 1 time";
                      });
                      setState(() {
                        isSnoozeExpanded = false; // Collapse after selection
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
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          if (trailing != null)
            Icon(
              trailing,
              color: Colors.grey[400],
            ),
          if (trailingSwitch)
            Switch(
              value: vibrate,
              onChanged: (value) {
                setState(() {
                  vibrate = value;
                });
              },
              activeColor: Colors.blue,
            ),
        ],
      ),
    );
  }
}
