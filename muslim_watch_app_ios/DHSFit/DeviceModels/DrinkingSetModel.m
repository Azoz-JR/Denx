//
//  DrinkSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "DrinkingSetModel.h"

@implementation DrinkingSetModel

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
        self.interval = 30;
    }
    return self;
}

+ (__kindof DrinkingSetModel *)currentModel{
    DrinkingSetModel *model =[DrinkingSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[DrinkingSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_drinking";
}

@end
