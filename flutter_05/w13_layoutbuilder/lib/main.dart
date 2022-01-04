import 'package:flutter/material.dart';

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
            'Layout Builder Demo',
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
        child: Text(s, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _portrait() {
    return Card(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _image(),
            _infoText(),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              myTextButton(previous, 'Previous', Colors.blueAccent, 140),
              const SizedBox(width: 30),
              myTextButton(next, 'Next', Colors.blueAccent, 140),
            ]),
          ]),
    );
  }

  Widget _ctrlBT() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        myTextButton(previous, 'Previous', Colors.blueAccent, 100),
        const SizedBox(width: 50),
        myTextButton(next, 'Next', Colors.blueAccent, 100),
      ],
    );
  }

  Widget _infoText() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
            "聖弗朗西斯科（英語：San Francisco），中文通常譯作舊金山或三藩市，官方正式名稱為舊金山市郡（City and County of San Francisco），是一座位於美國加利福尼亞州中部沿海的重要經濟都市，為加州唯一市郡合一的行政區，亦別名「金門城市」、「灣邊之城」、「霧城」等。位於舊金山半島的北端，東臨舊金山灣、西臨太平洋，人口86萬，為加州第四大城，僅次於洛杉磯，聖地牙哥及聖荷西；其與灣邊各都市組成的舊金山灣區，人口總數達768萬，是僅次於大洛杉磯地區的美國西岸第二大都會區[5]。"),
      ),
    );
  }

  Widget _image() {
    return Expanded(
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset(img),
      )),
    );
  }

  Widget _landscape() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _image(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _infoText(),
              _ctrlBT(),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 600) {
          return _portrait();
        } else {
          return _landscape();
        }
      },
    );
  }
}
