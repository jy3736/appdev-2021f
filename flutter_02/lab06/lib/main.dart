import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget myImage({double edge = 1, double width = 0}) => Container(
        padding: EdgeInsets.all(edge),
        child: (width > 0)
            ? Image.network('https://picsum.photos/300?image=20', width: width)
            : Image.network('https://picsum.photos/300?image=20'),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP程式設計實務',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Expanded with flex configuration'),
        ),
        body: Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: myImage(),
            ),
            Expanded(
              flex: 2,
              child: myImage(),
            ),
            Expanded(
              flex: 3,
              child: myImage(),
            ),
          ],
        )),
      ),
    );
  }
}
