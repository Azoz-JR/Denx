//
//  DHDeviceLogModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/10/11.
//

#import "DHDeviceLogModel.h"

@implementation DHDeviceLogModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timestamp = @"";
        self.date = @"";
        self.content = @"";
    }
    return self;
}

@end
