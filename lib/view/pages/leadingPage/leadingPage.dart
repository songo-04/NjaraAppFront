// ignore_for_file: file_names

import 'dart:async';
import 'package:appfront/constant/color.dart';
import 'package:appfront/view/pages/auth/login.dart';
import 'package:appfront/view/pages/home/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    Timer(const Duration(seconds: 5), () {
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bgColor, surfaceColor],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 20),
            _buildLoadingIndicator(),
            const SizedBox(height: 20),
            _buildVersionText(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogoText('task', mainColor),
        const SizedBox(width: 10),
        _buildLogoText('app', textColor),
      ],
    );
  }

  Widget _buildLogoText(String text, Color color) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 44,
        fontWeight: FontWeight.w600,
        shadows: [
          Shadow(
            blurRadius: 10.0,
            color: const Color.fromARGB(255, 19, 19, 19).withOpacity(0.3),
            offset: const Offset(5.0, 5.0),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SpinKitFadingCube(
      color: mainColor,
      size: 50,
    );
  }

  Widget _buildVersionText() {
    return const Text(
      'Version 1.0.0',
      style: TextStyle(
        color: textColorSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
