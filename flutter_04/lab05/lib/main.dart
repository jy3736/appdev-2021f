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
            'Assets + TextButton',
          )),
          body: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.msg = "STUST"}) : super(key: key);

  final String? msg;

  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  int index = 1;
  final root = "images/sfo/";
  String img = "images/sfo/1.png";

  void _next(int offset) {
    setState(() {
      index += offset;
      index = (index < 1)
          ? 10
          : (index > 10)
              ? 1
              : index;
      img = "$root$index.png";
    });
  }

  void next() => _next(1);

  void previous() => _next(-1);

  Widget myTextButton(void Function() fun, String s, Color c, double w) {
    return SizedBox(
      width: w,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: c, width: 3),
            ),
          ),
          foregroundColor: MaterialStateProperty.all(c),
        ),
        onPressed: fun,
        child: Text(s, style: const TextStyle(fontSize: 30)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
      Card(
        color: Colors.white12,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(img),
        ),
      ),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        myTextButton(previous, 'Previous', Colors.blueAccent, 140),
        const SizedBox(width: 30),
        myTextButton(next, 'Next', Colors.blueAccent, 140),
      ]),
      const SizedBox(height: 50),
    ]));
  }
}
