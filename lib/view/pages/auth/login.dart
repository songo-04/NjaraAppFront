// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/auth/auth.dart';
import 'package:appfront/controller/navigation/navigationBuilder.dart';
import 'package:appfront/view/pages/auth/singUp.dart';
import 'package:appfront/view/pages/home/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _globalKey = GlobalKey<FormState>();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  Auth auth = Auth();
  bool vis = true;
  bool charge = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login to your account',
              style: TextStyle(
                  color: inversColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Form(
              key: _globalKey,
              child: Column(
                children: [
                  _inputUserName(_userEmailController),
                  _inputPassword(vis, _userPasswordController, () {
                    setState(() {
                      vis = !vis;
                    });
                  }),
                  charge
                      ? const CircularProgressIndicator()
                      : _btn(() async {
                          if (_globalKey.currentState!.validate()) {
                            setState(() {
                              charge = true;
                            });
                            Map<String, String> data = {
                              'user_email': _userEmailController.text,
                              'user_password': _userPasswordController.text
                            };
                            var response = await auth.login(data);
                            Map outPut = json.decode(response.body);
                            if (response.statusCode == 201 ||
                                response.statusCode == 200) {
                              if (outPut['res'] == 'access') {
                                await storage.write(
                                    key: 'token', value: outPut['token']);
                                setState(() {
                                  charge = false;
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Tabs(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                charge = false;
                                _showDialog(context, outPut['res']);
                              }
                            } else {
                              charge = false;
                              _showDialog(context, outPut['res']);
                            }
                            charge=false;
                          }
                        }, 'Login', bgColor, mainColor),
                  const Text('or'),
                  _btn(() {
                    navigation(context, const SignUp());
                  }, 'Sign up', inversColor, inversColor2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context, String res) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: charge
                ? const CircularProgressIndicator()
                : Text(
                    res,
                    textAlign: TextAlign.center,
                  ),
          ),
        );
      },
    );
  }
}

Widget _inputUserName(TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(right: 24, left: 24, top: 20),
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is empty';
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        hintText: 'User email',
        filled: true,
        fillColor: inversColor2,
        suffixIconColor: bgColor,
      ),
    ),
  );
}

Widget _inputPassword(bool vis, TextEditingController controller, fun) {
  return Padding(
    padding: const EdgeInsets.only(right: 24, left: 24, top: 20),
    child: TextFormField(
      obscureText: vis,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          color: inversColor,
          onPressed: fun,
          icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        hintText: 'Password',
        filled: true,
        fillColor: inversColor2,
        suffixIconColor: bgColor,
      ),
    ),
  );
}

Widget _btn(fun, String txt, Color txtColor, Color bgColor) {
  return GestureDetector(
    onTap: fun,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: bgColor,
      ),
      child: Center(
        child: Text(
          txt,
          style: TextStyle(
            color: txtColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
