import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  String mulTab(n, m) {
    String s = '';
    for (var i = 1; i <= n; i++) {
      for (var j = 1; j <= m; j++) {
        s += (i * j > 9) ? '${i * j}  ' : '0${i * j}  ';
      }
      s += "\n";
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP程式設計實務',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('課堂練習 4'),
        ),
        body: Center(
          child: Text(
            mulTab(9, 9),
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

