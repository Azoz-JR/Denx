//
//  DailySportModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SportType) {
    SportTypeBreathe = 1,//呼吸
    SportTypeRide = 2,//骑行 APP
    SportTypeSpinning,//动感单车
    SportTypeRunIndoor,//室内跑步 APP
    SportTypeRunOutdoor = 5,//室外跑步 APP
    
    SportTypeTennis,//网球
    SportTypeWalk,//健走 APP
    SportTypeWeightLifting,//举重
    SportTypeYoga,//瑜伽
    SportTypeBadminton = 10,//羽毛球
    
    SportTypeBasketball,//篮球
    SportTypeJumpingRope,//跳绳
    SportTypeFootball,//足球
    SportTypeClimb,  //爬山
    SportTypeTableTennis,//乒乓球
    SportTypeFreeExercise,//自由锻炼
    SportTypeBallet,//芭蕾舞
    SportTypeGolf,//高尔夫
    SportTypeSquareDance,//广场舞
    SportTypeBaseball,//棒球
    SportTypeFootball2,//橄榄球
    SportTypePoppyJump,//波比跳
    SportTypeEllipticalMachine,//椭圆机
    SportTypeFitness,//健身
    SportTypeKayak,//皮划艇
    SportTypeOnFoot,//徒步
    SportTypeSkiing,//雪上运动
    SportTypePaddleBoard,//桨板
    SportTypePilates,//普拉提
    SportTypeRollerSkating,//轮滑
    SportTypeBoating,//划船
    SportTypeSailboat,//帆船
    SportTypeSkateboard,//滑板
    SportTypeToStretch,//拉伸
    SportTypeWaterPolo,//水球
    SportTypeMax
};

@interface DailySportModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;
/// 是否上传
@property (nonatomic, assign) BOOL isUpload;
/// 是否上传
@property (nonatomic, assign) BOOL isDevice;

/// 日期yyyyMMdd
@property (nonatomic, copy) NSString *date;
/// 日期时间戳（秒）
@property (nonatomic, copy) NSString *timestamp;

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

/// 公制配速items 例：@[@{@"index":@1,@"value":@300,@"isInt":@1},...]
/// index（序号）value（配速（秒/公里））isInt（是否满足1公里）
/// index从1开始
@property (nonatomic, copy) NSString *metricPaceItems;
/// 英制配速items 例：@[@{@"index":@1,@"value":@300,@"isInt":@1},...]
/// index（序号）value（配速（秒/英里））isInt（是否满足1英里）
/// index从1开始
@property (nonatomic, copy) NSString *imperialPaceItems;
/// 步频items 例：@[@{@"index":@1,@"value":@80},...]
/// index（时间下标（分钟））value（步频值（步/分钟））
@property (nonatomic, copy) NSString *strideFrequencyItems;
/// 心率items 例：@[@{@"index":@1,@"value":@80},...]
/// index（时间下标（秒））value（心率值）
@property (nonatomic, copy) NSString *heartRateItems;
/// 定位items 例：@[@{@"timestamp":@1,@"longtitude":@80,@"latitude":@80},...]
/// index（时间间隔（秒））longtitude（经度） latitude（纬度）
@property (nonatomic, copy) NSString *gpsItems;

@property (nonatomic, assign) Boolean isJLRunType; //是否杰里运动

/// 取指定一天数据，没有数据初始化一个
+ (__kindof DailySportModel *)currentModel:(NSString *)timestamp;

/// 获取某个运动类型的所以数据
+ (NSArray *)queryModels:(SportType)sportType;

/// 查询所有运动历史数据
+ (NSArray *)queryAllSports;

/// 查询需要上传的数据
+ (NSArray *)queryUploadModels;

/// 查询游客数据
+ (NSArray *)queryVisitorModels;

/// 查询指定模型
/// @param timestamp 时间戳
+ (DailySportModel *)queryModel:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
