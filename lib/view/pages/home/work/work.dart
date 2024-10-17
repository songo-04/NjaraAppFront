import 'package:flutter/material.dart';
import 'delimitation/delimitation.dart';
import 'morcellement/morcellement.dart';
class Work extends StatelessWidget {
  const Work({super.key});
  @override
  Widget build(BuildContext context) {
    return PageView(
      padEnds: false,
      children:const [
         MorcellementPage(),
         Delimitation(),
      ],
    );
  }
}

