//
//  DeviceFuncModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/9.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceFuncModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 计步（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isStep;
/// 睡眠
@property (nonatomic, assign) BOOL isSleep;
/// 心率
@property (nonatomic, assign) BOOL isHeartRate;
/// 血压
@property (nonatomic, assign) BOOL isBp;
/// 血氧
@property (nonatomic, assign) BOOL isBo;
/// 体温
@property (nonatomic, assign) BOOL isTemp;
/// 心电
@property (nonatomic, assign) BOOL isEcg;
/// 呼吸
@property (nonatomic, assign) BOOL isBreath;
/// 压力
@property (nonatomic, assign) BOOL isPressure;
/// 血糖
@property (nonatomic, assign) BOOL isBloodSugar;

/// 表盘
@property (nonatomic, assign) BOOL isDial;
/// 壁纸表盘
@property (nonatomic, assign) BOOL isWallpaper;
/// 消息
@property (nonatomic, assign) BOOL isAncs;
/// 久坐提醒
@property (nonatomic, assign) BOOL isSedentary;
/// 喝水提醒
@property (nonatomic, assign) BOOL isDrinking;
/// 提醒模式
@property (nonatomic, assign) BOOL isReminderMode;
/// 闹钟
@property (nonatomic, assign) BOOL isAlarm;
/// 抬腕亮屏
@property (nonatomic, assign) BOOL isGesture;

/// 亮屏时长
@property (nonatomic, assign) BOOL isBrightTime;
/// 心率监测
@property (nonatomic, assign) BOOL isHeartRateMode;
/// 勿扰模式
@property (nonatomic, assign) BOOL isDisturbMode;
/// 天气
@property (nonatomic, assign) BOOL isWeather;
/// 通讯录
@property (nonatomic, assign) BOOL isContact;
/// 恢复出厂设置
@property (nonatomic, assign) BOOL isRestore;
/// 固件升级
@property (nonatomic, assign) BOOL isOTA;
/// NFC
@property (nonatomic, assign) BOOL isNFC;

/// 二维码
@property (nonatomic, assign) BOOL isQRCode;
/// 重启
@property (nonatomic, assign) BOOL isRestart;
/// 关机
@property (nonatomic, assign) BOOL isShutdown;
/// 经典蓝牙
@property (nonatomic, assign) BOOL isBle3;
/// 生理周期
@property (nonatomic, assign) BOOL isMenstrualCycle;

//// 杰里新天气类型
@property (nonatomic, assign) BOOL isJLWeather2;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof DeviceFuncModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
