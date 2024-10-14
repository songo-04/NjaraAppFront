import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

Widget notificationCard() {
  return Container(
    color: inversColor2,
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: const Column(
      children: [
        Row(
          children: [
            Text(
              'data',
              style: TextStyle(fontWeight: FontWeight.w500,color: inversColor),
            ),
            SizedBox(width: 10),
            Text('title',style: TextStyle(color: inversColor),)
          ],
        ),
        Text('lorem ')
      ],
    ),
  );
}
