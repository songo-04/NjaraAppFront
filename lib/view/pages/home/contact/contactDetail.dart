// ignore_for_file: file_names
import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

class ContactDetail extends StatelessWidget {
  
  const ContactDetail({super.key,});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        title: const Text(
          'Contact',
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        padding: const EdgeInsets.all(24),
        child: const Column(
          children: [Center(child: CircleAvatar(radius: 44))],
        ),
      ),
    );
  }
}
