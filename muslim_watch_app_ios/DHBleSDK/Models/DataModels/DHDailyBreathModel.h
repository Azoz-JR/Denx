//
//  DHDailyBreathModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDailyBreathModel : NSObject

/// 时间戳（秒）
@property (nonatomic, copy) NSString *timestamp;
/// 日期yyyyMMdd
@property (nonatomic, copy) NSString *date;

/// 呼吸项  例：@[@{@"timestamp":@0,@"value":@2},...]
/// timestamp（时间戳（秒））value（时长（分钟））
@property (nonatomic,strong) NSArray <NSDictionary *>*items;

@end

NS_ASSUME_NONNULL_END
