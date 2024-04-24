//
//  PrayAlarmSetModel.m
//  DHSFit
//
//  Created by liwei qiao on 2023/5/22.
//

#import "PrayAlarmSetModel.h"

@implementation PrayAlarmSetModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.alarmType = 0;
        self.isOpen = YES;
        self.hour = [NSDate date].hour;
        self.minute = [NSDate date].minute;
        self.alarmBody = @"";
    }
    return self;
}

+ (NSArray <PrayAlarmSetModel *>*)queryAllPrayAlarms {
    NSArray *alarms =[PrayAlarmSetModel findWithFormat:@"WHERE macAddr = '%@' ORDER BY alarmType ASC", DHMacAddr];
    return alarms;
}

+ (void)deleteAllPrayAlarms {
    NSArray *array = [PrayAlarmSetModel queryAllPrayAlarms];
    if (array.count) {
        [PrayAlarmSetModel deleteObjects:array];
    }
}

+ (NSString *)getTableName{
    return @"t_device_prayalarm";
}
@end
