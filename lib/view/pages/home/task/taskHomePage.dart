// ignore_for_file: file_names, duplicate_ignore

import 'package:appfront/constant/color.dart';
import 'package:appfront/utils/circle.dart';
import 'package:flutter/material.dart';

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // Moved to bottom
            right: MediaQuery.of(context).size.width * 0.1, // Moved to right
            child: buildBlurCircle(60, mainColor.withOpacity(0.6)),
          ),
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child:
                Text('task', style: TextStyle(color: textColor, fontSize: 24)),
          ),
        ],
      ),
    );
  }
}
