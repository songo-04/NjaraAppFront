// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:appfront/utils/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:appfront/controller/api/APIController.dart';

class AddDelimitation extends StatefulWidget {
  const AddDelimitation({super.key});

  @override
  State<AddDelimitation> createState() => _AddDelimitationState();
}

class _AddDelimitationState extends State<AddDelimitation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contactProprietaireController =
      TextEditingController();
  final TextEditingController _proprietaireController = TextEditingController();
  final TextEditingController _numeroParcelleController =
      TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _cantonController = TextEditingController();
  final TextEditingController _titreFoncierController = TextEditingController();
  final TextEditingController _diteController = TextEditingController();
  final TextEditingController _proprieteDiteController =
      TextEditingController();
  final TextEditingController _dateReceptionController =
      TextEditingController();
  final TextEditingController _dateLivraisonController =
      TextEditingController();

  APIController delimitation = APIController();

  String txt = '';
  String userId = '';
  bool charge = false;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Logger logger = Logger();

  Future<void> getUserId() async {
    String? token = await storage.read(key: 'token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    setState(() {
      userId = decodedToken['userId'];
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
      appBar: const AppBarUtils(title: 'Ajouter une delimitation'),
      body: Container(
        color: bgColor,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextFormField(
                    'Contact du proprietaire',
                    _contactProprietaireController,
                    Icons.person,
                    TextInputType.text),
                _buildTextFormField('Proprietaire', _proprietaireController,
                    Icons.phone, TextInputType.text),
                _buildTextFormField(
                    'Numero de parcelle',
                    _numeroParcelleController,
                    Icons.numbers,
                    TextInputType.text),
                _buildTextFormField('Section', _sectionController,
                    Icons.numbers, TextInputType.text),
                _buildTextFormField(
                    'Dite', _diteController, Icons.numbers, TextInputType.text),
                _buildTextFormField('Canton', _cantonController, Icons.numbers,
                    TextInputType.text),
                _buildTextFormField('Titre foncier', _titreFoncierController,
                    Icons.numbers, TextInputType.text),
                _buildTextFormField('Propriété dite', _proprieteDiteController,
                    Icons.numbers, TextInputType.text),
                _buildDatePicker(context, 'Date de depot', 'Date de depot',
                    _dateReceptionController, DateTime.now()),
                _buildDatePicker(
                    context,
                    'Date de livraison',
                    'Date de livraison',
                    _dateLivraisonController,
                    DateTime.now()),
                (charge)
                    ? const Text('Loading...')
                    : saveButton(
                        () async {
                          if (_contactProprietaireController.text.isEmpty ||
                              _proprietaireController.text.isEmpty ||
                              _numeroParcelleController.text.isEmpty ||
                              _sectionController.text.isEmpty ||
                              _cantonController.text.isEmpty ||
                              _titreFoncierController.text.isEmpty ||
                              _proprieteDiteController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Tous les champs sont obligatoires')),
                            );
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              charge = true;
                            });
                            Map<String, dynamic> data = {
                              'userId': userId,
                              'contact_proprietaire':
                                  _contactProprietaireController.text,
                              'proprietaire': _proprietaireController.text,
                              'numero_parcelle': _numeroParcelleController.text,
                              'section': _sectionController.text,
                              'dite': _diteController.text,
                              'canton': _cantonController.text,
                              'titre_foncier': _titreFoncierController.text,
                              'propriete_dite': _proprieteDiteController.text,
                              'date_reception': _dateReceptionController.text,
                              'date_livraison': _dateLivraisonController.text,
                            };
                            logger.d(data);
                            await delimitation.create(
                                data, 'work/delimitation');
                            setState(() {
                              charge = false;
                            });
                            Navigator.pop(context);
                          }
                        },
                      ),
              ],
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
        ),
        style: const TextStyle(color: textColor),
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

  Widget saveButton(Function() onTap) {
    return Padding(
      padding: _fieldPadding,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            foregroundColor: bgColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
          ),
          child: const Text(
            'Soumettre',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
