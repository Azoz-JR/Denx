//
//  AlarmSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "AlarmSetModel.h"

@implementation AlarmSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.alarmIndex = 0;
        self.alarmType = @"";
        self.isOpen = YES;
        self.hour = [NSDate date].hour;
        self.minute = [NSDate date].minute;
        self.repeats = [@[@0,@0,@0,@0,@0,@0,@0] transToJsonString];
    }
    return self;
}

+ (NSArray <AlarmSetModel *>*)queryAllAlarms {
    NSArray *alarms =[AlarmSetModel findWithFormat:@"WHERE macAddr = '%@' ORDER BY alarmIndex ASC",DHMacAddr];
    return alarms;
}

+ (void)deleteAllAlarms {
    NSArray *array = [AlarmSetModel queryAllAlarms];
    if (array.count) {
        [AlarmSetModel deleteObjects:array];
    }
}

+ (NSString *)getTableName{
    return @"t_device_alarm";
}

@end
