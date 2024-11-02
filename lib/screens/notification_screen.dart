// import 'package:flutter/material.dart';
// import '../models/alarm_model.dart';
//
// class NotificationScreen extends StatelessWidget {
//   final AlarmModel alarm;
//
//   const NotificationScreen({Key? key, required this.alarm}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               alarm.time.format(context),
//               style: const TextStyle(
//                 fontSize: 60,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               alarm.title.isNotEmpty ? alarm.title : 'Alarm',
//               style: const TextStyle(
//                 fontSize: 24,
//                 color: Colors.white70,
//               ),
//             ),
//             const SizedBox(height: 40),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle snooze action here
//                     Navigator.pop(context);
//                   },
//                   child: const Text('Snooze'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle stop action here
//                     Navigator.pop(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                   ),
//                   child: const Text('Stop'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
