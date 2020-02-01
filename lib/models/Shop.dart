import 'package:calicourse_front/models/Article.dart';

class Shop {
  int             id;
  String          name;
  List<Article>   articles;

  /// Empty constructor for [Shop]
  Shop.empty();

  /// Full fields constructor for [Shop]
  Shop.build({this.id, this.name, this.articles});

  factory Shop.fromJson(Map<String, dynamic> json) {
    List<Article> articlesInstances = [];
    List<dynamic> articlesFromJson = json['articles'];
    for (Map<String, dynamic> articleFromJson in articlesFromJson) {
      articlesInstances.add(Article.fromJson(articleFromJson));
    }
    return Shop.build(
      id:   json['id'],
      name: json['name'],
      articles: articlesInstances
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    json['name'] = this.name;
    List<String> articlesIRIs = [];
    for (Article article in this.articles) {
      articlesIRIs.add(Article.articleIri + article.id.toString());
    }
    json['articles'] = articlesIRIs;
    return json;
  }

  @override
  String toString() {
    return 'Shop{id: $id, name: $name, articles: $articles}';
  }
}