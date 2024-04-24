//
//  OnlineFirmwareVersionModel.m
//  DHSFit
//
//  Created by DHS on 2022/11/12.
//

#import "OnlineFirmwareVersionModel.h"

@implementation OnlineFirmwareVersionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.currentVersion = @"";
        self.onlineVersion = @"";
        self.filePath = @"";
        self.desc = @"";
        
        self.fileSize = 0;
    }
    return self;
}

+ (__kindof OnlineFirmwareVersionModel *)currentModel {
    OnlineFirmwareVersionModel *model =[OnlineFirmwareVersionModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[OnlineFirmwareVersionModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_onlineversion";
}

@end
