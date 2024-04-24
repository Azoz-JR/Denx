//
//  SportGoalSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/8/10.
//

#import "SportGoalSetModel.h"

@implementation SportGoalSetModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.isVibration = YES;
        self.isAlwaysBright = YES;
        self.isAutoPause = YES;
        
        self.duration = 10;
        self.calorie = 100;
        self.distance = 1;
    }
    return self;
}

+ (__kindof SportGoalSetModel *)currentModel{
    SportGoalSetModel *model =[SportGoalSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[SportGoalSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_sportgoal";
}

@end
