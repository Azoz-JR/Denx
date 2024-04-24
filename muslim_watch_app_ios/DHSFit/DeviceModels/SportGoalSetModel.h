//
//  SportGoalSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/8/10.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SportGoalSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 振动开关
@property (nonatomic, assign) BOOL isVibration;
/// 屏幕常亮
@property (nonatomic, assign) BOOL isAlwaysBright;
/// 自动暂停
@property (nonatomic, assign) BOOL isAutoPause;
/// 时长（分钟）
@property (nonatomic, assign) NSInteger duration;
/// 消耗（千卡）
@property (nonatomic, assign) NSInteger calorie;
/// 距离（米）
@property (nonatomic, assign) NSInteger distance;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof SportGoalSetModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
