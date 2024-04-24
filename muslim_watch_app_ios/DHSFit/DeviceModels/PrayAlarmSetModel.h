//
//  PrayAlarmSetModel.h
//  DHSFit
//
//  Created by liwei qiao on 2023/5/22.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrayAlarmSetModel : DHBaseModel
/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 闹钟标签（名字）
@property (nonatomic, assign) NSInteger alarmType;
/// 开关
@property (nonatomic, assign) BOOL isOpen;
/// 小时
@property (nonatomic, assign) NSInteger hour;
/// 分钟
@property (nonatomic, assign) NSInteger minute;

@property (nonatomic, assign) NSString *alarmBody;

/// 查询数据库,如果查询不到初始化新的model对象
+ (NSArray <PrayAlarmSetModel *>*)queryAllPrayAlarms;

/// 删除所有闹钟
+ (void)deleteAllPrayAlarms;

@end

NS_ASSUME_NONNULL_END
