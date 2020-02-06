import 'dart:io';

import 'package:calicourse_front/models/Article.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:calicourse_front/models/Shop.dart';

class HttpHelper {
  static const apiBaseUrl               = "http://192.168.1.35:8080/calicourse/api";
  static const apiParamGetAllShops      = "/shops";
  static const apiParamGetAShop         = "/shops/";
  static const apiParamPutShop          = "/shops";
  static const apiParamGetAllArticles   = "/articles";
  static const apiParamPostArticle      = "/articles";
  static const apiParamPutArticle       = "/articles";

  static Future<Shop> getShop(String shopId) async {
    dynamic jsonResponse;
    http.Response response = await http.get(apiBaseUrl + apiParamGetAShop + shopId,
      headers: {"Accept": "application/json"});
    if (response.statusCode == HttpStatus.ok) {
      jsonResponse = convert.jsonDecode(response.body);
    } else {
      throw HttpException("Impossible de récupèrer les données (code HTTP retourné : ${response.statusCode})");
    }
    return Shop.fromJson(jsonResponse);
  }

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
  /// Performs the PUT a shop request to the API
  /// Throws [HttpException] if [response.statusCode] isn't 20O
  static Future<void> putShop(Shop shop) async {
    Map<String, dynamic> jsonShop = shop.toJson();
    http.Response response = await http.put(apiBaseUrl + apiParamPutShop + '/' + shop.id.toString(),
      headers: {"Content-Type": "application/json"},
      body: convert.jsonEncode(jsonShop)
    );
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException("Impossible de modifier cet article (code HTTP retourné : ${response.statusCode})");
    }
  }
  /// Performs the GET all articles request to the API
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
  /// Performs the POST new article request to the API
  /// Throws [HttpException] if [response.statusCode] isn't 201
  static Future<void> postArticle(Article article) async {
    Map<String, dynamic> jsonArticle = article.toJson();
    http.Response response = await http.post(apiBaseUrl + apiParamPostArticle,
      headers: {"Content-Type" : "application/json"},
      body:    convert.jsonEncode(jsonArticle)
    );
    if (response.statusCode != HttpStatus.created) {
      throw HttpException("Impossible de creéer cet article (code HTTP retourné : ${response.statusCode})");
    }
  }
  /// Performs the PUT new article request to the API
  /// Throws [HttpException] if [response.statusCode] isn't 200
  static Future<void> putArticle(Article article) async {
    Map<String, dynamic> jsonArticle = article.toJson();
    http.Response response = await http.put(apiBaseUrl + apiParamPutArticle + '/' + article.id.toString(),
      headers: {"Content-Type" : "application/json"},
      body:    convert.jsonEncode(jsonArticle)
    );
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException("Impossible de modifier cet article (code HTTP retourné : ${response.statusCode})");
    }
  }
}
