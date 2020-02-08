import 'dart:io';

import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Article.dart';
import 'package:calicourse_front/models/Shop.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/custom_widgets/FatalAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShopPageState();
  }
}

class _ShopPageState extends State<ShopPage> {

  Shop shop = Shop.empty();
  List<bool> displayCommentPressed  = [];
  List<IconData> trailingIcons      = [];

  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments;

    if (shop.id == null) {
      _loadShop(shopId);
    }
    return Scaffold(
      appBar: AppBar(
        title: (shop.id == null) ? CircularProgressIndicator() : Text(shop.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 7.5),
                    child: Text(
                      "À acheter",
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: (shop.articles == null) ? 0 : shop.articles.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      displayCommentPressed.add(false);
                      trailingIcons.add(Icons.keyboard_arrow_down);
                      // ARTICLES TO BUY
                      if (!shop.articles[index].bought) {
                        return Dismissible(
                          key: ValueKey('article_' + shop.articles[index].id.toString()),
                          background: Card(
                            color: Color.fromARGB(255, 0, 156, 122),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 35.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            )
                          ),
                          onDismissed: (DismissDirection direction) async {
                            setState(() {
                              shop.articles[index].bought = true;
                            });
                            await _processPutArticle(shop.articles[index]);
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      shop.articles[index].title
                                    ),
                                    onLongPress: () async {
                                      bool refresh = await _updateArticleWidget(shop.articles[index]);
                                      if (refresh) {
                                        setState(() {
                                          _loadShop(shopId);
                                        });
                                      }
                                    },
                                    trailing: (shop.articles[index].comment.isNotEmpty)
                                      ? IconButton(
                                      icon: Icon(trailingIcons[index]),
                                      onPressed: () {
                                        setState(() {
                                          if (displayCommentPressed[index] == true) {
                                            displayCommentPressed[index] = false;
                                            trailingIcons[index] = Icons.keyboard_arrow_down;
                                          } else {
                                            displayCommentPressed[index] = true;
                                            trailingIcons[index] = Icons.keyboard_arrow_up;
                                          }
                                        });
                                      })
                                      : null,
                                  ),
                                  (displayCommentPressed[index])
                                    ? Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text(shop.articles[index].comment),
                                  )
                                    : Container()
                                ],
                              ),
                            )
                          )
                        );
                      } else {
                        return Container();
                      }
                    })
                ],
              )
            ),
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text(
                      "Acheté",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: 7.5),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (shop.articles == null) ? 0 : shop.articles.length,
                    itemBuilder: (BuildContext context, int index) {
                      displayCommentPressed.add(false);
                      trailingIcons.add(Icons.keyboard_arrow_down);
                      // ARTICLES TO BUY
                      if (shop.articles[index].bought) {
                        return Dismissible(
                          key: ValueKey('article_' + shop.articles[index].id.toString()),
                          background: Card(
                            color: secondaryColor,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 35.0),
                              child:  Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                              ),
                            )
                          ),
                          onDismissed: (DismissDirection direction) async {
                            setState(() {
                              shop.articles[index].bought = false;
                            });
                            await _processPutArticle(shop.articles[index]);
                          },
                          child: Card(
                            color: Colors.blueGrey,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      shop.articles[index].title,
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                    trailing: (shop.articles[index].comment.isNotEmpty)
                                      ? IconButton(
                                      icon: Icon(
                                        trailingIcons[index],
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (displayCommentPressed[index] == true) {
                                            displayCommentPressed[index] = false;
                                            trailingIcons[index] = Icons.keyboard_arrow_down;
                                          } else {
                                            displayCommentPressed[index] = true;
                                            trailingIcons[index] = Icons.keyboard_arrow_up;
                                          }
                                        });
                                      })
                                      : null,
                                  ),
                                  (displayCommentPressed[index])
                                    ? Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      shop.articles[index].comment,
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  )
                                    : Container()
                                ],
                              ),
                            )
                          )
                        );
                      } else {
                        return Container();
                      }
                    })
                ],
              )
            ),
          ],
        ),
      )
    );
  }
  /// Load the shop from the API and then set it in the State.
  /// Catch [HttpException] and display Fatal Error if needed.
  Future<void> _loadShop(String shopId) async {
    try {
      Shop shop = await HttpHelper.getShop(shopId);
      setState(() {
        this.shop = shop;
      });
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
  /// Process the PUT request to the API
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _processPutArticle(Article article) async {
    try {
      await HttpHelper.putArticle(article);
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
//// Follow the road to the formPage with an article to update
  Future<bool> _updateArticleWidget(Article article) async {
    var refresh = await Navigator.pushNamed(
      context,
      '/updateArticle',
      arguments: article
    );
    return refresh;
  }
}