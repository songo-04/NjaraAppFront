import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/navigation/navigationBuilder.dart';
import 'package:appfront/view/pages/home/engine/engineFinance.dart';
import 'package:appfront/view/pages/home/engine/engineCalendar.dart';
import 'package:appfront/view/pages/home/engine/engineStory.dart';
import 'package:appfront/view/pages/home/engine/engineStoryAdd.dart';
import 'package:flutter/material.dart';

class Engine extends StatefulWidget {
  const Engine({super.key});

  @override
  State<Engine> createState() => _EngineState();
}

class _EngineState extends State<Engine> {
  final List<dynamic> _screen = [
    const EngineCalendarPage(),
    const EngineStoryPage(),
    const EngineFinancePage(),
  ];
  int _currentIndex = 0;
  bool stateBtn1 = true;
  bool stateBtn2 = false;
  bool stateBtn3 = false;

  void changeStateBtn(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        setState(() {
          stateBtn1 = true;
          stateBtn2 = stateBtn3 = false;
        });
        break;
      case 1:
        setState(() {
          stateBtn2 = true;
          stateBtn1 = stateBtn3 = false;
        });
        break;
      case 2:
        setState(() {
          stateBtn3 = true;
          stateBtn1 = stateBtn2 = false;
        });
        break;
      default:
        0;
    }

    debugPrint(_currentIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          Container(
            color: bgColor,
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _tabButton('Calendar', stateBtn1, () {
                  changeStateBtn(0);
                }),
                _tabButton('Story', stateBtn2, () {
                  changeStateBtn(1);
                }),
                _tabButton('finance', stateBtn3, () {
                  changeStateBtn(2);
                }),
              ],
            ),
          ),
          Expanded(child: _screen[_currentIndex]),
        ],
      ),
      Positioned(
        bottom: 280,
        right: 0,
        child: FloatingActionButton(
          backgroundColor: mainColor,
          onPressed: () {
            navigation(context, const EngineStoryAddPage());
          },
          child: const Icon(Icons.add),
        ),
      ),
    ]);
  }

  Widget _tabButton(String txtBtn, bool state, Function fun) {
    return GestureDetector(
      onTap: () {
        fun();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: (state) ? inversColor : inversColor2,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          txtBtn,
          style: TextStyle(
            
              color: (state) ? bgColor : inversColor,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
