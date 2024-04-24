//
//  AlarmSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlarmSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 序号
@property (nonatomic, assign) NSInteger alarmIndex;
/// 闹钟标签（名字）
@property (nonatomic, copy) NSString *alarmType;
/// 开关
@property (nonatomic, assign) BOOL isOpen;
/// 小时
@property (nonatomic, assign) NSInteger hour;
/// 分钟
@property (nonatomic, assign) NSInteger minute;
/// 重复 @[@0,@0,@0,@0,@0,@0,@0] 周日、周一、周二...
@property (nonatomic,copy) NSString *repeats;

@property (nonatomic, assign) NSInteger jlYear;
@property (nonatomic, assign) NSInteger jlMonth;
@property (nonatomic, assign) NSInteger jlDay;
@property (nonatomic, assign) NSInteger jlAlarmId;

/// 查询数据库,如果查询不到初始化新的model对象
+ (NSArray <AlarmSetModel *>*)queryAllAlarms;

/// 删除所有闹钟
+ (void)deleteAllAlarms;

@end

NS_ASSUME_NONNULL_END
