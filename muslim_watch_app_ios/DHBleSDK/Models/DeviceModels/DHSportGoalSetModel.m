//
//  DHSportGoalSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/28.
//

#import "DHSportGoalSetModel.h"

@implementation DHSportGoalSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.duration = 10;
        self.calorie = 100;
        self.distance = 1;
    }
    return self;
}

@end
