//
//  HeartRateSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "HeartRateSetModel.h"

@implementation HeartRateSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.isOpen = NO;
        self.startHour = 8;
        self.startMinute = 0;
        self.endHour = 22;
        self.endMinute = 0;
        self.interval = 10;
    }
    return self;
}

+ (__kindof HeartRateSetModel *)currentModel{
    HeartRateSetModel *model =[HeartRateSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[HeartRateSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_heartrate";
}

@end
