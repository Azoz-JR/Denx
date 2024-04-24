//
//  DHFunctionInfoModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHFunctionInfoModel.h"

@implementation DHFunctionInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isStep = YES;
        self.isSleep = YES;
        self.isHeartRate = YES;
        self.isBp = YES;
        self.isBo = YES;
        self.isTemp = YES;
        self.isEcg = NO;
        self.isBreath = YES;
        self.isPressure = NO;
        
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
        
        self.isQRCode = NO;
        self.isRestart = YES;
        self.isShutdown = YES;
        self.isBle3 = YES;
        self.isMenstrualCycle = YES;
        self.isLocation = NO;
        
    }
    return self;
}

@end
