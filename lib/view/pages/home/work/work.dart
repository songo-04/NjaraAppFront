import 'package:appfront/constant/color.dart';
import 'package:appfront/utils/circle.dart';
import 'package:flutter/material.dart';
import 'delimitation/delimitation.dart';
import 'morcellement/morcellement.dart';

class Work extends StatelessWidget {
  const Work({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      child: Stack(children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          left: MediaQuery.of(context).size.width * 0.1,
          child: buildBlurCircle(30, mainColor.withOpacity(0.6)),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.2,
          right: MediaQuery.of(context).size.width * 0.1,
          child: buildBlurCircle(60, mainColor.withOpacity(0.6)),
        ),
        PageView(
          padEnds: false,
          children: const [
            MorcellementPage(),
            Delimitation(),
          ],
        ),
      ]),
    );
  }
}
