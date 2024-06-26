//
//  DHDisturbModeSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDisturbModeSetModel : NSObject

/// 开关（0.关 1.开）
@property (nonatomic, assign) BOOL isOpen;
/// 全天开关（0.关 1.开）
@property (nonatomic, assign) BOOL isAllday;
/// 开始小时（0-23）
@property (nonatomic, assign) NSInteger startHour;
/// 开始分钟（0-59）
@property (nonatomic, assign) NSInteger startMinute;
/// 结束小时（0-23）
@property (nonatomic, assign) NSInteger endHour;
/// 结束分钟（0-59）
@property (nonatomic, assign) NSInteger endMinute;


- (NSData *)valueWithJL;

@end

NS_ASSUME_NONNULL_END
