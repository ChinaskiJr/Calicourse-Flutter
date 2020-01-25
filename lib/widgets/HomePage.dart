import 'dart:io';

import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Shop.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const String header = "La fierté d'avoir le contrôle sur les données de sa liste de courses";

  List<Shop> shops;

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
                    fontSize: globalFontSize
                ),
              ),
            ),
            FutureBuilder<void>(
                future: _loadShops(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: shops.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Text(shops[index].name),
                          );
                        }
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );
  }

  /// Between the Http call and the building of the [FutureBuilder].
  /// Purpose of this function is to properly manage the [HttpException]
  Future<void> _loadShops() async {
    try {
      this.shops = await HttpHelper.getShops();
    } on HttpException catch(exception, stackTrace) {
      print(stackTrace);
    }
  }
}