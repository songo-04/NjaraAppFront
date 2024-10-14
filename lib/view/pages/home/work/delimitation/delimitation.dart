import 'package:appfront/constant/color.dart';
import 'package:appfront/view/components/button/backButton.dart';
import 'package:flutter/material.dart';

import 'addDelimitation.dart';
import 'calendar.dart';
import 'delimitationStory.dart';

class Delimitation extends StatefulWidget {
  const Delimitation({super.key});

  @override
  State<Delimitation> createState() => _DelimitationState();
}

class _DelimitationState extends State<Delimitation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Calendar(),
    const DelimitationStory(),
    const AddDelimitation(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delimitation'),
        centerTitle: true,
        leading: const BackButtonV(),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 80,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                delimitationItemMenu(_currentIndex == 0, 'Calendar', mainColor, () => setState(() => _currentIndex = 0)),
                delimitationItemMenu(_currentIndex == 1, 'Story', mainColor, () => setState(() => _currentIndex = 1)),
                delimitationItemMenu(_currentIndex == 2, 'add', mainColor, () => setState(() => _currentIndex = 2)),
              ],
            ),
          ),
          Expanded(
            child: _pages[_currentIndex],
          )
        ],
      ),
    );
  }
}

Widget delimitationItemMenu(bool isSelected, String txt, Color color, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      width: 100,
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.grey,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text(
          txt,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
