//
//  SedentarySetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "SedentarySetModel.h"

@implementation SedentarySetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.isOpen = NO;
        self.startHour = 8;
        self.startMinute = 0;
        self.endHour = 22;
        self.endMinute = 0;
        self.repeats = [@[@0,@0,@0,@0,@0,@0,@0] transToJsonString];
        self.interval = 30;
    }
    return self;
}

+ (__kindof SedentarySetModel *)currentModel{
    SedentarySetModel *model =[SedentarySetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[SedentarySetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_sedentary";
}

@end
