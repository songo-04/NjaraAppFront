// ignore_for_file: file_names, non_constant_identifier_names

import 'package:appfront/controller/api/APIController.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:appfront/constant/color.dart';
import 'package:appfront/utils/appBar.dart';

class AddMorcellement extends StatefulWidget {
  const AddMorcellement({super.key});

  @override
  State<AddMorcellement> createState() => _AddMorcellementState();
}

class _AddMorcellementState extends State<AddMorcellement> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool charge = false;
  String userId = '';
  APIController apiController = APIController();
  Logger log = Logger();
  DateTime? selectedDateReception;
  DateTime? selectedDateLivraison;
  TextEditingController date_reception = TextEditingController();
  TextEditingController date_livraison = TextEditingController();
  TextEditingController name_topographe = TextEditingController();
  TextEditingController contact_topographe = TextEditingController();
  TextEditingController proprietaire = TextEditingController();

  Future<void> getUserId() async {
    userId = await apiController.getUserId();
    setState(() {
      userId = userId;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarUtils(title: 'Ajouter un morcellement'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: bgColor,
        ),
        child: Form(
          key: globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormField('Nom du topographe', name_topographe,
                  Icons.person, TextInputType.text),
              _buildTextFormField('Contact du topographe', contact_topographe,
                  Icons.phone, TextInputType.text),
              _buildTextFormField('Propriétaire', proprietaire, Icons.business,
                  TextInputType.text),
              _buildDatePicker(context, 'Date reception', 'Date reception',
                  date_reception, selectedDateReception),
              _buildDatePicker(context, 'Date livraison', 'Date livraison',
                  date_livraison, selectedDateLivraison),
              (charge)
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('Loading...'),
                    )
                  : _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  static const double _borderRadius = 10.0;
  static const EdgeInsets _fieldPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);

  Widget _buildTextFormField(String labelText, TextEditingController controller,
      IconData icon, TextInputType keyboardType) {
    return Padding(
      padding: _fieldPadding,
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
          prefixIcon: Icon(icon, color: textColor.withOpacity(0.7)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide.none,
          ),
          fillColor: cardColor,
          filled: true,
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
      BuildContext context,
      String hintText,
      String labelText,
      TextEditingController controller,
      DateTime? selectedDate) {
    return Padding(
      padding: _fieldPadding,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
          hintText: hintText,
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
          prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide.none,
          ),
          fillColor: cardColor,
          filled: true,
        ),
        style: const TextStyle(color: textColor),
        controller: controller,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2024),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null && pickedDate != selectedDate) {
            setState(() {
              controller.text = pickedDate.toString().split(' ')[0];
              selectedDate = pickedDate;
            });
          }
        },
      ),
    );
  }

  void _submitForm() async {
    if (name_topographe.text.isEmpty ||
        contact_topographe.text.isEmpty ||
        proprietaire.text.isEmpty ||
        date_reception.text.isEmpty ||
        date_livraison.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les champs sont obligatoires')),
      );
      return;
    }
    if (globalKey.currentState!.validate()) {
      setState(() {
        charge = true;
      });
      Map<String, dynamic> data = {
        'userId': userId,
        'name_topographe': name_topographe.text,
        'contact_topographe': contact_topographe.text,
        'proprietaire': proprietaire.text,
        'date_reception': date_reception.text,
        'date_livraison': date_livraison.text,
      };
      log.i(data.toString());
      await apiController.create(data, 'work/morcellement');
      setState(() {
        charge = false;
      });
      Navigator.pop(context);
    }
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            foregroundColor: bgColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Soumettre',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
