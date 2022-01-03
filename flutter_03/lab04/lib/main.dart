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
            'RichText - TextSpan',
          )),
          body: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, this.msg = 'STUST'}) : super(key: key);

  final String? msg;

  final String uu = '猶他大學';
  final String p1 =
      '(The University of Utah)是美國猶他州高等教育的旗艦型學校，也是一所享譽世界的公立綜合型大學.學校始建于1850年，位于鹽湖城的沃薩奇嶺山脈的山腳下。作為美國西部最著名且最古老的公立大學之一，';
  final String p2 =
      '被卡耐基教育基金會歸為特高研究型大學(Top-tier Research university), 在美國所有的約3632所被美國教育部識別的大學中，只有107所大學獲此殊榮 。';

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                uu + p1 + uu + p2,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                        text: uu,
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 30)),
                    TextSpan(text: p1),
                    TextSpan(
                        text: uu,
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline)),
                    TextSpan(text: p2),
                  ],
                ),
              ),
            ),
          ),
        ]);
  }
}

