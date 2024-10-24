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
  bool isSnoozeEnable = true;
  bool snoozeEnabled = true;
  String repeatOption = 'Ring once';
  List<bool> selectedDays = List.filled(7, false);
  List<bool> customSelectedDays = List.filled(7, false);

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
        selectedDays = [false, true, true, true, true, true, false]; // Mon to Fri
      } else if (option == 'Ring once') {
        selectedDays = List.filled(7, false); // No days selected
      } else if (option == 'Custom') {
        selectedDays = List.filled(7, false); // Clear previous selections for custom
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
                ? (customSelectedDays[index] ? Colors.blue : Colors.grey[800])
                : (selectedDays[index] ? Colors.blue : Colors.grey[800]),
            child: Text(
              ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index],
              style: TextStyle(
                color: repeatOption == 'Custom'
                    ? (customSelectedDays[index] ? Colors.white : Colors.grey[400])
                    : (selectedDays[index] ? Colors.white : Colors.grey[400]),
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
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: Text(
            'New Alarm',
            style: TextStyle(color: Colors.white),
          ),
        ),

        // Cancel Button
        leading: TextButton(
          onPressed: () {},
          child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
        ),

        // Done button
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Done', style: TextStyle(color: Colors.blue)),
          )
        ],
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Time Picker
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

            // Ring Once, Workdays, Custom Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOptionButton("Ring once", repeatOption == "Ring once"),
                _buildOptionButton("Workdays", repeatOption == "Workdays"),
                _buildOptionButton("Custom", repeatOption == "Custom"),
              ],
            ),

            const SizedBox(height: 20),

            // Showing Days only if Workdays or Custom is selected
            if (repeatOption == 'Custom' || repeatOption == 'Workdays') ...[
              const Text(
                "Repeat",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 10),
              _buildDaySelection(),
              const SizedBox(height: 20),
            ],

            // Alarm name, Ringtone, Vibrate, Snooze Settings
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Alarm name',  // Label that moves up on focus or input
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),  // Border when enabled
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),  // Border when focused
                ),
              ),
              style: const TextStyle(color: Colors.white),  // Text color for user input
              onChanged: (value) {
                // Handle the alarm name input
                print('Alarm name: $value');
              },
            ),

            const SizedBox(height: 10),

            _buildSettingsItem("Ringtone", "Holiday", trailing: Icons.keyboard_arrow_right_rounded),
            const SizedBox(height: 10),
            _buildSettingsItem("Vibrate", "On", trailingSwitch: isSnoozeEnable),
            const SizedBox(height: 10),
            _buildSettingsItem("Snooze", "5 minutes, 3 times", trailing: Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }

  // Build Option Button (Ring once, Workdays, Custom)
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

  // Build Settings Item (Ringtone, Vibrate, Snooze)
  Widget _buildSettingsItem(String title, String subtitle, {IconData? trailing, bool trailingSwitch = false}) {
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

              // Title
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 5),

              // Description
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          trailingSwitch
              ? Switch(
            value: vibrate,
            onChanged: (value) {
              setState(() {
                vibrate = value;
              });
            },
            activeColor: Colors.blue,
          )
              : Icon(trailing, color: Colors.grey),
        ],
      ),
    );
  }
}
