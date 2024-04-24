//
//  DHDialInfoModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHDialInfoModel.h"

@implementation DHDialInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.screenType = 0;
        self.screenWidth = 240;
        self.screenHeight = 280;
    }
    return self;
}

@end
