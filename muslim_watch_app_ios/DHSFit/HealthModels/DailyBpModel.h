//
//  DailyBpModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyBpModel : DHBaseModel

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

/// 最近一次收缩压
@property (nonatomic,assign) NSInteger lastSystolic;
/// 最近一次舒张压
@property (nonatomic,assign) NSInteger lastDiastolic;
/// 平均收缩压
@property (nonatomic,assign) NSInteger avgSystolic;
/// 平均舒张压
@property (nonatomic,assign) NSInteger avgDiastolic;
/// 最大收缩压
@property (nonatomic,assign) NSInteger maxSystolic;
/// 最大舒张压
@property (nonatomic,assign) NSInteger maxDiastolic;
/// 最小收缩压
@property (nonatomic,assign) NSInteger minSystolic;
/// 最小舒张压
@property (nonatomic,assign) NSInteger minDiastolic;

/// items 例：@[@{@"timestamp":@0,@"systolic":@120,@"diastolic":@80},...]
/// timestamp（时间戳（秒））systolic（收缩压））diastolic（舒张压））
@property (nonatomic, copy) NSString *items;

/// 取指定一天数据，没有数据初始化一个
+ (__kindof DailyBpModel *)currentModel:(NSString *)date;

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
+ (DailyBpModel *)queryModel:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
