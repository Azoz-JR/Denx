//
//  BrightTimeSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "BrightTimeSetModel.h"

@implementation BrightTimeSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.duration = 15;
    }
    return self;
}

+ (__kindof BrightTimeSetModel *)currentModel{
    BrightTimeSetModel *model =[BrightTimeSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[BrightTimeSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_brighttime";
}

@end
