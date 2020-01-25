import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:calicourse_front/models/Shop.dart';

class HttpHelper {
  static const API_URL = "http://192.168.1.35:8080/calicourse/api";
  static const API_GET_ALL_SHOPS = "/shops";

  /// Performs the GET all shops request to the API
  /// Throws [HttpException] if statusCode isn't 200
  Future<List<Shop>> getShops() async {
    http.Response response = await http.get(API_URL + API_GET_ALL_SHOPS,
        headers: {"Accept": "application/json"});
    if (response.statusCode == HttpStatus.ok) {
      dynamic jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
    } else {
      throw HttpException("Impossible de récupèrer les données (code HTTP retourné : ${response.statusCode})");
    }
    List<Shop> shops = List<Shop>();
    return shops;
  }
}
