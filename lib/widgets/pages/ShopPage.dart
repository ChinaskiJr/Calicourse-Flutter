import 'dart:async';
import 'dart:io';

import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Article.dart';
import 'package:calicourse_front/models/Shop.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/custom_widgets/FatalAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShopPageState();
  }
}

class _ShopPageState extends State<ShopPage> {

  Shop shop = Shop.empty();
  List<Article> articlesNotBought = [];
  List<Article> articlesNotBoughtBeforeFiltering = [];
  List<Article> articlesBought = [];
  List<Article> articlesBoughtBeforeFiltering = [];
  List<bool> displayCommentPressed  = [];
  List<IconData> trailingIcons      = [];
  TextEditingController _filterTextController = TextEditingController();
  Timer mytimer;

  @override
  void dispose() {
    super.dispose();
    _filterTextController.dispose();
    if (mytimer.isActive) {
      mytimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments;

    if (shop.id == null) {
      _loadShop(shopId);
      this.mytimer = Timer.periodic(Duration(seconds: 2), (timer) {
        _updateArticles(shopId);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: (shop.id == null) ? CircularProgressIndicator() : Text(shop.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25.0
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Filtrer...",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () async {
                          _filterTextController.clear();
                          await _restartTimerIfNeeded(shopId);
                        }
                    )
                ),
                controller: _filterTextController,
                onChanged: (String str) async {
                  if (mytimer.isActive) {
                    mytimer.cancel();
                  }
                  if (str.isNotEmpty) {
                    List<Article> articlesNotBoughtFiltered = this.articlesNotBoughtBeforeFiltering.where((Article article) {
                      return article.title.toLowerCase().contains(str.toLowerCase());
                    }).toList();
                    List<Article> articlesBoughtFiltered = this.articlesBoughtBeforeFiltering.where((Article article) {
                      return article.title.toLowerCase().contains(str.toLowerCase());
                    }).toList();
                    setState(() {
                      this.articlesNotBought = articlesNotBoughtFiltered;
                      this.articlesBought = articlesBoughtFiltered;
                    });
                  } else {
                    await _restartTimerIfNeeded(shopId);
                  }
                },
              ),
            ),
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
                  (this.articlesNotBought.length == 0)
                  ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Rien à afficher"),
                  )
                  : GridView.builder(
                    shrinkWrap: true,
                    itemCount: (shop.articles == null) ? 0 : this.articlesNotBought.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      displayCommentPressed.add(false);
                      trailingIcons.add(Icons.keyboard_arrow_down);
                      // ARTICLES TO BUY
                      return Dismissible(
                        key: ValueKey('article_' + articlesNotBought[index].id.toString()),
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
                          articlesNotBought[index].bought = true;
                          print(articlesNotBought[index]);
                          await _processPutArticle(articlesNotBought[index]);
                          setState(() {
                            articlesBought.add(articlesNotBought[index]);
                            articlesNotBought.removeAt(index);
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            if (articlesNotBought[index].comment.isNotEmpty
                                || articlesNotBought[index].image != null) {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          (articlesNotBought[index].image != null)
                                          ? FutureBuilder(
                                            future: _loadImage(articlesNotBought[index].image),
                                            builder: (ctx, snapshot) {
                                              if (!snapshot.hasData) {
                                                return CircularProgressIndicator();
                                              } else {
                                                return Image.network(snapshot.data);
                                              }
                                            })
                                              : Container(),
                                          Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              articlesNotBought[index].comment,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                }
                              );
                            } else {
                              return null;
                            }
                          },
                          onLongPress: () async {
                            bool refresh = await _updateArticleWidget(articlesNotBought[index]);
                            if (refresh != null && refresh) {
                              setState(() {
                                _loadShop(shopId);
                              });
                            }
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      articlesNotBought[index].title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: articleTitleFontSize
                                      ),
                                    ),
                                  ),
                                  (articlesNotBought[index].comment.isNotEmpty
                                      || articlesNotBought[index].image != null)
                                    ? Center(
                                        child: Icon(
                                          Icons.info_outline,
                                          color: mainColor,
                                        ),
                                      )
                                    : Container()
                                ],
                              ),
                            )
                          ),
                        )
                      );
                    },
                  )
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
                  (this.articlesBought.length == 0)
                      ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Rien à afficher"),
                  )
                      : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (shop.articles == null) ? 0 : this.articlesBought.length,
                    itemBuilder: (BuildContext context, int index) {
                      displayCommentPressed.add(false);
                      trailingIcons.add(Icons.keyboard_arrow_down);
                      // ARTICLES TO BUY
                      return Dismissible(
                        key: ValueKey('article_' + articlesBought[index].id.toString()),
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
                          articlesBought[index].bought = false;
                          print(articlesBought[index]);
                          await _processPutArticle(articlesBought[index]);
                          setState(() {
                            articlesNotBought.add(articlesBought[index]);
                            articlesBought.removeAt(index);
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            if (articlesBought[index].comment.isNotEmpty
                                || articlesBought[index].image != null) {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          (articlesBought[index].image != null)
                                              ? FutureBuilder(
                                              future: _loadImage(articlesBought[index].image),
                                              builder: (ctx, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return CircularProgressIndicator();
                                                } else {
                                                  return Image.network(snapshot.data);
                                                }
                                              })
                                              : Container(),
                                          Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              articlesBought[index].comment,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                }
                              );
                            } else {
                              return null;
                            }
                          },
                          onLongPress: () async {
                            bool refresh = await _updateArticleWidget(articlesBought[index]);
                            if (refresh != null && refresh) {
                              setState(() {
                                _loadShop(shopId);
                              });
                            }
                          },
                          child: Card(
                            color: Colors.blueGrey,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Center(
                                  child: Text(
                                      articlesBought[index].title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: articleTitleFontSize,
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                  (articlesBought[index].comment.isNotEmpty
                                      || articlesBought[index].image != null)
                                    ? Center(
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                    ),
                                  )
                                    : Container()
                                ],
                              ),
                            )
                          ),
                        )
                      );
                    })
                ],
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_shopping_cart
        ),
        onPressed: () async {
          await Navigator.pushNamed(context, '/addArticle', arguments: shop);
          await _loadShop(shopId);
        },
      ),
    );
  }
  Future<void> sortArticles(List<Article> article) async {
      this.articlesNotBought = [];
      this.articlesBought = [];
      for (Article article in article) {
        if (article.bought) {
          this.articlesBought.add(article);
        } else {
          this.articlesNotBought.add(article);
        }
      }
  }
  /// Load the shop from the API and then set it in the State.
  /// Catch [HttpException] and display Fatal Error if needed.
  Future<void> _loadShop(String shopId) async {
    try {
      this.shop = await HttpHelper.getShop(shopId);
      this.articlesBought = await HttpHelper.getArticlesByShopAndStatus(shopId, true);
      this.articlesNotBought = await HttpHelper.getArticlesByShopAndStatus(shopId, false);
      this.articlesBoughtBeforeFiltering = List.from(this.articlesBought);
      this.articlesNotBoughtBeforeFiltering = List.from(this.articlesNotBought);
      setState(() {
        this.articlesNotBought = this.articlesNotBought;
        this.articlesBought = this.articlesBought;
      });
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
  Future<void> _updateArticles(String shopId) async {
    try {
      this.articlesBought = await HttpHelper.getArticlesByShopAndStatus(shopId, true);
      this.articlesNotBought = await HttpHelper.getArticlesByShopAndStatus(shopId, false);
      setState(() {
        this.articlesNotBought = this.articlesNotBought;
        this.articlesBought = this.articlesBought;
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
  /// Follow the road to the formPage with an article to update
  Future<dynamic> _updateArticleWidget(Article article) async {
    return await Navigator.pushNamed(
      context,
      '/updateArticle',
      arguments: article
    );
  }

  Future<void> _restartTimerIfNeeded(String shopId) async {
    if (!mytimer.isActive) {
      await _updateArticles(shopId);
      this.mytimer = Timer.periodic(Duration(seconds: 2), (timer) {
        _updateArticles(shopId);
      });
    }
  }

  Future<void> _loadImage(String imageUri) async {
    String uri = await HttpHelper.getPicture(imageUri);
    if (kDebugMode) {
      return "http://10.0.2.2:3000/" + uri;
    } else {
      return "https://calicourse.robin-colombier.com/" + uri;
    }
  }
}