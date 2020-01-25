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
              child:  Text(
                header,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: globalFontSize
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );
  }
}