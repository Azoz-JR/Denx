//
//  GuestureSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "GuestureSetModel.h"

@implementation GuestureSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.isOpen = NO;
        self.startHour = 9;
        self.startMinute = 0;
        self.endHour = 22;
        self.endMinute = 0;
    }
    return self;
}

+ (__kindof GuestureSetModel *)currentModel{
    GuestureSetModel *model =[GuestureSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[GuestureSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_guesture";
}

@end
