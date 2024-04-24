//
//  ReminderModeSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReminderModeSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 提醒模式 0振动 1亮屏 2振动+亮屏
@property (nonatomic, assign) NSInteger reminderMode;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof ReminderModeSetModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
