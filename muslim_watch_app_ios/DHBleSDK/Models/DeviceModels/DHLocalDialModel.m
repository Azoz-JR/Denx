//
//  DHLocalDialModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/28.
//

#import "DHLocalDialModel.h"

@implementation DHLocalDialModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dialType = 0;
        self.dialId = 0;
    }
    return self;
}

@end
