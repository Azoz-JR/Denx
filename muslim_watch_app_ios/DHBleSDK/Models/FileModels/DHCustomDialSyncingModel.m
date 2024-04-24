//
//  DHCustomDialSyncingModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/10/6.
//

#import "DHCustomDialSyncingModel.h"

@implementation DHCustomDialSyncingModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timePos = 0;
        self.timeUp = 1;
        self.timeDown = 2;
        self.textColor = 0x000000;
        self.imageType = 0;
        self.imageWidth = 240;
        self.imageHeight = 280;
    }
    return self;
}

@end
