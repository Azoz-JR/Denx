//
//  DHQRCodeSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHQRCodeSetModel.h"

@implementation DHQRCodeSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appType = 0;
        self.title = @"";
        self.url = @"";
    }
    return self;
}

@end
