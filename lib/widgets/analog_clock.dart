// lib/widgets/analog_clock.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class AnalogClock extends StatefulWidget {
  const AnalogClock({super.key});

  @override
  AnalogClockState createState() => AnalogClockState();
}

class AnalogClockState extends State<AnalogClock> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: ClockPainter(_currentTime),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;
  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background Circle
    final paintCircle = Paint()..color = const Color(0xFF1B1B1B);
    canvas.drawCircle(center, radius, paintCircle);

    // Clock Numbers (12, 3, 6, 9)
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final numberStyle = TextStyle(color: Colors.white, fontSize: radius * 0.15, fontWeight: FontWeight.bold);

    const numbers = {
      '12': Offset(0, -0.85),
      '3': Offset(0.85, 0),
      '6': Offset(0, 0.85),
      '9': Offset(-0.85, 0),
    };

    numbers.forEach((text, position) {
      textPainter.text = TextSpan(text: text, style: numberStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx + position.dx * radius - textPainter.width / 2,
            center.dy + position.dy * radius - textPainter.height / 2),
      );
    });

    // Clock Hands
    final hourHandLength = radius * 0.5;
    final minuteHandLength = radius * 0.7;
    final secondHandLength = radius * 0.9;

    final paintHour = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final paintMinute = Paint()
      ..color = Colors.white70
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final paintSecond = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final hourAngle = ((time.hour % 12) + time.minute / 60) * 30 * 0.0174533;
    final minuteAngle = (time.minute + time.second / 60) * 6 * 0.0174533;
    final secondAngle = time.second * 6 * 0.0174533;

    canvas.drawLine(
      center,
      Offset(
        center.dx + hourHandLength * math.cos(hourAngle - math.pi / 2),
        center.dy + hourHandLength * math.sin(hourAngle - math.pi / 2),
      ),
      paintHour,
    );

    canvas.drawLine(
      center,
      Offset(
        center.dx + minuteHandLength * math.cos(minuteAngle - math.pi / 2),
        center.dy + minuteHandLength * math.sin(minuteAngle - math.pi / 2),
      ),
      paintMinute,
    );

    canvas.drawLine(
      center,
      Offset(
        center.dx + secondHandLength * math.cos(secondAngle - math.pi / 2),
        center.dy + secondHandLength * math.sin(secondAngle - math.pi / 2),
      ),
      paintSecond,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
