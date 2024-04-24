//
//  DHAlarmSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHAlarmSetModel.h"
#import "DHTool.h"

@implementation DHAlarmSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alarmType = @"";
        self.isOpen = YES;
        self.hour = 12;
        self.minute = 0;
        self.repeats = @[@0,@0,@0,@0,@0,@0,@0];
        self.isRemindLater = YES;
    }
    return self;
}

- (NSData *)valueWithJL
{
    NSInteger repeats = [DHTool transformRepeats:self.repeats];
    UInt8 tDayFlags = repeats;
    if (self.isOpen){
        tDayFlags = (tDayFlags | 0x80);
    }
    else{
        tDayFlags = (tDayFlags & 0x7f);
    }
    
    Byte sedentaryByte[28] = {0};
    sedentaryByte[0] = _jlAlarmId;
    sedentaryByte[1] = tDayFlags;
    sedentaryByte[2] = 23;
    sedentaryByte[3] = 1;
    sedentaryByte[4] = 1;
    sedentaryByte[5] = _hour;
    sedentaryByte[6] = _minute;
    sedentaryByte[7] = 31;
    sedentaryByte[8] = 32;
    
    return [NSData dataWithBytes:sedentaryByte length:28];
}

@end
