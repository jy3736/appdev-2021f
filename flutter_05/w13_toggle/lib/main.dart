import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Intro. App Development 2021 Fall',
        home: Scaffold(
          appBar: AppBar(
              title: const Text(
            'Toggle Button To Control The Timer',
          )),
          body: const Sandbox(),
        ));
  }
}

class Sandbox extends StatefulWidget {
  const Sandbox({Key? key, this.msg = "STUST"}) : super(key: key);

  final String? msg;

  @override
  State<StatefulWidget> createState() => _Sandbox();
}

class _Sandbox extends State<Sandbox> {
  bool flip = false;
  int counter = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (timer) {
        setState(() {
          if (flip) counter++;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(flex: 1, child: Container()),
      Expanded(
        flex: 2,
        child: Text("$counter",
            style: const TextStyle(fontSize: 120, color: Colors.blueAccent)),
      ),
      TextButton(
        onPressed: () {
          setState(() {
            flip = !flip;
          });
        },
        child: flip
            ? const Text("PAUSE", style: TextStyle(fontSize: 50, color: Colors.red))
            : const Text("GO", style: TextStyle(fontSize: 50, color: Colors.green)),
      ),
      const SizedBox(height: 20),
    ]));
  }
}
