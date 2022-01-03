import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, this.msg = 'STUST'}) : super(key: key);

  final String? msg;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          Text(
            "Text : Line 1.....................1",
            style: TextStyle(fontSize: 30, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          MyText(
            text: "MyText : Line 2.....................2",
            size: 20,
          )
        ]);
  }
}

class MyText extends StatelessWidget {
  const MyText({Key? key, this.text = '', this.size = 25}) : super(key: key);

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(fontSize: size),
        textAlign: TextAlign.center,
      );
}
