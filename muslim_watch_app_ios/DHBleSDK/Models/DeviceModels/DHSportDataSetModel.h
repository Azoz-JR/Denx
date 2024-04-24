//
//  DHSportDataSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHSportDataSetModel : NSObject

/// 是否结束
@property (nonatomic, assign) BOOL isStop;
/// 是否有地图轨迹
@property (nonatomic, assign) BOOL isMap;
/// 时长（秒）
@property (nonatomic, assign) NSInteger duration;
/// 步数（步）
@property (nonatomic, assign) NSInteger step;
/// 距离（米）
@property (nonatomic, assign) NSInteger distance;
/// 消耗（卡路里）
@property (nonatomic, assign) NSInteger calorie;
/// 公制配速（秒/公里）
@property (nonatomic, assign) NSInteger metricPace;
/// 英制配速（秒/英里）
@property (nonatomic, assign) NSInteger imperialPace;
/// 步频（步/分钟）
@property (nonatomic, assign) NSInteger strideFrequency;
/// 时间戳（秒）
@property (nonatomic, assign) NSInteger timestamp;

@property (nonatomic, assign) UInt16 jlAltitude; //海拔高度 单位：m
@property (nonatomic, assign) UInt16 jlAirPressure;//气压 单位：帕卡
@property (nonatomic, assign) UInt32 jlAveSpeed;//平均速度 单位：千米每小时
@property (nonatomic, assign) UInt8 jlWorkMode; //运动模式

- (NSData *)valueWithJL;

@end

NS_ASSUME_NONNULL_END
