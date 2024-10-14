// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:appfront/view/components/button/backButton.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: bgColor,
          title: const Text(
            'Notifications',
            style: TextStyle(
              color: inversColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: const Padding(
            padding: EdgeInsets.only(left: 4),
            child: BackButtonV(),
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        padding: const EdgeInsets.all(14),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return _cardNotification();
          },
        ),
      ),
    );
  }
}

Widget _cardNotification() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    width: double.infinity,
    height: 84,
    decoration: BoxDecoration(
        color: inversColor2, borderRadius: BorderRadius.circular(8)),
    child: const Row(
      children: [],
    ),
  );
}
