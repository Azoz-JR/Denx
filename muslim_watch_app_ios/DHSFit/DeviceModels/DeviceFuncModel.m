//
//  DeviceFuncModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/9.
//

#import "DeviceFuncModel.h"

@implementation DeviceFuncModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.isStep = YES;
        self.isSleep = YES;
        self.isHeartRate = YES;
        self.isBp = YES;
        self.isBo = YES;
        self.isTemp = NO;
        self.isEcg = NO;
        self.isBreath = YES;
        
        self.isDial = YES;
        self.isWallpaper = YES;
        self.isAncs = YES;
        self.isSedentary = YES;
        self.isDrinking = YES;
        self.isReminderMode = YES;
        self.isAlarm = YES;
        self.isGesture = YES;
        
        self.isBrightTime = YES;
        self.isHeartRateMode = YES;
        self.isDisturbMode = YES;
        self.isWeather = YES;
        self.isContact = YES;
        self.isRestore = YES;
        self.isOTA = YES;
        self.isNFC = NO;
        
        self.isQRCode = YES;
        self.isRestart = YES;
        self.isShutdown = YES;
        self.isBle3 = YES;
        self.isMenstrualCycle = YES;
        
    }
    return self;
}

+ (__kindof DeviceFuncModel *)currentModel{
    DeviceFuncModel *model =[DeviceFuncModel findFirstWithFormat:@"WHERE macAddr = '%@'",DHMacAddr];
    if (!model) {
        model = [[DeviceFuncModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_func";
}

@end
