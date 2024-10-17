// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:appfront/utils/spinkit.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Auth auth = Auth();
  String name = '';
  String email = '';
  bool charge = false;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    setState(() {
      charge = true;
    });
    var res = await auth.checkUser();
    var out = json.decode(res.body);
    setState(() {
      name = out['user_name'];
      email = out['user_email'];
      charge = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: charge
          ? Center(child: fadingCircle)
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        _avatar(name.isNotEmpty ? name[0] : ''),
                        const SizedBox(height: 16),
                        _text(name),
                        const SizedBox(height: 8),
                        _text(email),
                        // Add more profile information or actions here
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Text _text(String txt) {
    return Text(
      txt,
      style: const TextStyle(
        color: inversColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _avatar(String txt) {
    return Container(
      width: 100, // Increased size for better visibility
      height: 100,
      decoration: BoxDecoration(
        color: cardColor,
        shape: BoxShape
            .circle, // Use shape instead of borderRadius for perfect circle
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          txt.isNotEmpty
              ? txt[0].toUpperCase()
              : '?', // Handle empty string case
          style: const TextStyle(
            fontSize: 36, // Increased font size
            fontWeight: FontWeight.bold,
            color: Colors.white, // Improved contrast
          ),
        ),
      ),
    );
  }
}
