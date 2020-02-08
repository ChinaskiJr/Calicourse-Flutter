import 'dart:io';

import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Article.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/custom_widgets/FatalAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleForm extends StatefulWidget {
  Article article;

  @override
  State<StatefulWidget> createState() {
    return ArticleFormState();
  }

  ArticleForm({article: Article}) {
    this.article = article;
  }
}

class ArticleFormState extends State<ArticleForm>{

  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleFieldConstructor;
  TextEditingController _commentFieldConstructor;

  @override
  void dispose() {
    _titleFieldConstructor.dispose();
    _commentFieldConstructor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _titleFieldConstructor = TextEditingController(
      text: (widget.article != null) ? widget.article.title : ''
    );
    _commentFieldConstructor = TextEditingController(
      text: (widget.article != null) ? widget.article.comment : ''
    );
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _titleFieldConstructor,
            decoration: const InputDecoration(
              icon: const Icon(Icons.create),
              hintText: "ex: Veggies",
              labelText: "Nom de l'article"
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Ce champ est obligatoire';
              } else {
                return null;
              }
            },
          ),
          TextFormField(
            controller: _commentFieldConstructor,
            decoration: const InputDecoration(
              icon: const Icon(Icons.description),
              hintText: "ex: Fais attention, ils ont été changé de rayon ! <3",
              labelText: "Description",
              alignLabelWithHint: true
            ),
            maxLines: 6,
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: RaisedButton(
              child: Text(
                (widget.article == null) ? 'Ajouter' : 'Modifier',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              color: mainColor,
              splashColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  // New Article ?
                  if (widget.article == null) {
                    Article article = Article.create(
                      _titleFieldConstructor.text,
                      _commentFieldConstructor.text
                    );
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Traitement en cours...")
                      )
                    );
                    await _processAddArticle(article);
                  } else {
                    Article article = widget.article;
                    article.title = _titleFieldConstructor.text;
                    article.comment = _commentFieldConstructor.text;
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Traitement en cours...")
                      )
                    );
                    await _processPutArticle(article);
                  }

                  Navigator.pop(context);
                }
              },
            ),
          )
        ],
      )
    );
  }
  /// Between the Http call and the Navigator.pop.
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _processAddArticle(Article article) async {
    try {
      await HttpHelper.postArticle(article);
    } on HttpException catch (exception, stacktrace) {
      print(stacktrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
  /// Between the Http call and the Navigator.pop.
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _processPutArticle(Article article) async {
    try {
      await HttpHelper.putArticle(article);
    } on HttpException catch (exception, stacktrace) {
      print(stacktrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
}