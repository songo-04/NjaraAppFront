// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:appfront/constant/link.dart';
import 'dart:convert';
import 'package:appfront/model/work/delimitation.dart';
import 'package:appfront/utils/spinkit.dart';

class DelimitationStory extends StatefulWidget {
  const DelimitationStory({super.key});

  @override
  State<DelimitationStory> createState() => _DelimitationStoryState();
}

class _DelimitationStoryState extends State<DelimitationStory> {
  bool charge = false;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Logger log = Logger();
  List<DelimitationModel> _delimitationList = [];
  @override
  void initState() {
    super.initState();
    _fetchDelimitation();
  }

  Future<void> _fetchDelimitation() async {
    setState(() {
      charge = true;
    });
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('${urlApi}work/delimitation'),
        headers: {"Authorization": token ?? ''},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.body);
        final List<dynamic> datas = json.decode(response.body);
        setState(() {
          _delimitationList =
              datas.map((data) => DelimitationModel.fromJson(data)).toList();
          charge = false;
        });
      }
    } catch (e) {
      log.e('Error fetching delimitation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: (charge)
                ? Center(child: fadingCircle)
                : ListView.builder(
                    itemCount: _delimitationList.length,
                    itemBuilder: (context, index) {
                      return delimitationStoryItem(_delimitationList[index]);
                    },
                  ),
          ),
          seeMore(),
        ],
      ),
    );
  }
}

Widget delimitationStoryItem(DelimitationModel delimitation) {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date depot dossier :${delimitation.createdAt}',
              style: const TextStyle(fontSize: 14, color: textColorSecondary),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            delimitation.proprietaire,
          ),
        ),
        Text(
          delimitation.contact_proprietaire,
          style: const TextStyle(fontSize: 14, color: textColorSecondary),
        ),
        Text(
          delimitation.proprietaire,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date retour dossier : ${delimitation.updatedAt}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            detailStory(),
          ],
        ),
      ],
    ),
  );
}

Widget seeMore() {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(bottom: 10),
    width: 100,
    height: 40,
    decoration: BoxDecoration(
      color: mainColor,
      borderRadius: BorderRadius.circular(100),
    ),
    child: const Center(child: Text('See more')),
  );
}

Widget detailStory() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Text(
          'Detail',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey[600],
        ),
      ],
    ),
  );
}
