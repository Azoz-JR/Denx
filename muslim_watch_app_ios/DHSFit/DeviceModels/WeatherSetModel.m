//
//  WeatherSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "WeatherSetModel.h"

@implementation WeatherSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.appName = @"revivalfit";
        self.date = @"";
        self.hour = 0;
        self.items = @"";
    }
    return self;
}

+ (__kindof WeatherSetModel *)currentModel {
    WeatherSetModel *model =[WeatherSetModel findFirstWithFormat:@"WHERE appName = '%@'",@"revivalfit"];
    if (!model) {
        model = [[WeatherSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_weather";
}

@end
