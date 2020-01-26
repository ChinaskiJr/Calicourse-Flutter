import 'package:calicourse_front/helpers/DateTimeHelper.dart';
import 'package:calicourse_front/models/Shop.dart';

class Article {
  int       id;
  String    title;
  bool      bought;
  bool      archived;
  DateTime  createdAt;
  DateTime  boughtAt;
  String    comment;
  Shop      shop;

  /// Empty constructor for [Article]
  Article.empty();

  /// Constructor for brand new [Article]
  Article.create(this.title, this.comment) {
   this.bought    = false;
   this.archived  = false;
   this.createdAt = DateTime.now();
   this.boughtAt  = null;
   this.shop      = null;
  }

  /// All fields constructor for [Article]
  Article.build({this.id, this.title, this.bought, this.archived, this.createdAt,
    this.boughtAt, this.comment, this.shop});

  factory Article.fromJson(Map <String, dynamic> json) {
    return Article.build(
      id:         json['id'],
      title:      json['title'],
      bought:     json['bought'],
      archived:   json['archived'],
      createdAt:  DateTimeHelper.createDateTimeFromApiString(json['createdAt']),
      boughtAt:   (json.containsKey('boughtAt')) ? DateTimeHelper.createDateTimeFromApiString(json['boughtAt']) : null,
      comment:    (json.containsKey('comment')) ? json['comment'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic>json = {};
    json['id']        = this.id;
    json['title']     = this.title;
    json['bought']    = this.bought;
    json['archived']  = this.archived;
    json['createdAt'] = this.createdAt.toString();
    json['boughtAt']  = this.bought ?? null;
    json['comment']   = this.comment ?? null;
    return json;
  }

  @override
  String toString() {
    return 'Article{title: $title, bought: $bought, archived: $archived, createdAt: $createdAt, boughtAt: $boughtAt, comment: $comment, shop: $shop}';
  }
}