import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget myText(var txt, {double size = 40, Color bc = Colors.transparent}) =>
      Text(
        "$txt",
        style: TextStyle(fontSize: size, backgroundColor: bc),
      );

  Widget rainbow({int w = 5}) =>
      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        myText(' ' * w, size: (w - 1) * 10, bc: Colors.red),
        myText(' ' * w, size: (w - 1) * 10, bc: Colors.orange),
        myText(' ' * w, size: (w - 1) * 10, bc: Colors.yellow),
        myText(' ' * w, size: (w - 1) * 10, bc: Colors.green),
        myText(' ' * w, size: (w - 1) * 10, bc: Colors.blue),
        myText(' ' * w, size: (w - 1) * 10, bc: Colors.indigo),
        myText(' ' * w, size: (w - 1) * 10, bc: Colors.purple),
      ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP程式設計實務',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Column [Row1, Row2, ... ]'),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            rainbow(w: 5),
            const SizedBox(height: 5),
            rainbow(w: 5),
            const SizedBox(height: 5),
            rainbow(w: 5),
          ],
        )),
      ),
    );
  }
}
