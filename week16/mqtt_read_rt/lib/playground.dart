import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const broker = 'broker.hivemq.com';
const port = 1883;
const cid = '95affe31-a1d9-4ee3-8ee4-afbafb6cb1b6';
const user = 'Young';
const passwd = '123456';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Coffee Roasting Curve - Firebase';

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
  late ChartSeriesController _chartController;

  final client = MqttServerClient(broker, cid);
  bool _connected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
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
            maximum: 240,
            title: AxisTitle(text: 'Temperature (°C)')),
        series: <LineSeries<LiveData, int>>[
          LineSeries<LiveData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartController = controller;
            },
            dataSource: chartData,
            pointColorMapper: (LiveData dat, _) => Colors.blue,
            xValueMapper: (LiveData dat, _) => dat.time,
            yValueMapper: (LiveData dat, _) => dat.k1,
          ),
          LineSeries<LiveData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartController = controller;
            },
            dataSource: chartData,
            pointColorMapper: (LiveData dat, _) => Colors.deepOrangeAccent,
            xValueMapper: (LiveData dat, _) => dat.time,
            yValueMapper: (LiveData dat, _) => dat.k2,
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                k1.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 50,
                  color: (k1 >= 180) ? Colors.red : Colors.green,
                ),
              ),
              Text(
                k2.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 50,
                  color: (k2 >= 180) ? Colors.red : Colors.green,
                ),
              ),
            ]),
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

  num k1 = 210;
  num k2 = 210;
  int cntChart = 0;

  List mqttMsg = [];

  void updateDataSource() {
    setState(() {
      chartData.add(LiveData(cntChart, mqttMsg[1], mqttMsg[2]));
    });
    cntChart++;
    if (cntChart > 300) chartData.removeAt(0);
    _chartController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[];
  }

  Future<MqttServerClient?> connect() async {
    client.port = port;
    client.setProtocolV311();
    client.logging(on: false);
    await client.connect(user, passwd);
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      setState(() {
        _connected =
            client.connectionStatus!.state == MqttConnectionState.connected;
      });
    } else {
      client.disconnect();
    }
    client.subscribe("stust2021/roaster1", MqttQos.atLeastOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final message = c[0].payload as MqttPublishMessage;
      setState(() {
        // ignore: prefer_const_constructors
        final msg = Utf8Decoder().convert(message.payload.message);
        mqttMsg = msg.split(':');
        updateDataSource();
      });
    });
  }
}

class LiveData {
  LiveData(this.time, this.k1, this.k2);

  final int time;
  final num k1;
  final num k2;
}
