import 'dart:async';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

var uuid = const Uuid();
final uid = uuid.v4();

const broker = 'broker.emqx.io';
const port = 1883;
const user = 'AppDev2021f';
const passwd = 'whocares';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Coffee Roasting Curve - MQTT IoT Application';

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

  final client = MqttServerClient(broker, uid);

  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
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
                k2.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.purple,
                ),
              ),
              Text(
                k1.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.blue,
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
  int _time = 0;
  List mqttMsg = [];

  void updateDataSource() {
    if (mqttMsg.length == 3) {
      setState(() {
        k1 = num.parse(mqttMsg[1]);
        k2 = num.parse(mqttMsg[2]);
        chartData.add(LiveData(_time, k1, k2));
      });
      _time += 5;
      if (_time > 1000) chartData.removeAt(0);
    }
  }

  Future<MqttServerClient?> connect() async {
    client.port = port;
    client.setProtocolV311();
    client.logging(on: false);
    await client.connect(user, passwd);
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      client.disconnect();
    }
    client.subscribe("stust2021/roaster1", MqttQos.atLeastOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final message = c[0].payload as MqttPublishMessage;
      setState(() {
        final msg = const Utf8Decoder().convert(message.payload.message);
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
