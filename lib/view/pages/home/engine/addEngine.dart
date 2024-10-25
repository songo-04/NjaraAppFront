// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:appfront/utils/showSheetModal.dart';
import 'package:logger/logger.dart';
import 'package:appfront/controller/api/APIController.dart';

Future<void> addEngine(BuildContext context) {
  return showSheetModal(context, const AddEngine());
}

class AddEngine extends StatefulWidget {
  const AddEngine({super.key});

  @override
  State<AddEngine> createState() => _AddEngineState();
}

class _AddEngineState extends State<AddEngine> {
  bool isLoading = false;
  final Logger logger = Logger();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _engineNameController = TextEditingController();
  final TextEditingController _engineTypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField(
                "Engine Name", "Enter engine name", _engineNameController),
            _buildTextField(
                "Engine Type", "Enter engine type", _engineTypeController),
            (isLoading)
                ? const Text('loading...')
                : _buildButton("Add Engine", _addEngine),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: mainColor),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter $hint";
            }
            return null;
          },
        ));
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: mainColor, foregroundColor: bgColor),
      child: Text(label),
    );
  }

  Future<void> _addEngine() async {
    String userId = await APIController().getUserId();
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        "engine_name": _engineNameController.text,
        "engine_desc": _engineTypeController.text,
        "userId": userId
      };
      var response = await APIController().create(data, "engine");
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Engine added ${response.body}");
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      } else {
        logger.i(response.body);
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
