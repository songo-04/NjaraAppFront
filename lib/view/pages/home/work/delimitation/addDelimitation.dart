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
  final TextEditingController _nameTopographeController =
      TextEditingController();
  final TextEditingController _contactTopographeController =
      TextEditingController();
  final TextEditingController _proprietaireController = TextEditingController();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextFormField('Nom du topographe',
                  _nameTopographeController, Icons.person, TextInputType.text),
              _buildTextFormField(
                  'Contact du topographe',
                  _contactTopographeController,
                  Icons.phone,
                  TextInputType.text),
              _buildTextFormField('Propriétaire', _proprietaireController,
                  Icons.business, TextInputType.text),
              (charge)
                  ? const Text('Loading...')
                  : saveButton(
                      () async {
                        if (_nameTopographeController.text.isEmpty ||
                            _contactTopographeController.text.isEmpty ||
                            _proprietaireController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Tous les champs sont obligatoires')),
                          );
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            charge = true;
                          });
                          Map<String, dynamic> data = {
                            'userId': userId,
                            'name_topographe': _nameTopographeController.text,
                            'contact_topographe':
                                _contactTopographeController.text,
                            'proprietaire': _proprietaireController.text,
                          };
                          logger.d(data);
                          await delimitation.create(data, 'work/delimitation');
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
