//
//  DeviceModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "DeviceModel.h"

@implementation DeviceModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        
        self.macAddr = @"";
        self.uuid = @"";
        self.name = @"";
        self.firmwareVersion = @"";
        self.deviceModel = @"";
        self.timestamp = @"";
    }
    return self;
}

+ (__kindof DeviceModel *)currentModel {
    DeviceModel *model = [DeviceModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[DeviceModel alloc] init];
    }
    return model;
}

+ (__kindof DeviceModel *)historyModel {
    DeviceModel *model = [DeviceModel findFirstWithFormat:@"WHERE userId = '%@'",DHUserId];
    if (!model) {
        model = [[DeviceModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_info";
}

@end
