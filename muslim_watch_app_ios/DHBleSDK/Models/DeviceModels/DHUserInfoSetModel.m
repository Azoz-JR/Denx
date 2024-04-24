//
//  DHUserInfoSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHUserInfoSetModel.h"

@implementation DHUserInfoSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gender = 1;
        self.age = 25;
        self.height = 170;
        self.weight = 65;
        self.stepGoal = 8000;
    }
    return self;
}

- (NSData *)valueWithJL
{
    NSMutableData *tValue = [NSMutableData dataWithCapacity:0];
    
    UInt8 tDistanceUnit = [ConfigureModel shareInstance].distanceUnit;
//    UInt8 tDistanceUint = 0; //0：公制 1：英制
    [tValue appendBytes:&tDistanceUnit length:1];
    [tValue appendBytes:&_gender length:1];
    [tValue appendBytes:&_age length:1];
    float tHeight = self.height;
    float tWeight = self.weight/10.0;
    [tValue appendBytes:&tHeight length:4];
    [tValue appendBytes:&tWeight length:4];
    
    return tValue;
}

@end
