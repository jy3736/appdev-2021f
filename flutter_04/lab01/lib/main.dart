import 'dart:async';
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
            'Basic Layout Template - StatefulWidget',
          )),
          body: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title = "Flutter"}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int cnt = 0;
  late Timer _t1;

  @override
  void initState() {
    _t1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => cnt++);
    });
    super.initState();
  }

  @override
  void dispose() {
    _t1.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
        cnt.toString(),
        style: const TextStyle(fontSize: 100, color: Colors.red),
      );
}

