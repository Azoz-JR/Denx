//
//  CustomDialSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/10/6.
//

#import "CustomDialSetModel.h"

@implementation CustomDialSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.imagePath = @"";
        self.timePos = 0;
        self.timeUp = 1;
        self.timeDown = 4;
        self.textColor = 0x000000;
    }
    return self;
}

+ (__kindof CustomDialSetModel *)currentModel{
    CustomDialSetModel *model =[CustomDialSetModel findFirstWithFormat:@"WHERE macAddr = '%@' and userId = '%@'",DHMacAddr,DHUserId];
    if (!model) {
        model = [[CustomDialSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_customdial";
}

@end
