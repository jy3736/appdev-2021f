import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Coffee Roaster - Realtime Chart';

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
  late List<LiveData> chartData;
  late ChartSeriesController _chartController;

  @override
  void initState() {
    chartData = getChartData();
    Timer.periodic(const Duration(milliseconds: 200), updateDataSource);
    super.initState();
  }

  Widget sfchart() => Expanded(
          child: SfCartesianChart(
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
            maximum: 230,
            title: AxisTitle(text: 'Temperature (°C)')),
        series: <LineSeries<LiveData, num>>[
          LineSeries<LiveData, num>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartController = controller;
            },
            dataSource: chartData,
            color: const Color.fromRGBO(26, 95, 213, 1.0),
            xValueMapper: (LiveData dat, _) => dat.time,
            yValueMapper: (LiveData dat, _) => dat.temp,
          ),
        ],
      ));

  Widget screen() => SizedBox(
        height: 200,
        width: 200,
        child: Card(
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white12, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              k1.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 50,
                color: (k1>=180)?Colors.red:Colors.green,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 600) {
          return Column(children: [
            sfchart(),
            screen(),
          ]);
        } else {
          return Row(children: [
            sfchart(),
            screen(),
          ]);
        }
      },
    ));
  }

  int _clk = 0;
  CoffeeRoasting tempK1 = CoffeeRoasting();
  double k1 = 210;

  void updateDataSource(Timer timer) {
    setState(() {
      k1 = tempK1.next();
      chartData.add(LiveData(_clk, k1));
    });
    _clk += tempK1.rate;
    if (_clk > 20*60) {
      chartData.removeAt(0);
    }
    _chartController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[LiveData(_clk, k1)];
  }
}

class LiveData {
  LiveData(this.time, this.temp);

  final int time;
  final num temp;
}

class CoffeeRoasting {
  double k1 = 210;
  double kt = 210;
  int step = 90;
  int state = 0;
  int rate = 10;

  List<List<double>> ns = [
    [210, 30],
    [90, 90],
    [92, 30],
    [95, 30],
    [160, 180],
    [170, 180],
    [190, 60],
    [200, 90],
    [210, 60],
    [220, 180],
  ];

  double next() {
    if (k1 == kt) {
      kt = ns[state][0];
      step = ns[state++][1]~/rate;
      if (state >= ns.length) state = 0;
    }
    if (step >= 1) {
      if (math.Random().nextBool()) k1 -= (k1 - kt) / step;
      if (step == 1) k1 = kt;
      step--;
    }
    return k1;
  }
}
