// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:appfront/view/components/button/backButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import 'dart:io' show Platform;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late Timer _timer;
  Logger logger = Logger();
  bool _notificationSent = false;
  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions();
    _initializeNotifications().then((_) {
      logger.d('Notifications initialized');
      _startDailyCheck();
    });
  }

  Future<void> _initializeNotifications() async {
    try {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Configuration pour Android
      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      bool? initialized = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          logger.d('Notification clicked: ${response.payload}');
        },
      );

      logger.d('Notifications initialized: $initialized');

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      logger.d('Notification channel created');
    } catch (e) {
      logger.e('Error initializing notifications: $e');
    }
  }

  void _startDailyCheck() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final now = DateTime.now();
      logger.d('Checking time: ${now.hour}:${now.minute}:${now.second}');

      if (now.hour == 19 && now.minute == 00 && !_notificationSent) {
        logger.d('Time matched, showing notification');
        _showDailyNotification();
        _notificationSent = true;
      }

      if (now.hour == 20 && now.minute == 12) {
        _notificationSent = false;
      }
    });
  }

  Future<void> _requestNotificationPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();
      logger.d('Notification permission granted: $granted');
    }
  }

  Future<void> _showDailyNotification() async {
    try {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
      );
      const platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      await flutterLocalNotificationsPlugin.show(
        0,
        'Rappel quotidien',
        'Il est 20h11 !',
        platformChannelSpecifics,
      );
      logger.d('Notification sent successfully');
    } catch (e) {
      logger.e('Error showing notification: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: inversColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 4),
          child: BackButtonV(),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _showDailyNotification,
            child: const Text('Test Notification'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return _cardNotification();
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _cardNotification() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    width: double.infinity,
    height: 84,
    decoration:
        BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(8)),
    child: const Row(
      children: [],
    ),
  );
}
