// ignore: file_names
import 'package:appfront/controller/api/APIController.dart';
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
  Logger logger = Logger();
  String groupValue = '';
  List<dynamic> listEngine = [];
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
                "Engine Name", "Enter engine name", _engineNameController),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _getListEngine() async {
    try {
      final response = await APIController().getAll('/engine');
      logger.i(response.data);
    } catch (e) {
      logger.e(e);
    }
  }

  Widget _listEngine() {
    // Define the list of engine options
    final List<String> engineOptions = ['Engine 1', 'Engine 2', 'Engine 3'];

    // Set initial value if groupValue is empty
    if (groupValue.isEmpty) {
      groupValue = engineOptions[0];
    }

    return DropdownButton<String>(
      value: groupValue,
      onChanged: (String? newValue) {
        setState(() {
          groupValue = newValue!;
        });
      },
      items: engineOptions.map<DropdownMenuItem<String>>((String value) {
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
