//
//  DHFileSyncingModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/11/23.
//

#import "DHFileSyncingModel.h"

@implementation DHFileSyncingModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileType = 0;
        self.fileSize = 0;
    }
    return self;
}

@end
