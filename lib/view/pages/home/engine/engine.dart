import 'package:appfront/view/pages/home/engine/engineCalendar.dart';
import 'package:appfront/view/pages/home/engine/engineFinance.dart';
import 'package:appfront/view/pages/home/engine/engineStory.dart';
import 'package:flutter/material.dart';

class Engine extends StatefulWidget {
  const Engine({super.key});

  @override
  State<Engine> createState() => _EngineState();
}

class _EngineState extends State<Engine> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      padEnds: false,
      children: const [
        EngineCalendarPage(),
        EngineStoryPage(),
        EngineFinancePage()
      ],
    );
  }
}
