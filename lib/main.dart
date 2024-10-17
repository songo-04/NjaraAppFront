import 'package:appfront/view/pages/leadingPage/leadingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'constant/color.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await _configureLocalTimeZone();
  // await _initializeNotifications();
  // await scheduleDaily19h00Notification();
  runApp(const MyApp());
}

// Future<void> _configureLocalTimeZone() async {
//   tz.initializeTimeZones();
//   tz.setLocalLocation(tz.getLocation(tz.local.name));
// }

// Future<void> _initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   const DarwinInitializationSettings initializationSettingsIOS =
//       DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//   );
//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
//   );

//   // Request permissions for Android 13+
//   if (Platform.isAndroid) {
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//     if (androidImplementation != null) {
//       await androidImplementation.requestNotificationsPermission();
//     }
//   }
// }

// void _onDidReceiveNotificationResponse(NotificationResponse response) {
//   // Gérer la réponse à la notification ici
//   print('Notification cliquée avec le payload: ${response.payload}');
//   // Vous pouvez ajouter une logique de navigation ici si nécessaire
// }

// Future<void> scheduleDaily19h00Notification() async {
//   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//     'daily_19h00_notification_channel',
//     'Rappel quotidien',
//     channelDescription: 'This channel is used for daily 19:00 notifications',
//     importance: Importance.max,
//     priority: Priority.high,
//     showWhen: false,
//   );
//   var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//     iOS: iOSPlatformChannelSpecifics,
//   );

//   await flutterLocalNotificationsPlugin.zonedSchedule(
//     0,
//     'Rappel quotidien',
//     'Il est 19h00 !',
//     _nextInstanceOf19h00(),
//     platformChannelSpecifics,
//     uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//     matchDateTimeComponents: DateTimeComponents.time,
//   );
// }

// tz.TZDateTime _nextInstanceOf19h00() {
//   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//   tz.TZDateTime scheduledDate =
//       tz.TZDateTime(tz.local, now.year, now.month, now.day, 19, 00);
//   if (scheduledDate.isBefore(now)) {
//     scheduledDate = scheduledDate.add(const Duration(days: 1));
//   }
//   return scheduledDate;
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          primary: bgColor,
          secondary: mainColor,
          seedColor: textColor,
        ),
        useMaterial3: true,
      ),
      home: const LeadingPage(),
    );
  }
}
