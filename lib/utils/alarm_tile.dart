import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/alarm_provider.dart';

class AlarmTile extends StatelessWidget {
  final String id;
  final String time;
  final String title;
  final String days;
  final bool isEnabled;

  const AlarmTile({
    super.key,
    required this.id,
    required this.time,
    required this.title,
    required this.days,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    onDelete() {
      Provider.of<AlarmProvider>(context, listen: false).deleteAlarm(id);
    }

    // Split the time into hours/minutes and AM/PM part
    String mainTime = time.split(' ')[0]; // Extracts hours and minutes
    String period = time.split(' ')[1]; // Extracts AM or PM

    return Dismissible(
      key: Key(time),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => Future.delayed(const Duration(milliseconds: 100), onDelete),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 132,
          width: screenSize.width,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time display with AM/PM in a smaller font size
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: mainTime,
                            style: const TextStyle(fontSize: 50, color: Colors.white),
                          ),
                          TextSpan(
                            text: " $period", // Add a space before AM/PM
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Subtext
                    Text(
                      title.isNotEmpty ? '$days | $title' : days,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                // Trailing switch
                Switch(
                  value: isEnabled,
                  onChanged: (bool value) {
                    Provider.of<AlarmProvider>(context, listen: false)
                        .toggleAlarm(id, value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
