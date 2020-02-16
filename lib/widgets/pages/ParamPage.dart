
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ParamPageState();
  }
}

class ParamPageState extends State<ParamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
    );
  }
}