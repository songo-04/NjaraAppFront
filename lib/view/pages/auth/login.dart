// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/auth/auth.dart';
import 'package:appfront/controller/navigation/navigationBuilder.dart';
import 'package:appfront/view/pages/auth/singUp.dart';
import 'package:appfront/view/pages/home/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:appfront/utils/spinkit.dart';

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
                      ? fadingCircle
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
                            charge = false;
                          }
                        }, 'Login', bgColor, mainColor),
                  const Text('or', style: TextStyle(color: textColorSecondary)),
                  _btn(() {
                    navigation(context, const SignUp());
                  }, 'Sign up', textColor, cardColor),
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
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        // Add email format validation
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Entrez une adresse email valide';
        }
        return null;
      },
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: textColor),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: textColorSecondary),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: mainColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: 'Entrer votre email',
        hintStyle: const TextStyle(color: textColorSecondary),
        labelText: 'Email',
        labelStyle: const TextStyle(color: textColorSecondary),
        filled: true,
        fillColor: cardColor,
        prefixIcon: const Icon(Icons.email, color: textColorSecondary),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(fontSize: 16, color: textColor),
    ),
  );
}

Widget _inputPassword(bool vis, TextEditingController controller, fun) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: TextFormField(
      obscureText: vis,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        // Add password strength validation if needed
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: textColorSecondary),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: textColorSecondary),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: mainColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: 'Entrer votre mot de passe',
        hintStyle: const TextStyle(color: textColorSecondary),
        labelText: 'Mot de passe',
        labelStyle: const TextStyle(color: textColorSecondary),
        filled: true,
        fillColor: cardColor,
        prefixIcon: const Icon(Icons.lock, color: textColorSecondary),
        suffixIcon: IconButton(
          color: textColorSecondary,
          onPressed: fun,
          icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(fontSize: 16, color: textColor),
    ),
  );
}

Widget _btn(VoidCallback fun, String txt, Color txtColor, Color bgColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: fun,
        style: ElevatedButton.styleFrom(
          foregroundColor: txtColor,
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          txt,
          style: TextStyle(
            color: txtColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    ),
  );
}
