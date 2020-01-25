import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:calicourse_front/models/Shop.dart';

class HttpHelper {
  static const apiBaseUrl = "http://192.168.1.35:8080/calicourse/api";
  static const ApiParamGetAllShops = "/shops";

  /// Performs the GET all shops request to the API
  /// Throws [HttpException] if statusCode isn't 200
  static Future<List<Shop>> getShops() async {
    dynamic jsonResponse;
    http.Response response = await http.get(apiBaseUrl + ApiParamGetAllShops,
        headers: {"Accept": "application/json"});
    if (response.statusCode == HttpStatus.ok) {
      jsonResponse = convert.jsonDecode(response.body);
    } else {
      throw HttpException("Impossible de récupèrer les données (code HTTP retourné : ${response.statusCode})");
    }
    List<Shop> shops = [];
    for (Map map in jsonResponse) {
      Shop shop = Shop.fromJson(map);
      shops.add(shop);
    }
    return shops;
  }
}
