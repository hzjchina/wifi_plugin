import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wifi_plugin/wifi_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _wifiName = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await WifiPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> test() async{

    String wifiName;
    try{
      wifiName = await WifiPlugin.wifiName;
    }on PlatformException{
      wifiName = "exception";
    }

    if(!mounted) return;
    setState(() {
      _wifiName = wifiName;
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: Column(children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Center(
              child: Text('wifiName: $_wifiName'),
            ),
            ListTile(
              // tileColor: Colors.red,
              // contentPadding: EdgeInsetsGeometry.lerp(a, b, t),
              title: Text("printLog"),
              // subtitle: Text("test"),
              trailing:Icon(Icons.home),
              // isThreeLine:true,
              leading:Icon(Icons.share),
              onTap: () {
                test();
              },
            ),
          ]),
        ),
      ),
    );
  }
}
