import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget myText(var txt, {double size = 30}) => Text(
        "$txt",
        style: TextStyle(fontSize: size),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP程式設計實務',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter 實作 2 - 課堂練習 2'),
        ),
        body: Center(
            child: Row(children: <Widget>[
              myText('Col 1 |'),
              myText('Col 2 |'),
              myText('Col 3 |'),
              myText('Col 4 |'),
        ])),
      ),
    );
  }
}




