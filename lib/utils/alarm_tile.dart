import 'package:flutter/material.dart';

class AlarmTile extends StatefulWidget {
  final String time;
  final String title;
  final String days;
  final bool isSelected;

  const AlarmTile({
    super.key,
    required this.time,
    required this.title,
    required this.days,
    required this.isSelected,
  });

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Padding(
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
              // Time and Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time
                  Text(
                    widget.time,
                    style: const TextStyle(fontSize: 50, color: Colors.white),
                  ),

                  // Description
                  Text(
                    'Mon to Fri | Wake Up!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Switch
              Switch(
                value: _isSelected,
                onChanged: (value) {
                  setState(() {
                    _isSelected = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
