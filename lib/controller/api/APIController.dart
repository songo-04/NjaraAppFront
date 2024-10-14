// ignore_for_file: file_names

import 'dart:convert';
import 'package:appfront/constant/link.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
class APIController {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  Logger log = Logger();
  Future<dynamic> create(Map<dynamic, dynamic> body,String path) async {
    var token = await storage.read(key: 'token');
    var request = await http.post(
      Uri.parse('$urlApi$path'),
      headers: {
        "Authorization": token.toString(),
        "Content-type": "application/json"
      },
      body: json.encode(body),
    );
    if (request.statusCode == 200 || request.statusCode == 201) {
      log.i(request.body);
      return request;
    }else{
      return false;
    }
  }
}
