// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

class BackButtonV extends StatelessWidget {
  const BackButtonV({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon:  const Icon(Icons.arrow_back_ios,color: inversColor,),
    );
  }
}
