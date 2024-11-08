// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/api/APIController.dart';
import 'package:appfront/model/engine/engineReservation.dart';
import 'package:flutter/material.dart';
import 'package:appfront/utils/showSheetModal.dart';
import 'package:logger/logger.dart';

Future<void> reservationEngine(BuildContext context) {
  return showSheetModal(context, const ReservationEngine());
}

class ReservationEngine extends StatefulWidget {
  const ReservationEngine({super.key});

  @override
  _State createState() => _State();
}

class _State extends State<ReservationEngine> {
  bool isEngineLoading = false;
  bool isReservationLoading = false;
  Logger logger = Logger();
  final _formKey = GlobalKey<FormState>();
  String groupValue = '';
  List<dynamic> listEngine = [];
  List<String> nameEngine = [];
  String selectedEngine = '';
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _datePickerController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getListEngine();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _listEngine(),
            _buildTextField('desc', 'desc', _descController),
            _buildDatePicker(),
            const SizedBox(height: 10),
            _buildButton(_saveEngineReservation),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _getListEngine() async {
    try {
      final response = await APIController().getAll('engine');
      logger.i(response.body);
      final List<dynamic> datas = json.decode(response.body);
      setState(() {
        listEngine = datas.map((data) => Engine.fromJson(data)).toList();
        nameEngine = listEngine.map<String>((x) => x.engine_name).toList();
        isEngineLoading = true;
      });
      logger.i(nameEngine);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _saveEngineReservation() async {
    String userId = await APIController().getUserId();
    if (_formKey.currentState!.validate()) {
      setState(() {
        isReservationLoading = true;
      });
      Map<String, dynamic> data = {
        "engine": selectedEngine.toString(),
        "desc": _descController.text,
        "date": _datePickerController.text,
        "userId": userId,
      };

      var request = await APIController().create(data, 'enginedateused');
      if (request.statusCode == 200 || request.statusCode == 201) {
        logger.i(request.body);
        setState(() {
          isReservationLoading = false;
        });
        _dialogue(request.body);
      }
    }
  }

  Future<String?> _dialogue(dynamic message) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Titre du dialogue'),
          content: Text(message.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _listEngine() {
    if (groupValue.isEmpty) {
      // Ensure groupValue is set only if name_engine is not empty
      groupValue = nameEngine.isNotEmpty ? nameEngine[0] : '';
    }

    return DropdownButton<String>(
      value: groupValue.isNotEmpty ? groupValue : null, // Set to null if empty
      onChanged: (String? newValue) {
        setState(() {
          groupValue = newValue!;
          selectedEngine = newValue;
        });
      },
      items: nameEngine.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          _datePickerController.text =
              selectedDate.toLocal().toString().split(' ')[0]; // Format de date
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _datePickerController,
          decoration: const InputDecoration(
              labelText: 'Select Date', hintText: 'Tap to select a date'),
        ),
      ),
    );
  }

  Widget _buildButton(VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: const Text('Save'),
    );
  }
}
