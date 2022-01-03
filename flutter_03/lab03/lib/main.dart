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
                'Text Widget - TextOverflow',
              )),
          body: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, this.msg = 'STUST'}) : super(key: key);

  final String? msg;
  final alphabet = "abcdefghijklmnopqrstuvwxyz";

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            alphabet,
            style: const TextStyle(fontSize: 36, color: Colors.indigo),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            alphabet,
            style: const TextStyle(fontSize: 36, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          Text(
            alphabet*3,
            style: const TextStyle(fontSize: 36, color: Colors.red),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          Text(
            alphabet*3,
            style: const TextStyle(fontSize: 36, color: Colors.indigo),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ]);
  }
}

