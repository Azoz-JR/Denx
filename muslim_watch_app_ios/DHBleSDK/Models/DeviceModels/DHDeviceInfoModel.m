//
//  DHDeviceInfoModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/28.
//

#import "DHDeviceInfoModel.h"

@implementation DHDeviceInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.macAddr = @"";
        self.name = @"";
        self.isNeedConnect = NO;
    }
    return self;
}

@end
