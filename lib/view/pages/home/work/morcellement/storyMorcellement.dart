// ignore_for_file: file_names

import 'package:appfront/constant/color.dart';
import 'package:appfront/constant/link.dart';
import 'package:appfront/model/work/morcellement.dart';
import 'package:appfront/utils/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoryMorcellement extends StatefulWidget {
  const StoryMorcellement({super.key});

  @override
  State<StoryMorcellement> createState() => _StoryMorcellementState();
}

class _StoryMorcellementState extends State<StoryMorcellement> {
  bool charge = false;
  List<Morcellement> _morcellementList = [];
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  Logger log = Logger();

  @override
  void initState() {
    super.initState();
    _fetchMorcellement();
  }

  Future<void> _fetchMorcellement() async {
    setState(() {
      charge = true;
    });
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(Uri.parse('${urlApi}work/morcellement'),
          headers: {'Authorization': token ?? ''});
      if (response.statusCode == 200) {
        final List<dynamic> datas = json.decode(response.body);
        setState(() {
          _morcellementList =
              datas.map((e) => Morcellement.fromJson(e)).toList();
          charge = false;
        });
      } else {
        log.e('Error fetching morcellement data: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error fetching morcellement data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: (charge)
              ? Center(child: fadingCircle)
              : ListView.builder(
                  itemCount: _morcellementList.length,
                  itemBuilder: (context, index) {
                    return _itemStory(_morcellementList[index]);
                  },
                ),
        ),
        (charge) ? const SizedBox.shrink() : _seeMore(),
      ],
    );
  }

  Widget _itemStory(Morcellement morcellement) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('date reception: ${morcellement.date_reception}'),
          const SizedBox(height: 5),
          Row(
            children: [
              Text('parcelle: ${morcellement.numero_parcelle}'),
              Text('Propriétaire: ${morcellement.proprietaire}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('date livraison: ${morcellement.date_livraison}'),
              voirPlus(),
            ],
          ),
        ],
      ),
    );
  }

  Widget voirPlus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: mainColor),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Voir plus'),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_forward_ios,
            color: mainColor,
            size: 12,
          ),
        ],
      ),
    );
  }

  Widget _seeMore() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: const Text('See More'),
    );
  }
}
