//
//  ConfigureModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigureModel : NSObject<NSCoding>

/// APP状态 （0未同意协议 1未登录 2游客模式 3已登录）
@property (nonatomic, assign) NSInteger appStatus;
/// 游客ID
@property (nonatomic, copy) NSString *visitorId;
/// APP单位（0公制 1英制）
@property (nonatomic, assign) NSInteger distanceUnit;
/// 天气设置单位（0摄氏度 1华氏度）
@property (nonatomic, assign) NSInteger tempUnit;
/// 天气设置时间
@property (nonatomic, assign) NSInteger weatherTime;
/// 同意授权时间
@property (nonatomic, assign) NSInteger dataUploadTime;
/// 同意授权时间
@property (nonatomic, assign) NSInteger agreementTime;
/// 定位经度
@property (nonatomic, copy) NSString *longitude;
/// 定位纬度
@property (nonatomic, copy) NSString *latitude;
/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// 用户token
@property (nonatomic, copy) NSString *token;
/// 设备MAC地址
@property (nonatomic, copy) NSString *macAddr;
/// 拍照开关
@property (nonatomic, assign) BOOL isCamera;
/// 天气开关
@property (nonatomic, assign) BOOL isWeather;
/// 查询经典蓝牙
@property (nonatomic, assign) BOOL isNeedConnect;

@property (nonatomic, assign) NSInteger timeZoneInterval;

/// 单例
+ (__kindof ConfigureModel *)shareInstance;

/// 序列化
+ (void)archiveraModel;

/// 反序列化
+ (void)unarchiverModel;

+ (CGFloat)qiblaAngleFrom:(double)lat lon:(double)lon;

@end

NS_ASSUME_NONNULL_END
