import 'package:calicourse_front/models/Article.dart';
import 'package:calicourse_front/widgets/custom_widgets/forms/ArticleForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UpdateArticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // If we are updating
    Article article = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier un article"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05
        ),
        child: ArticleForm(article: article),
      ),
    );
  }
}