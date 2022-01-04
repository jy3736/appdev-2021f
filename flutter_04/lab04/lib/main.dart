import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Development 2021 Fall',
        home: Scaffold(
          appBar: AppBar(
              title: const Text(
            'Assets + TextButton',
          )),
          body: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.msg = "STUST"}) : super(key: key);

  final String? msg;

  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  int index = 1;
  final root = "images/sfo/";
  String img = "images/sfo/1.png";

  void next() {
    setState(() {
      index = (index < 10) ? index + 1 : 1;
      img = "$root$index.png";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: <Widget>[
      Card(
        color:Colors.white12,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(img),
        ),
      ),
      TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: next,
        child: const Text('Next', style: TextStyle(fontSize: 30)),
      ),
    ]));
  }
}

