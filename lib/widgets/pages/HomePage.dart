import 'dart:io';

import 'package:calicourse_front/helpers/ApiConnectionException.dart';
import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Article.dart';
import 'package:calicourse_front/models/Shop.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/custom_widgets/ArticleContainer.dart';
import 'package:calicourse_front/widgets/custom_widgets/CustomAlertDialog.dart';
import 'package:calicourse_front/widgets/custom_widgets/FatalAlertDialog.dart';
import 'package:calicourse_front/widgets/custom_widgets/ShopContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Shop>      shops = [];
  List<Article>   articles = [];

  bool connectionFailed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/param'),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: FutureBuilder<void>(
                  future: _loadShops(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: shops.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/showShop',
                                    arguments: this.shops[index].id.toString()
                                  );
                                },
                                child: DragTarget(
                                  builder: (context, List<String> candidateData, rejectedData) {
                                    return ShopContainer(context, shops[index]);
                                  },
                                  onWillAccept: (data) => true,
                                  onAccept: (data) async {
                                    // Data is the id of the article dropped
                                    Article articleDropped =
                                    articles.firstWhere((Article article) {
                                      return article.id.toString() == data;
                                    });
                                    shops[index].articles.add(articleDropped);
                                    await _processPutShop(shops[index]);
                                    setState(() {
                                      articles.removeWhere((Article article) {
                                        return article.id == articleDropped.id;
                                      });
                                      print(articles);
                                    });
                                  }
                                ),
                              );
                            }
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.5,
              child: FutureBuilder<void>(
                future: _loadArticlesWithNoShop(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: articles.length,
                      itemBuilder: (BuildContext context, int index) {
                        ArticleContainer articleContainer = ArticleContainer(context, articles[index]);
                        return Draggable(
                          child: articleContainer,
                          feedback: articleContainer,
                          childWhenDragging: Container(
                              height: MediaQuery.of(context).size.height * 0.065 + 10
                          ),
                          data: articles[index].id.toString(),
                        );
                      }
                    );
                  } else {
                    return SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.075
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: secondaryColor,
              child: Icon(
                  Icons.add_location
              ),
              onPressed: () => Navigator.pushNamed(context, '/addShop'),
              heroTag: "addShop",
            ),
            FloatingActionButton(
              backgroundColor: mainColor,
              child: Icon(
                  Icons.add_shopping_cart
              ),
              onPressed: () => Navigator.pushNamed(context, '/addArticle'),
              heroTag: "addArticle",
            ),
          ],
        ),
      )
    );
  }

  /// Between the Http call and the building of the [FutureBuilder].
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _loadShops() async {
    try {
      this.shops = await HttpHelper.getShops();
    } on ApiConnectionException catch(exception) {
      if (!connectionFailed) {
        connectionFailed = true;
        CustomAlertDialog.showError(exception.message, context);
      }
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
  /// Between the Http call and the building of the [FutureBuilder].
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _loadArticlesWithNoShop() async {
    try {
      List<Article> allArticles = await HttpHelper.getArticles();
      this.articles = allArticles.where((Article article) {
        return article.shop == null;
      }).toList();
    } on ApiConnectionException catch(exception) {
      if (!connectionFailed) {
        connectionFailed = true;
        CustomAlertDialog.showError(exception.message, context);
      }
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
  /// Between the Http call and the refresh of the [FutureBuilder].
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _processPutShop(Shop shop) async {
    try {
      await HttpHelper.putShop(shop);
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
}