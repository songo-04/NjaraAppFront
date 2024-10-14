// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/auth/auth.dart';
import 'package:flutter/material.dart';

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
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: charge
          ?  const Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(color: bgColor),
              child: Column(
                children: [
                  _avatar(name[0]),
                  _text(name),
                  _text(email),
                ],
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
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          color: inversColor2, borderRadius: BorderRadius.circular(100)),
      child: Center(
        child: Text(
          txt.toUpperCase(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
