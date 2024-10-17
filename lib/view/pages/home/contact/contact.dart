import 'package:flutter/material.dart';
import 'afficheContact.dart';
import 'createContactPage.dart';
import 'package:appfront/constant/color.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContactCreatePage()));
                    },
                    icon: const Icon(Icons.add, color: textColor))
              ],
            ),
          ),
          const Expanded(
            child: AfficheContact(),
          ),
        ],
      ),
    );
  }
}
