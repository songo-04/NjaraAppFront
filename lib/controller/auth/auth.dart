import 'dart:convert';
import 'package:appfront/constant/link.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  String baseUrl = 'http://127.0.0.1:8080/njarapi/user/';

  Logger log = Logger();
  final _storage = const FlutterSecureStorage();
  Future<http.Response> login(Map<String, String> body) async {
    var request = await http.post(
      Uri.parse('${urlApi}user/signin'),
      headers: {"Content-type": "application/json"},
      body: json.encode(body),
    );
    return request;
  }

  Future<dynamic> signup(Map<String, String> body) async {
    var request = await http.post(
      Uri.parse('${urlApi}user/signup'),
      headers: {"Content-type": "application/json"},
      body: json.encode(body),
    );
    if (request.statusCode == 200 || request.statusCode == 201) {
      log.i(request.body);
      return request;
    }
    log.d(request.body);
    log.d(request.statusCode);
  }

  Future<dynamic> checkUser() async {
    try {
      var token = await _storage.read(key: 'token');

      Logger log = Logger();
      log.i(token.toString());
      var response = await http.get(
        Uri.parse('${urlApi}user/checkuser'),
        headers: {"authorization": token.toString()},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.body);
        return response;
      } else {
        return response;
      }
    } catch (error) {
      log.e(error);
    }
  }
}

//  Future<dynamic> post(Map<String, String> body) async {
//     String url = 'signup';
//     var request = await http.post(
//       Uri.parse(baseUrl + url),
//       headers: {"Content-type": "application/json"},
//       body: json.encode(body),
//     );
//     if (request.statusCode == 200 || request.statusCode == 201) {
//       log.i(request.body);
//       return request;
//     }
//     log.d(request.body);
//     log.d(request.statusCode);
//   }
// }
