import 'dart:io';

import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Article.dart';
import 'package:calicourse_front/models/Shop.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/custom_widgets/ArticleContainer.dart';
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

  static const String header = "La fierté d'avoir le contrôle sur les données de sa liste de courses";

  List<Shop>      shops = [];
  List<Article>   articles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Text(
                header,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: globalFontSize,
                  color: mainColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: FutureBuilder<void>(
                  future: _loadShops(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: shops.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 25.0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ShopContainer(context, shops[index]);
                          }
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.5,
              child: FutureBuilder<void>(
                future: _loadArticles(),
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
                        );
                      }
                    );
                  } else {
                    return CircularProgressIndicator();
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
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
  /// Between the Http call and the building of the [FutureBuilder].
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _loadArticles() async {
    try {
      this.articles = await HttpHelper.getArticles();
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
}