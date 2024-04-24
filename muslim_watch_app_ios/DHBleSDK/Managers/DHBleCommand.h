//
//  DHBleCommand.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DHBleCommandEnums.h"

#import "DHDeviceInfoModel.h"
#import "DHFirmwareVersionModel.h"
#import "DHBatteryInfoModel.h"
#import "DHAlarmSetModel.h"
#import "DHAncsSetModel.h"
#import "DHBrightTimeSetModel.h"
#import "DHContactSetModel.h"
#import "DHDialInfoModel.h"
#import "DHDisturbModeSetModel.h"
#import "DHDrinkingSetModel.h"
#import "DHFunctionInfoModel.h"
#import "DHGestureSetModel.h"
#import "DHHeartRateModeSetModel.h"
#import "DHQRCodeSetModel.h"
#import "DHReminderModeSetModel.h"
#import "DHSedentarySetModel.h"
#import "DHTimeSetModel.h"
#import "DHUnitSetModel.h"
#import "DHUserInfoSetModel.h"
#import "DHWeatherSetModel.h"
#import "DHLocalDialModel.h"
#import "DHBindSetModel.h"
#import "DHSportDataSetModel.h"
#import "DHSportGoalSetModel.h"
#import "DHSportControlModel.h"
#import "DHLocationSetModel.h"

#import "DHOtaInfoModel.h"
#import "DHBreathSetModel.h"
#import "DHDataSyncingModel.h"
#import "DHDeviceLogModel.h"
#import "DHFileSyncingModel.h"

#import "DHDailyBoModel.h"
#import "DHDailyBpModel.h"
#import "DHDailyHrModel.h"
#import "DHDailySleepModel.h"
#import "DHDailySportModel.h"
#import "DHDailyStepModel.h"
#import "DHDailyTempModel.h"
#import "DHDailyBreathModel.h"
#import "DHDailyPressureModel.h"
#import "DHHealthDataModel.h"

#import "DHCustomDialSyncingModel.h"
#import "DHMenstrualCycleSetModel.h"
#import "DHPrayAlarmSetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHBleCommand : NSObject

#pragma mark - 获取类

/// 获取固件版本信息
/// @param block 回调
+ (void)getFirmwareVersion:(void(^)(int code, id data))block;

/// 获取电量信息
/// @param block 回调
+ (void)getBattery:(void(^)(int code, id data))block;

/// 获取绑定信息
/// @param block 回调
+ (void)getBindInfo:(void(^)(int code, id data))block;

+ (void)getJLBindInfoLogin:(void(^)(int code, id data))block;

/// 获取功能表
/// @param block 回调
+ (void)getFunction:(void(^)(int code, id data))block;

/// 获取表盘信息
/// @param block 回调
+ (void)getDialInfo:(void(^)(int code, id data))block;

/// 获取ANCS
/// @param block 回调
+ (void)getAncs:(void(^)(int code, id data))block;

/// 获取久坐提醒
/// @param block 回调
+ (void)getSedentary:(void(^)(int code, id data))block;

/// 获取喝水提醒
/// @param block 回调
+ (void)getDrinking:(void(^)(int code, id data))block;

/// 获取提醒模式
/// @param block 回调
+ (void)getReminderMode:(void(^)(int code, id data))block;

/// 获取闹钟提醒
/// @param block 回调
+ (void)getAlarms:(void(^)(int code, id data))block;

/// 获取抬腕亮屏
+ (void)getGesture:(void(^)(int code, id data))block;

/// 获取亮屏时长
/// @param block 回调
+ (void)getBrightTime:(void(^)(int code, id data))block;

/// 获取心率监测
/// @param block 回调
+ (void)getHeartRateMode:(void(^)(int code, id data))block;

/// 获取勿扰模式
/// @param block 回调
+ (void)getDisturbMode:(void(^)(int code, id data))block;

/// 获取MAC地址
/// @param block 回调
+ (void)getMacAddress:(void(^)(int code, id data))block;

/// 获取经典蓝牙
/// @param block 回调
+ (void)getClassicBle:(void(^)(int code, id data))block;

/// 获取本地表盘
/// @param block 回调
+ (void)getLocalDial:(void(^)(int code, id data))block;

/// 获取Ota状态
/// @param block 回调
+ (void)getOtaInfo:(void(^)(int code, id data))block;

/// 获取呼吸训练
/// @param block 回调
+ (void)getBreath:(void(^)(int code, id data))block;

/// 获取自定义表盘信息
/// @param block 回调
+ (void)getCustomDialInfo:(void(^)(int code, id data))block;

/// 获取生理周期
/// @param block 回调
+ (void)getMenstrualCycle:(void(^)(int code, id data))block;

#pragma mark - 设置类
/// 设置绑定信息
/// @param model 模型
/// @param block 回调
+ (void)setBind:(DHBindSetModel *)model block:(void(^)(int code, id data))block;

/// 设置时间
/// @param model 模型
/// @param block 回调
+ (void)setTime:(DHTimeSetModel *)model block:(void(^)(int code, id data))block;

/// 设置ANCS
/// @param model 模型
/// @param block 回调
+ (void)setAncs:(DHAncsSetModel *)model block:(void(^)(int code, id data))block;

/// 设置单位
/// @param model 模型
/// @param block 回调
+ (void)setUnit:(DHUnitSetModel *)model block:(void(^)(int code, id data))block;

/// 设置久坐提醒
/// @param model 模型
/// @param block 回调
+ (void)setSedentary:(DHSedentarySetModel *)model block:(void(^)(int code, id data))block;

/// 设置喝水提醒
/// @param model 模型
/// @param block 回调
+ (void)setDrinking:(DHDrinkingSetModel *)model block:(void(^)(int code, id data))block;

/// 设置提醒模式
/// @param model 模型
/// @param block 回调
+ (void)setReminderMode:(DHReminderModeSetModel *)model block:(void(^)(int code, id data))block;

+ (void)addJLAlarm:(DHAlarmSetModel *)alarm block:(void(^)(int code, id data))block;
+ (void)updateJLAlarm:(DHAlarmSetModel *)alarm block:(void(^)(int code, id data))block;
+ (void)deleteJLAlarm:(DHAlarmSetModel *)alarm block:(void(^)(int code, id data))block;


/// 设置祈祷闹钟提醒
/// @param alarms 闹钟数组
/// @param block 回调
+ (void)setPrayAlarms:(NSArray <DHPrayAlarmSetModel *> *)alarms block:(void(^)(int code, id data))block;


/// 设置闹钟提醒
/// @param alarms 闹钟数组
/// @param block 回调
+ (void)setAlarms:(NSArray <DHAlarmSetModel *>*)alarms block:(void(^)(int code, id data))block;

/// 设置抬腕亮屏
/// @param model 模型
/// @param block 回调
+ (void)setGesture:(DHGestureSetModel *)model block:(void(^)(int code, id data))block;

/// 设置亮屏时长
/// @param model 模型
/// @param block 回调
+ (void)setBrightTime:(DHBrightTimeSetModel *)model block:(void(^)(int code, id data))block;

/// 设置心率监测
/// @param model 模型
/// @param block 回调
+ (void)setHeartRateMode:(DHHeartRateModeSetModel *)model block:(void(^)(int code, id data))block;

/// 设置勿扰模式
/// @param model 模型
/// @param block 回调
+ (void)setDisturbMode:(DHDisturbModeSetModel *)model block:(void(^)(int code, id data))block;

/// 设置通讯录
/// @param contacts 数组
/// @param block 回调
+ (void)setContacts:(NSArray <DHContactSetModel *>*)contacts block:(void(^)(int code, id data))block;

/// 设置个人信息
/// @param model 模型
/// @param block 回调
+ (void)setUserInfo:(DHUserInfoSetModel *)model block:(void(^)(int code, id data))block;

/// 设置二维码
/// @param model 模型
/// @param block 回调
+ (void)setQRCode:(DHQRCodeSetModel *)model block:(void(^)(int code, id data))block;

/// 设置运动目标
/// @param model 模型
/// @param block 回调
+ (void)setSportGoal:(DHSportGoalSetModel *)model block:(void(^)(int code, id data))block;

/// 设置天气
/// @param weathers 数组 3天的数据 今天、明天、后天
/// @param block 回调
+ (void)setWeathers:(NSArray <DHWeatherSetModel *>*)weathers block:(void(^)(int code, id data))block;

/// 设置呼吸训练
/// @param model 模型
/// @param block 回调
+ (void)setBreath:(DHBreathSetModel *)model block:(void(^)(int code, id data))block;

/// 设置生理周期
/// @param model 模型
/// @param block 回调
+ (void)setMenstrualCycle:(DHMenstrualCycleSetModel *)model block:(void(^)(int code, id data))block;

/// 设置定位信息
/// @param model 模型
/// @param block 回调
+ (void)setLocation:(DHLocationSetModel *)model block:(void(^)(int code, id data))block;

+ (void)setJLTimeZone:(UInt8)timezone block:(void(^)(int code, id data))block;

///0: 24小时制 1:12小时制
+ (void)setJLTimeformat:(UInt8)timeformat block:(void(^)(int code, id data))block;
+ (void)setJLLanguage:(UInt8)language block:(void(^)(int code, id data))block;
///distanceUnit 0: 公制 1: 英制
+ (void)setJLDistanceUnit:(UInt8)distanceUnit block:(void(^)(int code, id data))block;
//tempUnit 0: 摄氏度 1: 华氏度
+ (void)setJLTempUnit:(UInt8)tempUnit block:(void(^)(int code, id data))block;

+ (void)setJLUserInfoWithStepTarget:(UInt32)stepTarget block:(void(^)(int code, id data))block;

+ (void)setJLMuslimAngle:(int16_t)angle lat:(double)lat lon:(double)lon china:(Boolean)isChina block:(void(^)(int code, id data))block;

+ (void)getPrayAlarms:(void(^)(int code, id data))block;

#pragma mark - 控制类

/// 拍照控制
/// @param type （0.关闭 1.打开 2.拍照）
/// @param block 回调
+ (void)controlCamera:(NSInteger)type block:(void(^)(int code, id data))block;

/// 开始寻找设备
/// @param block 回调
+ (void)controlFindDeviceBegin:(void(^)(int code, id data))block;

/// 结束寻找手机
/// @param block 回调
+ (void)controlFindPhoneEnd:(void(^)(int code, id data))block;

/// 设备控制
/// @param type （0.重启 1.关机 2.恢复出厂设置）
/// @param block 回调
+ (void)controlDevice:(NSInteger)type block:(void(^)(int code, id data))block;

/// 解绑设备
/// @param block 回调
+ (void)controlUnbind:(void(^)(int code, id data))block;

/// 运动控制
/// @param model 模型
/// @param block 回调
+ (void)controlSport:(DHSportControlModel *)model block:(void(^)(int code, id data))block;

/// 运动交换数据
/// @param model 模型
/// @param block 回调
+ (void)controlSportData:(DHSportDataSetModel *)model block:(void(^)(int code, id data))block;

/// APP当前状态
/// @param isActive 是否前台
/// @param block 回调
+ (void)controlAppStatus:(BOOL)isActive block:(void(^)(int code, id data))block;

/// 文件传输开始
/// @param model 模型
/// @param block 回调
+ (void)fileSyncingStart:(DHFileSyncingModel *)model block:(void(^)(int code, id data))block;

#pragma mark - 表盘传输类

/// 云端表盘传输
/// @param fileData 内容
/// @param block 回调
+ (void)startDialSyncing:(NSData *)fileData block:(void(^)(int code, CGFloat progress, id data))block;

/// 自定义表盘传输
/// @param model 模型
/// @param block 回调
+ (void)startCustomDialSyncing:(DHCustomDialSyncingModel *)model block:(void(^)(int code, CGFloat progress, id data))block;

#pragma mark - 文件传输类

/// 文件传输
/// @param fileData 内容
/// @param block 回调
+ (void)startFileSyncing:(NSData *)fileData block:(void(^)(int code, CGFloat progress, id data))block;

///  UI与字体资源同步
/// @param fileData 内容
/// @param block 回调
+ (void)startUIFileSyncing:(NSData *)fileData bleKey:(BleKey)bleKey block:(void(^)(int code, CGFloat progress, id data))block;

#pragma mark - 轨迹同步类

/// 轨迹同步
/// @param fileData 模型
/// @param block 回调
+ (void)startMapSyncing:(NSData *)fileData block:(void(^)(int code, CGFloat progress, id data))block;

#pragma mark - 缩略图同步类

/// 缩略图同步
/// @param fileData 模型
/// @param isCustomDial 是否自定义表盘
/// @param block 回调
+ (void)startThumbnailSyncing:(NSData *)fileData customDial:(BOOL)isCustomDial block:(void(^)(int code, CGFloat progress, id data))block;

#pragma mark - 自动同步数据类

/// 自动同步数据
/// @param block 回调
+ (void)startDataSyncing:(void(^)(int code, int progress, id data))block;

#pragma mark - 手动同步数据（只返回结果，不返回进度）

/// 查询需要同步的数据
/// @param block 回调
+ (void)checkDataSyncing:(void(^)(int code, id data))block;

/// 同步计步数据
/// @param block 回调
+ (void)startStepSyncing:(void(^)(int code, id data))block;

/// 同步睡眠数据
/// @param block 回调
+ (void)startSleepSyncing:(void(^)(int code, id data))block;

/// 同步心率数据
/// @param block 回调
+ (void)startHeartRateSyncing:(void(^)(int code, id data))block;

/// 同步血压数据
/// @param block 回调
+ (void)startBloodPressureSyncing:(void(^)(int code, id data))block;

/// 同步血氧数据
/// @param block 回调
+ (void)startBloodOxygenSyncing:(void(^)(int code, id data))block;

/// 同步体温数据
/// @param block 回调
+ (void)startTempSyncing:(void(^)(int code, id data))block;

/// 同步呼吸数据
/// @param block 回调
+ (void)startBreathSyncing:(void(^)(int code, id data))block;

/// 同步运动数据
/// @param block 回调
+ (void)startSportSyncing:(void(^)(int code, id data))block;

+ (void)startLogSyncingJL:(void(^)(int code, id data))block;

#pragma mark - 辅助方法

/// 是否可以打开经典蓝牙
+ (BOOL)classicBluetoothCanOpen;

/// 打开经典蓝牙
+ (void)classicBluetoothOpen;

@end

NS_ASSUME_NONNULL_END
