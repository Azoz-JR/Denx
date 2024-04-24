//
//  DHPrayAlarmSetModel.m
//  DHSFit
//
//  Created by liwei qiao on 2023/5/22.
//

#import "DHPrayAlarmSetModel.h"

@implementation DHPrayAlarmSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alarmType = 0x00;
        self.isOpen = YES;
        self.hour = 04;
        self.minute = 30;
    }
    return self;
}

- (NSData *)valueWithJL
{
    UInt8 tDayFlags = 0;
    if (self.isOpen){
        tDayFlags = 1;
    }
    
    Byte sedentaryByte[3] = {0};
    sedentaryByte[0] = _hour;
    sedentaryByte[1] = _minute;
    sedentaryByte[2] = tDayFlags;
    
    return [NSData dataWithBytes:sedentaryByte length:3];
}

@end
