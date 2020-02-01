import 'dart:io';

import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Shop.dart';
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

  Shop shop;

  @override
  Widget build(BuildContext context) {
    final String shopId = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
      future: _loadShop(shopId),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text(shop.name),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: shop.articles.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(shop.articles[index].title);
              }
            )
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
    );
  }

  Future<void> _loadShop(String shopId) async {
    try {
      this.shop = await HttpHelper.getShop(shopId);
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
}