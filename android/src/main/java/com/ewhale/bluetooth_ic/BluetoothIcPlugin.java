package com.ewhale.bluetooth_ic;

import com.ewhale.bluetooth_ic.handler.BluetoothHandler;
import com.ewhale.bluetooth_ic.handler.BluetoothRequsetHandler;
import com.ewhale.bluetooth_ic.handler.BluetoothResponseHandler;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * @author Puppet
 */
public class BluetoothIcPlugin implements MethodCallHandler {

    Registrar registrar;
    MethodChannel channel;

    private BluetoothIcPlugin(Registrar registrar, MethodChannel channel){
        this.registrar = registrar;
        this.channel = channel;
    }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "bluetooth_ic");
    BluetoothHandler.setRegistrar(registrar);
    BluetoothRequsetHandler.setRegistrar(registrar);
    BluetoothResponseHandler.setMethodChannel(channel);
    channel.setMethodCallHandler(new BluetoothIcPlugin(registrar, channel));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    if (call.method.equals("getPlatformVersion")) {
        BluetoothHandler.sendExampleMsg(call,result);
    } else if (call.method.equals("getScanMsg")) {
        BluetoothHandler.startScanDevice(call,result);
    } else if (call.method.equals("stopScanMsg")) {
        BluetoothHandler.stopScanDevice(call,result);
    } else if (call.method.equals("getBlueTooth")) {
        BluetoothHandler.initBlueDevice(call,result);
    } else if (call.method.equals("updateUserInfo")) {
        BluetoothHandler.updateUserInfo(call,result);
    } else if (call.method.equals("getDeviceMsg")) {
        BluetoothHandler.getDeviceMsg(call,result);
    } else if (call.method.equals("removeDevice")) {
        BluetoothHandler.removeDevice(call,result);
    } else {
        result.notImplemented();
    }
  }

}
