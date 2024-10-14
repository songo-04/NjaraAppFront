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
                  _input('User name', _userNameController),
                  _input('Email', _userEmailController),
                  _input('Password', _userPasswordController),
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
                  const Text('or'),
                  _btn(() {
                    navigation(context, const Login());
                  }, 'Login', inversColor, inversColor2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _input(String hintText, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(right: 24, left: 24, top: 20),
    child: TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is empty';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: hintText,
        filled: true,
        fillColor: inversColor2,
        suffixIconColor: inversColor,
      ),
    ),
  );
}

Widget _btn(fun, String txt, Color txtColor, Color bgColor) {
  return InkWell(
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
