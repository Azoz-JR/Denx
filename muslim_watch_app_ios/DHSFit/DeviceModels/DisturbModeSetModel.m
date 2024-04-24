//
//  DisturbModeSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "DisturbModeSetModel.h"

@implementation DisturbModeSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.isOpen = NO;
        self.isAllday = NO;
        self.startHour = 22;
        self.startMinute = 0;
        self.endHour = 8;
        self.endMinute = 0;
    }
    return self;
}

+ (__kindof DisturbModeSetModel *)currentModel{
    DisturbModeSetModel *model =[DisturbModeSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[DisturbModeSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_disturbmode";
}

@end
