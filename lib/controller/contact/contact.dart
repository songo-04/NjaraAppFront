import 'dart:convert';
import 'package:appfront/constant/link.dart';
import 'package:appfront/model/contact/contact.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

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
    }
  }

  Future<dynamic> get() async {
    
    var token = await storage.read(key: 'token');
    var response = await http.get(
      Uri.parse('${urlApi}contact'),
      headers: {
        "Authorization": token.toString(),
        "Content-type": "application/json"
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      List<dynamic> datas = json.decode(response.body);
     List<ContactModel> contactLists=datas.map((data)=>ContactModel.fromJson(data)).toList();
     return contactLists; 
    }
  }
}
