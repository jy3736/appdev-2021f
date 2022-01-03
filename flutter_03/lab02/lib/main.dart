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
            'Column with 2 Text Widgets',
          )),
          body: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, this.msg = 'STUST'}) : super(key: key);

  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "$msg : Row 1.....................1",
            style: const TextStyle(fontSize: 30, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          Text(
            "$msg : Row 2.....................2",
            style: const TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ]);
  }
}

