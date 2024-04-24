//
//  DHTool.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>
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
#import "DHSportDataSetModel.h"
#import "DHBindSetModel.h"
#import "DHSportGoalSetModel.h"
#import "DHLocalDialModel.h"
#import "DHOtaInfoModel.h"
#import "DHBreathSetModel.h"
#import "DHDataSyncingModel.h"
#import "DHCustomDialSyncingModel.h"
#import "DHDeviceLogModel.h"
#import "DHMenstrualCycleSetModel.h"
#import "DHPrayAlarmSetModel.h"

#import "DHDailyBoModel.h"
#import "DHDailyBpModel.h"
#import "DHDailyHrModel.h"
#import "DHDailySleepModel.h"
#import "DHDailySportModel.h"
#import "DHDailyStepModel.h"
#import "DHDailyTempModel.h"
#import "DHDailyBreathModel.h"
#import "DHHealthDataModel.h"
#import "DHDailyPressureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHTool : NSObject

#pragma mark- 大小端转换

+ (UInt16)calculateCrc16:(NSData *)data;


#pragma mark - 数据转换方法

/// 指令字符串转字类型
/// @param command 指令字符串
+ (DHBleCommandType)typeOfCommand:(NSString *)command;


/// 单包消息转换
/// @param command 消息ID
/// @param serial 流水号
+ (NSData *)transformCommand:(NSString *)command
                      serial:(NSInteger)serial;

/// 单包消息转换
/// @param command 消息ID
/// @param serial 流水号
/// @param payload 内容
+ (NSData *)transformCommand:(NSString *)command
                     serial:(NSInteger)serial
                     payload:(NSString *)payload;

/// 单包消息转换
/// @param command 消息ID
/// @param serial 流水号
/// @param contentData 内容
+ (NSData *)transformCommand:(NSString *)command
                     serial:(NSInteger)serial
                 contentData:(NSData *)contentData;


/// 分包消息转换
/// @param command 消息ID
/// @param serial 流水号
/// @param index 当前包序号
/// @param count 总包数
/// @param contentData 内容
+ (NSData *)transformCommand:(NSString *)command
                     serial:(NSInteger)serial
                       index:(NSInteger)index
                       count:(NSInteger)count
                     contentData:(NSData *)contentData;

/// 异或值
/// @param payload 需要校验的内容
+ (NSInteger)verifyCode:(NSData *)payload;

/// 数组转十进制数值(计算闹钟周重复时)
/// @param array 数组
+ (NSInteger)transformRepeats:(NSArray *)array;

/// 十进制数值转数组(计算闹钟周重复时)
/// @param repeatNumber 十进制数值
+ (NSArray *)transformRepeatNumber:(NSInteger)repeatNumber;

/// 消息模型转十进制数值
/// @param model 消息模型
+ (NSString *)transformAncs:(DHAncsSetModel *)model;

/// 二进制转数据模型
/// @param payload 内容
/// @param commandType 指令类型
+ (id)modelForPayload:(NSData *)payload
          commandType:(DHBleCommandType)commandType;

/// 二进制转10进制
/// @param data 内容
+ (int)hexDecimalValue:(NSData *)data;

/// 二进制转字符串
/// @param data 内容
+ (NSString *)hexadecimalString:(NSData *)data;

+ (NSString *)hexadecimalStringLog:(NSData *)data;

/// 字符串转二进制
/// @param str 字符串
+ (NSData *)hexToBytes:(NSString *)str;

/// MAC地址转换
/// @param symbol 符号
/// @param data 内容
+ (NSString*)hexRepresentationWithSymbol:(NSString *)symbol data:(NSData *)data;

#pragma mark - 日期转换

/// 日期转换
/// @param format 格式
/// @param date 日期
+ (NSString *)dateToStringFormat:(NSString *)format date:(NSDate *)date;

#pragma mark - 日志记录

/// 保存日志
/// @param log 内容
+ (void)saveLog:(NSString *)log;

/// 检查日志
+ (void)checkLogFiles;

/// 对象转换字符串
/// @param level 等级
/// @param object 对象
+ (NSString *)modelDescriptionWithIndent:(NSInteger)level Object:(id)object;

/// RGB888转RRGB565
/// @param rgbColor RGB888
+ (NSInteger)transformColor:(NSInteger)rgbColor;

/// 获取图片像素点
/// @param data 图片内容
+ (NSData *)transformCustomDialData:(NSData *)data;

+ (NSData *)transformCustomDialDataWithAlpha:(NSData *)data;

/// APP元素转成设备元素
/// @param appElement APP元素
+ (NSInteger)appElementToDevice:(NSInteger)appElement;

/// 设备元素转成APP元素
/// @param deviceElement 设备元素
+ (NSInteger)deviceElementToApp:(NSInteger)deviceElement;

+ (NSInteger)getTimeZoneInterval;

@end

NS_ASSUME_NONNULL_END
