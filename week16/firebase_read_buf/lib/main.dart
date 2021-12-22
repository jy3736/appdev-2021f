import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Firebase Simple Query - Read Buffer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(_title),
            backgroundColor: Colors.blueGrey,
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const MyHomePage(title: 'Realtime Chart'),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<LiveData> chartData = <LiveData>[];
  final database = FirebaseDatabase.instance;

  @override
  void initState() {
    readDB();
    super.initState();
  }

  Widget sfchart() => Expanded(
          child: SfCartesianChart(
        legend: Legend(isVisible: true),
        primaryXAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            interval: 30,
            title: AxisTitle(text: 'Time (seconds)')),
        primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 1),
            interval: 5,
            minimum: 80,
            maximum: 240,
            title: AxisTitle(text: 'Temperature (°C)')),
        series: <LineSeries<LiveData, int>>[
          LineSeries<LiveData, int>(
            dataSource: chartData,
            name: 'k1',
            pointColorMapper: (LiveData dat, _) => Colors.blue,
            xValueMapper: (LiveData dat, _) => dat.time,
            yValueMapper: (LiveData dat, _) => dat.k1,
          ),
          LineSeries<LiveData, int>(
            dataSource: chartData,
            name: 'k2',
            pointColorMapper: (LiveData dat, _) => Colors.purple,
            xValueMapper: (LiveData dat, _) => dat.time,
            yValueMapper: (LiveData dat, _) => dat.k2,
          ),
        ],
      ));

  Widget screen() => Card(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white12, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              _start.toInt().toString(),
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            Text(
              (_start + _width).toInt().toString(),
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ]),
        ),
      );

  Widget ctrlPanel() => Card(
        color: Colors.white12,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white12, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.all(10.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Slider(
              value: _start,
              max: 5000,
              min: 900,
              divisions: 100,
              onChanged: (double value) {
                setState(() {
                  _start = value;
                });
              },
              onChangeEnd: (double value) {
                updateChart();
              },
            ),
            Slider(
              value: _width,
              max: 2000,
              min: 100,
              divisions: 100,
              onChanged: (double value) {
                setState(() {
                  _width = value;
                });
              },
              onChangeEnd: (double value) {
                updateChart();
              },
            ),
          ]),
        ),
      );

  double _start = 900;
  double _width = 1000;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 600) {
          return Column(children: [
            sfchart(),
            SizedBox(
              height: 100,
              child: screen(),
            ),
            ctrlPanel(),
          ]);
        } else {
          return Row(children: [
            sfchart(),
            Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: 200,
                child: screen(),
              ),
              ctrlPanel(),
            ]),
          ]);
        }
      },
    ));
  }

  num k1 = 210;
  num k2 = 0;

  List<LiveData> _dbBuf = <LiveData>[];

  void updateChart() {
    chartData = <LiveData>[];
    int st = (_start.toInt()-900)~/5;
    int en = st + (_width.toInt()~/5);
    for(var i=st; i<en; i++) {
      setState(() {
        chartData.add(_dbBuf[i]);
      });
    }
  }

  Future<void> readDB() async {
    final fbRef = database.ref('roaster1');
    _dbBuf = <LiveData>[];
    await fbRef
        .orderByChild('time')
        .startAt(900)
        .endAt(7000)
        .get()
        .then((snapshot) {
      if (snapshot.value != null) {
        List data = (snapshot.value as Map).values.toList();
        data.sort((a, b) => a['time'].compareTo(b['time']));
        for (var e in data) {
          int time = e['time'];
          k1 = e['k1'];
          k2 = e['k2'];
          _dbBuf.add(LiveData(time, k1, k2));
        }
      }
    });
    updateChart();
  }
}

class LiveData {
  LiveData(this.time, this.k1, this.k2);

  final int time;
  final num k1;
  final num k2;
}
