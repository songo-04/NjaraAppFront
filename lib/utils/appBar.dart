// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

class AppBarUtils extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarUtils({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(color: textColor)),
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: textColor),
        onPressed: () => Navigator.of(context).pop(),
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: textColorSecondary),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.only(left: 8),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: textColor),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Information'),
                content: Text(
                    'Remplissez tous les champs pour ajouter un nouveau $title'),
                actions: [
                  TextButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(color: mainColor),
                    ),
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
