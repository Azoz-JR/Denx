//
//  DHHeartRateModeSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHHeartRateModeSetModel.h"

@implementation DHHeartRateModeSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOpen = NO;
        self.startHour = 8;
        self.startMinute = 0;
        self.endHour = 22;
        self.endMinute = 0;
        self.interval = 10;
    }
    return self;
}

- (NSData *)valueWithJL
{
    NSInteger repeats = 0x7f;//[DHTool transformRepeats:self.repeats];
    UInt8 tDayFlags = repeats;
    if (self.isOpen){
        tDayFlags = 1;
    }
    else{
        tDayFlags = 0;
    }
    
    Byte sedentaryByte[6] = {0};
    sedentaryByte[0] = tDayFlags;
    sedentaryByte[1] = self.startHour;
    sedentaryByte[2] = self.startMinute;
    sedentaryByte[3] = self.endHour;
    sedentaryByte[4] = self.endMinute;
    sedentaryByte[5] = self.interval;
    
    return [NSData dataWithBytes:sedentaryByte length:6];
}

@end
