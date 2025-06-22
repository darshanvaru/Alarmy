import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alarmclock/providers/alarm_provider.dart';
import 'package:alarmclock/services/notification_service.dart';
import 'package:alarmclock/screens/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.
  initialize();

  runApp(MyAlarmApp(notificationService: notificationService));
}

class MyAlarmApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyAlarmApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AlarmProvider()..loadAlarms(), // Load alarms on app start
      child: MaterialApp(
        key: navigatorKey,
        title: 'Alarm App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.blue,
            secondary: Colors.blueAccent,
            surface: Color(0xFF1B1B1B),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF000000),
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: const PermissionHandlerScreen(),
      ),
    );
  }
}

class PermissionHandlerScreen extends StatefulWidget {
  const PermissionHandlerScreen({super.key});

  @override
  PermissionHandlerScreenState createState() => PermissionHandlerScreenState();
}

class PermissionHandlerScreenState extends State<PermissionHandlerScreen> {
  bool _hasAlarmPermission = false;
  bool _hasNotificationPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Check both permissions
    final alarmPermission = await Permission.scheduleExactAlarm.isGranted;
    final notificationPermission = await Permission.notification.isGranted;

    setState(() {
      _hasAlarmPermission = alarmPermission;
      _hasNotificationPermission = notificationPermission;
    });

    if (!_hasAlarmPermission || !_hasNotificationPermission) {
      _requestPermissions();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _requestPermissions() async {
    final alarmStatus = await Permission.scheduleExactAlarm.request();
    final notificationStatus = await Permission.notification.request();

    setState(() {
      _hasAlarmPermission = alarmStatus.isGranted;
      _hasNotificationPermission = notificationStatus.isGranted;
    });

    if (_hasAlarmPermission && _hasNotificationPermission) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showPermissionSnackbar();
    }
  }

  void _showPermissionSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Permissions are required for the app to function correctly. Please grant them in Settings.',
        ),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () {
            openAppSettings();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Permission Required',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestPermissions,
              child: const Text('Grant Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}
