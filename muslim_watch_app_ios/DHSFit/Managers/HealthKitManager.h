//
//  HealthKitManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HealthKitManager : NSObject

+ (__kindof HealthKitManager *)shareInstance;

/// 上传数据
/// @param healthType 类型
/// @param value 数据
/// @param startDate 开始时间
/// @param endDate 结束时间
- (void)saveOrReplace:(HealthType) healthType value:(NSString *)value startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end

NS_ASSUME_NONNULL_END
