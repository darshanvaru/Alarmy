  import 'package:flutter/material.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:provider/provider.dart';
  import '../providers/alarm_provider.dart';
  import '../models/alarm_model.dart';

  class AddAlarm extends StatefulWidget {
    final AlarmModel? alarm;

    const AddAlarm({super.key, this.alarm});

    @override
    State<AddAlarm> createState() => _AddAlarmState();
  }

  class _AddAlarmState extends State<AddAlarm> {
    TimeOfDay selectedTime = TimeOfDay.now();
    bool isVibrate = true;
    String ringtone = "holiday"; // Default ringtone
    String snoozeOption = "5 minutes, 3 times"; // Default snooze option
    String repeatOption = 'Ring once';
    List<bool> selectedDays = List.filled(7, false);
    List<bool> customSelectedDays = List.filled(7, false);
    bool isSnoozeExpanded = false;
    bool isRingtoneExpanded = false;
    String alarmTitle = "";

    @override
    @override
    void initState() {
      super.initState();
      if (widget.alarm != null) {
        selectedTime = widget.alarm!.time;
        alarmTitle = widget.alarm!.title;
        isVibrate = widget.alarm!.isVibrate;
        ringtone = widget.alarm!.ringtone;
        snoozeOption = widget.alarm!.snoozeOption;
        selectedDays = widget.alarm!.selectedDays;

        // Determine the repeat option based on selectedDays
        if (selectedDays.every((day) => !day)) {
          repeatOption = "Ring once"; // All days are false
        } else if (!selectedDays.first && !selectedDays.last &&
            selectedDays.sublist(1, 6).every((day) => day)) {
          repeatOption = "Workdays"; // Only weekdays are true
        } else {
          repeatOption = "Custom";
          customSelectedDays = selectedDays;// Custom selection
        }

        print("------------------------------------------");
        print(selectedTime);
        print(alarmTitle);
        print(isVibrate);
        print(ringtone);
        print(snoozeOption);
        print(selectedDays);
        print("------------------------------------------");
      }
    }


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

            // AppBar with Cancel and Done buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                //cancel
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel",
                      style: TextStyle(fontSize: 18, color: Colors.blue)
                  ),
                ),

                //done
                TextButton(
                  onPressed: () {
                    // Check if an existing alarm is being edited
                    if (widget.alarm != null) {
                      // Update the existing alarm
                      final updatedAlarm = AlarmModel(
                        id: widget.alarm!.id, // Keep the same ID for the existing alarm
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

                      // Update the alarm using provider
                      Provider.of<AlarmProvider>(context, listen: false)
                          .updateAlarm(updatedAlarm); // Make sure you have this method in your AlarmProvider
                    } else {
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
                    }

                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: const Text("Done",
                      style: TextStyle(fontSize: 18, color: Colors.blue)
                  ),
                ),
              ],
            ),

            // time picker
            SizedBox(
              height: 150,
              child: CupertinoDatePicker(
                initialDateTime: widget.alarm != null
                    ? DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute)
                    : DateTime.now(),
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
              onTap: () {
                setState(() {
                  isRingtoneExpanded = !isRingtoneExpanded;
                });},
              child: _buildSettingsItem(
                "Ringtone",
                ringtone,
                trailing: isRingtoneExpanded? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              height: isRingtoneExpanded ? 185 : 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text("Holiday"),
                      onTap: () {
                        setState(() {
                          ringtone = "Holiday";
                          isRingtoneExpanded = false;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text("Morning Sunshine"),
                      onTap: () {
                        setState(() {
                          ringtone = "Morning Sunshine";
                          isRingtoneExpanded = false;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text("Peaceful Waves"),
                      onTap: () {
                        setState(() {
                          ringtone = "Peaceful Waves";
                          isRingtoneExpanded = false;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text("Gentle Chimes"),
                      onTap: () {
                        setState(() {
                          ringtone = "Gentle Chimes";
                          isRingtoneExpanded = false;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text("Soft Piano"),
                      onTap: () {
                        setState(() {
                          ringtone = "Soft Piano";
                          isRingtoneExpanded = false;
                        });
                      },
                    ),
                    ListTile(
                      title: const Text("Fun Tune"),
                      onTap: () {
                        setState(() {
                          ringtone = "Fun Tune";
                          isRingtoneExpanded = false;
                        });
                      },
                    ),
                  ],
                ),
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
                trailing: isSnoozeExpanded? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_rounded,
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
