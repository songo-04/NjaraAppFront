import 'package:flutter/material.dart';
import 'dart:ui';

Widget buildBlurCircle(double size, Color color) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.8),
          blurRadius: 100,
          spreadRadius: 50,
        ),
      ],
    ),
    child: ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.05),
          ),
        ),
      ),
    ),
  );
}
