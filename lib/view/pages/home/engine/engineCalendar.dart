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

  final Map<DateTime, List<EngineReservation>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  List<EngineReservation> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _addEvent() {
    final eventTitle = _eventController.text;

    if (eventTitle.isEmpty) return;

    final newEvent = EngineReservation(
      engine: '',
      date: _selectedDay,
      notify: '',
      desc: '',
    );
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
  }

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
                      title: Text(event.notify),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
