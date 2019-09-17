//
//  ICUserInfo.h
//  ICleDevice
//
//  Created by lifesense－mac on 17/4/18.
//  Copyright © 2017年 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICConstant.h"

/**
 用户信息
 */
@interface ICUserInfo : NSObject

/**
 用户编号,默认:1
 */
@property (nonatomic, assign) NSUInteger userIndex;

/**
 身高(cm),默认:172cm
 */
@property (nonatomic, assign) NSUInteger height;

/**
 体重(kg),默认:60.0kg
 */
@property (nonatomic, assign) float weight;

/**
 年龄,默认:24
 */
@property (nonatomic, assign) NSUInteger age;

/**
 性别,默认:ICSexTypeMale
 */
@property (nonatomic, assign) ICSexType sex;

/**
 使用体脂算法版本,默认:ICBFATypeContainWater
 */
@property (nonatomic, assign) ICBFAType bfaType;

/**
 用户类型,默认:ICPeopleTypeNormal
 */
@property (nonatomic, assign) ICPeopleType peopleType;

/**
 用户默认的体重单位,默认:ICWeightUnitKg
 */
@property (nonatomic, assign) ICWeightUnit weightUnit;

/**
 用户默认的围尺单位,默认:ICRulerUnitCM
 */
@property (nonatomic, assign) ICRulerUnit rulerUnit;

/**
 用户默认的围尺测量模式,默认:ICRulerMeasureModeLength
 */
@property (nonatomic, assign) ICRulerMeasureMode rulerMode;

/**
 厨房秤默认单位,默认:ICKitchenScaleUnitG
 */
@property (nonatomic, assign) ICKitchenScaleUnit kitchenUnit;


@end
