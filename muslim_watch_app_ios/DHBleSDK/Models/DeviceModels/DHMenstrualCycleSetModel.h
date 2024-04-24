//
//  DHMenstrualCycleSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/11/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHMenstrualCycleSetModel : NSObject

/// 类型（0.默认 1.正常 2.孕期）
@property (nonatomic, assign) BOOL type;
/// 开关（0.关 1.开）
@property (nonatomic, assign) BOOL isOpen;
/// 经期提醒开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindMenstrualPeriod;
/// 排卵期提醒开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindOvulationPeriod;
/// 排卵高峰开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindOvulationPeak;
/// 排卵期结束开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindOvulationEnd;

/// 周期天数（15-60）
@property (nonatomic, assign) NSInteger cycleDays;
/// 经期天数（3-15）
@property (nonatomic, assign) NSInteger menstrualDays;

/// 时间戳
@property (nonatomic, assign) NSInteger timestamp;

/// 提醒时间小时（0-23）
@property (nonatomic, assign) NSInteger remindHour;
/// 提醒时间分钟（0-59）
@property (nonatomic, assign) NSInteger remindMinute;

@property (nonatomic, assign) NSInteger jlRemindBeforeDay;//经期提醒,提前0~15天
@property (nonatomic, assign) NSInteger jlRemindOvulationBeforeDay;//排卵期提醒,提前0~15天

- (NSData *)valueWithJL;

@end

NS_ASSUME_NONNULL_END
