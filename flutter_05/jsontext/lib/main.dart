import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Read JSON Text'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const MyHomePage(),
      ),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  List infoDB = [];
  Map<String, String> photo = {};
  Map<String, String> description = {};
  String info = "";
  String picked = "";

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/info_db.json');
    final data = await json.decode(response);
    photo = {};
    description = {};
    setState(() {
      infoDB = data["info"];
      for (var db in infoDB) {
        photo[db['city']] = db['photo'];
        description[db['city']] = db['description'];
      }
      picked = photo.keys.first;
      info = description[picked]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 15),
          Expanded(flex:4,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Image.asset("images/"+photo[picked]!),
                ),
              ),
            ),
          ),
          Expanded( flex:5,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Text(
                    info,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          DropdownButton<String>(
            value: picked,
            icon: const Icon(Icons.arrow_downward),
            style: const TextStyle(color: Colors.deepPurple, fontSize: 30),
            elevation: 16,
            items: photo.keys.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (v) {
              setState(() {
                picked = v!;
                info = description[picked]!;
              });
            },
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
