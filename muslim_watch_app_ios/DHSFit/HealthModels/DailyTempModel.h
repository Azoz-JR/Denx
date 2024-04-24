//
//  DailyTempModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyTempModel : DHBaseModel

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

/// 最近一次体温
@property (nonatomic,assign) NSInteger lastTemp;
/// 平均体温
@property (nonatomic,assign) NSInteger avgTemp;
/// 最大体温
@property (nonatomic,assign) NSInteger maxTemp;
/// 最小体温
@property (nonatomic,assign) NSInteger minTemp;

/// items 例：@[@{@"timestamp":@0,@"value":@80},...]
/// timestamp（时间戳（秒））value（血氧值）
@property (nonatomic, copy) NSString *items;

/// 取指定一天数据，没有数据初始化一个
+ (__kindof DailyTempModel *)currentModel:(NSString *)date;

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
+ (DailyTempModel *)queryModel:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
