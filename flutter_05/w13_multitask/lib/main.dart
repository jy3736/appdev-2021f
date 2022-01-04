import 'dart:async';
import 'package:flutter/material.dart';

const Color bgColor = Color.fromARGB(255, 50, 111, 206);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: CounterSrc(),
        ),
      ),
    );
  }
}

class CounterSrc extends StatefulWidget {
  const CounterSrc({Key? key}) : super(key: key);

  @override
  _CounterSrcState createState() => _CounterSrcState();
}

class _CounterSrcState extends State<CounterSrc> {
  int cnt1 = 0;
  int cnt2 = 0;
  Timer? timer1, timer2;
  final interval1 = const Duration(milliseconds: 1000);
  final interval2 = const Duration(milliseconds: 100);

  void task1(Timer t) {
    setState(() {
      cnt1++;
    });
  }

  void task2(Timer t) {
    setState(() {
      cnt2++;
    });
  }

  @override
  void initState() {
    super.initState();

    timer1 = Timer.periodic(interval1, task1);
    timer2 = Timer.periodic(interval2, task2);
  }

  @override
  void dispose() {
    super.dispose();
    timer1?.cancel();
    timer2?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("$cnt1", style: const TextStyle(fontSize: 100)),
          Text("$cnt2", style: const TextStyle(fontSize: 100)),
        ]);
  }
}
