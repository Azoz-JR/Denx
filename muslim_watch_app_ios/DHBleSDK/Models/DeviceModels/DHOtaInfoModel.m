//
//  DHOtaInfoModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/7/5.
//

#import "DHOtaInfoModel.h"

@implementation DHOtaInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOta = NO;
        self.isComplete = YES;
    }
    return self;
}


@end
