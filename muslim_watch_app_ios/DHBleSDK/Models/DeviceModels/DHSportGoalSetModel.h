//
//  DHSportGoalSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHSportGoalSetModel : NSObject

/// 时长（分钟）
@property (nonatomic, assign) NSInteger duration;
/// 消耗（千卡）
@property (nonatomic, assign) NSInteger calorie;
/// 距离（公里/英里）
@property (nonatomic, assign) NSInteger distance;

@end

NS_ASSUME_NONNULL_END
