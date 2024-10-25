import 'package:appfront/constant/color.dart';
import 'package:appfront/view/pages/home/engine/addEngine.dart';
import 'package:appfront/view/pages/home/engine/engineCalendar.dart';
import 'package:appfront/view/pages/home/engine/engineFinance.dart';
import 'package:appfront/view/pages/home/engine/engineStory.dart';
import 'package:appfront/view/pages/home/engine/reservationEngine.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Engine extends StatefulWidget {
  const Engine({super.key});

  @override
  State<Engine> createState() => _EngineState();
}

class _EngineState extends State<Engine> {
  Logger log = Logger();
  bool isClicked = false;
  final PageController _pageController = PageController();

  changeClickedState(bool value) {
    setState(() {
      isClicked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            log.i("Page changed to $index");
          },
          children: const [
            EngineCalendarPage(),
            EngineStoryPage(),
            EngineFinancePage(),
          ],
        ),
        Positioned(
          bottom: 40,
          right: 4,
          child: (isClicked)
              ? Column(
                  children: [
                    buildBottomBar(() => addEngine(context), Icons.add_alert),
                    buildBottomBar(
                        () => reservationEngine(context), Icons.calendar_month),
                    buildBottomBar(
                        () => changeClickedState(false), Icons.cancel),
                  ],
                )
              : buildBottomBar(() => changeClickedState(true), Icons.add),
        ),
      ],
    );
  }

  Widget buildBottomBar(onPressed, IconData icon) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: bgColor),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: mainColor,
      ),
    );
  }
}
