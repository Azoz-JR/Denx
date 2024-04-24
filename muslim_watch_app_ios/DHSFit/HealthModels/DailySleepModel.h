//
//  DailySleepModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailySleepModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;
/// 是否上传
@property (nonatomic, assign) BOOL isUpload;

/// 日期yyyyMMdd
@property (nonatomic, copy) NSString *date;
/// 日期时间戳（秒）
@property (nonatomic, copy) NSString *timestamp;

/// 总睡眠时长(分)
@property (nonatomic,assign) NSInteger total;
/// 深睡时长(分)
@property (nonatomic,assign) NSInteger deep;
/// 浅睡时长(分)
@property (nonatomic,assign) NSInteger light;
/// 清醒时长(分)
@property (nonatomic,assign) NSInteger wake;
/// 清醒次数
@property (nonatomic,assign) NSInteger wakeCount;
/// 开始入睡时间戳，秒
@property (nonatomic,copy) NSString *beginTime;
/// 开始入睡时间戳，秒
@property (nonatomic,copy) NSString *endTime;

/// items 例：@[@{@"status":@0,@"value":@60},...]
/// status（睡眠类型）value（时长（分钟））
/// status（0.清醒 1.浅睡 2.深睡）
@property (nonatomic, copy) NSString *items;

@property (nonatomic, assign) BOOL isJLType;

/// 取指定一天数据，没有数据初始化一个
+ (__kindof DailySleepModel *)currentModel:(NSString *)date;

/// 取一个范围内的数据，没有数据的初始化一个空数据
+ (NSArray *)queryModels:(NSString *)startDateStr endDateStr:(NSString *)endDateStr;

/// 获取某年的每月统计数据
/// @param date 日期
+ (NSArray *)queryYearModels:(NSDate *)date;

/// 查询需要上传的数据
+ (NSArray *)queryUploadModels;

/// 查询游客数据
+ (NSArray *)queryVisitorModels;

/// 查询指定模型
/// @param timestamp 时间戳
+ (DailySleepModel *)queryModel:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
