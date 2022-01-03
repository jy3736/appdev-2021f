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
          title: const Text('Flutter 實作 2 - 課堂練習 1'),
        ),
        body: Center(
            child: Column(children: <Widget>[
              myText('Row 1 ................. 1'),
              myText('Row 2 ................. 2'),
              myText('Row 3 ................. 3'),
              myText('Row 4 ................. 4'),
              myText('Row 5 ................. 5'),
              myText('Row 6 ................. 6'),
        ])),
      ),
    );
  }
}


