import 'package:appfront/constant/link.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String urlBase = urlApi;
  var log = Logger();
  Future<dynamic> get(String url) async {
    var response = await http.get(Uri.parse(urlBase+url));
    log.i(response.body);
    log.i(response.statusCode);
  }
}
