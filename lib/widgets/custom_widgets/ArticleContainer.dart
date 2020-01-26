import 'package:calicourse_front/models/Article.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:flutter/material.dart';

class ArticleContainer extends Container {
  ArticleContainer(BuildContext context, Article article): super(
    width: MediaQuery.of(context).size.width * 0.6,
    height: MediaQuery.of(context).size.height * 0.075,
    padding: EdgeInsets.all(15.0),
    margin: EdgeInsets.symmetric(
        vertical: 5.0,
    ),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border.all(
          width: 5.0,
          color: secondaryColor
      ),
      borderRadius: BorderRadius.circular(12),
      color: mainColor,
    ),
    child: Material(
      type: MaterialType.transparency,
      child: Text(
        article.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: globalFontSize,
          fontStyle: FontStyle.italic,
          color: secondaryColor
        ),
      ),
    ),
  );
}