//
//  DHBatteryInfoModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHBatteryInfoModel.h"

@implementation DHBatteryInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.battery = 0;
        self.status = 0;
        self.isLower = NO;
    }
    return self;
}

@end
