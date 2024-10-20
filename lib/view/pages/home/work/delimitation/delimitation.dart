import 'dart:convert';
import 'package:appfront/constant/color.dart';
import 'package:appfront/constant/link.dart';
import 'package:appfront/model/work/delimitation.dart';
import 'package:appfront/utils/spinkit.dart';
import 'package:appfront/view/pages/home/work/delimitation/addDelimitation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:appfront/utils/voirPlus.dart';

class Delimitation extends StatefulWidget {
  const Delimitation({super.key});

  @override
  State<Delimitation> createState() => _DelimitationState();
}

class _DelimitationState extends State<Delimitation> {
  bool _isLoading = false;
  bool _isCalendar = true;
  List<DelimitationModel> _delimitationList = [];
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Logger log = Logger();
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<DelimitationModel>> _events;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _events = {};
    _fetchDelimitation();
  }

  List<DelimitationModel> _getEventsForDay(DateTime day) {
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

  Future<void> _fetchDelimitation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('${urlApi}work/delimitation'),
        headers: {"Authorization": token ?? ''},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.body);
        final List<dynamic> datas = json.decode(response.body);
        setState(() {
          _delimitationList =
              datas.map((data) => DelimitationModel.fromJson(data)).toList();
          _loadDelimitation();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load delimitations: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error fetching delimitation: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadDelimitation() {
    _events = {};
    for (var delimitation in _delimitationList) {
      final date = DateTime.parse(delimitation.createdAt).toLocal();
      final dateKey = DateTime(date.year, date.month, date.day);
      if (_events[dateKey] == null) {
        _events[dateKey] = [];
      }
      _events[dateKey]!.add(delimitation);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 80,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isCalendar = !_isCalendar;
                      });
                    },
                    icon: Icon(
                      _isCalendar ? Icons.calendar_month : Icons.list,
                      color: textColor,
                    )),
                const Text('Delimitation', style: TextStyle(color: textColor)),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddDelimitation()));
                  },
                  icon: const Icon(
                    Icons.add,
                    color: textColor,
                  ),
                )
              ],
            ),
          ),
          Expanded(child: _isCalendar ? _calendar() : _story())
        ],
      ),
    );
  }

  Widget _calendar() {
    return Column(
      children: [
        TableCalendar<DelimitationModel>(
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getEventsForDay,
          onDaySelected: _onDaySelected,
          calendarStyle: CalendarStyle(
            markersAutoAligned: true,
            markerSize: 8,
            markerDecoration: const BoxDecoration(
              color: mainColor,
              shape: BoxShape.circle,
            ),
            // Adjust text colors for dark mode
            defaultTextStyle: const TextStyle(color: textColor),
            weekendTextStyle: const TextStyle(color: textColor),
            selectedTextStyle: const TextStyle(color: bgColor),
            todayTextStyle: const TextStyle(color: bgColor),
            outsideTextStyle: TextStyle(color: textColor.withOpacity(0.5)),
            // Adjust decoration colors for dark mode
            selectedDecoration:
                const BoxDecoration(color: mainColor, shape: BoxShape.circle),
            todayDecoration: BoxDecoration(
                color: mainColor.withOpacity(0.5), shape: BoxShape.circle),
            defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
            weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${events.length}',
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
            dowBuilder: (context, day) {
              return Center(
                child: Text(
                  DateFormat.E().format(day)[0],
                  style: const TextStyle(
                      color: textColor, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          daysOfWeekHeight: 20,
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: textColor),
            weekendStyle: TextStyle(color: textColor),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(color: textColor),
            leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
            rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
          ),
        ),
        Expanded(
          child: _isLoading
              ? Center(child: fadingCircle)
              : _getEventsForDay(_selectedDay).isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.event_busy,
                            size: 80,
                            color: textColorSecondary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Aucune delimitation',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColorSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'pour le ${DateFormat('d MMMM yyyy').format(_selectedDay)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddDelimitation()),
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              color: bgColor,
                            ),
                            label: const Text(
                              'Ajouter une delimitation',
                              style: TextStyle(color: bgColor),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: _getEventsForDay(_selectedDay)
                          .map((delimitation) => Card(
                                color: cardColor,
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: mainColor,
                                    child: Text(
                                      delimitation.proprietaire[0]
                                          .toUpperCase(),
                                      style: const TextStyle(color: textColor),
                                    ),
                                  ),
                                  title: Text(
                                    delimitation.proprietaire,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        'Propriétaire: ${delimitation.proprietaire}',
                                        style: const TextStyle(
                                            color: textColorSecondary),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Contact: ${delimitation.contact_proprietaire}',
                                        style: const TextStyle(
                                            color: textColorSecondary),
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      color: mainColor),
                                  onTap: () {},
                                ),
                              ))
                          .toList(),
                    ),
        ),
      ],
    );
  }

  Widget _story() {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: (_isLoading)
                ? Center(child: fadingCircle)
                : ListView.builder(
                    itemCount: _delimitationList.length,
                    itemBuilder: (context, index) {
                      return delimitationStoryItem(_delimitationList[index]);
                    },
                  ),
          ),
          seeMore(),
        ],
      ),
    );
  }

  Widget delimitationStoryItem(DelimitationModel delimitation) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: inversColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date depot dossier :${DateFormat('dd/MM/yyyy').format(DateTime.parse(delimitation.createdAt))}',
                style: const TextStyle(fontSize: 14, color: textColorSecondary),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              delimitation.proprietaire,
              style: const TextStyle(fontSize: 14, color: textColor),
            ),
          ),
          Text(
            delimitation.contact_proprietaire,
            style: const TextStyle(fontSize: 14, color: textColorSecondary),
          ),
          Text(
            delimitation.proprietaire,
            style: const TextStyle(fontSize: 14, color: textColorSecondary),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date retour dossier : ${DateFormat('dd/MM/yyyy').format(DateTime.parse(delimitation.updatedAt))}',
                style: const TextStyle(fontSize: 14, color: textColorSecondary),
              ),
              const VoirPlus(),
            ],
          ),
        ],
      ),
    );
  }

  Widget seeMore() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Center(child: Text('See more')),
    );
  }
}
