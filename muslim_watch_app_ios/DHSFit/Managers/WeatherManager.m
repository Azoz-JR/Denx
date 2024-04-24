//
//  WeatherManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import "WeatherManager.h"
#import "DataUploadManager.h"

@implementation WeatherManager

static WeatherManager *_shared = nil;

+ (__kindof WeatherManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    }) ;
    return _shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [WeatherManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [WeatherManager shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)delayUploadAllHealthData {
    [DataUploadManager uploadAllHealthData];
}

/// 单次定位，并发送天气设置
- (void)getLocationInfoAndRequestWeather {
    if (![ConfigureModel shareInstance].isWeather) {
        return;
    }
    DeviceFuncModel *funcModel = [DeviceFuncModel currentModel];
    if (!funcModel.isWeather) {
        return;
    }
    WeatherSetModel *model = [WeatherSetModel currentModel];
    if (model.date.length) {
        NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
        if ([dateStr isEqualToString:model.date] && model.hour == [NSDate date].hour) {
            [self setWeathersCommand:model];
            return;
        }
    }
    
    if ([ConfigureModel shareInstance].longitude.length) {
        [self requestWeather];
        return;
    }
    WEAKSELF
    [[OnceLocationManager shareInstance] startOnceRequestLocationWithBlock:^(NSString * _Nonnull locationStr) {
        if (locationStr.length) {
            [weakSelf requestWeather];
        } else {
            [weakSelf performSelector:@selector(setWeatherAgain) withObject:nil afterDelay:5.0];
        }
    }];
}

- (void)requestWeather {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[ConfigureModel shareInstance].longitude forKey:@"lon"];
    [dict setObject:[ConfigureModel shareInstance].latitude forKey:@"lat"];
    [dict setObject:[[NSDate date] dateToStringFormat:@"yyyy-MM-dd"] forKey:@"date"];
    
    NSLog(@"requestWeather %@", dict);

    WEAKSELF
    [NetworkManager queryForeignWeatherWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            if ([data isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray *)data;
                if (array.count >= 3) {
                    WeatherSetModel *model = [WeatherSetModel currentModel];
                    model.date = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
                    model.hour = [NSDate date].hour;
                    model.items = [array transToJsonString];
                    [model saveOrUpdate];
                    [weakSelf setWeathersCommand:model];
                }
            }
        } else {
            [weakSelf performSelector:@selector(setWeatherAgain) withObject:nil afterDelay:5.0];
        }
    }];
}

- (void)setWeathersCommand:(WeatherSetModel *)model {
    if (!DHDeviceConnected) {
        return;
    }
    //解析数据
    NSArray *items = [model.items transToObject];
    NSMutableArray *weathers = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dict = items[i];
        DHWeatherSetModel *item = [[DHWeatherSetModel alloc] init];
        item.weatherType = [dict[@"type"] integerValue];
        item.maxTemp = [dict[@"high"] integerValue] + 100;
        item.minTemp = [dict[@"low"] integerValue] + 100;
        if (i == 0) {
            item.currentTemp = [dict[@"current"] integerValue] + 100;
        } else {
            item.currentTemp = 0;
        }
        [weathers addObject:item];
    }

    WEAKSELF
    [DHBleCommand setWeathers:weathers block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [ConfigureModel shareInstance].weatherTime = [[NSDate date] timeIntervalSince1970];
            [ConfigureModel archiveraModel];
            [weakSelf delayUpdateWeatherInfo];
        } else {
            [weakSelf performSelector:@selector(setWeatherAgain) withObject:nil afterDelay:5.0];
        }
    }];
}

- (void)delayUpdateWeatherInfo {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getLocationInfoAndRequestWeather) object:nil];
    if ([NSDate date].hour >= 23) {
        NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
        NSString *fullTimeStr = [NSString stringWithFormat:@"%@235959",dateStr];
        NSDate *fullDate = [fullTimeStr dateByStringFormat:@"yyyyMMddHHmmss"];
        NSTimeInterval inteval = [fullDate timeIntervalSinceDate:[NSDate date]];
        [self performSelector:@selector(getLocationInfoAndRequestWeather) withObject:nil afterDelay:inteval+2];
    } else {
        [self performSelector:@selector(getLocationInfoAndRequestWeather) withObject:nil afterDelay:3600];
    }
}

- (void)setWeatherAgain {
    self.requestCount++;
    if (self.requestCount > 3) {
        return;
    }
    [self getLocationInfoAndRequestWeather];
}

#pragma mark - 定位信息

- (void)requestLocation {
    if ([ConfigureModel shareInstance].longitude.length == 0) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[ConfigureModel shareInstance].longitude forKey:@"lon"];
    [dict setObject:[ConfigureModel shareInstance].latitude forKey:@"lat"];
    WEAKSELF
    [NetworkManager queryLocationWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            NSDictionary *item = data;
            if (DHIsNotEmpty(item, @"address")) {
                NSString *address = [item objectForKey:@"address"];
                [weakSelf setLocation:address];
            }
        }
    }];
}

- (void)setLocation:(NSString *)address {
    DHLocationSetModel *model = [[DHLocationSetModel alloc] init];
    model.longitude = floor([[ConfigureModel shareInstance].longitude floatValue]*1000000);
    model.latitude = floor([[ConfigureModel shareInstance].latitude floatValue]*1000000);
    model.locationStr = address;
    [DHBleCommand setLocation:model block:^(int code, id  _Nonnull data) {
        
    }];
}

@end
