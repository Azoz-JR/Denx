//
//  DialInfoSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import "DialInfoSetModel.h"

@implementation DialInfoSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.screenType = 0;
        self.screenWidth = 320;
        self.screenHeight = 380;
        NSLog(@"DialInfoSetModel init");
    }
    return self;
}

+ (__kindof DialInfoSetModel *)currentModel{
    DialInfoSetModel *model =[DialInfoSetModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[DialInfoSetModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_dialinfo";
}

@end
