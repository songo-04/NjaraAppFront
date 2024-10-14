// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';

class EngineStoryPage extends StatefulWidget {
  const EngineStoryPage({super.key});

  @override
  State<EngineStoryPage> createState() => _EngineStoryPageState();
}

class _EngineStoryPageState extends State<EngineStoryPage> {
  bool isGrid = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: double.infinity,
      color: bgColor,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isGrid = !isGrid;
                    });
                  },
                  icon: Icon((isGrid) ? Icons.menu : Icons.grid_view_outlined),
                ),
              ],
            ),
          ),
          Expanded(
            child: (isGrid)
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                    ),
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return _gridCard();
                    },
                  )
                : ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return _listCard();
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget _gridCard() {
    return GestureDetector(
      child: Card(
        elevation: 4,
        color: bgColor,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: const Text('grid view'),
        ),
      ),
    );
  }

  Widget _listCard() {
    return GestureDetector(
      child: Card(
        color: bgColor,
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(6),
          width: double.infinity,
          height: 100,
          child: const Text('list view'),
        ),
      ),
    );
  }
}
