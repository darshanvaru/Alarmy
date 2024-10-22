import 'package:alarmclock/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyAlarmApp());
}

class MyAlarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
          )
      ),
      home: HomeScreen(),
    );
  }
}
