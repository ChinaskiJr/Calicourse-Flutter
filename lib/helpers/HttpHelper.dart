import 'dart:io';

import 'package:calicourse_front/models/Article.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:calicourse_front/models/Shop.dart';

class HttpHelper {
  static const apiBaseUrl               = "http://192.168.1.35:8080/calicourse/api";
  static const apiParamGetAllShops      = "/shops";
  static const apiParamGetAllArticles   = "/articles";

  /// Performs the GET all shops request to the API
  /// Throws [HttpException] if [response.statusCode] isn't 200
  static Future<List<Shop>> getShops() async {
    dynamic jsonResponse;
    http.Response response = await http.get(apiBaseUrl + apiParamGetAllShops,
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
  /// Performs the GET all articles requests to the API
  /// Throws [HttpException] if [response.statusCode] isn't 20O
  static Future<List<Article>> getArticles() async {
    dynamic jsonResponse;
    http.Response response = await http.get(apiBaseUrl + apiParamGetAllArticles,
      headers: {"Accept": "application/json"});
    if (response.statusCode == HttpStatus.ok) {
      jsonResponse = convert.jsonDecode(response.body);
    } else {
      throw HttpException("Impossible de récupèrer les données (code HTTP retourné : ${response.statusCode})");
    }
    List<Article> articles = [];
    for (Map map in jsonResponse) {
      Article article = Article.fromJson(map);
      articles.add(article);
    }
    return articles;
  }
}
