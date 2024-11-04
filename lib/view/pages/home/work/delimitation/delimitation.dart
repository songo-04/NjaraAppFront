// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/api/APIController.dart';
import 'package:appfront/model/work/delimitation.dart';
import 'package:appfront/utils/spinkit.dart';
import 'package:appfront/view/pages/home/work/delimitation/addDelimitation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
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
      final response = await APIController().getAll('work/delimitation');
      log.i(response.body);
      final List<dynamic> datas = json.decode(response.body);
      setState(() {
        _delimitationList =
            datas.map((data) => DelimitationModel.fromJson(data)).toList();
        _loadDelimitation();
        _isLoading = false;
      });
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
    return Column(
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
    );
  }

  Widget _calendar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: cardColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TableCalendar<DelimitationModel>(
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
        ),
        const SizedBox(height: 12),
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
                          .map((delimitation) =>
                              DelimitationListItem(delimitation: delimitation))
                          .toList(),
                    ),
        ),
      ],
    );
  }

  Widget _story() {
    return Container(
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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      decoration: BoxDecoration(
          color: cardColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10)),
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

class DelimitationListItem extends StatelessWidget {
  final DelimitationModel delimitation;

  const DelimitationListItem({super.key, required this.delimitation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          delimitation.proprietaire,
          style: const TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact: ${delimitation.contact_proprietaire}',
                style: const TextStyle(color: textColorSecondary)),
            Text(
                'Date de création: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(delimitation.createdAt))}',
                style: const TextStyle(color: textColorSecondary)),
          ],
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: mainColor),
        onTap: () {
          _showDelimitationDetails(context, delimitation);
        },
      ),
    );
  }

  void _showDelimitationDetails(
      BuildContext context, DelimitationModel delimitation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          DelimitationDetailsSheet(delimitation: delimitation),
    );
  }
}

class DelimitationDetailsSheet extends StatefulWidget {
  final DelimitationModel delimitation;

  const DelimitationDetailsSheet({super.key, required this.delimitation});

  @override
  _DelimitationDetailsSheetState createState() =>
      _DelimitationDetailsSheetState();
}

class _DelimitationDetailsSheetState extends State<DelimitationDetailsSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return FractionallySizedBox(
          heightFactor: 0.7 * _animation.value,
          child: DraggableScrollableSheet(
            initialChildSize: 1.0,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            builder: (_, controller) => Container(
              decoration: const BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _buildHandle(),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildDetailsList(),
                        const SizedBox(height: 24),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 5,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.delimitation.proprietaire,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Créé le ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.delimitation.createdAt))}',
          style: const TextStyle(color: textColorSecondary),
        ),
      ],
    );
  }

  Widget _buildDetailsList() {
    return Column(
      children: [
        _detailItem('Propriétaire', widget.delimitation.proprietaire),
        _detailItem('Contact', widget.delimitation.contact_proprietaire),
        _detailItem(
            'Date de création',
            DateFormat('dd/MM/yyyy HH:mm')
                .format(DateTime.parse(widget.delimitation.createdAt))),
        _detailItem(
            'Dernière mise à jour',
            DateFormat('dd/MM/yyyy HH:mm')
                .format(DateTime.parse(widget.delimitation.updatedAt))),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Implement edit functionality
          },
          icon: const Icon(Icons.edit),
          label: const Text('Modifier'),
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            foregroundColor: bgColor,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Implement delete functionality
          },
          icon: const Icon(Icons.delete),
          label: const Text('Supprimer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: bgColor,
          ),
        ),
      ],
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textColorSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
