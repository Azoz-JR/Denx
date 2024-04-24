//
//  DHReminderModeSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHReminderModeSetModel : NSObject

/// 提醒模式（ 0.振动 1.亮屏 2.振动+亮屏）
@property (nonatomic, assign) NSInteger reminderMode;

@end

NS_ASSUME_NONNULL_END
