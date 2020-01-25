import 'package:calicourse_front/widgets/HomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calicourse',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomePage(title: 'Calicourse'),
    );
  }
}
