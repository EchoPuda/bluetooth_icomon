package com.ewhale.bluetooth_ic.handler;

import android.app.Activity;
import android.content.Context;

import java.util.ArrayList;
import java.util.HashMap;

import cn.icomon.icdevicemanager.ICDeviceManager;
import cn.icomon.icdevicemanager.ICDeviceManagerDelegate;
import cn.icomon.icdevicemanager.callback.ICScanDeviceDelegate;
import cn.icomon.icdevicemanager.model.data.ICCoordData;
import cn.icomon.icdevicemanager.model.data.ICKitchenScaleData;
import cn.icomon.icdevicemanager.model.data.ICRulerData;
import cn.icomon.icdevicemanager.model.data.ICWeightCenterData;
import cn.icomon.icdevicemanager.model.data.ICWeightData;
import cn.icomon.icdevicemanager.model.data.ICWeightHistoryData;
import cn.icomon.icdevicemanager.model.device.ICDevice;
import cn.icomon.icdevicemanager.model.device.ICScanDeviceInfo;
import cn.icomon.icdevicemanager.model.device.ICUserInfo;
import cn.icomon.icdevicemanager.model.other.ICConstant;
import cn.icomon.icdevicemanager.model.other.ICDeviceManagerConfig;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static cn.icomon.icdevicemanager.model.other.ICConstant.ICBFAType.ICBFATypeNoContainWater;
import static cn.icomon.icdevicemanager.model.other.ICConstant.ICBleState.ICBleStatePoweredOn;
import static cn.icomon.icdevicemanager.model.other.ICConstant.ICDeviceConnectState.ICDeviceConnectStateConnected;
import static cn.icomon.icdevicemanager.model.other.ICConstant.ICDeviceConnectState.ICDeviceConnectStateDisconnected;
import static cn.icomon.icdevicemanager.model.other.ICConstant.ICDeviceType.ICDeviceTypeBalance;
import static cn.icomon.icdevicemanager.model.other.ICConstant.ICDeviceType.ICDeviceTypeFatScale;
import static cn.icomon.icdevicemanager.model.other.ICConstant.ICDeviceType.ICDeviceTypeFatScaleWithTemperature;
import static cn.icomon.icdevicemanager.model.other.ICConstant.ICDeviceType.ICDeviceTypeRuler;
import static cn.icomon.icdevicemanager.model.other.ICConstant.ICPeopleType.ICPeopleTypeNormal;
import static cn.icomon.icdevicemanager.model.other.ICConstant.ICRulerUnit.ICRulerUnitInch;

/**
 * @author Puppet
 */
public class BluetoothHandler implements ICDeviceManagerDelegate, ICScanDeviceDelegate {

    private static ArrayList<ICScanDeviceInfo> listDevices = new ArrayList<>();

    private static PluginRegistry.Registrar registrar = null;

    private static ICDevice device = new ICDevice();

    public static void setRegistrar(PluginRegistry.Registrar registrar) {
        BluetoothHandler.registrar = registrar;
    }

    public static void sendExampleMsg(MethodCall call, MethodChannel.Result result) {
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        BluetoothResponseHandler.testConnect("yes");
    }

    /**
     * 更新用户数据
     */
    public static void updateUserInfo(MethodCall call, MethodChannel.Result result) {
        ICUserInfo userInfo = new ICUserInfo();
        if (call != null) {
            userInfo.rulerUnit = ICRulerUnitInch;
            userInfo.age = call.argument("age");
            userInfo.weight = (double) call.argument("weight");
            userInfo.height = call.argument("height");
            userInfo.sex = (int) call.argument("sex") == 0
                    ? ICConstant.ICSexType.ICSexTypeMale : ICConstant.ICSexType.ICSexTypeFemal;
            userInfo.userIndex = 1;
            userInfo.bfaType = ICBFATypeNoContainWater;
            userInfo.peopleType = ICPeopleTypeNormal;
            //更新用户数据
            ICDeviceManager.shared().updateUserInfo(userInfo);
            result.success("success");
        }
    }

    /**
     * 获取相应设备回调
     */
    public static void getDeviceMsg(MethodCall call, final MethodChannel.Result result) {
        String mac = call.argument("macAddr");
        device.setMacAddr(mac);
        ICDeviceManager.shared().addDevice(device, new ICConstant.ICAddDeviceCallBack() {
            @Override
            public void onCallBack(ICDevice icDevice, ICConstant.ICAddDeviceCallBackCode icAddDeviceCallBackCode) {
                if ("ICAddDeviceCallBackCodeSuccess".equals(icAddDeviceCallBackCode + "")) {
                    System.out.println("000");
                    result.success("success");
                }
                System.out.println(icAddDeviceCallBackCode);
            }
        });
    }

    /**
     * 取消设备连接，不用设备了或者切换设备就要调用
     */
    public static void removeDevice(MethodCall call, final MethodChannel.Result result) {
        String mac = call.argument("macAddr");
        device.setMacAddr(mac);
        if (device != null) {
            if (device.getMacAddr().equals(mac)){
                ICDeviceManager.shared().removeDevice(device,null);
            } else {
                device.setMacAddr(mac);
                ICDeviceManager.shared().removeDevice(device,null);
            }
        }
    }

    /**
     * 初始化
     */
    public static void initBlueDevice(MethodCall call, MethodChannel.Result result) {
        Activity activity = registrar.activity();
        //检查是否开启了蓝牙权限
        if (!ICDeviceManager.checkBlePermission(activity.getBaseContext())) {
            ICDeviceManager.requestBlePermission(activity);
        } else {
            initSDK();
        }
        initSDK();
        ICDeviceManager.shared().setDelegate(new BluetoothHandler());
    }

    /**
     * 初始化
     */
    public static void startScanDevice(MethodCall call, MethodChannel.Result result) {
        ICDeviceManager.shared().scanDevice(new BluetoothHandler());
    }

    /**
     * 初始化
     */
    public static void stopScanDevice(MethodCall call, MethodChannel.Result result) {
        ICDeviceManager.shared().stopScan();
    }

    /**
     * 蓝牙SDK初始化
     */
    private static void initSDK() {
        Context context = registrar.context();
        ICDeviceManagerConfig config = new ICDeviceManagerConfig();
        config.context = context.getApplicationContext();
        //初始化
        ICDeviceManager.shared().initMgrWithConfig(config);
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        ICDeviceManager.shared().stopScan();
    }

    /**
     * 扫描结果回调
     * @param icScanDeviceInfo 扫描的信息
     */
    @Override
    public void onScanResult(ICScanDeviceInfo icScanDeviceInfo) {
//        boolean isEnd = false;
//        for (ICScanDeviceInfo deviceInfo1 : listDevices) {
//            if (deviceInfo1.getMacAddr().equalsIgnoreCase(icScanDeviceInfo.getMacAddr())) {
//                deviceInfo1.setRssi(icScanDeviceInfo.getRssi());
//                isEnd = true;
//                break;
//            }
//        }
        HashMap<String, Object> map = new HashMap<>();
        map.put("name", icScanDeviceInfo.getName());
        map.put("macAddr",icScanDeviceInfo.getMacAddr());
        if (icScanDeviceInfo.getType() == ICDeviceTypeRuler) {
            map.put("type","围度尺");
        } else if (icScanDeviceInfo.getType() == ICDeviceTypeFatScale
                || icScanDeviceInfo.getType() == ICDeviceTypeFatScaleWithTemperature) {
            map.put("type","体脂秤");
        } else if (icScanDeviceInfo.getType() == ICDeviceTypeBalance) {
            map.put("type","紧致宝");
        }
//        if (!isEnd) {
//
//        }
        listDevices.add(icScanDeviceInfo);
        BluetoothResponseHandler.sendScanResult(map);

    }

    /**
     * 初始化结果
     * @param b true false
     */
    @Override
    public void onInitFinish(boolean b) {
        BluetoothResponseHandler.onInitFinish(b);
    }

    /**
     * 蓝牙状态
     * @param icBleState true false
     */
    @Override
    public void onBleState(ICConstant.ICBleState icBleState) {
        if (icBleState == ICBleStatePoweredOn) {
            BluetoothResponseHandler.sendBleState(true);
        } else {
            BluetoothResponseHandler.sendBleState(false);
        }
    }

    /**
     * 设备连接状态
     * @param icDevice
     * @param icDeviceConnectState
     */
    @Override
    public void onDeviceConnectionChanged(ICDevice icDevice, ICConstant.ICDeviceConnectState icDeviceConnectState) {
        if (icDeviceConnectState == ICDeviceConnectStateConnected) {
            BluetoothResponseHandler.sendDeviceState(true);
        } else if (icDeviceConnectState == ICDeviceConnectStateDisconnected) {
            BluetoothResponseHandler.sendDeviceState(false);
        }
    }

    /**
     * 体脂秤数据回调
     */
    @Override
    public void onReceiveWeightData(ICDevice icDevice, ICWeightData icWeightData) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("bmi",icWeightData.bmi);
        map.put("bmr",icWeightData.bmr);
        map.put("bodyFatPercent",icWeightData.bodyFatPercent);
        map.put("boneMass",icWeightData.boneMass);
        map.put("electrode",icWeightData.electrode);
        map.put("hr",icWeightData.hr);
        map.put("imp",icWeightData.imp);
        map.put("isStabilized",icWeightData.isStabilized);
        map.put("moisturePercent",icWeightData.moisturePercent);
        map.put("musclePercent",icWeightData.musclePercent);
        map.put("physicalAge",icWeightData.physicalAge);
        map.put("proteinPercent",icWeightData.proteinPercent);
        map.put("smPercent",icWeightData.smPercent);
        map.put("subcutaneousFatPercent",icWeightData.subcutaneousFatPercent);
        map.put("temperature",icWeightData.temperature);
        map.put("time",String.valueOf(icWeightData.time));
        map.put("visceralFat",icWeightData.visceralFat);
        map.put("weight_kg",icWeightData.weight_kg);
        BluetoothResponseHandler.sendFatScaleMsg(map);
    }

    @Override
    public void onReceiveKitchenScaleData(ICDevice icDevice, ICKitchenScaleData icKitchenScaleData) {

    }

    @Override
    public void onReceiveKitchenScaleUnitChanged(ICDevice icDevice, ICConstant.ICKitchenScaleUnit icKitchenScaleUnit) {

    }

    @Override
    public void onReceiveCoordData(ICDevice icDevice, ICCoordData icCoordData) {

    }

    /**
     * 维度尺数据回调
     */
    @Override
    public void onReceiveRulerData(ICDevice icDevice, ICRulerData icRulerData) {
        HashMap<String, Object> map = new HashMap<>();
        if (icRulerData.isStabilized) {
            map.put("distance",icRulerData.distance_cm);
            map.put("time",String.valueOf(icRulerData.time));
            BluetoothResponseHandler.sendRulerMsg(map);
        }

    }

    @Override
    public void onReceiveWeightCenterData(ICDevice icDevice, ICWeightCenterData icWeightCenterData) {

    }

    @Override
    public void onReceiveWeightUnitChanged(ICDevice icDevice, ICConstant.ICWeightUnit icWeightUnit) {

    }

    @Override
    public void onReceiveRulerUnitChanged(ICDevice icDevice, ICConstant.ICRulerUnit icRulerUnit) {

    }

    @Override
    public void onReceiveRulerMeasureModeChanged(ICDevice icDevice, ICConstant.ICRulerMeasureMode icRulerMeasureMode) {

    }

    @Override
    public void onReceiveMeasureStepData(ICDevice icDevice, ICConstant.ICMeasureStep icMeasureStep, Object o) {

    }

    @Override
    public void onReceiveWeightHistoryData(ICDevice icDevice, ICWeightHistoryData icWeightHistoryData) {

    }
}
