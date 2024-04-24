//
//  DHDataSyncingModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDataSyncingModel : NSObject

/// 数据个数
@property (nonatomic, assign) NSInteger count;
/// 计步（0.无数据 1.有数据）
@property (nonatomic, assign) BOOL isStep;
/// 睡眠（0.无数据 1.有数据）
@property (nonatomic, assign) BOOL isSleep;
/// 心率（0.无数据 1.有数据）
@property (nonatomic, assign) BOOL isHeartRate;
/// 血压（0.无数据 1.有数据）
@property (nonatomic, assign) BOOL isBp;
/// 血氧（0.无数据 1.有数据）
@property (nonatomic, assign) BOOL isBo;
/// 体温（0.无数据 1.有数据）
@property (nonatomic, assign) BOOL isTemp;
/// 心电（0.无数据 1.有数据）
@property (nonatomic, assign) BOOL isEcg;
/// 呼吸训练（0.无数据 1.有数据）
@property (nonatomic, assign) BOOL isBreath;
/// 运动（0.无数据 1.有数据）
@property (nonatomic, assign) BOOL isSport;
/// 压力
@property (nonatomic, assign) BOOL isPress;


@end

NS_ASSUME_NONNULL_END
