import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/pages/ArticlePage.dart';
import 'package:calicourse_front/widgets/pages/HomePage.dart';
import 'package:calicourse_front/widgets/pages/ParamPage.dart';
import 'package:calicourse_front/widgets/pages/ShopPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/pages/AddShopPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

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
        '/':              (context)     => HomePage(title: 'Calicourse'),
        '/addArticle':    (context)     => ArticlePage(),
        '/updateArticle': (context)     => ArticlePage(),
        '/addShop':       (context)     => AddShopPage(),
        '/showShop':      (context)     => ShopPage(),
        '/param':         (context)     => ParamPage()
      },
    );
  }
}
