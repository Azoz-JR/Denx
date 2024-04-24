//
//  DHHealthDataModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/29.
//

#import "DHHealthDataModel.h"

@implementation DHHealthDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = 0;
        
        self.timestamp = 0;
        
        self.index = 0;
        self.step = 0;
        self.distance = 0;
        self.calorie = 0;
        
        self.heartRate = 0;
        self.systolic = 0;
        self.diastolic = 0;
        self.bo = 0;
        self.temp = 0;
        self.breath = 0;
        
    }
    return self;
}

@end
