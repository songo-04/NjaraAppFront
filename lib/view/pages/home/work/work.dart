import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';
import 'delimitation/delimitation.dart';

class Work extends StatelessWidget {
  Work({super.key});
  final List<Color> colors = [
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.red
  ];
  final List<Widget> pages = [
    const Delimitation(),
    const Delimitation(),
    const Delimitation(),
    const Delimitation(),
  ];
  final List<String> titles = ['Delimitation', 'Title 2', 'Title 3', 'Title 4'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: bgColor,
      child: GridView.builder(
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return workItem(context, colors[index], pages[index], titles[index]);
        },
      ),
    );
  }
}

Widget workItem(BuildContext context, Color color, Widget page, String title) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: inversColor),
        ),
      ),
    ),
  );
}
