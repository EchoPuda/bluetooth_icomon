import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bluetooth_ic/bluetooth_ic.dart' as bluetooth;
import 'model/scan_result.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _response = "no";

  List<Widget> listScan = new List();

  List<Widget> list = new List();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    bluetooth.responseFromScan.listen((data) {
      print(data.macAddr);
      listScan.add(new Item(name: data.name,deviceState: data.macAddr,));
      setState(() {
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await bluetooth.bluetoothMacAddr;
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

  Widget _getListData(BuildContext context,int position) {
    if (listScan != null) {
      return listScan[position];
    }
    return SizedBox();
  }

  Widget _getListMsgData(BuildContext context,int position) {
    if (list != null) {
      return list[position];
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              Text("response: $_response"),
              new Expanded(
                child: new ListView.builder(
                    itemCount: listScan == null ? 0 : listScan.length,
                    itemBuilder: (BuildContext context,int position) {
                      return _getListData(context, position);
                    }
                ),
                flex: 1,
              ),
              new Expanded(
                child: new ListView.builder(
                    itemCount: list == null ? 0 : list.length,
                    itemBuilder: (BuildContext context,int position) {
                      return _getListMsgData(context, position);
                    }
                ),
                flex: 1,
              ),
            ],
          )

        ),
      ),
    );
  }
}

class Item extends StatefulWidget {
  Item({Key key,this.name : "",this.deviceState : ""}) : super(key : key);
  final String name;
  final String deviceState;

  @override
  State<StatefulWidget> createState() => new ItemState();
}

class ItemState extends State<Item> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.maxFinite,
      child: InkWell(
        child: new Padding(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue
                  ),
                ),
              ),
              new Text(
                widget.deviceState,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
