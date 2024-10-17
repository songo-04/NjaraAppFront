import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

class VoirPlus extends StatelessWidget {
  const VoirPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: mainColor),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Voir plus', style: TextStyle(color: textColor)),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_forward_ios,
            color: mainColor,
            size: 12,
          ),
        ],
      ),
    );
  }
}
