//
//  DHPeripheralModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHPeripheralModel.h"

@implementation DHPeripheralModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.macAddr = @"";
        self.uuid = @"";
        self.name = @"";
        self.rssi = 0;
    }
    return self;
}

@end
