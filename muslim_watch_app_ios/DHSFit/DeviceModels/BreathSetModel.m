//
//  BreathSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/8/10.
//

#import "BreathSetModel.h"

@implementation BreathSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.isOpen = NO;
        self.hourItems = @"";
        self.minuteItems = @"";
    }
    return self;
}

+ (__kindof BreathSetModel *)currentModel{
    BreathSetModel *model =[BreathSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[BreathSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_breath";
}

@end
