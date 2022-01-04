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
            'Basic Layout Template',
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
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        cnt++;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              cnt.toString(),
              style: const TextStyle(fontSize: 50, color: Colors.indigo),
            ),
            Text(
              cnt.toString(),
              style: const TextStyle(fontSize: 50, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const Text(
                "StatefulWidget Template : ",
                style: TextStyle(fontSize: 20, color: Colors.blue),
                textAlign: TextAlign.left,
              ),
              Text(
                cnt.toString(),
                style: const TextStyle(fontSize: 30, color: Colors.red),
              ),
            ]),
            Text(
              cnt.toString(),
              style: const TextStyle(fontSize: 50, color: Colors.purpleAccent),
              textAlign: TextAlign.right,
            ),
          ]);
}

