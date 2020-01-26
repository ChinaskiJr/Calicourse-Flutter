import 'package:calicourse_front/widgets/custom_widgets/forms/ArticleForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddArticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un article"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05
      ),
      child: ArticleForm(),
      ),
    );
  }
}