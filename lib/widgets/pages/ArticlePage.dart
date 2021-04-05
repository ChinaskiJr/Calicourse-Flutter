import 'dart:io';

import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Article.dart';
import 'package:calicourse_front/models/Shop.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/custom_widgets/FatalAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArticlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ArticlePageState();
  }
}

class ArticlePageState extends State<ArticlePage> {
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  File _image;

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
    Article article;
    Shop shop;
    if (ModalRoute.of(context).settings.arguments.runtimeType == Article) {
      article = ModalRoute.of(context).settings.arguments;
    }
    if (ModalRoute.of(context).settings.arguments.runtimeType == Shop) {
      shop = ModalRoute.of(context).settings.arguments;
    }

    _titleFieldConstructor =
        TextEditingController(text: (article != null) ? article.title : '');
    _commentFieldConstructor =
        TextEditingController(text: (article != null) ? article.comment : '');

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
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            (article != null)
                            ? article.image == null
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    RaisedButton.icon(
                                        onPressed: () {
                                          _takePicture(article);
                                        },
                                        icon: Icon(Icons.camera_enhance_rounded),
                                        label: Text("Photo")),
                                  RaisedButton.icon(
                                        onPressed: () {
                                          _takePicture(article, fromCamera: false);
                                        },
                                        icon: Icon(Icons.folder),
                                        label: Text("Gallerie")),

                                  ],
                                )
                                : Column(
                                  children: [
                                    FutureBuilder(
                                        future: _loadImage(article.image),
                                        builder: (ctx, snapshot) {
                                          if (!snapshot.hasData) {
                                            return CircularProgressIndicator();
                                          } else {
                                            return Image.network(snapshot.data);
                                          }
                                        }),
                                    RaisedButton.icon(onPressed: () {
                                      _deletePicture(article);
                                    }, icon: Icon(Icons.delete),
                                      label: Text("Supprimer la photo"),
                                      color: Colors.red,
                                      splashColor: Colors.white,
                                      textColor: Colors.white,
                                    ),

                                  ],
                                )
                                 : Container(),
                            TextFormField(
                              controller: _titleFieldConstructor,
                              decoration: const InputDecoration(
                                  icon: const Icon(Icons.create),
                                  hintText: "ex: Veggies",
                                  labelText: "Nom de l'article"),
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
                                  hintText:
                                      "ex: Fais attention, ils ont été changé de rayon ! <3",
                                  labelText: "Description",
                                  alignLabelWithHint: true),
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
                                              await _processDeleteArticle(
                                                  article);
                                              // True cause we need to refresh the page
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text(
                                              'Supprimer',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : Container(),
                                    RaisedButton(
                                      child: Text(
                                        (article == null)
                                            ? 'Ajouter'
                                            : 'Modifier',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: mainColor,
                                      splashColor: Colors.white,
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          if (article == null) {
                                            // New article
                                            Article newArticle = Article.create(
                                                _titleFieldConstructor.text,
                                                _commentFieldConstructor.text);
                                            Article articledCreated =
                                                await _processAddArticle(
                                                    newArticle);
                                            // Do we have a shop to link ?
                                            if (shop != null) {
                                              shop.articles
                                                  .add(articledCreated);
                                              await _processPutShop(shop);
                                            }
                                          } else {
                                            // Update Article
                                            article.title =
                                                _titleFieldConstructor.text;
                                            article.comment =
                                                _commentFieldConstructor.text;
                                            await _processPutArticle(article);
                                          }
                                          // False cause no need to refresh the page
                                          Navigator.of(context).pop(false);
                                        }
                                      },
                                    ),
                                  ],
                                ))
                          ],
                        )),
                  ),
                ),
              ),
            );
          },
        ));
  }

  /// Between the Http call and the Navigator.pop.
  /// Purpose of this function is to properly manage the [HttpException]
  Future<dynamic> _processAddArticle(Article article) async {
    try {
      Article articleCreated = await HttpHelper.postArticle(article);
      return articleCreated;
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

  /// Between the Http call and the refresh of the [FutureBuilder].
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _processPutShop(Shop shop) async {
    try {
      await HttpHelper.putShop(shop);
    } on HttpException catch (exception, stackTrace) {
      print(stackTrace);
      print(exception.message);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }

  Future<void> _takePicture(Article article, { bool fromCamera = true }) async {
    final pickedFile = await _picker.getImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      int imageId = await HttpHelper.postPicture(File(pickedFile.path));
      article.image = '/api/media_objects/' + imageId.toString();
      await HttpHelper.putArticle(article);
    }
    setState(() {});
  }

  Future<void> _loadImage(String imageUri) async {
    String uri = await HttpHelper.getPicture(imageUri);
    if (kDebugMode) {
      return "http://10.0.2.2:3000/" + uri;
    } else {
      return "https://calicourse.robin-colombier.com/" + uri;
    }
  }

  Future<void> _deletePicture(Article article) async {
    article.image = null;
    await this._processPutArticle(article);
    setState(() {});
  }
}
