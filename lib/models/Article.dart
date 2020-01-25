import 'package:calicourse_front/models/Shop.dart';

class Article {
  String    title;
  bool      bought;
  bool      archived;
  DateTime  createdAt;
  DateTime  boughtAt;
  String    comment;
  Shop      shop;

  /// Empty constructor for [Article]
  Article.empty();

  /// All fields constructor for [Article]
  Article.build(this.title, this.bought, this.archived, this.createdAt, this.boughtAt,
      this.comment, this.shop);

  @override
  String toString() {
    return 'Article{title: $title, bought: $bought, archived: $archived, createdAt: $createdAt, boughtAt: $boughtAt, comment: $comment, shop: $shop}';
  }
}