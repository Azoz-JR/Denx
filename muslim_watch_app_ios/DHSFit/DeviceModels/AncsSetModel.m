//
//  AncsSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/5.
//

#import "AncsSetModel.h"

@implementation AncsSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;

    }
    return self;
}

+ (__kindof AncsSetModel *)currentModel{
    AncsSetModel *model =[AncsSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[AncsSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_ancs";
}

@end
