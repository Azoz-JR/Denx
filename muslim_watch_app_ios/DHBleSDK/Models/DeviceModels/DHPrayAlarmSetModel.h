//
//  DHPrayAlarmSetModel.h
//  DHSFit
//
//  Created by liwei qiao on 2023/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHPrayAlarmSetModel : NSObject
/// 开关（0.关 1.开）
@property (nonatomic, assign) BOOL isOpen;
/// 小时（0-23）
@property (nonatomic, assign) NSInteger hour;
/// 分钟（0-59）
@property (nonatomic, assign) NSInteger minute;
/// 标签
@property (nonatomic, assign) NSInteger alarmType;

@property (nonatomic, assign) NSString *alarmBody;

- (NSData *)valueWithJL;

@end

NS_ASSUME_NONNULL_END
