//
//  BluetoothPluginUtil.h
//  bluetooth_ic
//
//  Created by 曾宪程 on 2019/8/22.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BluetoothPluginUtil : NSObject

@property (strong, nonatomic)FlutterMethodChannel *channel;

- (void)testConect:(NSString*)result;

- (void)sendScanResult:(NSDictionary*)map;

- (void)onInitFinish:(BOOL)b;

- (void)sendBleState:(BOOL)b;

- (void)sendDeviceState:(BOOL)b;

- (void)sendRulerMsg:(NSDictionary*)map;

- (void)sendFatScaleMsg:(NSDictionary*)map;

- (void)sendBalanceMsg:(NSString*)str;

@end

NS_ASSUME_NONNULL_END
