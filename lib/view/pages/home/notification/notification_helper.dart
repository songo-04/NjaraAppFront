import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import 'dart:io' show Platform;

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  factory NotificationHelper() => _instance;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Logger logger = Logger();

  NotificationHelper._internal() {
    _initialize();
  }

  static final Logger log = Logger();

  Future<void> _initialize() async {
    await _initializeNotifications();
    await _requestNotificationPermissions();
    _startDailyCheck();
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
    final now = DateTime.now();
    DateTime scheduledTime = DateTime(now.year, now.month, now.day, 19, 00);

    if (now.isAfter(scheduledTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    Duration initialDelay = scheduledTime.difference(now);

    Timer(initialDelay, () {
      _showDailyNotification();
      // Planifier la prochaine notification pour le lendemain
      Timer.periodic(const Duration(days: 1), (_) {
        _showDailyNotification();
      });
    });

    logger.d('Notification scheduled for ${scheduledTime.toString()}');
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
        'Il est 19h00 !',
        platformChannelSpecifics,
      );
      logger.d('Notification sent successfully');
    } catch (e) {
      logger.e('Error showing notification: $e');
    }
  }

  Future<void> showDailyNotification() async {
    await _showDailyNotification();
  }

  Future<void> initialize() async {
    await _initializeNotifications();
    await _requestNotificationPermissions();
    _startDailyCheck();
  }
}
