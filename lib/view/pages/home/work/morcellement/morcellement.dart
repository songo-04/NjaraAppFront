import 'dart:convert';
import 'package:appfront/constant/color.dart';
import 'package:appfront/constant/link.dart';
import 'package:appfront/model/work/morcellement.dart';
import 'package:appfront/utils/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';
import 'addMorcellement.dart';
import 'package:http/http.dart' as http;
import 'package:appfront/utils/voirPlus.dart';

class MorcellementPage extends StatefulWidget {
  const MorcellementPage({super.key});

  @override
  State<MorcellementPage> createState() => _MorcellementState();
}

class _MorcellementState extends State<MorcellementPage> {
  bool _isLoading = false;
  bool _isCalendar = true;

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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const Text('Morcellement', style: TextStyle(color: textColor)),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddMorcellement()),
                    );
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
        TableCalendar<Morcellement>(
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
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) =>
                DateFormat.E(locale).format(date)[0],
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
                            'Aucun morcellement',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'pour le ${DateFormat('d MMMM yyyy').format(_selectedDay)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: textColorSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddMorcellement()),
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              color: bgColor,
                            ),
                            label: const Text(
                              'Ajouter un morcellement',
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
                          .map((morcellement) =>
                              MorcellementListItem(morcellement: morcellement))
                          .toList(),
                    ),
        ),
      ],
    );
  }

  Widget _story() {
    return Column(
      children: [
        Expanded(
          child: (_isLoading)
              ? Center(child: fadingCircle)
              : ListView.builder(
                  itemCount: _morcellementList.length,
                  itemBuilder: (context, index) {
                    return _itemStory(_morcellementList[index]);
                  },
                ),
        ),
        (_isLoading) ? const SizedBox.shrink() : _seeMore(),
      ],
    );
  }

  Widget _itemStory(Morcellement morcellement) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: inversColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'date reception: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(morcellement.date_reception))}',
            style: const TextStyle(color: textColorSecondary),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                'Geometre: ${morcellement.name_topographe}',
                style: const TextStyle(color: textColorSecondary),
              ),
              Text(
                'Propriétaire: ${morcellement.proprietaire}',
                style: const TextStyle(color: textColorSecondary),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'date livraison: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(morcellement.date_livraison))}',
                style: const TextStyle(color: textColor),
              ),
              const VoirPlus()
            ],
          ),
        ],
      ),
    );
  }

  Widget _seeMore() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: const Text('See More'),
    );
  }
}

class MorcellementListItem extends StatelessWidget {
  final Morcellement morcellement;

  const MorcellementListItem({super.key, required this.morcellement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(morcellement.name_topographe,
            style: Theme.of(context).textTheme.titleMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Propriétaire: ${morcellement.proprietaire}'),
            Text('Contact: ${morcellement.contact_topographe}'),
            Text(
                'Date de réception: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(morcellement.date_reception))}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}