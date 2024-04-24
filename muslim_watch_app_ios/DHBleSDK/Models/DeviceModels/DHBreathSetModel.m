//
//  DHBreathSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/8/10.
//

#import "DHBreathSetModel.h"

@implementation DHBreathSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOpen = YES;
        self.times = 5;
        self.hourArray = [NSArray array];
        self.minuteArray = [NSArray array];
    }
    return self;
}

@end
