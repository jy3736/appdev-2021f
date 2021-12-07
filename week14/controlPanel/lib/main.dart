import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Control Panel Sample';

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
                image: AssetImage('images/8.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const MyStatefulWidget(),
          ),
        ));
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final Color kbColor1 = const Color.fromARGB(255, 32, 76, 206);
  final Color kbColor2 = const Color.fromARGB(255, 60, 153, 203);
  final Color kbColor3 = const Color.fromARGB(255, 39, 39, 54);

  String whichBt = 'Hello Flutter';

  Widget eButton(void Function() fun, String s, Color c, double w, double h) {
    return SizedBox(
      width: w,
      height: h,
      child: ElevatedButton(
        child: Text(s),
        style: ElevatedButton.styleFrom(
          primary: c,
          onPrimary: Colors.white,
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontStyle: FontStyle.normal,
          ),
        ),
        onPressed: fun,
      ),
    );
  }

  Widget space() {
    return const SizedBox(
      height: 10,
      width: 30,
    );
  }

  void updateScreen(String s) {
    setState(() {
      whichBt = s;
    });
  }

  void eventHold() => updateScreen('HOLD');

  void eventT1() => updateScreen('T1');

  void eventT2() => updateScreen('T2');

  void eventT1T2() => updateScreen('T1 - T2');

  void eventMax() => updateScreen('MAX');

  void eventMin() => updateScreen('MIN');

  void eventC() => updateScreen('\u2103');

  void eventF() => updateScreen('\u2109');

  Widget screen() => SizedBox(
        height: 200,
        width: 400,
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
              whichBt,
              style: const TextStyle(
                fontSize: 50,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

  Widget keypad() => SizedBox(
        height: 400,
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
                    eButton(eventT1, 'T1', kbColor1, 160, 80),
                    space(),
                    eButton(eventT2, 'T2', kbColor1, 160, 80),
                  ],
                ),
                space(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    eButton(eventHold, 'HOLD', kbColor2, 160, 80),
                    space(),
                    eButton(eventT1T2, 'T1 - T2', kbColor1, 160, 80),
                  ],
                ),
                space(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    eButton(eventMax, 'MAX', kbColor2, 160, 80),
                    space(),
                    eButton(eventMin, 'MIN', kbColor2, 160, 80),
                  ],
                ),
                space(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    eButton(eventC, '\u2103', kbColor3, 160, 80),
                    space(),
                    eButton(eventF, '\u2109', kbColor3, 160, 80),
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
}
