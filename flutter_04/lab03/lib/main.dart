import 'dart:ui';
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
  int _selCurve = 1;

  Widget _radioButton(String text, int value) {
    return RadioListTile(
      title: Text(
        text,
        style: const TextStyle(fontSize: 30, color: Colors.blueAccent),
      ),
      groupValue: _selCurve,
      value: value,
      onChanged: (int? value) {
        setState(() {
          _selCurve = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _radioButton("k1", 1),
                _radioButton("k2", 2),
                _radioButton("k1, k2", 3),
              ],
            ),
          ),
          Expanded(
            child: Text(
              _selCurve.toString(),
              style: const TextStyle(fontSize: 100, color: Colors.blueAccent),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
}

