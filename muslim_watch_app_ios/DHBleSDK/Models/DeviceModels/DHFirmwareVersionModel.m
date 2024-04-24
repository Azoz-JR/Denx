//
//  DHFirmwareVersionModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/28.
//

#import "DHFirmwareVersionModel.h"

@implementation DHFirmwareVersionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firmwareVersion = @"";
        self.deviceModel = @"";
    }
    return self;
}

@end
