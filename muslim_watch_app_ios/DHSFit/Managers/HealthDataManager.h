//
//  HealthDataManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HealthType) {
    HealthTypeStep = 0,//计步
    HealthTypeDistance,//距离
    HealthTypeCycling,//骑行
    HealthTypeCalorie,//消耗
    HealthTypeHeartRate,//心率
    HealthTypeHeight,//身高
    HealthTypeWeight,//体重
    HealthTypeTemp,//体温
    HealthTypeStress,//压力
};

typedef NS_ENUM(NSInteger, HealthDataType) {
    HealthDataTypeStep = 0,//计步
    HealthDataTypeSleep,//睡眠
    HealthDataTypeHeartRate,//心率
    HealthDataTypeBP,//血压
    HealthDataTypeBO,//血氧
    HealthDataTypeTemp,//体温
    HealthDataTypeBreath,//呼吸训练
    HealthDataTypePressure,//压力
};

typedef NS_ENUM(NSInteger, SleepDataType) {
    SleepDataTypeWake = 0,//清醒
    SleepDataTypeLight,//浅睡
    SleepDataTypeDeep//深睡 
};

typedef NS_ENUM(NSInteger, HealthDateType) {
    HealthDateTypeDay = 0,//日
    HealthDateTypeWeek,//周
    HealthDateTypeMonth,//月
    HealthDateTypeYear,//年
};

@interface HealthDataManager : NSObject

/// 主色调
/// @param cellType 数据类型
+ (UIColor *)mainColor:(HealthDataType)cellType;

/// 睡眠主色调
/// @param sleepType 睡眠类型
+ (UIColor *)sleepMainColor:(SleepDataType)sleepType;

/// 单位
/// @param cellType 数据类型
+ (NSString *)unitOfType:(HealthDataType)cellType;

/// 图表x轴标题
/// @param dateType 日期类型
+ (NSArray *)chartXTitle:(HealthDateType)dateType;

#pragma mark - 详情TableViewCell内容

/// 日详情数据标题
/// @param type 数据类型
+ (NSArray *)detailDataCellDayTitles:(HealthDataType)type;

/// 周、月、年详情数据标题
/// @param type 数据类型
+ (NSArray *)detailDataCellWeekTitles:(HealthDataType)type;

/// 日详情描述标题
/// @param type 数据类型
+ (NSArray *)detailDescCellTitles:(HealthDataType)type;

/// 周、月、年详情数据标题
/// @param type 数据类型
+ (NSArray *)detailDescCellSubTitles:(HealthDataType)type;

#pragma mark - 日、周、月、年原始数据

/// 日原始数据
/// @param date 日期
/// @param type 数据类型
+ (id)dayChartDatas:(NSDate *)date type:(HealthDataType)type;

/// 周原始数据
/// @param date 日期
/// @param type 数据类型
+ (NSArray *)weekChartDatas:(NSDate *)date type:(HealthDataType)type;

/// 月原始数据
/// @param date 日期
/// @param type 数据类型
+ (NSArray *)monthChartDatas:(NSDate *)date type:(HealthDataType)type;

/// 年原始数据
/// @param date 日期
/// @param type 数据类型
+ (NSArray *)yearChartDatas:(NSDate *)date type:(HealthDataType)type;


#pragma mark - 日、周、月、年图表数据

/// 日图表数据
/// @param date 日期
/// @param type 数据类型
+ (ChartViewModel *)dayChartModel:(NSDate *)date type:(HealthDataType)type;

/// 周图表数据
/// @param date 日期
/// @param type 数据类型
+ (ChartViewModel *)weekChartModel:(NSDate *)date type:(HealthDataType)type;

/// 月图表数据
/// @param date 日期
/// @param type 数据类型
+ (ChartViewModel *)monthChartModel:(NSDate *)date type:(HealthDataType)type;

/// 年图表数据
/// @param date 日期
/// @param type 数据类型
+ (ChartViewModel *)yearChartModel:(NSDate *)date type:(HealthDataType)type;

#pragma mark - 主页图表数据

/// 主页图表数据（日）
/// @param date 日期
/// @param type 数据类型
+ (ChartViewModel *)homeCellChartModel:(NSDate *)date type:(HealthDataType)type;

/// 运动总距离
/// @param type 运动类型
+ (NSInteger)sportTotalDistance:(SportType)type;

#pragma mark - 保存某天的健康数据

/// 保存计步数据
/// @param model 模型
+ (void)saveDailyStepModel:(DHDailyStepModel *)model;

/// 保存睡眠数据
/// @param model 模型
+ (void)saveDailySleepModel:(DHDailySleepModel *)model;

/// 保存心率数据
/// @param model 模型
+ (void)saveDailyHrModel:(DHDailyHrModel *)model;

/// 保存血压数据
/// @param model 模型
+ (void)saveDailyBpModel:(DHDailyBpModel *)model;

/// 保存血氧数据
/// @param model 模型
+ (void)saveDailyBoModel:(DHDailyBoModel *)model;

/// 保存体温数据
/// @param model 模型
+ (void)saveDailyTempModel:(DHDailyTempModel *)model;

/// 保存呼吸训练数据
/// @param model 模型
+ (void)saveDailyBreathModel:(DHDailyBreathModel *)model;

/// 保存运动数据
/// @param model 模型
+ (void)saveDailySportModel:(DHDailySportModel *)model;

+ (void)saveDailyPressureModel:(DHDailyPressureModel *)model;

#pragma mark - 保持主动广播的健康数据item

/// 保存计步数据item
/// @param model 模型
+ (void)saveDailyStepItem:(DHHealthDataModel *)model;

/// 保存心率数据item
/// @param model 模型
+ (void)saveDailyHrItem:(DHHealthDataModel *)model;

/// 保存血压数据item
/// @param model 模型
+ (void)saveDailyBpItem:(DHHealthDataModel *)model;

/// 保存血氧数据item
/// @param model 模型
+ (void)saveDailyBoItem:(DHHealthDataModel *)model;

/// 保存体温数据item
/// @param model 模型
+ (void)saveDailyTempItem:(DHHealthDataModel *)model;

/// 保存呼吸训练数据item
/// @param model 模型
+ (void)saveDailyBreathItem:(DHHealthDataModel *)model;

@end

NS_ASSUME_NONNULL_END
