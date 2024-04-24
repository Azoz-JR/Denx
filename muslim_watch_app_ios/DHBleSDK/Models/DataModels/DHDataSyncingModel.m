//
//  DHDataSyncingModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/8/20.
//

#import "DHDataSyncingModel.h"

@implementation DHDataSyncingModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.count = 0;
        
        self.isStep = NO;
        self.isSleep = NO;
        self.isHeartRate = NO;
        self.isBp = NO;
        self.isBo = NO;
        self.isTemp = NO;
        
        self.isEcg = NO;
        self.isBreath = NO;
        self.isSport = NO;
        self.isPress = NO;
        
    }
    return self;
}

@end
