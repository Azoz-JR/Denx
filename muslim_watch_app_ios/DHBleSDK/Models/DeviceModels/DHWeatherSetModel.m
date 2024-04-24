//
//  DHWeatherSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHWeatherSetModel.h"

@implementation DHWeatherSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxTemp = 0;
        self.minTemp = 0;
        self.currentTemp = 0;
        self.weatherType = 0;
    }
    return self;
}

- (NSInteger)typeRK2JK{
    /// 天气类型（0.无 1.晴 2.阴 3.多云 4.小雨 5.中雨 6.大雨 7.阵雨 8.雷阵雨 9.小雪 10.中雪 11.大雪 12.雨夹雪 13.雾 14.沙尘暴）
    int tJLType[20] = {0x00, 0x01, 0x03, 0x02, 0x04, 0x04, 0x04, 0x04, 0x06, 0x08, 0x08, 0x08, 0x08, 0x09, 10, 0x00, 0x00};
    
    if (self.weatherType < 20){
        return tJLType[self.weatherType];
    }
    else{
        return 0;
    }
}

- (NSData *)valueWithJL
{
    Byte weatherByte[11] = {0};
    char tTemp = 0;
    char tMaxTemp = self.maxTemp - 100;
    char tMinTemp = self.minTemp - 100;
    weatherByte[0] = tTemp;
    weatherByte[1] = tMaxTemp;
    weatherByte[2] = tMinTemp;
    weatherByte[3] = [self typeRK2JK];
    weatherByte[4] = _jlWindSpeed;
    weatherByte[5] = _jlHumidity;
    weatherByte[6] = _jlVisibility;
    weatherByte[7] = _jlUVIntensity;
    weatherByte[8] = (_jlRainfall & 0xff);
    weatherByte[9] = ((_jlRainfall >> 8) & 0xff);
    
    return [NSData dataWithBytes:weatherByte length:10];
}

- (NSData *)valueWithJL2
{
    Byte weatherByte[104] = {0};
    int tOffset = 0;
    char tTemp = 0;
    
    char tMaxTemp = self.maxTemp - 100;
    char tMinTemp = self.minTemp - 100;
    weatherByte[tOffset++] = tTemp;
    weatherByte[tOffset++] = tMaxTemp;
    weatherByte[tOffset++] = tMinTemp;
    int tType = (int)[self typeRK2JK];
    weatherByte[tOffset++] = (tType & 0xff);
    weatherByte[tOffset++] =  ((tType >> 8) & 0xff);
    weatherByte[tOffset++] = _jlWindSpeed;
    weatherByte[tOffset++] = _jlHumidity;
    weatherByte[tOffset++] = _jlVisibility;
    weatherByte[tOffset++] = _jlUVIntensity;
    weatherByte[tOffset++] = (_jlRainfall & 0xff);
    weatherByte[tOffset++] = ((_jlRainfall >> 8) & 0xff);
    weatherByte[tOffset++] = _jlSunriseHour;
    weatherByte[tOffset++] = _jlSunriseMin;
    weatherByte[tOffset++] = _jlSunriseSec;
    weatherByte[tOffset++] = _jlSunsetHour;
    weatherByte[tOffset++] = _jlSunsetMin;
    weatherByte[tOffset++] = _jlSunsetSec;
    
    tOffset += 3;

    return [NSData dataWithBytes:weatherByte length:tOffset];
}

- (NSData *)valueWithTodayJL
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:currentDate];

    NSInteger tyear = [components year] - 2000;
    NSInteger tmonth = [components month];
    NSInteger tday = [components day];
    NSInteger thour = [components hour];
    NSInteger tminute = [components minute];
    
    Byte weatherByte[16] = {0};
    weatherByte[0] = tyear;
    weatherByte[1] = tmonth;
    weatherByte[2] = tday;
    weatherByte[3] = thour;
    weatherByte[4] = tminute;
    weatherByte[5] = 0;
    char tTemp = self.currentTemp - 100;
    char tMaxTemp = self.maxTemp - 100;
    char tMinTemp = self.minTemp - 100;
    weatherByte[6] = tTemp;
    weatherByte[7] = tMaxTemp;
    weatherByte[8] = tMinTemp;
    weatherByte[9] = [self typeRK2JK];
    weatherByte[10] = _jlWindSpeed;
    weatherByte[11] = _jlHumidity;
    weatherByte[12] = _jlVisibility;
    weatherByte[13] = _jlUVIntensity;
    weatherByte[14] = (_jlRainfall & 0xff);
    weatherByte[15] = ((_jlRainfall >> 8) & 0xff);
    
    return [NSData dataWithBytes:weatherByte length:16];
}

- (NSData *)valueWithTodayJL2
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:currentDate];

    NSInteger tyear = [components year] - 2000;
    NSInteger tmonth = [components month];
    NSInteger tday = [components day];
    NSInteger thour = [components hour];
    NSInteger tminute = [components minute];
    
    Byte weatherByte[104] = {0};
    int tOffset = 0;
    weatherByte[tOffset++] = tyear;
    weatherByte[tOffset++] = tmonth;
    weatherByte[tOffset++] = tday;
    weatherByte[tOffset++] = thour;
    weatherByte[tOffset++] = tminute;
    weatherByte[tOffset++] = 0;
    
    tOffset += 66;
    
    char tTemp = self.currentTemp - 100;
    char tMaxTemp = self.maxTemp - 100;
    char tMinTemp = self.minTemp - 100;
    weatherByte[tOffset++] = tTemp;
    weatherByte[tOffset++] = tMaxTemp;
    weatherByte[tOffset++] = tMinTemp;
    int tType = [self typeRK2JK];
    weatherByte[tOffset++] = (tType & 0xff);
    weatherByte[tOffset++] =  ((tType >> 8) & 0xff);
    weatherByte[tOffset++] = _jlWindSpeed;
    weatherByte[tOffset++] = _jlHumidity;
    weatherByte[tOffset++] = _jlVisibility;
    weatherByte[tOffset++] = _jlUVIntensity;
    weatherByte[tOffset++] = (_jlRainfall & 0xff);
    weatherByte[tOffset++] = ((_jlRainfall >> 8) & 0xff);
    
    weatherByte[tOffset++] = _jlSunriseHour;
    weatherByte[tOffset++] = _jlSunriseMin;
    weatherByte[tOffset++] = _jlSunriseSec;
    weatherByte[tOffset++] = _jlSunsetHour;
    weatherByte[tOffset++] = _jlSunsetMin;
    weatherByte[tOffset++] = _jlSunsetSec;
    
    tOffset += 3;
    
    return [NSData dataWithBytes:weatherByte length:tOffset];
}

@end
