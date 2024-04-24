//
//  DHUnitSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHUnitSetModel.h"

@implementation DHUnitSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.language = 0;
        self.timeformat = 0;
        self.distanceUnit = 0;
        self.tempUnit = 0;
    }
    return self;
}

@end
