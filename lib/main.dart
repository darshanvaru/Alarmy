import 'package:alarmclock/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarmclock/providers/alarm_provider.dart';
import 'package:alarmclock/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'models/alarm_model.dart';
import 'screens/notification_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request notification permissions
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(MyAlarmApp(notificationService: notificationService));
}

class MyAlarmApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyAlarmApp({super.key, required this.notificationService});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlarmProvider(),
      child: MaterialApp(
        title: 'Alarm App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.blue,
            secondary: Colors.blueAccent,
            // background: Colors.black,
            surface: Color(0xFF1B1B1B),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            // onBackground: Colors.white,
            onSurface: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor:  Color(0xFF000000),
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
        routes: {
          '/notification': (context) => NotificationScreen(
            alarm: ModalRoute.of(context)?.settings.arguments as AlarmModel,
          ),
        },
      ),
    );
  }
}