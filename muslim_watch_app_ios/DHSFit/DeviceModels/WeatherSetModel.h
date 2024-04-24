//
//  WeatherSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// APP名称
@property (nonatomic, copy) NSString *appName;
/// 日期
@property (nonatomic, copy) NSString *date;
/// 小时
@property (nonatomic, assign) NSInteger hour;
/// items 例：@[@{@"type":@0,@"maxTemp":@30,@"minTemp":@20,@"currentTemp":@28},...]
/// type（天气类型）maxTemp（最高气温）minTemp（最低气温） currentTemp（当前气温）单位：摄氏度）
/// 天气类型（0.无 1.晴 2.多云 3.多云转晴 4.小雨 5.中雨 6.大雨 7.阵雨 8.雷阵雨 9.小雪 10.中雪 11.大雪 12.雨夹雪 13.雾 14.沙尘暴）
/// 固定3个item 3天数据
@property (nonatomic, copy) NSString *items;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof WeatherSetModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
