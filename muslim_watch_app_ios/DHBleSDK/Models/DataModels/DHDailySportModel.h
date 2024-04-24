//
//  DHDailySportModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDailySportModel : NSObject

/// 时间戳（秒）
@property (nonatomic, copy) NSString *timestamp;
/// 日期yyyyMMdd
@property (nonatomic, copy) NSString *date;
/// 运动类型（2.骑行 3.动感单车 4.室内跑步 5.室外跑步 6.游泳 7.走路 8.举重 9.瑜伽 10.羽毛球 11.篮球 12.跳绳 13.自由锻炼 14.足球 15.爬山 16.乒乓球）
@property (nonatomic, assign) NSInteger type;
/// 时长（秒）
@property (nonatomic, assign) NSInteger duration;
/// 里程（米）
@property (nonatomic, assign) NSInteger distance;
/// 消耗（卡路里）
@property (nonatomic, assign) NSInteger calorie;
/// 步数（步）
@property (nonatomic, assign) NSInteger step;
/// 杰里 高度
@property (nonatomic, assign) NSInteger sportHeight;
/// 杰里  气压
@property (nonatomic, assign) NSInteger sportPress;
/// 杰里  步频
@property (nonatomic, assign) NSInteger sportStepFreq;
/// 杰里  速度
@property (nonatomic, assign) CGFloat sportSpeed;
/// 杰里配速
@property (nonatomic, assign) NSInteger pace;
/// 杰里最大心率
@property (nonatomic, assign) NSInteger heartMax;
/// 杰里最小心率
@property (nonatomic, assign) NSInteger heartMin;
/// 杰里 平均心率
@property (nonatomic, assign) NSInteger heartAve;

@property (nonatomic, assign) NSInteger viewType;
/// 杰里 最大步频
@property (nonatomic, assign) NSInteger maxStepFreq;
/// 杰里 最小步频
@property (nonatomic, assign) NSInteger minStepFreq;
/// 杰里 最大配速
@property (nonatomic, assign) NSInteger sportMaxPace;
/// 杰里 最小配速
@property (nonatomic, assign) NSInteger sportMinPace;

/// 公制配速项 例：@[@{@"index":@1,@"value":@300,@"isInt":@1},...]
/// index（序号）value（配速（秒/公里））isInt（是否满足1公里）
/// index从1开始
@property (nonatomic,strong) NSArray <NSDictionary *>*metricPaceItems;

/// 英制配速项 例：@[@{@"index":@1,@"value":@300,@"isInt":@1},...]
/// index（序号）value（配速（秒/英里））isInt（是否满足1英里）
/// index从1开始
@property (nonatomic,strong) NSArray <NSDictionary *>*imperialPaceItems;

/// 步频项 例：@[@{@"index":@0,@"value":@80},...]
/// index（时间间隔（分钟））value（步频值（步/分钟））
@property (nonatomic,strong) NSArray <NSDictionary *>*strideFrequencyItems;

/// 心率项 例：@[@{@"index":@0,@"value":@80},...]
/// index（时间间隔（秒））value（心率值）
@property (nonatomic,strong) NSArray <NSDictionary *>*heartRateItems;

@property (nonatomic, assign) Boolean isJLRunType; //是否杰里运动

- (NSInteger)typeJL2RK:(NSInteger)jlType;

@end

NS_ASSUME_NONNULL_END
