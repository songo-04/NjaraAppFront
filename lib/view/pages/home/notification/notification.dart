import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

class Notif extends StatelessWidget {
  const Notif({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Container();
          }),
    );
  }
}
