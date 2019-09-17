//
//  BluetoothPluginUtil.m
//  bluetooth_ic
//
//  Created by 曾宪程 on 2019/8/22.
//

#import "BluetoothPluginUtil.h"

@implementation BluetoothPluginUtil

- (void)testConect:(NSString*)result{
    [_channel invokeMethod:@"getTestResult" arguments:result];
}

- (void)sendScanResult:(NSDictionary*)map{
    [_channel invokeMethod:@"onScanResult" arguments:map];
}

- (void)onInitFinish:(BOOL)b{
    [_channel invokeMethod:@"onInitFinish" arguments:b ? @"1" : @"0"];
}

- (void)sendBleState:(BOOL)b{
    [_channel invokeMethod:@"sendBleState" arguments:b ? @"1" : @"0"];
}

- (void)sendDeviceState:(BOOL)b{
    [_channel invokeMethod:@"onDeviceState" arguments:b ? @"1" : @"0"];
}

- (void)sendRulerMsg:(NSDictionary*)map{
    [_channel invokeMethod:@"onRulerMsg" arguments:map];
}

- (void)sendFatScaleMsg:(NSDictionary*)map{
    [_channel invokeMethod:@"onFatScaleMsg" arguments:map];
}

- (void)sendBalanceMsg:(NSString*)str{
    [_channel invokeMethod:@"onBalanceMsg" arguments:str];
}

@end
