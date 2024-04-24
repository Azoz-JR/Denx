//
//  DHHealthDataModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHHealthDataModel : NSObject

/// 类型（0.计步 1.心率 2.血压 3.血氧 4.体温 5.呼吸训练）
@property (nonatomic, assign) NSInteger type;

/// 时间戳（秒）
@property (nonatomic, assign) NSInteger timestamp;

/// 序号（小时）
@property (nonatomic, assign) NSInteger index;
/// 步数（步）
@property (nonatomic, assign) NSInteger step;
/// 距离（米）
@property (nonatomic, assign) NSInteger distance;
/// 消耗（卡路里）
@property (nonatomic, assign) NSInteger calorie;

/// 心率（bpm）
@property (nonatomic, assign) NSInteger heartRate;

/// 收缩压（mmHg）
@property (nonatomic, assign) NSInteger systolic;
/// 舒张压（mmHg）
@property (nonatomic, assign) NSInteger diastolic;

/// 血氧（%）
@property (nonatomic, assign) NSInteger bo;

/// 体温（摄氏度*10）
@property (nonatomic, assign) NSInteger temp;

/// 呼吸训练时长（分钟）
@property (nonatomic, assign) NSInteger breath;


@end

NS_ASSUME_NONNULL_END
