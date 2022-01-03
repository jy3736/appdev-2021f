import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget myImage(int img, {double edge = 1, double width = 0}) => Container(
        padding: EdgeInsets.all(edge),
        child: (width > 0)
            ? Image.network('https://picsum.photos/300?image=$img',
                width: width)
            : Image.network('https://picsum.photos/300?image=$img'),
      );

  Widget landscape() => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: myImage(20),),
          Expanded(child: myImage(30),),
          Expanded(child: myImage(40),),
        ],
      );

  Widget portrait() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(child: myImage(20),),
          Expanded(child: myImage(30),),
          Expanded(child: myImage(40),),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP程式設計實務',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Layout Builder'),
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 600) {
                return landscape();
              } else {
                return portrait();
              }
            },
          ),
        ),
      ),
    );
  }
}
