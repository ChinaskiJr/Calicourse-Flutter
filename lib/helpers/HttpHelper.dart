import 'dart:io';

import 'package:calicourse_front/helpers/ApiConnectionException.dart';
import 'package:calicourse_front/models/Article.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:calicourse_front/models/Shop.dart';

class HttpHelper {
  // Dev
  // static const apiBaseUrl = "http://calicourse.192.168.1.35:8080/api/";
  // Prod
  static const apiBaseUrl               = "https://calicourse.robin-colombier.com/api";
  static const apiGetParamShops         = "/shops";
  static const apiGetParamArticles      = "/articles";
  static const apiParamBought           = "bought";
  static const apiParamShop             = "shop";

  static Future<Shop> getShop(String shopId) async {
    dynamic jsonResponse;
    http.Response response = await http.get(apiBaseUrl + apiGetParamShops + '/' + shopId,
      headers: {
        "Accept": "application/json",
        "X-AUTH-TOKEN": await HttpHelper.loadApiKey()
    });
    if (response.statusCode == HttpStatus.ok) {
      jsonResponse = convert.jsonDecode(response.body);
    } else if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.forbidden) {
      throw ApiConnectionException("Veuiller entrer une clé API valide");
    } else {
      throw HttpException("Impossible de récupèrer les données (code HTTP retourné : ${response.statusCode})");
    }
    return Shop.fromJson(jsonResponse);
  }

  /// Performs the GET all shops request to the API
  /// Throws [HttpException] if [response.statusCode] isn't 200
  static Future<List<Shop>> getShops() async {
    dynamic jsonResponse;
    http.Response response = await http.get(apiBaseUrl + apiGetParamShops,
        headers: {
          "Accept": "application/json",
          "X-AUTH-TOKEN": await HttpHelper.loadApiKey()
        });
    if (response.statusCode == HttpStatus.ok) {
      jsonResponse = convert.jsonDecode(response.body);
    } else if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.forbidden) {
      throw ApiConnectionException("Veuiller entrer une clé API valide");
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
    http.Response response = await http.put(apiBaseUrl + apiGetParamShops + '/' + shop.id.toString(),
      headers: {
        "Content-Type": "application/json",
        "X-AUTH-TOKEN": await HttpHelper.loadApiKey()
      },
      body: convert.jsonEncode(jsonShop)
    );
    if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.forbidden) {
      throw ApiConnectionException("Veuiller entrer une clé API valide");
    } else if (response.statusCode != HttpStatus.ok) {
      throw HttpException("Impossible de modifier ce magasin (code HTTP retourné : ${response.statusCode})");
    }
  }

  static Future<void> postShop(Shop shop) async {
    Map<String, dynamic> jsonArticle = shop.toJson();
    http.Response response = await http.post(apiBaseUrl + apiGetParamShops,
      headers: {
        "Content-Type" : "application/json",
        "X-AUTH-TOKEN": await HttpHelper.loadApiKey()
      },
      body:    convert.jsonEncode(jsonArticle)
    );
    if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.forbidden) {
      throw ApiConnectionException("Veuiller entrer une clé API valide");
    } else if (response.statusCode != HttpStatus.created) {
      throw HttpException("Impossible de creéer cet article (code HTTP retourné : ${response.statusCode})");
    }
  }

  /// Performs the GET all articles request to the API
  /// Throws [HttpException] if [response.statusCode] isn't 20O
  static Future<List<Article>> getArticles() async {
    dynamic jsonResponse;
    http.Response response = await http.get(apiBaseUrl + apiGetParamArticles,
      headers: {
        "Accept": "application/json",
        "X-AUTH-TOKEN": await HttpHelper.loadApiKey()
      });
    if (response.statusCode == HttpStatus.ok) {
      jsonResponse = convert.jsonDecode(response.body);
    } else if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.forbidden) {
      throw ApiConnectionException("Veuiller entrer une clé API valide");
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
  static Future<List<Article>> getArticlesByShopAndStatus(String shopId, bool isBought) async {
    dynamic jsonResponse;
    debugPrint(apiBaseUrl + apiGetParamArticles + "?" + apiParamBought + "=" + isBought.toString() + "&" + apiParamShop + "=" + shopId);
    // /api/articles?bought=true&shop=1
    http.Response response = await http.get(apiBaseUrl + apiGetParamArticles + "?" + apiParamBought + "=" + isBought.toString() + "&" + apiParamShop + "=" + shopId,
        headers: {
          "Accept": "application/json",
          "X-AUTH-TOKEN": await HttpHelper.loadApiKey()
        });
    if (response.statusCode == HttpStatus.ok) {
      jsonResponse = convert.jsonDecode(response.body);
    } else if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.forbidden) {
      throw ApiConnectionException("Veuiller entrer une clé API valide");
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
  static Future<dynamic> postArticle(Article article) async {
    Map<String, dynamic> jsonArticle = article.toJson();
    http.Response response = await http.post(apiBaseUrl + apiGetParamArticles,
      headers: {
        "Content-Type" : "application/json",
        "X-AUTH-TOKEN": await HttpHelper.loadApiKey()
      },
      body:    convert.jsonEncode(jsonArticle)
    );
    if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.forbidden) {
      throw ApiConnectionException("Veuiller entrer une clé API valide");
    } else if (response.statusCode != HttpStatus.created) {
      throw HttpException("Impossible de créer cet article (code HTTP retourné : ${response.statusCode})");
    } else {
      dynamic jsonResponse;
      jsonResponse = convert.jsonDecode(response.body);
      Article article = Article.fromJson(jsonResponse);
      return article;
    }
  }
  /// Performs the PUT new article request to the API
  /// Throws [HttpException] if [response.statusCode] isn't 200
  static Future<void> putArticle(Article article) async {
    Map<String, dynamic> jsonArticle = article.toJson();
    http.Response response = await http.put(apiBaseUrl + apiGetParamArticles + '/' + article.id.toString(),
      headers: {
        "Content-Type" : "application/json",
        "X-AUTH-TOKEN": await HttpHelper.loadApiKey()
      },
      body:    convert.jsonEncode(jsonArticle)
    );
    if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.forbidden) {
      throw ApiConnectionException("Veuiller entrer une clé API valide");
    } else if (response.statusCode != HttpStatus.ok) {
      throw HttpException("Impossible de modifier cet article (code HTTP retourné : ${response.statusCode})");
    }
  }
  /// Performs the DELETE article request to the API
  /// Throws [HttpException] if [response.statusCode] isn't 204
  static Future<void> deleteArticle(Article article) async {
    http.Response response = await http.delete(apiBaseUrl + apiGetParamArticles + '/' + article.id.toString(),
      headers: {
        "Content-Type" : "application/json",
        "X-AUTH-TOKEN": await HttpHelper.loadApiKey()
      }
    );
    if (response.statusCode == HttpStatus.unauthorized || response.statusCode == HttpStatus.forbidden) {
      throw ApiConnectionException("Veuiller entrer une clé API valide");
    } else if (response.statusCode != HttpStatus.noContent) {
      throw HttpException("Impossible de modifier cet article (code HTTP retourné : ${response.statusCode})");
    }
  }

  static Future<String> loadApiKey() async {
    final storage = FlutterSecureStorage();

    String apiKey = await storage.read(key: 'calicourse_api_key');
    return apiKey;
  }
}
