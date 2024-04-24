//
//  DHTimeSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHTimeSetModel.h"
#import "DHTool.h"

@implementation DHTimeSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *dateStr = [DHTool dateToStringFormat:@"yyyy/MM/dd/HH/mm/ss" date:[NSDate date]];
        NSArray *dateArray = [dateStr componentsSeparatedByString:@"/"];
        self.year = [dateArray[0] integerValue];
        self.month = [dateArray[1] integerValue];
        self.day = [dateArray[2] integerValue];
        self.hour = [dateArray[3] integerValue];
        self.minute = [dateArray[4] integerValue];
        self.second = [dateArray[5] integerValue];
    }
    return self;
}

- (NSData *)valueWithJL
{
    Byte timeByte[6] = {0};
    timeByte[0] = (self.year - 2000);
    timeByte[1] = self.month;
    timeByte[2] = self.day;
    timeByte[3] = self.hour;
    timeByte[4] = self.minute;
    timeByte[5] = self.second;
    
    // 17 0a 1b 11 3a 25
//    timeByte[0] = 0x17;
//    timeByte[1] = 0x0a;
//    timeByte[2] = 0x1b;
//    timeByte[3] = 0x11;
//    timeByte[4] = 0x3a;
//    timeByte[5] = 0x25;
    
    return [NSData dataWithBytes:timeByte length:6];
}

@end
