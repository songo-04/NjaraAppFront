
// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

class AppBarUtils extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarUtils({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        backgroundColor: mainColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show info dialog or navigate to help page
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Information'),
                  content: const Text('Remplissez tous les champs pour ajouter un nouveau morcellement.'),
                  actions: [
                    TextButton(
                      child: const Text('OK',style: TextStyle(color: mainColor),),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}