import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget myImage({double edge = 1, double width = 0}) => Container(
        padding: EdgeInsets.all(edge),
        child: (width > 0)
            ? Image.network('https://picsum.photos/150?image=20', width: width)
            : Image.network('https://picsum.photos/150?image=20'),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP程式設計實務',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shrink Image'),
        ),
        body: Center(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            myImage(),
            myImage(width: 80),
            myImage(width: 100),
          ],
        )),
      ),
    );
  }
}
