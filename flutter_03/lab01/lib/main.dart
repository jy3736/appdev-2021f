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
            'Basic Layout Template',
          )),
          body: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, this.msg = 'Flutter'}) : super(key: key);

  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Text(
      "$msg : Hello, world.",
      style: const TextStyle(fontSize: 36),
    );
  }
}

