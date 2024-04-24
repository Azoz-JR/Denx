//
//  DHDisturbModeSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHDisturbModeSetModel.h"

@implementation DHDisturbModeSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOpen = NO;
        self.isAllday = NO;
        self.startHour = 22;
        self.startMinute = 0;
        self.endHour = 8;
        self.endMinute = 0;
    }
    return self;
}

- (NSData *)valueWithJL
{
    UInt8 tDayFlags = 0;
    if (self.isOpen){
        tDayFlags = 1;
    }
    else{
        tDayFlags = 0;
    }
    
    Byte sedentaryByte[16] = {0};
    int tOffset = 0;
    sedentaryByte[tOffset++] = tDayFlags;
    sedentaryByte[tOffset++] = tDayFlags;
    sedentaryByte[tOffset++] = self.startHour;
    sedentaryByte[tOffset++] = self.startMinute;
    sedentaryByte[tOffset++] = self.endHour;
    sedentaryByte[tOffset++] = self.endMinute;
    
    
    return [NSData dataWithBytes:sedentaryByte length:16];
}


@end
