// ignore_for_file: file_names, library_private_types_in_public_api, non_constant_identifier_names

import 'package:appfront/constant/color.dart';
import 'package:appfront/view/components/button/backButton.dart';
import 'package:flutter/material.dart';

class EngineStoryAddPage extends StatefulWidget {
  const EngineStoryAddPage({super.key});

  @override
  _EngineStoryAddPageState createState() => _EngineStoryAddPageState();
}

class _EngineStoryAddPageState extends State<EngineStoryAddPage> {
  final _globalKey = GlobalKey<FormState>();
  final TextEditingController engine_name = TextEditingController();
  final TextEditingController engine_date = TextEditingController();
  final TextEditingController engine_desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: const BackButtonV(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _input(engine_name, TextInputType.text, 'Engine'),
                  _input(engine_date, TextInputType.datetime, 'Engine'),
                  _input(engine_desc, TextInputType.text, 'Engine'),
                ],
              )),
              _addButton(() {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, TextInputType keyboardType,
      String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 14),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: inversColor2,
        ),
      ),
    );
  }

  Widget _addButton(fun) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 40,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Add',
            style: TextStyle(color: inversColor, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
