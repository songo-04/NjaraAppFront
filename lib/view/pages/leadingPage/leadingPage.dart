// ignore_for_file: file_names

import 'dart:async';
import 'package:appfront/constant/color.dart';
import 'package:appfront/view/pages/auth/login.dart';
import 'package:appfront/view/pages/home/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LeadingPage extends StatefulWidget {
  const LeadingPage({super.key});

  @override
  State<LeadingPage> createState() => _LeadingPageState();
}

class _LeadingPageState extends State<LeadingPage> {
  Widget page = const Login();
  final storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    checkToken();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => page),
        (route) => false,
      );
    });
  }

  void getToken() async {}
  
  void checkToken() async {
    var token = await storage.read(key: 'token');
    debugPrint(token);
    if (token != null) {
      setState(() {
        page = const Tabs();
      });
    } else {
      setState(() {
        page = const Login();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'task'.toUpperCase(),
                style: const TextStyle(
                  color: mainColor,
                  fontSize: 44,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'app'.toUpperCase(),
                style: const TextStyle(
                  color: inversColor,
                  fontSize: 44,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
