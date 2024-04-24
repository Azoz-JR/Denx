//
//  DHSportControlModel.m
//  DHBleSDK
//
//  Created by DHS on 2023/1/9.
//

#import "DHSportControlModel.h"

@implementation DHSportControlModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.controlType = 0;
        self.sportType = 0;
    }
    return self;
}

- (NSData *)valueWithJL
{
    /// 控制类型（0.开始 1.暂停 2.继续 3.结束）
    /// 运动类型（2.骑行 3.动感单车 4.室内跑步 5.室外跑步 6.游泳 7.走路 8.举重 9.瑜伽 10.羽毛球 11.篮球 12.跳绳 13.自由锻炼 14.足球 15.爬山 16.乒乓球）
    NSMutableData *tValue = [NSMutableData dataWithCapacity:0];
    UInt8 tControlType = 0; //运动模式
    UInt8 tSportType = 0x08; //运动类型, JL默认跑步机
    UInt8 tJLControlType[4] = {0x01, 0x03, 0x02, 0x04};
    tControlType = tJLControlType[self.controlType];
    
    if (self.sportType == SportTypeRunIndoor){
        tSportType = BLE_ACTIVITY_INDOOR;
    }
    else if (self.sportType == SportTypeRunOutdoor){
        tSportType = BLE_ACTIVITY_RUNNING;
    }
    else if (self.sportType == SportTypeRide){
        tSportType = BLE_ACTIVITY_CYCLING;
    }
    else if (self.sportType == SportTypeClimb){
        tSportType = BLE_ACTIVITY_CLIMBING;
    }
    else if (self.sportType == SportTypeWalk){
        tSportType = BLE_ACTIVITY_WALKING;
    }
    else{
        tSportType = BLE_ACTIVITY_WALKING;
    }
    
    NSLog(@"tControlType %02X tSportType %02X jlType %02X", tControlType, self.sportType, tSportType);
    
    [tValue appendBytes:&tSportType length:1];
    [tValue appendBytes:&tControlType length:1];
    
    return tValue;
}

@end
