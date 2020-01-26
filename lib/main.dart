import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/AddArticlePage.dart';
import 'package:calicourse_front/widgets/HomePage.dart';
import 'package:flutter/material.dart';

import 'widgets/custom_widgets/AddShopPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calicourse',
      theme: ThemeData(
        primarySwatch: mainColor
      ),
      initialRoute: '/',
      routes: {
        '/':            (context)     => HomePage(title: 'Calicourse'),
        '/addArticle':  (context)     => AddArticlePage(),
        '/addShop':     (context)     => AddShopPage(),
      },
    );
  }
}
