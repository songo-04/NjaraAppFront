// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

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
  TextEditingController date_reception_controller = TextEditingController();
  TextEditingController date_livraison_controller = TextEditingController();
  TextEditingController contact_proprietaire_controller =
      TextEditingController();
  TextEditingController proprietaire_controller = TextEditingController();
  TextEditingController numero_parcelle_controller = TextEditingController();
  TextEditingController section_controller = TextEditingController();
  TextEditingController canton_controller = TextEditingController();
  TextEditingController titre_foncier_controller = TextEditingController();
  TextEditingController propriete_dite_controller = TextEditingController();

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Form(
              key: globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextFormField(
                      'Nom du proprietaire ',
                      proprietaire_controller,
                      Icons.person,
                      TextInputType.text),
                  _buildTextFormField(
                      'Contact du proprietaire',
                      contact_proprietaire_controller,
                      Icons.phone,
                      TextInputType.text),
                  _buildTextFormField(
                      'Numero de parcelle',
                      numero_parcelle_controller,
                      Icons.numbers,
                      TextInputType.text),
                  _buildTextFormField('Section', section_controller,
                      Icons.numbers, TextInputType.text),
                  _buildTextFormField('Canton', canton_controller,
                      Icons.numbers, TextInputType.text),
                  _buildTextFormField('Titre foncier', titre_foncier_controller,
                      Icons.numbers, TextInputType.text),
                  _buildTextFormField(
                      'Propriete dite',
                      propriete_dite_controller,
                      Icons.numbers,
                      TextInputType.text),
                  _buildDatePicker(context, 'Date reception', 'Date reception',
                      date_reception_controller, selectedDateReception),
                  _buildDatePicker(context, 'Date livraison', 'Date livraison',
                      date_livraison_controller, selectedDateLivraison),
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
    if (contact_proprietaire_controller.text.isEmpty ||
        proprietaire_controller.text.isEmpty ||
        numero_parcelle_controller.text.isEmpty ||
        section_controller.text.isEmpty ||
        canton_controller.text.isEmpty ||
        titre_foncier_controller.text.isEmpty ||
        propriete_dite_controller.text.isEmpty ||
        date_reception_controller.text.isEmpty ||
        date_livraison_controller.text.isEmpty) {
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
        'contact_proprietaire': contact_proprietaire_controller.text,
        'proprietaire': proprietaire_controller.text,
        'numero_parcelle': numero_parcelle_controller.text,
        'section': section_controller.text,
        'canton': canton_controller.text,
        'titre_foncier': titre_foncier_controller.text,
        'propriete_dite': propriete_dite_controller.text,
        'date_reception': date_reception_controller.text,
        'date_livraison': date_livraison_controller.text,
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
