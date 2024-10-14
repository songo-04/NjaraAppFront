import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

TextFormField searchInput() {
  return TextFormField(
    decoration:  InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      hintText: 'Search ...',
      filled: true,
      fillColor: Colors.white,
      suffixIcon: const Icon(
        Icons.search,
        color: bgColor,
      ),
      suffixIconColor: bgColor,
    ),
  );
}
