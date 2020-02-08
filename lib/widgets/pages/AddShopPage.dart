import 'dart:io';

import 'package:calicourse_front/helpers/HttpHelper.dart';
import 'package:calicourse_front/models/Shop.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:calicourse_front/widgets/custom_widgets/FatalAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddShopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddShopPageStage();
  }
}

class AddShopPageStage extends State<AddShopPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleFieldConstructor;

  @override
  void dispose() {
    _titleFieldConstructor.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _titleFieldConstructor = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un magasin"),
        backgroundColor: secondaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextFormField(
                controller: _titleFieldConstructor,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.create),
                  hintText: "ex: Carrefour",
                  labelText: "Nom du magasin"
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
              RaisedButton(
                child: Text(
                  'Ajouter',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: secondaryColor,
                splashColor: Colors.white,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Shop newShop = Shop.build(
                      name: _titleFieldConstructor.text
                    );
                    await _processAddShop(newShop);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          )
        ),
      ),
    );
  }

  Future<void> _processAddShop(Shop shop) async {
    try {
      await HttpHelper.postShop(shop);
    } on HttpException catch (exception, stacktrace) {
      print(stacktrace);
      FatalAlertDialog.showFatalError(exception.message, context);
    }
  }
}