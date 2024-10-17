// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:appfront/controller/auth/auth.dart';
import 'package:appfront/controller/navigation/navigationBuilder.dart';
import 'package:appfront/view/pages/auth/login.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _globalKey = GlobalKey<FormState>();
  Auth auth = Auth();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
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
              'Create a new account',
              style: TextStyle(
                color: inversColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _globalKey,
              child: Column(
                children: [
                  _input('User name', _userNameController, icon: Icons.person),
                  _input('Email', _userEmailController,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email),
                  _input('Password', _userPasswordController,
                      isPassword: true, icon: Icons.lock),
                  charge
                      ? const CircularProgressIndicator()
                      : _btn(() {
                          if (_globalKey.currentState!.validate()) {
                            setState(() {
                              charge = true;
                            });
                            Map<String, String> data = {
                              'user_name': _userNameController.text,
                              'user_email': _userEmailController.text,
                              'user_password': _userPasswordController.text
                            };
                            debugPrint(data.toString());
                            auth.signup(data);
                            setState(() {
                              charge = false;
                            });
                            navigation(context, const Login());
                          }
                        }, 'Sign Up', bgColor, mainColor),
                  const Text('or', style: TextStyle(color: textColorSecondary)),
                  _btn(() {
                    navigation(context, const Login());
                  }, 'Login', textColor, cardColor),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _input(
  String hintText,
  TextEditingController controller, {
  bool isPassword = false,
  TextInputType keyboardType = TextInputType.text,
  IconData? icon,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 24, left: 24, top: 20),
    child: TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is empty';
        }
        return null;
      },
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
        hintText: hintText,
        hintStyle: const TextStyle(color: textColorSecondary),
        labelText: hintText,
        labelStyle: const TextStyle(color: textColorSecondary),
        filled: true,
        fillColor: cardColor,
        prefixIcon: icon != null ? Icon(icon, color: textColorSecondary) : null,
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
