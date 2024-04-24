//
//  BaseTimeModel.h
//  DHSFit
//
//  Created by DHS on 2022/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTimeModel : NSObject

/// 转换成上午下午
/// @param hour 小时
+ (NSInteger)timeSplitIndex:(NSInteger)hour;
/// 转换成小时
/// @param hour 小时
+ (NSInteger)timeHourIndex:(NSInteger)hour;
/// 转换成小时
/// @param hourIndex 小时
/// @param splitIndex 分钟
+ (NSInteger)transHour:(NSInteger)hourIndex splitIndex:(NSInteger)splitIndex;
/// 转换成时间字符串
/// @param hour 小时
/// @param minute 分钟
/// @param isHasAMPM 是否十二小时制
+ (NSString *)transTimeStr:(NSInteger)hour minute:(NSInteger)minute isHasAMPM:(BOOL)isHasAMPM;
/// 转换成重复
/// @param repeats 重复集合
+ (NSString *)repeatsTitle:(NSArray *)repeats;
/// 是否十二小时制
+ (BOOL)isHasAMPM;

@end

NS_ASSUME_NONNULL_END
