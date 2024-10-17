import 'package:appfront/constant/link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:appfront/model/work/morcellement.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:appfront/utils/spinkit.dart';

class CalendarMorcellement extends StatefulWidget {
  const CalendarMorcellement({super.key});

  @override
  State<CalendarMorcellement> createState() => _CalendarMorcellementState();
}

class _CalendarMorcellementState extends State<CalendarMorcellement> {
  bool _isLoading = false;
  List<Morcellement> _morcellementList = [];
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Logger log = Logger();
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Morcellement>> _events;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _events = {};
    _fetchMorcellement();
  }

  List<Morcellement> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  Future<void> _fetchMorcellement() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('${urlApi}work/morcellement'),
        headers: {"Authorization": token ?? ''},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.body);
        final List<dynamic> datas = json.decode(response.body);
        setState(() {
          _morcellementList =
              datas.map((data) => Morcellement.fromJson(data)).toList();
          _loadMorcellement();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load morcellement: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error fetching morcellement: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMorcellement() {
    _events = {};
    for (var morcellement in _morcellementList) {
      final date = DateTime.parse(morcellement.date_reception).toLocal();
      final dateKey = DateTime(date.year, date.month, date.day);
      if (_events[dateKey] == null) {
        _events[dateKey] = [];
      }
      _events[dateKey]!.add(morcellement);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: fadingCircle)
        : Column(
            children: [
              TableCalendar<Morcellement>(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: _getEventsForDay,
                onDaySelected: _onDaySelected,
                calendarStyle: const CalendarStyle(
                  markersAutoAligned: true,
                  markerSize: 8,
                  markerDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '${events.length}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                daysOfWeekHeight: 20,
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) =>
                      DateFormat.E(locale).format(date)[0],
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat.yMMMMd(locale).format(date),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _getEventsForDay(_selectedDay)
                      .map((delimitation) => ListTile(
                            title: Text(delimitation.name_topographe),
                            subtitle: Text(
                              '${delimitation.proprietaire} - ${delimitation.contact_topographe}',
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          );
  }
}
