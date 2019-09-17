//
//  ICKitchenScaleData.h
//  ICDeviceManager
//
//  Created by Symons on 2018/8/20.
//  Copyright © 2018年 Symons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICConstant.h"

/**
 厨房秤数据
 */
@interface ICKitchenScaleData : NSObject

/**
 数据是否稳定数, 不稳定的数据只做展示用，请勿保存
 */
@property (nonatomic, assign) BOOL isStabilized;

/**
 数据值,单位:G
 */
@property (nonatomic, assign) float value_g;

/**
 数据值,单位:ml
 */
@property (nonatomic, assign) float value_ml;

/**
 数据值,单位:lb:oz中的lb
 */
@property (nonatomic, assign) NSUInteger value_lb;

/**
 数据值,单位:lb:oz中的oz
 */
@property (nonatomic, assign) float value_lb_oz;

/**
 数据值,单位:fl.oz中
 */
@property (nonatomic, assign) NSUInteger value_fl_oz;

/**
 测量时间戳(秒)
 */
@property (nonatomic, assign) NSUInteger time;

/**
 本次数据单位
 */
@property (nonatomic, assign) ICKitchenScaleUnit unit;

/**
 小数点位数,如:value_g=70.12,则precision=2，value_g=71.5,则precision=1
 */
@property (nonatomic, assign) NSUInteger precision;

@end
