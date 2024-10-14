import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';
import 'afficheContact.dart';
import 'createContactPage.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final List<Widget> pages = [
    const AfficheContact(),
    const ContactCreatePage(),
  ];
  int index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _contactBtn(index == 0, Colors.blue, 'Contact', () {
                  setState(() {
                    index = 0;
                  });
                }),
                _contactBtn(index == 1, Colors.blue, 'Add', () {
                  setState(() {
                    index = 1;
                  });
                }),
              ],
            ),
          ),
          Expanded(child: pages[index]),
        ],
      ),
    );
  }
}

Widget _contactBtn(
    bool isSelected, Color color, String text, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? mainColor : Colors.grey,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
