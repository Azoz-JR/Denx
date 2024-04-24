//
//  DHWeatherSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHWeatherSetModel : NSObject

/// 天气类型（0.无 1.晴 2.阴 3.多云 4.小雨 5.中雨 6.大雨 7.阵雨 8.雷阵雨 9.小雪 10.中雪 11.大雪 12.雨夹雪 13.雾 14.沙尘暴）
@property (nonatomic, assign) NSInteger weatherType;
/// 最高气温（摄氏度加100）
@property (nonatomic, assign) NSInteger maxTemp;
/// 最低气温（摄氏度加100）
@property (nonatomic, assign) NSInteger minTemp;
/// 当前气温（摄氏度加100）
@property (nonatomic, assign) NSInteger currentTemp;

@property (nonatomic, assign) UInt8 jlWeatherYear;
@property (nonatomic, assign) UInt8 jlWeatherMonth;
@property (nonatomic, assign) UInt8 jlWeatherDay;
@property (nonatomic, assign) UInt8 jlWeatherHour;
@property (nonatomic, assign) UInt8 jlWeatherMin;
@property (nonatomic, assign) UInt8 jlWeatherSec;
@property (nonatomic, assign) UInt8 jlWindSpeed; //风速
@property (nonatomic, assign) UInt8 jlHumidity; //湿度
@property (nonatomic, assign) UInt8 jlVisibility; //能见度
@property (nonatomic, assign) UInt8 jlUVIntensity; //紫外线强度
@property (nonatomic, assign) UInt8 jlRainfall; //雨量
@property (nonatomic, assign) UInt8 jlSunriseHour; //日出小时
@property (nonatomic, assign) UInt8 jlSunriseMin; //日出分钟
@property (nonatomic, assign) UInt8 jlSunriseSec; //日出秒钟
@property (nonatomic, assign) UInt8 jlSunsetHour; //日落小时
@property (nonatomic, assign) UInt8 jlSunsetMin; //日落分钟
@property (nonatomic, assign) UInt8 jlSunsetSec; //日落秒


- (NSData *)valueWithJL;
- (NSData *)valueWithJL2;

- (NSData *)valueWithTodayJL;
- (NSData *)valueWithTodayJL2;

@end

NS_ASSUME_NONNULL_END
