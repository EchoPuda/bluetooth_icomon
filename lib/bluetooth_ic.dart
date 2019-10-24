import 'dart:async';

import 'package:flutter/services.dart';

import 'model/fat_scale_msg.dart';
import 'model/scan_result.dart';
import 'model/ruler_msg.dart';

///@author puppet
class BluetoothIc {

}

final MethodChannel _channel =
const MethodChannel('bluetooth_ic')..setMethodCallHandler(_handler);

Future<String> get platformVersion async {
  final String version = await _channel.invokeMethod('getPlatformVersion');
  return version;
}

Future<String> get bluetoothMacAddr async {
  String result = await _channel.invokeMethod("getBlueTooth");
  return result;
}

///更新用户信息
Future updateUserInfo(
    {int age : 0,
      double weight : 0,
      int height : 0,
      int sex : 0}) async {
    String result = await _channel.invokeMethod("updateUserInfo", {
      "age": age,
      "weight": weight,
      "height": height,
      "sex": sex
  });
  return result;
}

///开始扫描
Future getScanMsg() async {
  String result = await _channel.invokeMethod("getScanMsg");
  return result;
}

///停止扫描
Future stopScanMsg() async {
  String result = await _channel.invokeMethod("stopScanMsg");
  return result;
}

///获取设备数据
Future getDeviceMsg(
    { String macAddr }) async {
  String result = await _channel.invokeMethod("getDeviceMsg", {
    "macAddr": macAddr,
  });
  return result;
}

///设备解除绑定
///结束使用或切换设备时都得先解除已绑定设备
Future removeDevice(
    { String macAddr }) async {
  String result = await _channel.invokeMethod("removeDevice", {
    "macAddr": macAddr,
  });
  return result;
}

///测试接受数据
StreamController<String> _controller = new StreamController.broadcast();

Stream<String> get responseFromTest => _controller.stream;

///扫描结果
StreamController<ScanResult> _scanResultController = new StreamController.broadcast();

Stream<ScanResult> get responseFromScan => _scanResultController.stream;

///初始化完成回调
///"0": false , "1": true
StreamController<String> _initFinishController = new StreamController.broadcast();

Stream<String> get responseFromInitSdkFinish => _initFinishController.stream;

///蓝牙状态回调
///"0": false , "1": true
StreamController<String> _isBlueOpenController = new StreamController.broadcast();

Stream<String> get responseFromBleState => _isBlueOpenController.stream;

///设备状态回调
///"0": false , "1": true
StreamController<String> _deviceStateController = new StreamController.broadcast();

Stream<String> get responseFromDeviceState => _deviceStateController.stream;

///维度尺信息回调
StreamController<RulerMsg> _rulerMsgController = new StreamController.broadcast();

Stream<RulerMsg> get responseFromRulerMsg => _rulerMsgController.stream;

///体脂秤信息回调
StreamController<FatScaleMsg> _fatScaleMsgController = new StreamController.broadcast();

Stream<FatScaleMsg> get responseFromFatScaleMsg => _fatScaleMsgController.stream;

///紧致宝信息回调
StreamController<String> _balanceController = new StreamController.broadcast();

Stream<String> get responseFromBalanceMsg => _balanceController.stream;


Future<dynamic> _handler(MethodCall methodCall) {
  if ("getTestResult" == methodCall.method) {
    _controller.add(methodCall.arguments);
  } else if ("onScanResult" == methodCall.method) {
    _scanResultController
        .add(ScanResult.fromMap(methodCall.arguments));
  } else if ("onInitFinish" == methodCall.method) {
    _initFinishController
        .add(methodCall.arguments);
  } else if ("onBleState" == methodCall.method) {
    _isBlueOpenController
        .add(methodCall.arguments);
  } else if ("onDeviceState" == methodCall.method) {
    _deviceStateController
        .add(methodCall.arguments);
  } else if ("onRulerMsg" == methodCall.method) {
    _rulerMsgController
        .add(RulerMsg.fromMap(methodCall.arguments));
  } else if ("onFatScaleMsg" == methodCall.method) {
    _fatScaleMsgController
        .add(FatScaleMsg.fromMap(methodCall.arguments));
  } else if ("onBalanceMsg" == methodCall.method) {
    _balanceController
        .add(methodCall.arguments);
  }
  return Future.value(true);
}
