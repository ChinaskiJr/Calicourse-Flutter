import 'package:calicourse_front/models/Article.dart';

class Shop {
  int             id;
  String          name;
  List<Article>  articles;

  /// Empty constructor for [Shop]
  Shop.empty();

  /// Full fields constructor for [Shop]
  Shop.build({this.id, this.name});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop.build(
        id:   json['id'],
        name: json['name'],
    );
  }

  @override
  String toString() {
    return 'Shop{id: $id, name: $name, articles: $articles}';
  }
}