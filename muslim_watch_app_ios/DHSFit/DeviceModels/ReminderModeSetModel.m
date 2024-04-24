//
//  ReminderModeSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "ReminderModeSetModel.h"

@implementation ReminderModeSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.reminderMode = 2;
    }
    return self;
}

+ (__kindof ReminderModeSetModel *)currentModel{
    ReminderModeSetModel *model =[ReminderModeSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[ReminderModeSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_remindermode";
}

@end
