//
//  DHLocationSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2023/1/9.
//

#import "DHLocationSetModel.h"

@implementation DHLocationSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.longitude = 0;
        self.latitude = 0;
        self.locationStr = @"";
    }
    return self;
}

@end
