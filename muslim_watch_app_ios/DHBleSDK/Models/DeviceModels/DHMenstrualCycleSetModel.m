//
//  DHMenstrualCycleSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/11/5.
//

#import "DHMenstrualCycleSetModel.h"

@implementation DHMenstrualCycleSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.type = 0;
        self.isOpen = NO;
        self.isRemindMenstrualPeriod = YES;
        self.isRemindOvulationPeriod = YES;
        self.isRemindOvulationPeak = YES;
        self.isRemindOvulationEnd = YES;
        
        self.cycleDays = 25;
        self.menstrualDays = 5;
        
        self.timestamp = 0;
        
        self.remindHour = 9;
        self.remindMinute = 0;
        
        self.jlRemindBeforeDay = 1;
        self.jlRemindOvulationBeforeDay = 1;
    }
    return self;
}

- (NSData *)valueWithJL
{
    Byte tMenstrualCycleByte[10] = {0};
    tMenstrualCycleByte[0] = 0x00;
    if (self.isOpen){
        tMenstrualCycleByte[0] = 0x01;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timestamp];
    
    tMenstrualCycleByte[1] = self.remindHour; //提醒时间小时
    tMenstrualCycleByte[2] = self.remindMinute;//提醒时间分钟
    tMenstrualCycleByte[3] = _jlRemindBeforeDay; //经期提醒提前0~15天
    tMenstrualCycleByte[4] = _jlRemindOvulationBeforeDay; //排卵期提醒提前0~15天
    tMenstrualCycleByte[5] = date.year - 2000; //最近一次月经年
    tMenstrualCycleByte[6] = date.month; //月
    tMenstrualCycleByte[7] = date.day; //日
    tMenstrualCycleByte[8] = self.menstrualDays; //经期/周期长度
    tMenstrualCycleByte[9] = self.cycleDays; //周期长度
    return [NSData dataWithBytes:tMenstrualCycleByte length:10];
}

@end
