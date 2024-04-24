//
//  RunningManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RunningManagerDelegate <NSObject>

@optional

/// 定时器
/// @param duration 时长
- (void)runningTimeAdd:(NSInteger)duration;

/// 继续运动
- (void)cotinueRunning;

@end

@interface RunningManager : NSObject

@property (nonatomic, weak) id<RunningManagerDelegate> delegate;

/// 运动类型
@property (nonatomic, assign) SportType sportType;
/// 地图放大
@property (nonatomic, assign) BOOL isBigMap;
/// 运动中
@property (nonatomic, assign) BOOL isRunning;
/// 已连接
@property (nonatomic, assign) BOOL isConnected;
/// 时长
@property (nonatomic, assign) NSInteger duration;
/// 总步数
@property (nonatomic, assign) NSInteger totalStep;
/// 步数增量
@property (nonatomic, assign) NSInteger addStep;
/// 最近一次步数
@property (nonatomic, assign) NSInteger lastStep;
/// 公制配速序号
@property (nonatomic, assign) NSInteger metricPaceIndex;
/// 英制配速序号
@property (nonatomic, assign) NSInteger imperialPaceIndex;
/// 公制配速items
@property (nonatomic, strong) NSMutableArray *metricPaceItems;
/// 英制配速items
@property (nonatomic, strong) NSMutableArray *imperialPaceItems;
/// 步频items
@property (nonatomic, strong) NSMutableArray *strideFrequencyItems;
/// 定位点items
@property (nonatomic, strong) NSMutableArray *gpsItems;

/// 运动目标
@property (nonatomic, strong) SportGoalSetModel *goalModel;
/// 运动时长已达标
@property (nonatomic, assign) BOOL isTimeGoalAchieved;
/// 运动距离已达标
@property (nonatomic, assign) BOOL isDistanceGoalAchieved;
/// 运动卡路里已达标
@property (nonatomic, assign) BOOL isCalorieGoalAchieved;
/// 自动暂停中
@property (nonatomic, assign) BOOL isAutoPause;
/// 暂停计数
@property (nonatomic, assign) NSInteger pauseCount;
/// 步数变化
@property (nonatomic, assign) BOOL isStepChange;
/// 杰里平台 设备侧点击继续与结束
@property (nonatomic, assign) BOOL isJLRunDeviceControl;

/// 单例
+ (__kindof RunningManager *)shareInstance;

/// 开始运动
- (void)startTimer;

/// 继续运动
/// @param isAutoContinue 是否自动继续
- (void)continueTimer:(BOOL)isAutoContinue;

/// 暂停运动
/// @param isAutoPause 是否自动暂停
- (void)pauseTimer:(BOOL)isAutoPause;

/// 停止运动
- (void)stopTimer;

/// 初始化数据
- (void)initData;

/// 运动控制
/// @param model 模型
/// @param step 步数
/// @param isStop 结束
- (void)controlSportData:(DailySportModel *)model Step:(NSInteger)step Stop:(BOOL)isStop;

/// 运动记录icon
/// @param type 运动类型
+ (NSString *)recordTypeImage:(SportType)type;

/// 运动icon
/// @param type 运动类型
+ (NSString *)runningTypeImage:(SportType)type;

/// 运动标题
/// @param type 运动类型
+ (NSString *)runningTypeTitle:(SportType)type;

/// 运动总距离标题
/// @param type 运动类型
+ (NSString *)runningTypeDataTitle:(SportType)type;

+ (NSString *)recordTypeJLImage:(NSInteger)type;

+ (NSString *)runningTypeJLTitle:(NSInteger)type;

/// 步幅
/// @param height 身高cm
+ (NSInteger)kStrideLength:(NSInteger)height;

/// 最大速度
/// @param type  运动类型
+ (CGFloat)maxSpeed:(SportType)type;

/// 最小速度
/// @param type  运动类型
+ (CGFloat)minSpeed:(SportType)type;

/// 千卡换算
/// @param calorie  卡路里
+ (CGFloat)kcalValue:(NSInteger)calorie;

/// 距离换算
/// @param meter  米
+ (CGFloat)distanceValue:(NSInteger)meter;

/// 温度换算
/// @param celsius 摄氏度
+ (CGFloat)tempValue:(NSInteger)celsius;

/// 体重换算
/// @param kilogram 千克
+ (CGFloat)weightValue:(NSInteger)kilogram;

/// 身高换算
/// @param cm 厘米
+ (CGFloat)heightValue:(CGFloat)cm;

/// 保留一位小数
/// @param value 浮点数
+ (CGFloat)formatOneDecimalValue:(CGFloat)value;

/// 时长转换
/// @param second 秒
+ (NSString *)transformDuration:(NSInteger)second;

@end

NS_ASSUME_NONNULL_END
