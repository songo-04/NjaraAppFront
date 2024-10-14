// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
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
  final TextEditingController _nameTopographeController = TextEditingController();
  final TextEditingController _contactTopographeController = TextEditingController();
  final TextEditingController _proprietaireController = TextEditingController();
  
  APIController delimitation = APIController();

  String txt = '';
  String userId = '';
  bool charge = false;
  final FlutterSecureStorage storage =const FlutterSecureStorage();
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
    return Container(
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addDelimitationItem(_nameTopographeController),
            addDelimitationItem(_contactTopographeController),
            addDelimitationItem(_proprietaireController),            
            saveButton(() async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  charge = true;
                });
                Map<String, String> data = {
                  'userId': userId,
                  'name_topographe': _nameTopographeController.text,
                  'contact_topographe': _contactTopographeController.text,
                  'proprietaire': _proprietaireController.text,
                }; 
                logger.d(data);
                await delimitation.create(data,'delimitation');
                setState(() {
                  charge = false;
                });
                }
            },(charge) ? 'Loading...' : 'Enregistrer'),
          ],
        ),
      ),
    );
  }
}

Widget addDelimitationItem(TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est requise et ne doit pas être vide';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'Nom de l\'utilisateur',
        filled: true,
        fillColor: inversColor2,
      ),
    ),
  );
}

Widget saveButton(Function() onTap,String txt) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        txt,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

