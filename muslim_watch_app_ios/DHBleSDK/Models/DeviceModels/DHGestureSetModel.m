//
//  DHGestureSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHGestureSetModel.h"

@implementation DHGestureSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOpen = NO;
        self.startHour = 8;
        self.startMinute = 0;
        self.endHour = 22;
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
    
    Byte sedentaryByte[5] = {0};
    sedentaryByte[0] = tDayFlags;
    sedentaryByte[1] = self.startHour;
    sedentaryByte[2] = self.startMinute;
    sedentaryByte[3] = self.endHour;
    sedentaryByte[4] = self.endMinute;
    
    return [NSData dataWithBytes:sedentaryByte length:5];
}

@end
