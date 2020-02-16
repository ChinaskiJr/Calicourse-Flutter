import 'dart:convert';

import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {};

  // Singleton design pattern
  static final Session _session = Session._internal();
  factory Session() {
    return _session;
  }
  Session._internal();

  /// GET requests
  Future<Map> get(String url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }
  /// POST requests
  Future<Map> post(String url, {dynamic body}) async {
    http.Response response = await http.post(url, body: body, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }
  /// PUT requests
  Future<Map> put(String url, {dynamic body}) async {
   http.Response response = await http.put(url, body: body, headers: headers);
   updateCookie(response);
   return json.decode(response.body);
  }
  /// DELETE requests
  Future <Map> delete(String url) async {
    http.Response response = await http.delete(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  void updateCookie(http.Response response) {
    String cookie = response.headers['set-cookie'];
    if (cookie != null) {
      int index = cookie.indexOf(';');
      headers['cookie'] = (index == -1) ? cookie : cookie.substring(0, index);
    }
  }
}