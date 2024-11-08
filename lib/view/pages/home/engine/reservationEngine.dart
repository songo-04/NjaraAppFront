// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
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
  Logger logger = Logger();
  String groupValue = '';
  List<dynamic> listEngine = [];
  List<String> name_engine = [];
  final TextEditingController _engineNameController = TextEditingController();

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
        child: Column(
          children: [
            _listEngine(),
            _buildTextField(
              "Engine Name",
              "Enter engine name",
              _engineNameController,
            ),
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
        name_engine = listEngine.map<String>((x) => x.engine_name).toList();
        isEngineLoading = true;
      });
      logger.i(name_engine);
    } catch (e) {
      logger.e(e);
    }
  }

  Widget _listEngine() {
    if (groupValue.isEmpty) {
      // Ensure groupValue is set only if name_engine is not empty
      groupValue = name_engine.isNotEmpty ? name_engine[0] : '';
    }

    return DropdownButton<String>(
      value: groupValue.isNotEmpty ? groupValue : null, // Set to null if empty
      onChanged: (String? newValue) {
        setState(() {
          groupValue = newValue!;
        });
      },
      items: name_engine.map<DropdownMenuItem<String>>((String value) {
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
}
