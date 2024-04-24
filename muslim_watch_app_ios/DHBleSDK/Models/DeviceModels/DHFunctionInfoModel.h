//
//  DHFunctionInfoModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHFunctionInfoModel : NSObject

/// 计步（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isStep;
/// 睡眠（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isSleep;
/// 心率（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isHeartRate;
/// 血压（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isBp;
/// 血氧（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isBo;
/// 体温（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isTemp;
/// 心电（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isEcg;
/// 呼吸训练（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isBreath;

/// 压力
@property (nonatomic, assign) BOOL isPressure;

/// 表盘（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isDial;
/// 壁纸表盘（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isWallpaper;
/// 消息提醒（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isAncs;
/// 久坐提醒（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isSedentary;
/// 喝水提醒（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isDrinking;
/// 提醒模式（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isReminderMode;
/// 闹钟提醒（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isAlarm;
/// 抬腕亮屏（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isGesture;

/// 亮屏时长（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isBrightTime;
/// 心率监测（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isHeartRateMode;
/// 勿扰模式（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isDisturbMode;
/// 天气（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isWeather;
/// 通讯录（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isContact;
/// 恢复出厂设置（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isRestore;
/// 固件升级（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isOTA;
/// NFC（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isNFC;

/// 二维码（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isQRCode;
/// 重启（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isRestart;
/// 关机（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isShutdown;
/// 经典蓝牙（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isBle3;
/// 生理周期（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isMenstrualCycle;
/// 定位（0.支持 1.不支持）
@property (nonatomic, assign) BOOL isLocation;


@end

NS_ASSUME_NONNULL_END
