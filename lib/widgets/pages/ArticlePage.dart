import 'dart:io';

import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Article.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/custom_widgets/FatalAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ArticlePageState();
  }
}

class ArticlePageState extends State<ArticlePage>{

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
    Article article = ModalRoute.of(context).settings.arguments;


    _titleFieldConstructor = TextEditingController(
      text: (article != null) ? article.title : ''
    );
    _commentFieldConstructor = TextEditingController(
      text: (article != null) ? article.comment : ''
    );
    return Scaffold(
      appBar: AppBar(
        title: (article != null)
        ? Text("Modifier un article")
        : Text("Ajouter un article"),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportContraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportContraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          child: Row(
                            mainAxisAlignment: (article == null)
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              (article != null)
                                ? RaisedButton(
                                color: Colors.red,
                                splashColor: Colors.white,
                                onPressed: () async {
                                  await _processDeleteArticle(article);
                                  // True cause we need to refresh the page
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  'Supprimer',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              )
                                : Container(),
                              RaisedButton(
                                child: Text(
                                  (article == null) ? 'Ajouter' : 'Modifier',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                color: mainColor,
                                splashColor: Colors.white,
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    if (article == null) {
                                      // New article
                                      Article newArticle = Article.create(
                                        _titleFieldConstructor.text,
                                        _commentFieldConstructor.text
                                      );
                                      await _processAddArticle(newArticle);
                                    } else {
                                      // Update Article
                                      article.title = _titleFieldConstructor.text;
                                      article.comment = _commentFieldConstructor.text;
                                      await _processPutArticle(article);
                                    }
                                    // False cause no need to refresh the page
                                    Navigator.of(context).pop(false);
                                  }
                                },
                              ),
                            ],
                          )
                        )
                      ],
                    )
                  ),
                ),
              ),
            ),
          );
        },
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
  /// Between the Http call and the Navigator.pop.
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _processDeleteArticle(Article article) async {
    try {
      await HttpHelper.deleteArticle(article);
    } on HttpException catch (exception, stacktrace) {
      print(stacktrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
}