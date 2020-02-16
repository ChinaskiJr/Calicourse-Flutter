
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ParamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ParamPageState();
  }
}

class ParamPageState extends State<ParamPage> {
  String apiKey;

  @override
  void initState() {
    loadApiKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  labelText: 'Clé API *'
                ),
                onSubmitted: (String str) async {
                  await saveApiKey(str);
                },
                controller: TextEditingController()..text = apiKey,
                onChanged: (_) => {},
                autofocus: true,
              )
            ],
          ),
        )
      ),
    );
  }

  Future<void> saveApiKey(String apiKey) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'calicourse_api_key', value: apiKey);
  }

  Future<void> loadApiKey() async {
    final storage = FlutterSecureStorage();
    this.apiKey = await storage.read(key: 'calicourse_api_key');
  }
}