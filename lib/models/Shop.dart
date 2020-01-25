import 'package:calicourse_front/models/Article.dart';

class Shop {
  String          name;
  List<Article>   articles;

  /// Empty constructor for [Shop]
  Shop.empty();

  /// Full fields constructor for [Shop]
  Shop.build(this.name, this.articles);

  @override
  String toString() {
    return 'Shop{name: $name, articles: $articles}';
  }
}