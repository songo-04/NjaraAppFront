// ignore_for_file: file_names, non_constant_identifier_names

import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/api/APIController.dart';
import 'package:appfront/utils/appBar.dart';
import 'package:appfront/utils/spinkit.dart';
import 'package:flutter/material.dart';

class ContactCreatePage extends StatefulWidget {
  const ContactCreatePage({super.key});

  @override
  State<ContactCreatePage> createState() => _ContactCreatePageState();
}

class _ContactCreatePageState extends State<ContactCreatePage> {
  final _globalKey = GlobalKey<FormState>();
  final TextEditingController contact_name = TextEditingController();
  final TextEditingController contact_number = TextEditingController();
  final TextEditingController contact_email = TextEditingController();
  final TextEditingController contact_note = TextEditingController();

  APIController contact = APIController();
  bool charge = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarUtils(title: 'Ajouter un contact'),
      body: Container(
        width: double.infinity,
        color: bgColor,
        child: Form(
          key: _globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _input(contact_name, 'contact name', TextInputType.text),
              _input(contact_number, 'contact number', TextInputType.number),
              _input(
                  contact_email, 'contact email', TextInputType.emailAddress),
              _input(contact_note, 'contact note', TextInputType.text),
              charge
                  ? fadingCircle
                  : _btn(
                      () async {
                        if (contact_name.text.isEmpty ||
                            contact_number.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('nom et numero sont obligatoires')),
                          );
                          return;
                        }
                        if (_globalKey.currentState!.validate()) {
                          setState(() {
                            charge = true;
                          });
                          Map<String, String> data = {
                            'contact_name': contact_name.text,
                            'contact_number': contact_number.text,
                            'contact_email': contact_email.text,
                            'contact_note': contact_note.text,
                          };
                          debugPrint(data.toString());
                          await contact.create(data, 'contact');
                          setState(() {
                            charge = false;
                          });
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, String hintText,
      TextInputType keyboard) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: TextFormField(
        keyboardType: keyboard,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hintText is empty';
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: hintText,
          filled: true,
          fillColor: cardColor,
        ),
      ),
    );
  }

  _btn(VoidCallback fun) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: mainColor, borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: Text(
            'Enregistrer',
            style: TextStyle(
                color: bgColor, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
