// ignore_for_file: file_names

import 'package:flutter/material.dart';

navigation(BuildContext context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

navigationReplace(BuildContext context, widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}
