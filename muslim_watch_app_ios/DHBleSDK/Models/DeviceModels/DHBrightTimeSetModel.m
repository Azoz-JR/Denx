//
//  DHBrightTimeSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHBrightTimeSetModel.h"

@implementation DHBrightTimeSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.duration = 15;
    }
    return self;
}

- (NSData *)valueWithJL
{
    UInt8 tTimeLong = self.duration;
    return [NSData dataWithBytes:&tTimeLong length:1];
}

@end
