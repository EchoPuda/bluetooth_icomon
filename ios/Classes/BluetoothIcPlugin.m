#import "BluetoothIcPlugin.h"
#import "BluetoothPluginUtil.h"
#import <ICDeviceManager/ICDeviceManager.h>

@interface BluetoothIcPlugin()<ICDeviceManagerDelegate,ICScanDeviceDelegate>

@property (strong, nonatomic)NSMutableArray *items;

@property (strong, nonatomic)BluetoothPluginUtil *util;

@property (strong, nonatomic)ICDevice *device;

@property FlutterResult result;

@end

@implementation BluetoothIcPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"bluetooth_ic"
            binaryMessenger:[registrar messenger]];
  BluetoothIcPlugin* instance = [[BluetoothIcPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    instance.util = [[BluetoothPluginUtil alloc]init];
    instance.util.channel = channel;
    [ICDeviceManager shared].delegate = instance;
    [[ICDeviceManager shared] initMgr];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"getPlatformVersion" isEqualToString:call.method]) {
      [self updateUserInfo:call];
  }  else if ([@"getScanMsg" isEqualToString:call.method]) {
      [self scanDevice];
  }  else if ([@"getBlueTooth" isEqualToString:call.method]) {
      [self updateUserInfo:call];
  }  else if ([@"stopScanMsg" isEqualToString:call.method]) {
      [self updateUserInfo:call];
  }  else if ([@"getBlueTooth" isEqualToString:call.method]) {
      [self updateUserInfo:call];
  }  else if ([@"getDeviceMsg" isEqualToString:call.method]) {
            //获取设备连接
      [self getDeviceMsg:call result:result];

  } else if ([@"removeDevice" isEqualToString:call.method]) {
      [self removeDevice:call result:result];
      //取消设备连接
  }else {
    result(FlutterMethodNotImplemented);
  }
    
    
}

- (void) getDeviceMsg:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.device.macAddr = call.arguments;
    [[ICDeviceManager shared] addDevice:_device callback:^(ICDevice *device, ICAddDeviceCallBackCode code) {
        if (code == ICAddDeviceCallBackCodeSuccess) {
            result(@"success");
        } else {
            result(@"fail");
        }
    }];
}

- (void)removeDevice:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (_device != nil) {
        if ([_device.macAddr isEqualToString:call.arguments]) {
            [[ICDeviceManager shared] removeDevice:_device callback:nil];
        } else {
            self.device.macAddr = call.arguments;
            [[ICDeviceManager shared] removeDevice:_device callback:nil];
        }
    }
}

- (void)initBluetooth{
   
}

- (void)onBleState:(ICBleState)state{
    if (state == ICBleStatePoweredOn) {
        [_util sendBleState:YES];
    } else {
        [_util sendBleState:NO];
    }
}

-(void)onDeviceConnectionChanged:(ICDevice *)device state:(ICDeviceConnectState)state{
    //连接状态
    if (state == ICDeviceConnectStateConnected) {
        [_util sendDeviceState:YES];
    } else {
        [_util sendDeviceState:NO];
    }
}

- (void)onInitFinish:(BOOL)bSuccess{
    [_util onInitFinish:bSuccess];
}

- (void)onScanResult:(ICScanDeviceInfo *)deviceInfo{
    BOOL isE = NO;
    for (ICScanDeviceInfo *devic in _items) {
        if ([devic.macAddr isEqualToString:deviceInfo.macAddr]) {
            isE = YES;
            break;
        }
    }
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"name"] = deviceInfo.name;
    info[@"macAddr"] = deviceInfo.macAddr;
    if (deviceInfo.type == ICDeviceTypeRuler) {
        info[@"type"] = @"围度尺";
    } else if(deviceInfo.type == ICDeviceTypeFatScale || deviceInfo.type == ICDeviceTypeFatScaleWithTemperature){
        info[@"type"] = @"体脂秤";
    } else if(deviceInfo.type == ICDeviceTypeBalance){
        info[@"type"] = @"紧致宝";
    }
    if (!isE) {
        [_items addObject:deviceInfo];
        [self.util sendScanResult:info];
    }
}

- (void)updateUserInfo:(FlutterMethodCall*)call{
    
    ICUserInfo * info = [[ICUserInfo alloc]init];
    if (call != nil) {
        info.rulerUnit = ICRulerUnitInch;
        info.age = [call.arguments[@"age"] integerValue];
        info.weight = [call.arguments[@"weight"] doubleValue];
        info.height = [call.arguments[@"height"] integerValue];
        info.sex = [call.arguments[@"sex"] integerValue] == 0 ? ICSexTypeMale : ICSexTypeFemal;
        info.userIndex = 1;
        info.bfaType = ICBFATypeNoContainWater;
        [[ICDeviceManager shared] updateUserInfo:info];
        
    }
}


/**
 体重秤数据回调
 
 @param device 设备
 @param data 测量数据
 */
- (void)onReceiveWeightData:(ICDevice *)device data:(ICWeightData *)data{
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"bmi"] = @(data.bmi);
    info[@"bmr"] = @(data.bmr);
    info[@"bodyFatPercent"] = @(data.bodyFatPercent);
    info[@"boneMass"] = @(data.boneMass);
    info[@"electrode"] = @(data.electrode);
    info[@"hr"] = @(data.hr);
    info[@"imp"] = @(data.imp);
    info[@"isStabilized"] = @(data.isStabilized);
    info[@"moisturePercent"] = @(data.moisturePercent);
    info[@"musclePercent"] = @(data.musclePercent);
    info[@"physicalAge"] = @(data.physicalAge);
    info[@"proteinPercent"] = @(data.proteinPercent);
    info[@"smPercent"] = @(data.smPercent);
    info[@"subcutaneousFatPercent"] = @(data.subcutaneousFatPercent);
    info[@"temperature"] = @(data.temperature);
    info[@"time"] = @(data.time);
    info[@"visceralFat"] = @(data.visceralFat);
    info[@"weight_kg"] = @(data.weight_kg);
    [_util sendFatScaleMsg:info];
}


/**
 厨房秤数据回调
 
 @param device 设备
 @param data 测量数据
 */
- (void)onReceiveKitchenScaleData:(ICDevice *)device data:(ICKitchenScaleData *)data{
    
}


/**
 厨房秤单位改变
 
 @param device 设备
 @param unit 改变后的单位
 */
- (void)onReceiveKitchenScaleUnitChanged:(ICDevice *)device unit:(ICKitchenScaleUnit)unit{
    
}


/**
 平衡秤坐标数据回调
 
 @param device 设备
 @param data 测量坐标数据
 */
- (void)onReceiveCoordData:(ICDevice *)device data:(ICCoordData *)data{
    
}

/**
 围尺数据回调
 
 @param device 设备
 @param data 测量数据
 */
- (void)onReceiveRulerData:(ICDevice *)device data:(ICRulerData *)data{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    if (data.isStabilized) {
        info[@"distance"] = @(data.distance_cm);
        info[@"time"] = @(data.time);
        [_util sendRulerMsg:info];
    }
}

/**
 平衡数据回调
 
 @param device 设备
 @param data 平衡数据
 */
- (void)onReceiveWeightCenterData:(ICDevice *)device data:(ICWeightCenterData *)data{
    
}

/**
 设备单位改变回调
 
 @param device  设备
 @param unit    设备当前单位
 */
- (void)onReceiveWeightUnitChanged:(ICDevice *)device unit:(ICWeightUnit)unit{
    
}


/**
 围尺单位改变回调
 
 @param device 设备
 @param unit 设备当前单位
 */
- (void)onReceiveRulerUnitChanged:(ICDevice *)device unit:(ICRulerUnit)unit{
    
}

/**
 围尺测量模式改变回调
 
 @param device 设备
 @param mode 设备当前测量模式
 */
- (void)onReceiveRulerMeasureModeChanged:(ICDevice *)device mode:(ICRulerMeasureMode)mode{
    
}


/**
 4个传感器数据回调
 
 @param device 设备
 @param data 传感器数据
 */
- (void)onReceiveElectrodeData:(ICDevice *)device data:(ICElectrodeData *)data{
    
}

/**
 分步骤体重、平衡、阻抗、心率数据回调
 
 @param device  设备
 @param step    当前处于的步骤
 @param data    数据
 */
- (void)onReceiveMeasureStepData:(ICDevice *)device step:(ICMeasureStep)step data:(NSObject *)data{
    
}

/**
 体重历史数据回调
 
 @param device 设备
 @param data 体重历史数据
 */
- (void)onReceiveWeightHistoryData:(ICDevice *)device data:(ICWeightHistoryData *)data{
    
}





- (void)scanDevice{
    [[ICDeviceManager shared] scanDevice:self];
}

- (NSMutableArray *)items{
    if (!_items) {
        self.items = [NSMutableArray array];
    }
    return _items;
}

- (ICDevice *)device{
    if (!_device) {
        self.device = [[ICDevice alloc]init];
    }
    return _device;
}

@end
