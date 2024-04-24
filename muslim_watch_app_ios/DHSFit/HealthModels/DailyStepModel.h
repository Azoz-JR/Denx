//
//  DailyStepModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyStepModel : DHBaseModel

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

/// 里程（米）
@property (nonatomic, assign) NSInteger distance;
/// 消耗（卡路里）
@property (nonatomic, assign) NSInteger calorie;
/// 步数（步）
@property (nonatomic, assign) NSInteger step;

/// items 例：@[@{@"index":@0,@"step":@100,@"calorie":@10000,@"distance":@50},...]
/// index（序号）step（步数）calorie（消耗） distance（里程）单位同上
/// index从0开始，固定24个item，对应一天24小时
@property (nonatomic, copy) NSString *items;

/// 取指定一天数据，没有数据初始化一个
+ (__kindof DailyStepModel *)currentModel:(NSString *)date;

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
+ (DailyStepModel *)queryModel:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
