//
//  MenstrualCycleSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/11/7.
//

#import "MenstrualCycleSetModel.h"

@implementation MenstrualCycleSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.type = 1;
        self.isOpen = NO;
        self.isRemindMenstrualPeriod = YES;
        self.isRemindOvulationPeriod = YES;
        self.isRemindOvulationPeak = YES;
        self.isRemindOvulationEnd = YES;
        
        self.cycleDays = 25;
        self.menstrualDays = 5;
        
        NSString *date = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
        self.timestamp = [[NSDate get1970timeTempWithDateStr:date] integerValue];
        self.remindHour = 9;
        self.remindMinute = 0;
        
        self.jlRemindBeforeDay = 1;
        self.jlRemindOvulationBeforeDay = 1;
    }
    return self;
}

+ (__kindof MenstrualCycleSetModel *)currentModel{
    MenstrualCycleSetModel *model =[MenstrualCycleSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[MenstrualCycleSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_menstrualcycle";
}

@end
