import 'package:calicourse_front/helpers/DateTimeHelper.dart';
import 'package:calicourse_front/models/Shop.dart';

class Article {
  static const articleIri = '/api/articles/';

  int id;
  String title;
  bool bought;
  bool archived;
  DateTime createdAt;
  DateTime boughtAt;
  String comment;
  String image;
  Shop shop;

  /// Empty constructor for [Article]
  Article.empty();

  /// Constructor for brand new [Article]
  Article.create(this.title, this.comment) {
    this.bought = false;
    this.archived = false;
    this.createdAt = DateTime.now();
    this.boughtAt = null;
    this.image = null;
    this.shop = null;
  }

  /// All fields constructor for [Article]
  Article.build(
      {this.id,
      this.title,
      this.bought,
      this.archived,
      this.createdAt,
      this.boughtAt,
      this.comment,
      this.image,
      this.shop});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article.build(
        id: json['id'],
        title: json['title'],
        bought: json['bought'],
        archived: json['archived'],
        createdAt:
            DateTimeHelper.createDateTimeFromApiString(json['createdAt']),
        boughtAt: (json.containsKey('boughtAt') && json['boughtAt'] != null)
            ? DateTimeHelper.createDateTimeFromApiString(json['boughtAt'])
            : null,
        comment: (json.containsKey('comment')) ? json['comment'] : null,
        image: (json.containsKey('image')) ? json['image'] : null,
        shop: (json.containsKey('shop') && json['shop'] != null)
            ? Shop.build(id: json['shop']['id'], name: json['shop']['name'])
            : null);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = this.id;
    json['title'] = this.title;
    json['bought'] = this.bought;
    json['archived'] = this.archived;
    json['createdAt'] = this.createdAt.toString();
    if (this.boughtAt != null) {
      json['boughtAt'] = this.boughtAt.toString();
    }
    json['image'] = this.image ?? null;
    json['comment'] = this.comment ?? null;
    return json;
  }

  @override
  String toString() {
    return 'Article{id: $id, title: $title, bought: $bought, archived: $archived, createdAt: $createdAt, boughtAt: $boughtAt, comment: $comment, image: $image, shop: $shop}';
  }
}
