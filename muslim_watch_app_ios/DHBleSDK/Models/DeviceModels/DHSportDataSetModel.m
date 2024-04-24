//
//  DHSportDataSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/28.
//

#import "DHSportDataSetModel.h"

@implementation DHSportDataSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isStop = NO;
        self.isMap = NO;
        self.duration = 0;
        self.calorie = 0;
        self.distance = 0;
        
        self.metricPace = 0;
        self.imperialPace = 0;
        self.strideFrequency = 0;
        self.timestamp = 0;
        
    }
    return self;
}

- (NSData *)valueWithJL
{
    NSMutableData *tValue = [NSMutableData dataWithCapacity:0];
    UInt32 tStep = (UInt32)self.step;
//    tStep = htonl(tStep);
    UInt32 tDistance = (UInt32)self.distance;
//    tDistance = htonl(tDistance);
    UInt32 tCalorie = (UInt32)self.calorie/1000;
//    tCalorie = htonl(tCalorie);
    UInt16 tSportTimeLong = self.duration;
//    tSportTimeLong = htons(tSportTimeLong);
    UInt16 tSportAveStepFreq = self.strideFrequency;
//    tSportAveStepFreq = htons(tSportAveStepFreq);
    UInt16 tSportHeight = self.jlAltitude;
//    tSportHeight = htons(tSportHeight);
    UInt16 tSportPressure = self.jlAirPressure;
//    tSportPressure = htons(tSportPressure);
    UInt32 tSportAvePace = (UInt32)self.metricPace; //秒每公里
//    tSportAvePace = htonl(tSportAvePace);
    UInt32 tSportAveSpeed = self.jlAveSpeed;
//    tSportAveSpeed = htonl(tSportAveSpeed);
    UInt8 tSportWorkMode = self.jlWorkMode;
    
    
    [tValue appendBytes:&tStep length:4];
    [tValue appendBytes:&tDistance length:4];
    [tValue appendBytes:&tCalorie length:4];
    [tValue appendBytes:&tSportTimeLong length:2];
    [tValue appendBytes:&tSportAveStepFreq length:2];
    [tValue appendBytes:&tSportHeight length:2];
    [tValue appendBytes:&tSportPressure length:2];
    [tValue appendBytes:&tSportAvePace length:4];
    [tValue appendBytes:&tSportAveSpeed length:4];
    [tValue appendBytes:&tSportWorkMode length:1];
    //预留3字节
    [tValue appendBytes:&tSportWorkMode length:1];
    [tValue appendBytes:&tSportWorkMode length:1];
    [tValue appendBytes:&tSportWorkMode length:1];

    
    return tValue;
}

@end
