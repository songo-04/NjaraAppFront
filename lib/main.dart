import 'package:appfront/view/pages/leadingPage/leadingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'constant/color.dart';
import 'package:appfront/view/pages/home/notification/notification_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize NotificationHelper
  await NotificationHelper().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          primary: bgColor,
          secondary: mainColor,
          seedColor: bgColor,
        ),
        useMaterial3: true,
      ),
      home: const LeadingPage(),
    );
  }
}
