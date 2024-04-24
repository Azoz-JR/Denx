//
//  DataUploadManager.h
//  DHSFit
//
//  Created by DHS on 2022/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataUploadManager : NSObject

/// 上传所有数据
+ (void)uploadAllHealthData;
/// 下载所有数据
+ (void)downloadAllHealthData;

#pragma mark - 上传数据
/// 上传计步
+ (void)uploadDailySteps;
/// 上传睡眠
+ (void)uploadDailySleeps;
/// 上传心率
+ (void)uploadDailyHrs;
/// 上传血压
+ (void)uploadDailyBps;
/// 上传血氧
+ (void)uploadDailyBos;
/// 上传体温
+ (void)uploadDailyTemps;
/// 上传呼吸训练
+ (void)uploadDailyBreaths;
/// 上传运动
+ (void)uploadDailySports;

#pragma mark - 下载数据
/// 下载计步
+ (void)downloadDailySteps;
/// 下载睡眠
+ (void)downloadDailySleeps;
/// 下载心率
+ (void)downloadDailyHrs;
/// 下载血压
+ (void)downloadDailyBps;
/// 下载血氧
+ (void)downloadDailyBos;
/// 下载体温
+ (void)downloadDailyTemps;
/// 下载呼吸训练
+ (void)downloadDailyBreaths;
/// 下载运动
+ (void)downloadDailySports;


@end

NS_ASSUME_NONNULL_END
