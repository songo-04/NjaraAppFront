// ignore_for_file: file_names, collection_methods_unrelated_type

import 'package:appfront/model/engine/engineReservation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EngineCalendarPage extends StatefulWidget {
  const EngineCalendarPage({super.key});

  @override
  State<EngineCalendarPage> createState() => _EngineCalendarPageState();
}

class _EngineCalendarPageState extends State<EngineCalendarPage> {
  Logger log = Logger();

  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;

  Map<DateTime, List<EngineReservation>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  List<EngineReservation> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _addEvent() {
    final eventTitle = _eventController.text;

    if (eventTitle.isEmpty) return;

    final newEvent = EngineReservation(reservation_name: eventTitle);
    setState(() {
      if (_events[_selectedDay] != null) {
        _events[_selectedDay]!.add(newEvent);
      } else {
        _events[_selectedDay] = [newEvent];
      }
    });

    log.i(_events[_selectedDay]);
    log.i(_events[eventTitle]);
    _eventController.clear();
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _events = {
      DateTime.utc(2024, 9, 9): [
        const EngineReservation(reservation_name: 'reservation appareil 1')
      ],
      DateTime.utc(2024, 9, 10): [
        const EngineReservation(reservation_name: 'reservation appareil 2')
      ],
    };

    // _initializeNotifications();
    // _scheduleAlarm();
  }

  // Future<void> _initializeNotifications() async {
  //   tz.initializeTimeZones();
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final DarwinInitializationSettings initializationSettingsDarwin =
  //       DarwinInitializationSettings(
  //     requestAlertPermission: true,
  //     requestBadgePermission: true,
  //     requestSoundPermission: true,
  //   );
  //   final InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsDarwin,
  //   );
  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
  //       // Handle the notification response here
  //       log.i('Notification clicked');
  //       _handleNotificationResponse(notificationResponse);
  //     },
  //   );

  //   // Demandez les permissions
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  //       ?.requestNotificationsPermission();
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );
  // }

  // void _handleNotificationResponse(NotificationResponse notificationResponse) {
  //   final String? payload = notificationResponse.payload;
  //   if (payload != null) {
  //     log.i('Notification payload: $payload');
  //     // Parse the payload and navigate to the appropriate screen or perform an action
  //     _navigateToRelevantScreen(payload);
  //   }

  //   // Update the UI or perform any other necessary actions
  //   setState(() {
  //     // For example, you could refresh the calendar or mark a specific day
  //     _focusedDay = DateTime.now();
  //     _selectedDay = DateTime.now();
  //   });
  // }

  // void _navigateToRelevantScreen(String payload) {
  //   // Implement navigation logic based on the payload
  //   // For example:
  //   switch (payload) {
  //     case 'daily_reminder':
  //       // Navigate to daily summary screen
  //       // Navigator.push(context, MaterialPageRoute(builder: (context) => DailySummaryScreen()));
  //       break;
  //     case 'upcoming_reservation':
  //       // Navigate to reservation details screen
  //       // Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationDetailsScreen()));
  //       break;
  //     default:
  //       // Default action or error handling
  //       log.w('Unknown payload: $payload');
  //   }
  // }

  // Future<void> _scheduleAlarm() async {
  //   final now = DateTime.now();
  //   final alarmTime = DateTime(now.year, now.month, now.day, 17, 55);

  //   if (now.isBefore(alarmTime)) {
  //     await _scheduleNotification(alarmTime);
  //   } else {
  //     // If it's already past 19:00, schedule for tomorrow
  //     final tomorrowAlarm = alarmTime.add(const Duration(days: 1));
  //     await _scheduleNotification(tomorrowAlarm);
  //   }
  // }

  // Future<void> _scheduleNotification(DateTime scheduledDate) async {
  //   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  //     'alarm_channel',
  //     'Alarm Notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: true,
  //   );
  //   var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics,
  //   );

  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     'Alarme',
  //     'Il est 19h00!',
  //     tz.TZDateTime.from(scheduledDate, tz.local),
  //     platformChannelSpecifics,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //     payload: 'daily_reminder',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: _firstDay,
          lastDay: _lastDay,
          calendarStyle: const CalendarStyle(
            markerDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: _getEventsForDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _eventController,
            decoration: const InputDecoration(
              labelText: 'Titre de l\'événement',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(
          height: 40.0,
          width: double.infinity,
          child: IconButton(onPressed: _addEvent, icon: const Icon(Icons.add)),
        ),
        Expanded(
          child: ListView(
            children: _getEventsForDay(_selectedDay)
                .map((event) => ListTile(
                      title: Text(event.reservation_name),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
