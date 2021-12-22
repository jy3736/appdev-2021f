import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

var uuid = const Uuid();
final uid = uuid.v4();

const broker = 'broker.emqx.io';
const port = 1883;
const user = 'AppDev2021f';
const passwd = 'whocares';

void main() {
  if (Platform.isWindows) {
    Size scrSize = const Size(800, 1200);
    DesktopWindow.setWindowSize(scrSize);
    DesktopWindow.setMaxWindowSize(scrSize);
    DesktopWindow.setMinWindowSize(scrSize);
  }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'MQTT Traffic Light System';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(_title),
          backgroundColor: Colors.indigo,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/wallpaper/4.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: const MyStatefulWidget(),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String light1 = 'images/light/X.png';
  String light2 = 'images/light/X.png';

  final client = MqttServerClient(broker, uid);
  List mqttMsg = [];

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

  Future<MqttServerClient?> connect() async {
    client.port = port;
    client.keepAlivePeriod = 30;
    client.setProtocolV311();
    client.logging(on: false);
    await client.connect(user, passwd);
    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      client.disconnect();
    }
    client.subscribe(txtTopicCtrl.text, MqttQos.atLeastOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final message = c[0].payload as MqttPublishMessage;
      setState(() {
        final msg = const Utf8Decoder().convert(message.payload.message);
        mqttMsg = msg.split(':');
        print(mqttMsg);
      });
    });
  }

  void mqttPub(String cmd) {
    final builder = MqttClientPayloadBuilder();
    //builder.addString(txtMsgCtrl.text);
    builder.addUTF8String(cmd);
    client.publishMessage(
        txtTopicCtrl.text, MqttQos.atLeastOnce, builder.payload!);
  }

  Widget eButton(void Function() fun, String s,
      {Color c = Colors.lightBlue,
      double fs = 26,
      Color fc = Colors.white,
      double w = 160,
      double h = 60}) {
    return SizedBox(
      width: w,
      height: h,
      child: ElevatedButton(
        child: Text(s),
        style: ElevatedButton.styleFrom(
          primary: c,
          onPrimary: fc,
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: fs,
            fontStyle: FontStyle.normal,
          ),
        ),
        onPressed: fun,
      ),
    );
  }

  Widget space({double h = 10, double w = 30}) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  Timer _timer = Timer.periodic(const Duration(seconds: 10), (timer) {});

  int _cs = 0;
  int _cd = -1;
  bool _showcd = false;
  late List<List<dynamic>> _ns;

  void initFsm(List<List<dynamic>> ns,
      {int cd = 1,
      int cs = 0,
      bool loop = true,
      bool showcd = false,
      int ms = 1000}) {
    _timer.cancel();
    _ns = ns;
    _cd = cd;
    _cs = cs;
    _showcd = showcd;
    _timer = Timer.periodic(Duration(milliseconds: ms), (timer) => fsm(loop));
  }

  void fsm(bool loop) {
    setState(() {
      _cd--;
      if (_cd <= 0) {
        light1 = 'images/light/${_ns[_cs][0]}.png';
        light2 = 'images/light/${_ns[_cs][1]}.png';
        _cd = (_ns[_cs].length >= 3) ? _ns[_cs][2] : 1;
        _cs++;
      }
    });
    if (_cs >= _ns.length) {
      if (loop) {
        _cs = 0;
      } else {
        _timer.cancel();
      }
    }
  }

  void eventGR() {
    mqttPub('1');
    initFsm([
      ['G', 'R']
    ], loop: false);
  }

  void eventRG() {
    mqttPub('2');
    initFsm([
      ['R', 'G']
    ], loop: false);
  }

  void eventBR() {
    mqttPub('3');
    initFsm(nsBR, ms: 400);
  }

  void eventBY() {
    mqttPub('4');
    initFsm(nsBY, ms: 400);
  }

  void eventMode01() {
    mqttPub('5');
    initFsm(nsG2R1, showcd: true);
  }

  void eventMode02() {
    mqttPub('6');
    initFsm(nsG2R2, showcd: true);
  }

  bool curDir = false;

  void eventCD() {
    mqttPub('7');
    curDir = !curDir;
    (curDir) ? initFsm(nsG2R, loop: false) : initFsm(nsR2G, loop: false);
  }

  void eventXmas() {
    mqttPub('8');
    initFsm(nsXmas, ms: 150);
  }

  TextEditingController txtTopicCtrl =
      TextEditingController(text: 'uproc2021f/traffic/');

  void mqttSub(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  Widget screen() => SizedBox(
        height: 350,
        width: 400,
        child: Card(
            color: Colors.black87,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white12, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              SizedBox(
                height: 50,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo, width: 3.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 3.0),
                    ),
                    hintText: 'MQTT Message Topic...',
                  ),
                  controller: txtTopicCtrl,
                  onSubmitted: (value) => mqttSub(value.toString()),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(light1),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      (_showcd && _cd >= 0) ? _cd.toString() : '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 50, color: Colors.yellowAccent),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(light2),
                    ),
                  ),
                ]),
              ),
            ])),
      );

  Widget keypad() => SizedBox(
        height: 310,
        width: 400,
        child: Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white12, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    eButton(eventGR, '直  行', c: Colors.indigo),
                    space(),
                    eButton(eventRG, '橫  行', c: Colors.indigo),
                  ],
                ),
                space(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    eButton(eventBR, '閃紅燈', c: Colors.red, fc: Colors.black),
                    space(),
                    eButton(eventBY, '閃黃燈', c: Colors.yellow, fc: Colors.black),
                  ],
                ),
                space(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    eButton(eventMode01, '模式 1', c: Colors.blueAccent),
                    space(),
                    eButton(eventMode02, '模式 2', c: Colors.blueAccent),
                  ],
                ),
                space(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    eButton(eventCD, '換向通行', c: Colors.blue),
                    space(),
                    eButton(eventXmas, '聖誕創意', c: Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          screen(),
          keypad(),
        ],
      ),
    );
  }

  List<List<dynamic>> nsBR = [
    ['R', 'R'],
    ['X', 'X'],
  ];

  List<List<dynamic>> nsBY = [
    ['Y', 'Y'],
    ['X', 'X'],
  ];

  List<List<dynamic>> nsG2R1 = [
    ['G', 'R', 3],
    ['Y', 'RY'],
    ['R', 'G', 3],
    ['RY', 'Y'],
  ];

  List<List<dynamic>> nsG2R2 = [
    ['G', 'R', 6],
    ['Y', 'RY'],
    ['R', 'G', 2],
    ['RY', 'Y'],
  ];

  List<List<dynamic>> nsG2R = [
    ['G', 'R'],
    ['Y', 'RY'],
    ['R', 'G'],
  ];

  List<List<dynamic>> nsR2G = [
    ['R', 'G'],
    ['RY', 'Y'],
    ['G', 'R'],
  ];

  final List<List<dynamic>> nsXmas = <List<dynamic>>[
    ['R', 'X'],
    ['Y', 'X'],
    ['G', 'X'],
    ['X', 'G'],
    ['X', 'Y'],
    ['X', 'R'],
    ['R', 'X'],
    ['Y', 'X'],
    ['G', 'X'],
    ['X', 'G'],
    ['X', 'Y'],
    ['X', 'R'],
    ['X', 'X'],
    ['R', 'R'],
    ['X', 'X'],
    ['Y', 'Y'],
    ['X', 'X'],
    ['G', 'G'],
    ['X', 'X'],
    ['Y', 'Y'],
    ['X', 'X'],
    ['R', 'R'],
    ['X', 'R'],
    ['X', 'Y'],
    ['X', 'G'],
    ['G', 'X'],
    ['Y', 'X'],
    ['R', 'X'],
    ['X', 'R'],
    ['X', 'Y'],
    ['X', 'G'],
    ['G', 'X'],
    ['Y', 'X'],
    ['R', 'X'],
    ['X', 'R'],
    ['Y', 'X'],
    ['X', 'Y'],
    ['G', 'X'],
    ['X', 'G'],
    ['G', 'X'],
    ['X', 'Y'],
    ['Y', 'X'],
    ['X', 'R'],
    ['R', 'X'],
  ];
}
