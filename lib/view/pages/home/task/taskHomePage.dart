
// ignore_for_file: file_names, duplicate_ignore

import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

class TaskHomePage extends StatelessWidget {
  const TaskHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      child: const Center(child: Text('task'),),
    );
  }
}