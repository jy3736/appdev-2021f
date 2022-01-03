import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  String draw(List<int> dat) {
    String s = "";
    for (var n in dat) {
      s += "\n$n : " + "*" * n;
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP程式設計實務',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('課堂練習 3'),
        ),
        body: Center(
          child: Text(
            draw([1, 3, 2, 4, 5, 6, 3, 8, 9, 7]),
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
