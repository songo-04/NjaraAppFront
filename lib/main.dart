import 'package:appfront/view/pages/leadingPage/leadingPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          primary: Colors.amber,
          secondary: Colors.black,
          seedColor: Colors.amber,
        ),
        useMaterial3: true,
      ),
      home: const LeadingPage(),
    );
  }
}
