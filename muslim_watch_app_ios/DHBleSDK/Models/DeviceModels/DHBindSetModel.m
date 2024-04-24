//
//  DHBindSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/28.
//

#import "DHBindSetModel.h"

@implementation DHBindSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isBind = NO;
        self.bindOS = 0;
        self.userId = @"";
    }
    return self;
}

- (NSData *)valueWithJL{
    return [NSData dataWithBytes:&_userIDJL length:4];
}

@end
