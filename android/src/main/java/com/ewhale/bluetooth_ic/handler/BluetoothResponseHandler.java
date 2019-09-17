package com.ewhale.bluetooth_ic.handler;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;

/**
 * @author Puppet
 */
public class BluetoothResponseHandler {

    private static MethodChannel channel = null;

    public static void setMethodChannel(MethodChannel channel) {
        BluetoothResponseHandler.channel = channel;
    }

    public static void testConnect(String result){
        channel.invokeMethod("getTestResult",result);
    }

    public static void sendScanResult(HashMap<String, Object> map){
        channel.invokeMethod("onScanResult", map);
    }

    public static void onInitFinish(Boolean b){
        if (b) {
            channel.invokeMethod("onInitFinish", "1");
        } else {
            channel.invokeMethod("onInitFinish", "0");
        }

    }

    public static void sendBleState(Boolean isOpen){
        if (isOpen) {
            channel.invokeMethod("onBleState", "1");
        } else {
            channel.invokeMethod("onBleState", "0");
        }
    }

    public static void sendDeviceState(Boolean state){
        if (state) {
            channel.invokeMethod("onDeviceState", "1");
        } else {
            channel.invokeMethod("onDeviceState", "0");
        }
    }

    public static void sendRulerMsg(HashMap<String, Object> map){
        channel.invokeMethod("onRulerMsg", map);
    }

    public static void sendFatScaleMsg(HashMap<String, Object> map){
        channel.invokeMethod("onFatScaleMsg", map);
    }

    public static void sendBalanceMsg(String str){
        channel.invokeMethod("onBalanceMsg", str);
    }

}
