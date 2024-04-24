//
//  JLBleAcceptManager.m
//  DHSFit
//
//  Created by DHS on 2023/10/5.
//

#import "JLBleAcceptManager.h"
#import "JLBleProtocol.h"
#import "DHTool.h"
#import "DHBleSendManager.h"

#define UTC_TO_YEAR2000_S      946684800u // 毫秒

@implementation JLBleAcceptManager

static JLBleAcceptManager *_shared = nil;
+ (__kindof JLBleAcceptManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    });
    return _shared ;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [JLBleAcceptManager shareInstance];
}

- (instancetype)init
{
    if (self = [super init]){
        _receiveData = [NSMutableData dataWithCapacity:0];
    }
    return self;
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [JLBleAcceptManager shareInstance];
}


- (void)didUpdateValueWithResponse:(NSData *)response {
    JLBleProtocol *tBleModel = nil;
    [self.receiveData appendData:response];
    if ([JLBleProtocol checkReceiveFinish:self.receiveData]){
        tBleModel = [JLBleProtocol unpackProtocolHead:self.receiveData];
        self.receiveData = [NSMutableData dataWithCapacity:0];
    }
    else{
        return;
    }
    
//    if (response.length < 8) {
//        DHSaveLog(@"response value error: no header");
//        return;
//    }
    if (tBleModel.magic != 0xAB) {
        DHSaveLog(@"response value error: identification error");
        return;
    }
    
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    
    if ((tBleModel.protocolFlag >> 4) == 0x00){ //需回复ACK
        UInt8 tStateCode = 0;
        JLBleProtocol *tBleAck = [[JLBleProtocol alloc] initAckCmd:tBleModel.cmdtype key:tBleModel.keytype opType:tBleModel.keyFlag value:[NSData dataWithBytes:&tStateCode length:1]];
        [manager sendAck:[tBleAck packProtocolData]];
    }
    else{// 接收到了ACK
        NSLog(@"接收到了ACK");
        [manager jlPopQueue];
    }
        
    switch (tBleModel.keytype) {
        case BLE_KEY_IDENTITY:{
#pragma mark- BLE_KEY_IDENTITY
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                
                if (tBleModel.payloadLen < 5){ //点击了取消
                    if (manager.bindSetBlock) {
                        manager.bindSetBlock(DHCommandCodeFailed, DHCommandMsgFailed);
                        manager.bindSetBlock = nil;
                    }
                    return;
                }
                else{
                    if (manager.bindSetBlock) {
                        manager.bindSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                        manager.bindSetBlock = nil;
                    }
                }
                
                //默认值
                UInt8 tJLHeart = 0;//默认心率开
                UInt8 tJLBO = 0; //默认血氧开
                UInt8 tJLBP = 0; //血压
                UInt8 tJLBloodsugar = 0; //血糖
                UInt8 tJLStress = 0;//默认压力开
                UInt8 tJLTemperature = 0; //体温
                UInt8 tIsMenstrualCycle = 1; //生理周期,默认开启
                
                int tOffset = 4;
                UInt32 tUserId = 0;
                [tBleModel.value getBytes:&tUserId range:NSMakeRange(tOffset, 4)];
                tOffset += 4;
                UInt8 tByteValue = 0;
                NSLog(@"tUserId %08X", tUserId);
                NSMutableData *tStrData = [NSMutableData data];
                NSString *tStrTemp = @"";
                NSInteger tStringCount = 0;
                for (int i = tOffset; i < tBleModel.value.length; ++i){
                    [tBleModel.value getBytes:&tByteValue range:NSMakeRange(i, 1)];
//                    [tStrData appendBytes:&tByteValue length:1];
                    if (tByteValue == 0){
                        tStrTemp = [[NSString alloc] initWithData:tStrData encoding:NSUTF8StringEncoding];
                        
                        if (tStringCount == 0){ //功能列表
                            NSLog(@"tStrData functionList %@", tStrData);
                            //0x05ff050205030504050d0505050e0509
                            int j = 0;
                            UInt16 tCmdType = 0;
                            while (j < tStrData.length) {
                                [tStrData getBytes:&tCmdType range:NSMakeRange(j, 2)];
                                tCmdType = ntohs(tCmdType);
                                j += 2;
                                
                                if (tCmdType == BLE_KEY_ACTIVITY){ //步数
                                    
                                }
                                else if (tCmdType == BLE_KEY_HEART_RATE){ //心率
                                    tJLHeart = 1;
                                }
                                else if (tCmdType == BLE_KEY_BLOOD_PRESSURE){ //血压
                                    tJLBP = 1;
                                }
                                else if (tCmdType == BLE_KEY_SLEEP){ //睡眠
                                    
                                }
                                else if (tCmdType == BLE_KEY_TEMPERATURE){ //温度
                                    tJLTemperature = 1;
                                }
                                else if (tCmdType == BLE_KEY_BLOOD_OXYGEN){ //血氧
                                    tJLBO = 1;
                                }
                                else if (tCmdType == BLE_KEY_STRESS){ //压力
                                    tJLStress = 1;
                                }
                                else if (tCmdType == BLE_KEY_WORKOUT2){
                                    
                                }
                                else if (tCmdType == BLE_KEY_BLOOD_SUGAR){
                                    tJLBloodsugar = 1;
                                }
                                
                                NSLog(@"tCmdType %04X", tCmdType);
                            }
                        }
                        tStrData = [NSMutableData data];
                        tStringCount++;
                        
                        if (tStringCount == 5){ //Device Model;
                            NSLog(@"tStrTemp 5 %@", tStrTemp);
                        }
                        else if (tStringCount == 6){//Device Model;
                            NSLog(@"tStrTemp 6 %@", tStrTemp);
                            self.jlDeviceModel = tStrTemp;
                            tOffset = i + 1;
                            break;
                        }
                    }
                    else{
                        [tStrData appendBytes:&tByteValue length:1];
                    }
//                    if ([tStrTemp contains:@"08010100"]){ //08010100  02130101
//                        tOffset = i + 1;
//                        break;
//                    }
                }
                
                UInt8 tAgpsFiltType = 0;
                [tBleModel.value getBytes:&tAgpsFiltType range:NSMakeRange(tOffset++, 1)];
                UInt16 tCmdpagesizes = 0;
                [tBleModel.value getBytes:&tCmdpagesizes range:NSMakeRange(tOffset, 2)];
                tOffset += 2;
                UInt8 tBptype = 0;
                [tBleModel.value getBytes:&tBptype range:NSMakeRange(tOffset++, 1)];
                
                char bt3address[18] = {0};
                [tBleModel.value getBytes:bt3address range:NSMakeRange(tOffset, 18)];
                tOffset += 18; //经典蓝牙地址
                
                UInt8 tHideNumBattery = 0;
                [tBleModel.value getBytes:&tHideNumBattery range:NSMakeRange(tOffset++, 1)];
                
                UInt8 tAntilostSwitch = 0;
                [tBleModel.value getBytes:&tAntilostSwitch range:NSMakeRange(tOffset++, 1)];
                
                UInt8 tNewSleep = 0;
                [tBleModel.value getBytes:&tNewSleep range:NSMakeRange(tOffset++, 1)];
                
                UInt8 tDateFormat = 0;
                [tBleModel.value getBytes:&tDateFormat range:NSMakeRange(tOffset++, 1)];
                
                tOffset += 7; //是否支持洗手提醒的设置
                
                tOffset += 18;
                UInt8 tJLWeather2Enable = 0;
                [tBleModel.value getBytes:&tJLWeather2Enable range:NSMakeRange(tOffset++, 1)];
                DeviceFuncModel *funcModel = [DeviceFuncModel currentModel];
                funcModel.isJLWeather2 = tJLWeather2Enable;
                
                tOffset += 6;

                [tBleModel.value getBytes:&tIsMenstrualCycle range:NSMakeRange(tOffset++, 1)];
                NSLog(@"杰里生理周期 %d isJLWeather2 %d", tIsMenstrualCycle, tJLWeather2Enable);
                
                funcModel.isHeartRate = tJLHeart;
                funcModel.isBo = tJLBO;
                funcModel.isBp = tJLBP;
                funcModel.isBloodSugar = tJLBloodsugar;
                funcModel.isPressure = tJLStress;
                funcModel.isTemp = tJLTemperature;
                funcModel.isMenstrualCycle = tIsMenstrualCycle;
                
                [funcModel saveOrUpdate];
                
                NSLog(@"tAgpsFiltType %02x tCmdpagesizes %04x isBp %02x bt3address %s tAntilostSwitch %02x tNewSleep %02x tJLWeather2Enable %02x", tAgpsFiltType, tCmdpagesizes, tJLBP, bt3address, tAntilostSwitch, tNewSleep, tJLWeather2Enable);

                [manager jlHandleNextPacket];
            }
            else if (tBleModel.keyFlag == BLE_KEY_FLAG_DELETE){
                if (manager.unbindBlock) {
                    manager.unbindBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.unbindBlock = nil;
                }
            }
            break;
        }
        case BLE_KEY_SESSION:{
            DHBindSetModel *model = [[DHBindSetModel alloc] init];
            model.isBind = YES;
            model.bindOS = 2;
            model.userId = @"0";
            
            if (manager.bindInfoGetBlock) {
                manager.bindInfoGetBlock(DHCommandCodeSuccessfully, model);
                manager.bindInfoGetBlock = nil;
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_TIME:{
            if (manager.timeSetBlock) {
                manager.timeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.timeSetBlock = nil;
            }
            [manager jlHandleNextPacket];

            break;
        }
        case BLE_KEY_TIME_ZONE:{
            if (manager.timeSetBlock) {
                manager.timeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.timeSetBlock = nil;
            }
            [manager jlHandleNextPacket];
            
            NSTimeZone *curTimeZone = [NSTimeZone localTimeZone];
            self.gTimezoneOffset = [curTimeZone secondsFromGMTForDate:[NSDate date]];
            
            NSLog(@"gTimezoneOffset %d", self.gTimezoneOffset);

            break;
        }
        case BLE_KEY_HOUR_SYSTEM:
        case BLE_KEY_LANGUAGE:
        case BLE_KEY_UNIT:
        case BLE_KEY_TEMPERATURE_UNIT:{
            if (manager.unitSetBlock) {
                manager.unitSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.unitSetBlock = nil;
            }
            [manager jlHandleNextPacket];

            break;
        }
        case BLE_KEY_WORSHIP_ANGLE:
        case BLE_KEY_USER_PROFILE:
        case BLE_KEY_STEP_GOAL:{
            if (manager.userInfoSetBlock) {
                manager.userInfoSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.userInfoSetBlock = nil;
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_FIRMWARE_VERSION:{
#pragma mark- BLE_KEY_FIRMWARE_VERSION
            DHFirmwareVersionModel *model = [[DHFirmwareVersionModel alloc] init];
            if (tBleModel.value.length >= 4) { //只包含版本号
                Byte *tValueByte = (Byte *)tBleModel.value.bytes;
                model.firmwareVersion = [NSString stringWithFormat:@"%d.%d.%d", tValueByte[3], tValueByte[4], tValueByte[5]];
                
                if (tBleModel.value.length > 16){ //包含宽高与DeviceModel
                    UInt8 tScreenType = 0; //0是方 1是圓
                    UInt16 tScreenWidth = 0;
                    UInt16 tScreenHeight = 0;
                    [tBleModel.value getBytes:&tScreenType range:NSMakeRange(6, 1)];
                    [tBleModel.value getBytes:&tScreenWidth range:NSMakeRange(7, 2)];
                    [tBleModel.value getBytes:&tScreenHeight range:NSMakeRange(9, 2)];
                    
                    self.jlDeviceModel = [[NSString alloc] initWithData:[NSData dataWithBytes:tValueByte + 11 length:8] encoding:NSUTF8StringEncoding];
                    
                    DialInfoSetModel *dialInfoModel = [DialInfoSetModel currentModel];
                    dialInfoModel.screenType = tScreenType;
                    dialInfoModel.screenWidth = tScreenWidth;
                    dialInfoModel.screenHeight = tScreenHeight;
                    
                    [dialInfoModel saveOrUpdate];

                    NSLog(@"firmwareVersion jlDeviceModel %@ %d %d %d", self.jlDeviceModel, tScreenType, tScreenWidth, tScreenHeight);
                }
                else if (tBleModel.value.length > 8){//只包含DeviceModel
                    self.jlDeviceModel = [[NSString alloc] initWithData:[NSData dataWithBytes:tValueByte + 6 length:8] encoding:NSUTF8StringEncoding];
                    NSLog(@"firmwareVersion 只包含DeviceModel %@", self.jlDeviceModel);
                    DialInfoSetModel *dialInfoModel = [DialInfoSetModel currentModel];
                    if ([self.jlDeviceModel isEqualToString:@"02130101"] ){
                        dialInfoModel.screenType = 1;
                        dialInfoModel.screenWidth = 466;
                        dialInfoModel.screenHeight = 466;
                    }
                    if ([self.jlDeviceModel isEqualToString:@"0A010200"] ){//小星亿
                        dialInfoModel.screenType = 0;
                        dialInfoModel.screenWidth = 240;
                        dialInfoModel.screenHeight = 296;
                    }
                    else{
                        dialInfoModel.screenType = 0;
                        dialInfoModel.screenWidth = 240;
                        dialInfoModel.screenHeight = 284;
                    }
                    [dialInfoModel saveOrUpdate];
                }
                
                if (self.jlDeviceModel.length > 0){
                    model.deviceModel = self.jlDeviceModel;
                }
                NSLog(@"firmwareVersion %@ jlDeviceModel %@", model.firmwareVersion, self.jlDeviceModel);
            }
            if (manager.firmwareVersionGetBlock) {
                manager.firmwareVersionGetBlock(DHCommandCodeSuccessfully, model);
                manager.firmwareVersionGetBlock = nil;
            }
            [manager jlHandleNextPacket];
            break;
        }        
        case BLE_KEY_POWER:{
            Byte *tValueByte = (Byte *)tBleModel.value.bytes;
            DHBatteryInfoModel *model = [[DHBatteryInfoModel alloc] init];
            model.isLower = 0;
            model.status = 0;
            model.battery = tValueByte[3];
            NSLog(@"BLE_KEY_POWER %d", model.battery);
            if (manager.batteryGetBlock) {
                manager.batteryGetBlock(DHCommandCodeSuccessfully, model);
                manager.batteryGetBlock = nil;
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_BLE_ADDRESS:{
            Byte *tValueByte = (Byte *)tBleModel.value.bytes;
            DHDeviceInfoModel *model = [[DHDeviceInfoModel alloc] init];
            model.macAddr = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", tValueByte[8], tValueByte[7], tValueByte[6], tValueByte[5], tValueByte[4], tValueByte[3]];
            model.name = @"";
            NSLog(@"JL model.macAddr %@", model.macAddr);
            
            if (manager.macAddressGetBlock) {
                manager.macAddressGetBlock(DHCommandCodeSuccessfully, model);
                manager.macAddressGetBlock = nil;
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_ACTIVITY_REALTIME:{
#pragma mark- BLE_KEY_ACTIVITY_REALTIME
            NSInteger count = 0;
            DHDataSyncingModel *model = [[DHDataSyncingModel alloc] init];
            model.isStep = YES;
            model.isSleep = YES;
            model.isHeartRate = YES;
            model.isBp = YES;
            model.isBo = YES;
            model.isTemp = NO;
            model.isBreath = NO;
            model.isEcg = NO;
            model.isPress = NO;
            
            model.isSport = YES;
            
            if (model.isStep) {
                count++;
            }
            if (model.isSleep) {
                count++;
            }
            if (model.isHeartRate) {
                count++;
            }
            if (model.isBp) {
                count++;
            }
            if (model.isBo) {
                count++;
            }
            if (model.isTemp) {
                count++;
            }
            if (model.isEcg) {
                count++;
            }
            if (model.isBreath) {
                count++;
            }
            if (model.isSport) {
                count++;
            }
            if (model.isPress) {
                count++;
            }
            model.count = count;
            
            if (manager.dataSyncingBlock) {
                DHDataSyncingModel *dataModel = model;
                if (dataModel.count > 0) {
                    manager.dataSyncProgress = 0;
                    manager.dataSyncInterval = 100/dataModel.count;
                    if (dataModel.isStep) {
                        self.receiveSliceDatas = [NSMutableArray arrayWithCapacity:0];
                        [manager startStepSyncing];
                    }
                    if (dataModel.isSleep) {
                        [manager startSleepSyncing];
                    }
                    if (dataModel.isHeartRate) {
                        [manager startHeartRateSyncing];
                    }
                    if (dataModel.isBo) {
                        [manager startBloodOxygenSyncing];
                    }
                    if (dataModel.isBp) {
                        [manager startBloodPressureSyncing];
                    }
                    if (dataModel.isSport) {
                        [manager startSportSyncing];
                    }
                    if (dataModel.isPress) {
                        [manager startJLPressSyncing];
                    }
                } else {
                    manager.isDataSyncing = NO;
                    if (manager.dataSyncingBlock) {
                        manager.dataSyncingBlock(DHCommandCodeSuccessfully, 100, DHCommandMsgSuccessfully);
                        manager.dataSyncingBlock = nil;
                    }
                }
            } else if (manager.checkDataSyncingBlock) {
                manager.checkDataSyncingBlock(DHCommandCodeSuccessfully, model);
                manager.checkDataSyncingBlock = nil;
            }
            break;
        }
        case BLE_KEY_APP_REAL_TIME_ACTIVITY_DATA:{
#pragma mark- BLE_KEY_APP_REAL_TIME_ACTIVITY_DATA
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                int tOffset = 3;
                UInt32 tActivityTime = 0;
                UInt8 tActivityMode = 0;
                UInt32 tActivitySteps = 0;
                UInt32 tActivityCalorie = 0;
                UInt32 tActivityDistance = 0;
                
                NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                while (tOffset < tBleModel.value.length) {
                    [tBleModel.value getBytes:&tActivityTime range:NSMakeRange(tOffset, 4)];
                    tActivityTime = ntohl(tActivityTime);
                    long tActivityTime2 = tActivityTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                    tOffset += 4;
                    [tBleModel.value getBytes:&tActivityMode range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tActivitySteps range:NSMakeRange(tOffset, 3)];
                    tActivitySteps = ntohl(tActivitySteps);
                    tActivitySteps = (tActivitySteps >> 8);
                    tOffset += 3;
                    [tBleModel.value getBytes:&tActivityCalorie range:NSMakeRange(tOffset, 4)];
                    tActivityCalorie = ntohl(tActivityCalorie);
                    tActivityCalorie = tActivityCalorie / 10; //KCal
                    tOffset += 4;
                    [tBleModel.value getBytes:&tActivityDistance range:NSMakeRange(tOffset, 4)];
                    tActivityDistance = ntohl(tActivityDistance);
                    tActivityDistance = tActivityDistance / 10000;
                    tOffset += 4;
                    
                    [self.receiveSliceDatas addObject:@{@"activitytime":@(tActivityTime2), @"step":@(tActivitySteps), @"calorie":@(tActivityCalorie), @"distance":@(tActivityDistance)}];
                    NSLog(@"计步 time: %d %@ %d step %d Cal %d Distance %d", tActivityTime, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tActivityTime2]], tActivityMode, tActivitySteps, tActivityCalorie, tActivityDistance);
                }
                
                NSMutableDictionary<NSString *, NSMutableArray *> *daysData = [NSMutableDictionary dictionary];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
                
                NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
                [dayFormatter setDateFormat:@"yyyyMMdd"];
                
                for (NSDictionary *entry in self.receiveSliceDatas) {
                    NSString *dayString = [dayFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[entry[@"activitytime"] unsignedIntValue]]];

                    NSMutableArray *hourlyData = daysData[dayString];
                    if (!hourlyData) {
                        // 如果这一天的数据还没有初始化，我们创建24小时的条目
                        hourlyData = [NSMutableArray arrayWithCapacity:0];
                        NSDate *startDate = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate dateWithTimeIntervalSince1970:[entry[@"activitytime"] unsignedIntValue]]];
                        for (int i = 0; i < 24; i++) {
                            [hourlyData addObject:@{@"index":@(i), @"step": @(0), @"calorie": @(0), @"distance":@(0), @"timestamp":@([startDate timeIntervalSince1970])}];
                        }
                        daysData[dayString] = hourlyData;
                        
                        DailyStepModel *stepModel = [DailyStepModel currentModel:dayString];
                        if (stepModel.items != nil && stepModel.items.length > 0){
                            NSArray *tSavedStepArray = [stepModel.items transToObject];
                            
                            //之前保存数据库里的是增量,需加前面每个时间点保存总量
                            NSInteger tSavedStep = 0;
                            NSInteger tSavedCal = 0;
                            NSInteger tSavedDis = 0;
                            for (int tSaveHourIndex = 0; tSaveHourIndex < tSavedStepArray.count; tSaveHourIndex++){
                                NSDictionary *tSavedDic = tSavedStepArray[tSaveHourIndex];
                                int tStep = [tSavedDic[@"step"] intValue];
                                int tCalorie = [tSavedDic[@"calorie"] intValue];
                                int tDistance = [tSavedDic[@"distance"] intValue];
                                
                                if (tStep > 0){
                                    tSavedStep += tStep;
                                    tSavedCal += tCalorie;
                                    tSavedDis += tDistance;
                                    
                                    [hourlyData replaceObjectAtIndex:tSaveHourIndex withObject:@{@"index":@(tSaveHourIndex), @"step":@(tSavedStep), @"calorie":@(tSavedCal), @"distance":@(tSavedDis), @"timestamp":@([tSavedDic[@"timestamp"] unsignedIntValue])}];
                                }
                            }
                        }
                    }

                    NSString *hourString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[entry[@"activitytime"] unsignedIntValue]]];
                    NSArray *thourStringArr = [hourString componentsSeparatedByString:@" "];
                    NSInteger tHourIndex = [[thourStringArr lastObject] integerValue];
                    
                    [hourlyData replaceObjectAtIndex:tHourIndex withObject:@{@"index":@(tHourIndex), @"step":entry[@"step"], @"calorie":entry[@"calorie"], @"distance":entry[@"distance"], @"timestamp":@([entry[@"activitytime"] unsignedIntValue])}];
                }
                NSMutableArray *resultArray = [NSMutableArray array];
                for (NSString *dayStepKey in daysData.allKeys){
                    NSMutableArray *tDayStepArr = daysData[dayStepKey];

                    NSDictionary *tLastStepDic = [tDayStepArr lastObject];

                    DHDailyStepModel *model = [[DHDailyStepModel alloc] init];
                    model.isJLType = YES;
                    model.timestamp = [NSString stringWithFormat:@"%ld", (long)[tLastStepDic[@"timestamp"] longValue]];
                    model.date = dayStepKey;
                    
                    NSInteger tMaxStep = 0;
                    for (NSDictionary *tStepDic in tDayStepArr){
                        NSInteger tStep = [tStepDic[@"step"] integerValue];
                        if (tStep > tMaxStep){
                            tMaxStep = tStep;
                            model.step = [tStepDic[@"step"] integerValue];
                            model.calorie = [tStepDic[@"calorie"] integerValue];
                            model.distance = [tStepDic[@"distance"] integerValue];
                        }
                    }
                    //计算增量
                    NSInteger tPreStep = 0;
                    NSInteger tPreCal = 0;
                    NSInteger tPreDis = 0;
                    NSMutableArray *tIncreaStepArr = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary *tStepDic in tDayStepArr){
                        NSInteger tStep = [tStepDic[@"step"] integerValue];
                        NSInteger tcalorie = [tStepDic[@"calorie"] integerValue];
                        NSInteger tdistance = [tStepDic[@"distance"] integerValue];

                        if (tStep - tPreStep >= 0){
                            [tIncreaStepArr addObject:@{@"index":tStepDic[@"index"], @"step": @(tStep - tPreStep), @"calorie": @(tcalorie - tPreCal), @"distance":@(tdistance - tPreDis), @"timestamp":tStepDic[@"timestamp"]}];
                            tPreStep = tStep;
                            tPreCal = tcalorie;
                            tPreDis = tdistance;
                        }
                        else{
                            [tIncreaStepArr addObject:tStepDic];
                        }
                    }
                    model.items = tIncreaStepArr;
                    [resultArray addObject:model];
                }
                
                for (DHDailyStepModel *tStepModel in resultArray){
                    [HealthDataManager saveDailyStepModel:tStepModel];
                }
                
                NSDictionary *dict = @{@"type":@(0)};
                //健康数据更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationHealthDataChange object:nil userInfo:dict];
    
                NSLog(@"实时步数历史请求完成,处理下一个类型");
                [self.receiveSliceDatas removeAllObjects];
                [manager jlHandleNextPacket];
            }
            break;
        }
        case BLE_KEY_ACTIVITY:{
#pragma mark- BLE_KEY_ACTIVITY
            if (tBleModel.keyFlag == BLE_KEY_FLAG_READ){
                int tOffset = 3;
                UInt32 tActivityTime = 0;
                UInt8 tActivityMode = 0;
                UInt32 tActivitySteps = 0;
                UInt32 tActivityCalorie = 0;
                UInt32 tActivityDistance = 0;
                NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                while (tOffset < tBleModel.value.length) {
                    [tBleModel.value getBytes:&tActivityTime range:NSMakeRange(tOffset, 4)];
                    tActivityTime = ntohl(tActivityTime);
                    long tActivityTime2 = tActivityTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                    tOffset += 4;
                    [tBleModel.value getBytes:&tActivityMode range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tActivitySteps range:NSMakeRange(tOffset, 3)];
                    tActivitySteps = ntohl(tActivitySteps);
                    tActivitySteps = (tActivitySteps >> 8);
                    tOffset += 3;
                    [tBleModel.value getBytes:&tActivityCalorie range:NSMakeRange(tOffset, 4)];
                    tActivityCalorie = ntohl(tActivityCalorie);
                    tActivityCalorie = tActivityCalorie / 10; //KCal
                    tOffset += 4;
                    [tBleModel.value getBytes:&tActivityDistance range:NSMakeRange(tOffset, 4)];
                    tActivityDistance = ntohl(tActivityDistance);
                    tActivityDistance = tActivityDistance / 10000;
                    tOffset += 4;
                    
                    [self.receiveSliceDatas addObject:@{@"activitytime":@(tActivityTime2), @"step":@(tActivitySteps), @"calorie":@(tActivityCalorie), @"distance":@(tActivityDistance)}];
                    NSLog(@"计步 time: %d %@ %d step %d Cal %d Distance %d", tActivityTime, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tActivityTime2]], tActivityMode, tActivitySteps, tActivityCalorie, tActivityDistance);
                }
                
                if (tBleModel.payloadLen > 3){ //清除已读取的历史数据，释放空间
                    NSLog(@"已读取的历史数据 payloadLen %d 将清除已读取的历史数据 ", tBleModel.payloadLen);
                    [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_ACTIVITY opType:BLE_KEY_FLAG_DELETE value:[NSData data]];
                }
                else{
                    
                    NSDictionary *tFirstRecvEntry = [self.receiveSliceDatas firstObject];
                    if (tFirstRecvEntry){
                        int tFirstNewestStep =  [tFirstRecvEntry[@"step"] unsignedIntValue];
                        if (tFirstNewestStep == 0){ //删除当天数据;
                            NSLog(@"step = 0 删除当天数据");
                            NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
                            [dayFormatter setDateFormat:@"yyyyMMdd"];
                            DailyStepModel *stepModel = [DailyStepModel currentModel:[dayFormatter stringFromDate:[NSDate date]]];
                            if (stepModel){
                                [stepModel deleteObject];
                            }
                        }
                    }
                    
                    NSMutableDictionary<NSString *, NSMutableArray *> *daysData = [NSMutableDictionary dictionary];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
                    
                    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
                    [dayFormatter setDateFormat:@"yyyyMMdd"];
                    
                    for (NSDictionary *entry in self.receiveSliceDatas) {
                        NSString *dayString = [dayFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[entry[@"activitytime"] unsignedIntValue]]];

                        NSMutableArray *hourlyData = daysData[dayString];
                        if (!hourlyData) {
                            // 如果这一天的数据还没有初始化，我们创建24小时的条目
                            hourlyData = [NSMutableArray arrayWithCapacity:0];
                            NSDate *startDate = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate dateWithTimeIntervalSince1970:[entry[@"activitytime"] unsignedIntValue]]];
                            for (int i = 0; i < 24; i++) {
                                [hourlyData addObject:@{@"index":@(i), @"step": @(0), @"calorie": @(0), @"distance":@(0), @"timestamp":@([startDate timeIntervalSince1970])}];
                            }
                            daysData[dayString] = hourlyData;
                            
                            DailyStepModel *stepModel = [DailyStepModel currentModel:dayString];
                            if (stepModel.items != nil && stepModel.items.length > 0){
                                NSArray *tSavedStepArray = [stepModel.items transToObject];
                                
                                //之前保存数据库里的是增量,需加前面每个时间点保存总量
                                NSInteger tSavedStep = 0;
                                NSInteger tSavedCal = 0;
                                NSInteger tSavedDis = 0;
                                for (int tSaveHourIndex = 0; tSaveHourIndex < tSavedStepArray.count; tSaveHourIndex++){
                                    NSDictionary *tSavedDic = tSavedStepArray[tSaveHourIndex];
                                    int tStep = [tSavedDic[@"step"] intValue];
                                    int tCalorie = [tSavedDic[@"calorie"] intValue];
                                    int tDistance = [tSavedDic[@"distance"] intValue];
                                    
                                    if (tStep > 0){
                                        tSavedStep += tStep;
                                        tSavedCal += tCalorie;
                                        tSavedDis += tDistance;
                                        
                                        [hourlyData replaceObjectAtIndex:tSaveHourIndex withObject:@{@"index":@(tSaveHourIndex), @"step":@(tSavedStep), @"calorie":@(tSavedCal), @"distance":@(tSavedDis), @"timestamp":@([tSavedDic[@"timestamp"] unsignedIntValue])}];
                                    }
                                }
                            }
                        }

                        NSString *hourString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[entry[@"activitytime"] unsignedIntValue]]];
                        NSArray *thourStringArr = [hourString componentsSeparatedByString:@" "];
                        NSInteger tHourIndex = [[thourStringArr lastObject] integerValue];
                        
                        [hourlyData replaceObjectAtIndex:tHourIndex withObject:@{@"index":@(tHourIndex), @"step":entry[@"step"], @"calorie":entry[@"calorie"], @"distance":entry[@"distance"], @"timestamp":@([entry[@"activitytime"] unsignedIntValue])}];
                    }
                    
                    
                    NSMutableArray *resultArray = [NSMutableArray array];
                    for (NSString *dayStepKey in daysData.allKeys){
                        NSMutableArray *tDayStepArr = daysData[dayStepKey];

                        NSDictionary *tLastStepDic = [tDayStepArr lastObject];

                        DHDailyStepModel *model = [[DHDailyStepModel alloc] init];
                        model.isJLType = YES;
                        model.timestamp = [NSString stringWithFormat:@"%ld", (long)[tLastStepDic[@"timestamp"] longValue]];
                        model.date = dayStepKey;
                        
                        NSInteger tMaxStep = 0;
                        for (NSDictionary *tStepDic in tDayStepArr){
                            NSInteger tStep = [tStepDic[@"step"] integerValue];
                            if (tStep > tMaxStep){
                                tMaxStep = tStep;
                                model.step = [tStepDic[@"step"] integerValue];
                                model.calorie = [tStepDic[@"calorie"] integerValue];
                                model.distance = [tStepDic[@"distance"] integerValue];
                            }
                        }
                        //计算增量
                        NSInteger tPreStep = 0;
                        NSInteger tPreCal = 0;
                        NSInteger tPreDis = 0;
                        NSMutableArray *tIncreaStepArr = [NSMutableArray arrayWithCapacity:0];
                        for (NSDictionary *tStepDic in tDayStepArr){
                            NSInteger tStep = [tStepDic[@"step"] integerValue];
                            NSInteger tcalorie = [tStepDic[@"calorie"] integerValue];
                            NSInteger tdistance = [tStepDic[@"distance"] integerValue];

                            if (tStep - tPreStep >= 0){
                                [tIncreaStepArr addObject:@{@"index":tStepDic[@"index"], @"step": @(tStep - tPreStep), @"calorie": @(tcalorie - tPreCal), @"distance":@(tdistance - tPreDis), @"timestamp":tStepDic[@"timestamp"]}];
                                tPreStep = tStep;
                                tPreCal = tcalorie;
                                tPreDis = tdistance;
                            }
                            else{
                                [tIncreaStepArr addObject:tStepDic];
                            }
                        }
                        model.items = tIncreaStepArr;
                        [resultArray addObject:model];
                    }
                    
                    NSLog(@"步数历史请求完成,处理下一个类型");
                    if (manager.dataSyncingBlock) {
                        if (manager.dataSyncProgress < 100) {
                            manager.dataSyncProgress += [manager getSyncInterval];
                        }
                        
                        [self.receiveSliceDatas removeAllObjects];
                        manager.dataSyncingBlock(DHCommandCodeSuccessfully, manager.dataSyncProgress, resultArray);
                        
                        if (manager.dataSyncProgress >= 100) {
                            manager.isDataSyncing = NO;
                            manager.dataSyncingBlock = nil;
                        }
                    }
                    [manager jlHandleNextPacket];
                }
            }
            else if (tBleModel.keyFlag == BLE_KEY_FLAG_DELETE){
                NSLog(@"步数 BLE_KEY_FLAG_DELETE 请求下一包步数历史");
//                [manager startStepSyncing];
                [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_ACTIVITY opType:BLE_KEY_FLAG_READ value:[NSData data]];
            }
            
            break;
        }
        case BLE_KEY_APP_REAL_TIME_HR_DATA:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                int tOffset = 3;
                UInt32 tHrTime = 0;
                UInt8 tHr = 0;
                
                NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                
                [tBleModel.value getBytes:&tHrTime range:NSMakeRange(tOffset, 4)];
                tHrTime = ntohl(tHrTime);
                long tHrTime2 = tHrTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                tOffset += 4;
                [tBleModel.value getBytes:&tHr range:NSMakeRange(tOffset++, 1)];
                tOffset += 1;
                                
                [self.receiveSliceDatas addObject:@{@"timestamp":@(tHrTime2), @"value":@(tHr)}];
                
                NSLog(@"实时心率 time: %d %@ %d", tHrTime, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tHrTime2]], tHr);
                
                NSMutableArray *resultArray = [NSMutableArray array];
                NSMutableDictionary *tDailyDic = [NSMutableDictionary dictionaryWithCapacity:0];
                
                for (NSDictionary *entry in self.receiveSliceDatas) {
                    UInt32 timestamp = [entry[@"timestamp"] unsignedIntValue];
                    int hrvalue = [entry[@"value"] intValue];
                    NSString *tDateDay = [DHTool dateToStringFormat:@"yyyyMMdd" date:[NSDate dateWithTimeIntervalSince1970:timestamp]];
                    DHDailyHrModel *tDailyHrModel = [tDailyDic valueForKey:tDateDay];
    
                    if (tDailyHrModel == nil){
                        tDailyHrModel = [[DHDailyHrModel alloc] init];
                        tDailyHrModel.isJLType = YES;
                        tDailyHrModel.date = tDateDay;
                        tDailyHrModel.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                        [tDailyDic setObject:tDailyHrModel forKey:tDateDay];
                        NSMutableArray *tItems = [NSMutableArray arrayWithObject:@{@"timestamp":@(timestamp), @"value":@(hrvalue)}];
                        tDailyHrModel.items = tItems;
                        [resultArray addObject:tDailyHrModel];
                    }
                    else{
                        tDailyHrModel.isJLType = YES;
                        [tDailyHrModel.items addObject:@{@"timestamp":@(timestamp), @"value":@(hrvalue)}];
                    }
                }
                
                for (DHDailyHrModel *tHrModel in resultArray){
                    [HealthDataManager saveDailyHrModel:tHrModel];
                }
                
                NSDictionary *dict = @{@"type":@(HealthDataTypeHeartRate - 1)};
                //健康数据更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationHealthDataChange object:nil userInfo:dict];
                [self.receiveSliceDatas removeAllObjects];
                NSLog(@"实时心率 历史请求完成,处理下一个类型");
                [manager jlHandleNextPacket];
            }
            break;
        }
        case BLE_KEY_HEART_RATE:{
#pragma mark- BLE_KEY_HEART_RATE
            if (tBleModel.keyFlag == BLE_KEY_FLAG_READ){
                int tOffset = 3;
                UInt32 tHrTime = 0;
                UInt8 tHr = 0;
                
                NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                while (tOffset < tBleModel.value.length) {
                    [tBleModel.value getBytes:&tHrTime range:NSMakeRange(tOffset, 4)];
                    tHrTime = ntohl(tHrTime);
                    long tHrTime2 = tHrTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                    tOffset += 4;
                    [tBleModel.value getBytes:&tHr range:NSMakeRange(tOffset++, 1)];
                    tOffset += 1;
                    
                    [self.receiveSliceDatas addObject:@{@"timestamp":@(tHrTime2), @"value":@(tHr)}];
                    
                    NSLog(@"心率 time: %d %@ %d", tHrTime, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tHrTime2]], tHr);
                }
                
                if (tBleModel.payloadLen > 3){ //清除已读取的历史数据，释放空间
                    NSLog(@"已读取的历史数据 payloadLen %d 将清除已读取的历史数据 ", tBleModel.payloadLen);
                    [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_HEART_RATE opType:BLE_KEY_FLAG_DELETE value:[NSData data]];
                }
                else{
                    NSMutableArray *resultArray = [NSMutableArray array];
                    NSMutableDictionary *tDailyDic = [NSMutableDictionary dictionaryWithCapacity:0];
                    
                    for (NSDictionary *entry in self.receiveSliceDatas) {
                        UInt32 timestamp = [entry[@"timestamp"] unsignedIntValue];
                        int hrvalue = [entry[@"value"] intValue];
                        NSString *tDateDay = [DHTool dateToStringFormat:@"yyyyMMdd" date:[NSDate dateWithTimeIntervalSince1970:timestamp]];
                        DHDailyHrModel *tDailyHrModel = [tDailyDic valueForKey:tDateDay];
        
                        if (tDailyHrModel == nil){
                            tDailyHrModel = [[DHDailyHrModel alloc] init];
                            tDailyHrModel.isJLType = YES;
                            tDailyHrModel.date = tDateDay;
                            tDailyHrModel.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                            [tDailyDic setObject:tDailyHrModel forKey:tDateDay];
                            NSMutableArray *tItems = [NSMutableArray arrayWithObject:@{@"timestamp":@(timestamp), @"value":@(hrvalue)}];
                            tDailyHrModel.items = tItems;
                            [resultArray addObject:tDailyHrModel];
                        }
                        else{
                            tDailyHrModel.isJLType = YES;
                            [tDailyHrModel.items addObject:@{@"timestamp":@(timestamp), @"value":@(hrvalue)}];
                        }
                    }
                    
                    NSLog(@"心率 历史请求完成,处理下一个类型");
                    if (manager.dataSyncingBlock) {
                        if (manager.dataSyncProgress < 100) {
                            manager.dataSyncProgress += [manager getSyncInterval];
                        }
                        
                        [self.receiveSliceDatas removeAllObjects];
                        manager.dataSyncingBlock(DHCommandCodeSuccessfully, manager.dataSyncProgress, resultArray);
                        
                        if (manager.dataSyncProgress >= 100) {
                            manager.isDataSyncing = NO;
                            manager.dataSyncingBlock = nil;
                        }
                    }
                    [manager jlHandleNextPacket];
                }
            }
            else if (tBleModel.keyFlag == BLE_KEY_FLAG_DELETE){
                NSLog(@"心率真 BLE_KEY_FLAG_DELETE 请求下一包步数历史");
//                [manager startStepSyncing];
                [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_HEART_RATE opType:BLE_KEY_FLAG_READ value:[NSData data]];
            }
            break;
        }
        case BLE_KEY_SEDENTARINESS:{
            
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.sedentarySetBlock) {
                    manager.sedentarySetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.sedentarySetBlock = nil;
                }
            }
            else{
                int tOffset = 3;
                UInt8 tDayFlags = 0;
                UInt8 tStartHour = 0;
                UInt8 tStartMin = 0;
                UInt8 tEndHour = 0;
                UInt8 tEndMin = 0;
                UInt8 tRemindInterval = 0;
                
                [tBleModel.value getBytes:&tDayFlags range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tRemindInterval range:NSMakeRange(tOffset++, 1)];
                
                
                DHSedentarySetModel *model = [[DHSedentarySetModel alloc] init];
                model.isOpen = 0;
                if ((tDayFlags & 0x80) > 0){ //Bit 7为久坐的独立开关
                    model.isOpen = 1;
                }
                model.interval = tRemindInterval;
                NSInteger repeatsNumber = (tDayFlags & 0x7F);
                model.repeats = [DHTool transformRepeatNumber:repeatsNumber];
                model.startHour = tStartHour;
                model.startMinute = tStartMin;
                model.endHour = tEndHour;
                model.endMinute = tEndMin;
                
                if (manager.sedentaryGetBlock) {
                    manager.sedentaryGetBlock(DHCommandCodeSuccessfully, model);
                    manager.sedentaryGetBlock = nil;
                }
                [manager jlHandleNextPacket];
            }

            break;
        }
        case BLE_KEY_DRINK_WATER_SITE:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.drinkingSetBlock) {
                    manager.drinkingSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.drinkingSetBlock = nil;
                }
            }
            else{
                int tOffset = 3;
                UInt8 tDayFlags = 0;
                UInt8 tStartHour = 0;
                UInt8 tStartMin = 0;
                UInt8 tEndHour = 0;
                UInt8 tEndMin = 0;
                UInt8 tRemindInterval = 0;
                
                [tBleModel.value getBytes:&tDayFlags range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tRemindInterval range:NSMakeRange(tOffset++, 1)];
                
                DHDrinkingSetModel *model = [[DHDrinkingSetModel alloc] init];
                model.isOpen = 0;
                if ((tDayFlags & 0x80) > 0){ //Bit 7为久坐的独立开关
                    model.isOpen = 1;
                }
                model.interval = tRemindInterval;
                model.startHour = tStartHour;
                model.startMinute = tStartMin;
                model.endHour = tEndHour;
                model.endMinute = tEndMin;
                
                if (manager.drinkingGetBlock) {
                    manager.drinkingGetBlock(DHCommandCodeSuccessfully, model);
                    manager.drinkingGetBlock = nil;
                }
                [manager jlHandleNextPacket];
            }
            break;
        }
        case BLE_KEY_GESTURE_WAKE:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.gestureSetBlock) {
                    manager.gestureSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.gestureSetBlock = nil;
                }
            }
            else{
                int tOffset = 3;
                UInt8 tDayFlags = 0;
                UInt8 tStartHour = 0;
                UInt8 tStartMin = 0;
                UInt8 tEndHour = 0;
                UInt8 tEndMin = 0;
                
                [tBleModel.value getBytes:&tDayFlags range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndMin range:NSMakeRange(tOffset++, 1)];
                
                
                DHGestureSetModel *model = [[DHGestureSetModel alloc] init];
                model.isOpen = tDayFlags;
                model.startHour = tStartHour;
                model.startMinute = tStartMin;
                model.endHour = tEndHour;
                model.endMinute = tEndMin;
                
                if (manager.gestureGetBlock) {
                    manager.gestureGetBlock(DHCommandCodeSuccessfully, model);
                    manager.gestureGetBlock = nil;
                }
                [manager jlHandleNextPacket];
            }
            break;
        }
        case BLE_KEY_BACK_LIGHT:{
#pragma mark- BLE_KEY_BACK_LIGHT
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.brightTimeSetBlock) {
                    manager.brightTimeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.brightTimeSetBlock = nil;
                }
            }
            else{
                int tOffset = 3;
                UInt8 tDayFlags = 0;
                UInt8 tDurationNum = 0;
                
                [tBleModel.value getBytes:&tDayFlags range:NSMakeRange(tOffset++, 1)];
                DHBrightTimeSetModel *model = [[DHBrightTimeSetModel alloc] init];
                model.duration = tDayFlags;
                model.durationNums = @"";
                if (tBleModel.value.length > 4){
                    //5, 10, 15, 20, 25, 30, 0
                    NSMutableArray *tDurationNums = [NSMutableArray arrayWithCapacity:0];
                    for (int i = tOffset; i < tBleModel.value.length; i++){
                        [tBleModel.value getBytes:&tDurationNum range:NSMakeRange(i, 1)];
                        [tDurationNums addObject:[NSString stringWithFormat:@"%d", tDurationNum]];
                    }
                    NSString *commaSeparatedString = [tDurationNums componentsJoinedByString:@"_"];
                    model.durationNums = commaSeparatedString;
                    NSLog(@"BLE_KEY_BACK_LIGHT %@", commaSeparatedString);
                }
                
                
                if (manager.brightTimeGetBlock) {
                    manager.brightTimeGetBlock(DHCommandCodeSuccessfully, model);
                    manager.brightTimeGetBlock = nil;
                }
                [manager jlHandleNextPacket];
            }
            break;
        }
        case BLE_KEY_NO_DISTURB_RANGE:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE && tBleModel.protocolFlag == 0x11){ //设备ACK
                if (manager.disturbModeSetBlock) {
                    manager.disturbModeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.disturbModeSetBlock = nil;
                }
            }
            else{
                int tOffset = 3;
                UInt8 tAllOpen = 0; //总开关
                UInt8 tDayFlags = 0;
                UInt8 tStartHour = 0;
                UInt8 tStartMin = 0;
                UInt8 tEndHour = 0;
                UInt8 tEndMin = 0;
                //020a00 01 00 17 00 07 00 ffffffffffffffffffff
                //020a00 00 00 17000700ffffffffffffffffffff
                //020a00 01 16 00 07 00
                
                [tBleModel.value getBytes:&tAllOpen range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tDayFlags range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndMin range:NSMakeRange(tOffset++, 1)];
                
                
                DHDisturbModeSetModel *model = [[DHDisturbModeSetModel alloc] init];
                model.isAllday = 0;
                model.isOpen = tAllOpen;
                model.startHour = tStartHour;
                model.startMinute = tStartMin;
                model.endHour = tEndHour;
                model.endMinute = tEndMin;
                
                if (tBleModel.protocolFlag == 0x01){ //设备主动发送
                    DisturbModeSetModel *disturbModel = [DisturbModeSetModel currentModel];
                    
                    disturbModel.isOpen = model.isOpen;
                    disturbModel.isAllday = model.isAllday;
                    disturbModel.startHour = model.startHour;
                    disturbModel.startMinute = model.startMinute;
                    disturbModel.endHour = model.endHour;
                    disturbModel.endMinute = model.endMinute;
                    
                    [disturbModel saveOrUpdate];
                    //勿扰模式更新
                    [DHNotificationCenter postNotificationName:BluetoothNotificationDisturbModeChange object:nil];
                }
                else{
                    NSLog(@"APP端设置发送 直接返回block");
                    if (manager.disturbModeGetBlock) {
                        manager.disturbModeGetBlock(DHCommandCodeSuccessfully, model);
                        manager.disturbModeGetBlock = nil;
                    }
                }
                [manager jlHandleNextPacket];
            }
            break;
        }
        case BLE_KEY_FIND_WATCH:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.findDeviceControlBlock) {
                    manager.findDeviceControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.findDeviceControlBlock = nil;
                }
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_FIND_PHONE:{
            if (tBleModel.protocolFlag == 0x11){ //设备回复ack
                if (manager.findPhoneControlBlock) {
                    manager.findPhoneControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.findPhoneControlBlock = nil;
                }
            }
            else{ //设备主动更新数据
                int tOffset = 3;
                UInt8 tDayFlags = 0;
                
                [tBleModel.value getBytes:&tDayFlags range:NSMakeRange(tOffset++, 1)];
                if (tDayFlags == 1) {
                    //寻找手机结束
                    [DHNotificationCenter postNotificationName:BluetoothNotificationFindPhoneEnd object:nil];
                } else {
                    //寻找手机开始
                    [DHNotificationCenter postNotificationName:BluetoothNotificationFindPhoneStart object:nil];
                }
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_HR_MONITORING:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.heartRateModeSetBlock) {
                    manager.heartRateModeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.heartRateModeSetBlock = nil;
                }
            }
            else{
                int tOffset = 3;
                UInt8 tDayFlags = 0;
                UInt8 tStartHour = 0;
                UInt8 tStartMin = 0;
                UInt8 tEndHour = 0;
                UInt8 tEndMin = 0;
                UInt8 tInterval = 0;
                
                [tBleModel.value getBytes:&tDayFlags range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tEndMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tInterval range:NSMakeRange(tOffset++, 1)];
                
                DHHeartRateModeSetModel *model = [[DHHeartRateModeSetModel alloc] init];
                model.isOpen = tDayFlags;
                model.startHour = tStartHour;
                model.startMinute = tStartMin;
                model.endHour = tEndHour;
                model.endMinute = tEndMin;
                model.interval = tInterval;
                
                if (manager.heartRateModeGetBlock) {
                    manager.heartRateModeGetBlock(DHCommandCodeSuccessfully, model);
                    manager.heartRateModeGetBlock = nil;
                }
                [manager jlHandleNextPacket];
            }
            break;
        }
        case BLE_KEY_GIRL_CARE:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.menstrualCycleSetBlock) {
                    manager.menstrualCycleSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.menstrualCycleSetBlock = nil;
                }
            }
            else{
                int tOffset = 3;
                UInt8 tDayFlags = 0;
                UInt8 tStartHour = 0;
                UInt8 tStartMin = 0;
                UInt8 tLastRemindYear = 0;
                UInt8 tLastRemindMonth = 0;
                UInt8 tLastRemindDay = 0;
                UInt8 tMenstrualLen = 0;
                UInt8 tMenstrualCycleLen = 0;
                UInt8 tMenstrualBeforeDay1 = 0;
                UInt8 tMenstrualBeforeDay2 = 0;

                
                [tBleModel.value getBytes:&tDayFlags range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tStartMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tMenstrualBeforeDay1 range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tMenstrualBeforeDay2 range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tLastRemindYear range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tLastRemindMonth range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tLastRemindDay range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tMenstrualLen range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tMenstrualCycleLen range:NSMakeRange(tOffset++, 1)];
                
                DHMenstrualCycleSetModel *model = [[DHMenstrualCycleSetModel alloc] init];
                model.type = 0;
                model.isOpen = tDayFlags;
                model.isRemindMenstrualPeriod = YES;
                model.isRemindOvulationPeriod = YES;
                model.isRemindOvulationPeak = YES;
                model.isRemindOvulationEnd = YES;
                
                model.cycleDays = tMenstrualCycleLen;
                model.menstrualDays = tMenstrualLen;
                if (tLastRemindYear == 0xff && tLastRemindMonth == 0xff && tLastRemindDay == 0xff){ //设备初始化是值
                    model.timestamp = [[NSDate date] timeIntervalSince1970];
                }
                else{
                    NSString *date = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)tLastRemindYear + 2000,(long)tLastRemindMonth,(long)tLastRemindDay];
                    model.timestamp = [[NSDate get1970timeTempWithDateStr:date] integerValue];
                }
                
                model.remindHour = tStartHour;
                model.remindMinute = tStartMin;
                
                model.jlRemindBeforeDay = tMenstrualBeforeDay1;
                model.jlRemindOvulationBeforeDay = tMenstrualBeforeDay2;
                
                if (manager.menstrualCycleGetBlock) {
                    manager.menstrualCycleGetBlock(DHCommandCodeSuccessfully, model);
                    manager.menstrualCycleGetBlock = nil;
                }
                [manager jlHandleNextPacket];
            }
            break;
            break;
        }
        case BLE_KEY_NOTIFICATION_REMINDER:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.ancsSetBlock) {
                    manager.ancsSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.ancsSetBlock = nil;
                }
            }
            else{
                int tOffset = 3;
                UInt32 tNtfValue = 0;
                [tBleModel.value getBytes:&tNtfValue range:NSMakeRange(tOffset++, 4)];
//                NSLog(@"tNtfValue %08X", tNtfValue);
                tNtfValue = ntohl(tNtfValue);
//                NSLog(@"tNtfValue ntohl %08X", tNtfValue);
                
                DHAncsSetModel *model = [[DHAncsSetModel alloc] init];
                model.isOther = (tNtfValue & (1 << 0));
                model.isCall = (tNtfValue & (1 << 1));
                model.isSMS = (tNtfValue & (1 << 2));
                model.isEmail = (tNtfValue & (1 << 3));
                model.isSkype = (tNtfValue & (1 << 4));
                model.isFacebook = (tNtfValue & (1 << 5));
                model.isWhatsapp = (tNtfValue & (1 << 6));
                model.isLine = (tNtfValue & (1 << 7));
                model.isInstagram = (tNtfValue & (1 << 8));
                model.isKakaotalk = (tNtfValue & (1 << 9));
                model.isGmail = (tNtfValue & (1 << 10));
                model.isTwitter = (tNtfValue & (1 << 11));
                model.isLinkedin = (tNtfValue & (1 << 12));
                
                model.isJLSinaWeiBo = (tNtfValue & (1 << 13));
                
                model.isQQ = (tNtfValue & (1 << 14));
                model.isWechat = (tNtfValue & (1 << 15));
                
                model.isJLBand = (tNtfValue & (1 << 16));
                model.isJLTelegram = (tNtfValue & (1 << 17));
                model.isJLBetween = (tNtfValue & (1 << 18));
                model.isJLNavercafe = (tNtfValue & (1 << 19));
                
                model.isYoutube = (tNtfValue & (1 << 20));
                
                model.isJLNetflix = (tNtfValue & (1 << 21));
                
                if (manager.ancsGetBlock) {
                    manager.ancsGetBlock(DHCommandCodeSuccessfully, model);
                    manager.ancsGetBlock = nil;
                }
                [manager jlHandleNextPacket];
            }
            break;
        }
        case BLE_KEY_ALARM:{
            
            if (tBleModel.keyFlag == BLE_KEY_FLAG_CREATE 
                || tBleModel.keyFlag == BLE_KEY_FLAG_DELETE
                || tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                
                if (tBleModel.protocolFlag == 0x01){
                    NSLog(@"设备端发送 直接刷新闹钟列表");
                    [DHNotificationCenter postNotificationName:BluetoothNotificationAlarmChange object:nil];
                }
                else{
                    NSLog(@"APP端设置发送 直接返回block");
                    if (manager.alarmSetBlock) {
                        manager.alarmSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                        manager.alarmSetBlock = nil;
                    }
                }
            }
            else{
                int tOffset = 3;
                UInt8 tAlarmId = 0;
                UInt8 tDayflags = 0;
                UInt8 tYear = 0;
                UInt8 tMonth = 0;
                UInt8 tDay = 0;
                UInt8 tHour = 0;
                UInt8 tMin = 0;
                NSData *tAlarmNameData;
                
                NSMutableArray *alarms = [NSMutableArray array];
                while (tOffset < tBleModel.value.length) {
                    [tBleModel.value getBytes:&tAlarmId range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tDayflags range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tYear range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tMonth range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tDay range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tHour range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tMin range:NSMakeRange(tOffset++, 1)];
                    tAlarmNameData = [tBleModel.value subdataWithRange:NSMakeRange(tOffset, 21)];
                    tOffset += 21;
                    
                    
                    DHAlarmSetModel *model = [[DHAlarmSetModel alloc] init];
                    model.jlAlarmId = tAlarmId;
                    model.isOpen = 0;
                    if ((tDayflags & 0x80) > 0){ //Bit 7为久坐的独立开关
                        model.isOpen = 1;
                    }
                    NSInteger repeatsNumber = (tDayflags & 0x7F);
                    model.repeats = [DHTool transformRepeatNumber:repeatsNumber];
                    model.jlYear = tYear + 2000;
                    model.jlMonth = tMonth;
                    model.jlDay = tDay;

                    model.hour = tHour;
                    model.minute = tMin;
                    model.isRemindLater = YES;
                    model.alarmType = [[NSString alloc] initWithData:tAlarmNameData encoding:NSUTF8StringEncoding];
                    [alarms addObject:model];
                    
                    NSLog(@"tAlarmId %d tDayflags %d tYear %d tMonth %d tDay %d tHour %d tMin %d alarmType %@", tAlarmId, tDayflags, tYear, tMonth, tDay, tHour, tMin, model.alarmType);
                    
                }
                
                if (manager.alarmsGetBlock) {
                    manager.alarmsGetBlock(DHCommandCodeSuccessfully, alarms);
                    manager.alarmsGetBlock = nil;
                }
                [manager jlHandleNextPacket];
            }

            break;
        }
        case BLE_KEY_WEATHER_FORECAST2:
        case BLE_KEY_WEATHER_FORECAST:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.weatherSetBlock) {
                    manager.weatherSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.weatherSetBlock = nil;
                }
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_WEATHER_REALTIME2:
        case BLE_KEY_WEATHER_REALTIME:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
//                if (manager.weatherSetBlock) {
//                    manager.weatherSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
//                    manager.weatherSetBlock = nil;
//                }
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_SHUT_DOWN:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                if (manager.deviceControlBlock) {
                    manager.deviceControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.deviceControlBlock = nil;
                }
            }
            [manager jlHandleNextPacket];
            break;
        }
#pragma mark- 穆斯林祈祷闹钟
        case BLE_KEY_APP_PRAYER_TIME_SYNC:{
            NSLog(@"BLE_KEY_APP_PRAYER_TIME_SYNC");
            int tOffset = 3;
            Byte tPrayerHour = 0;
            Byte tPrayerMin = 0;
            Byte tPrayerOn = 0;
            NSMutableArray *prayAlarms = [NSMutableArray array];
            while (tOffset < 18 && tBleModel.value.length > 15) {
                [tBleModel.value getBytes:&tPrayerHour range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tPrayerMin range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tPrayerOn range:NSMakeRange(tOffset++, 1)];
                
                DHPrayAlarmSetModel *model = [[DHPrayAlarmSetModel alloc] init];
                model.isOpen = tPrayerOn;
                model.hour = tPrayerHour;
                model.minute = tPrayerMin;
                [prayAlarms addObject:model];
                NSLog(@"tPrayerHour %02d:%02d %d", tPrayerHour, tPrayerMin, tPrayerOn);
                
                if (manager.prayAlarmGetBlock) {
                    manager.prayAlarmGetBlock(DHCommandCodeSuccessfully, prayAlarms);
//                    manager.prayAlarmGetBlock = nil;
                }
            }
            
            if (tBleModel.keyFlag == BLE_KEY_FLAG_READ){
                
            }
            else{
                if (manager.prayAlarmSetBlock) {
                    manager.prayAlarmSetBlock(DHCommandCodeSuccessfully, prayAlarms);
                    manager.prayAlarmSetBlock = nil;
                }
            }
        
            
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_WORKOUT2:
        case BLE_KEY_WORKOUT:{
#pragma mark- BLE_KEY_WORKOUT
            if (tBleModel.keyFlag == BLE_KEY_FLAG_READ){
                int tOffset = 3;
                UInt32 tSportStartTime = 0;
                UInt32 tSportEndTime = 0;
                UInt16 tSportTimeLen = 0;
                UInt16 tSportHeight = 0;
                UInt16 tSportPress = 0;
                UInt8 tSportStepFreq = 0;
                UInt8 tSportType = 0;
                UInt32 tSportStep = 0;
                UInt32 tSportDistance = 0;
                UInt32 tSportCalorie = 0;
                float tSportSpeed = 0;
                UInt32 tSportPace = 0;
                NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                while (tOffset < tBleModel.value.length) {
                    [tBleModel.value getBytes:&tSportStartTime range:NSMakeRange(tOffset, 4)];
                    tSportStartTime = ntohl(tSportStartTime);
                    tSportStartTime = tSportStartTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                    tOffset += 4;
                    
                    [tBleModel.value getBytes:&tSportEndTime range:NSMakeRange(tOffset, 4)];
                    tSportEndTime = ntohl(tSportEndTime);
                    tSportEndTime = tSportEndTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                    tOffset += 4;
                    
                    [tBleModel.value getBytes:&tSportTimeLen range:NSMakeRange(tOffset, 2)];
                    tOffset += 2;
                    tSportTimeLen = ntohs(tSportTimeLen);
                    
                    [tBleModel.value getBytes:&tSportHeight range:NSMakeRange(tOffset, 2)];
                    tOffset += 2;
                    tSportHeight = ntohs(tSportHeight);
                    
                    [tBleModel.value getBytes:&tSportPress range:NSMakeRange(tOffset, 2)];
                    tOffset += 2;
                    tSportPress = ntohs(tSportPress);
                    
                    [tBleModel.value getBytes:&tSportStepFreq range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tSportType range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tSportStep range:NSMakeRange(tOffset, 4)];
                    tSportStep = ntohl(tSportStep);
                    
                    
                    NSLog(@"运动时长 %ds 高度 %dm 气压 %d 步频 %d 运动模式 %d 步数 %d", tSportTimeLen, tSportHeight, tSportPress, tSportStepFreq, tSportType, tSportStep);
                    
                    tOffset += 4;
                    [tBleModel.value getBytes:&tSportDistance range:NSMakeRange(tOffset, 4)];
                    tSportDistance = ntohl(tSportDistance);
                    tOffset += 4;
                    [tBleModel.value getBytes:&tSportCalorie range:NSMakeRange(tOffset, 4)];
                    tSportCalorie = ntohl(tSportCalorie);
                    tOffset += 4;
                    [tBleModel.value getBytes:&tSportSpeed range:NSMakeRange(tOffset, 4)];
//                    tSportSpeed = ntohl(tSportSpeed);
                    tOffset += 4;
                    
                    [tBleModel.value getBytes:&tSportPace range:NSMakeRange(tOffset, 4)];
                    tSportPace = ntohl(tSportPace);
                    tOffset += 4;
                    UInt8 tAveHeart = 0;
                    [tBleModel.value getBytes:&tAveHeart range:NSMakeRange(tOffset++, 1)];
                    UInt8 tMaxHeart = 0;
                    [tBleModel.value getBytes:&tMaxHeart range:NSMakeRange(tOffset++, 1)];
                    UInt8 tMinHeart = 0;
                    [tBleModel.value getBytes:&tMinHeart range:NSMakeRange(tOffset++, 1)];
                    UInt8 tViewType = 0;
                    [tBleModel.value getBytes:&tViewType range:NSMakeRange(tOffset++, 1)];
//                    tOffset++; //预留
                    
                    NSLog(@"运动距离 %dm 运动卡路里 %dkal 速度 %.2fm/h 配速 %d 平均心率 %d 最大心率 %d 最小心率 %d tViewType %d", tSportDistance, tSportCalorie, tSportSpeed, tSportPace, tAveHeart, tMaxHeart, tMinHeart, tViewType);
                    
                    UInt16 tMaxStepFreq = 0; //最大步频
                    [tBleModel.value getBytes:&tMaxStepFreq range:NSMakeRange(tOffset, 2)];
                    tMaxStepFreq = ntohs(tMaxStepFreq);
                    tOffset += 2;
                    UInt16 tMinStepFreq = 0; //最小步频
                    [tBleModel.value getBytes:&tMinStepFreq range:NSMakeRange(tOffset, 2)];
                    tMinStepFreq = ntohs(tMinStepFreq);
                    tOffset += 2;
                    UInt32 tSportMaxPace = 0;
                    [tBleModel.value getBytes:&tSportMaxPace range:NSMakeRange(tOffset, 4)];
                    tSportMaxPace = ntohl(tSportMaxPace);
                    tOffset += 4;
                    UInt32 tSportMinPace = 0;
                    [tBleModel.value getBytes:&tSportMinPace range:NSMakeRange(tOffset, 4)];
                    tSportMinPace = ntohl(tSportMinPace);
                    tOffset += 4;
                    
                    NSLog(@"最大步频 %d 最小步频 %d 最大配速 %d 最小配速 %d", tMaxStepFreq, tMinStepFreq, tSportMaxPace, tSportMinPace);
                    
                    tOffset += 76; //预留
                    
                    NSLog(@"tSportTimeLen: %d %@ tSportType %d tSportStep %d %d %d tOffset %d tViewType %d", tSportTimeLen, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tSportStartTime]], tSportType, tSportStep, tSportCalorie, tSportDistance, tOffset, tViewType);
                    
                    DHDailySportModel *model = [[DHDailySportModel alloc] init];
                    model.isJLRunType = true;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tSportStartTime];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)tSportStartTime];
                    model.date = [DHTool dateToStringFormat:@"yyyyMMdd" date:date];
                    model.type = tSportType;
                    model.duration = tSportTimeLen;
                    model.distance = tSportDistance;
                    model.step = tSportStep;
                    model.calorie = tSportCalorie;
                    model.sportHeight = tSportHeight;
                    model.sportPress = tSportPress;
                    model.sportStepFreq = tSportStepFreq;
                    model.sportSpeed = tSportSpeed;
                    model.pace = tSportPace;
                    model.heartMax = tMaxHeart;
                    model.heartMin = tMinHeart;
                    model.heartAve = tAveHeart;
                    model.viewType = tViewType;
                    model.maxStepFreq = tMaxStepFreq;
                    model.minStepFreq = tMinStepFreq;
                    model.sportMaxPace = tSportMaxPace;
                    model.sportMinPace = tSportMinPace;
                    
                    model.metricPaceItems = @[];
                    model.imperialPaceItems = @[];
                    model.strideFrequencyItems = @[];
                    model.heartRateItems = @[];
                    [self.receiveSliceDatas addObject:model];
                }

                if (tBleModel.payloadLen > 3){ //清除已读取的历史数据，释放空间
                    NSLog(@"WorkOut已读取的历史数据 payloadLen %d 将清除已读取的历史数据 ", tBleModel.payloadLen);
                    [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_WORKOUT2 opType:BLE_KEY_FLAG_DELETE value:[NSData data]];
                }
                else{
                    NSLog(@"WorkOut 历史请求完成,处理下一个类型");
                    NSMutableArray *resultArray = [NSMutableArray array];
                    [resultArray addObjectsFromArray:self.receiveSliceDatas];

                    if (manager.dataSyncingBlock) {
                        if (manager.dataSyncProgress < 100) {
                            manager.dataSyncProgress += [manager getSyncInterval];
                        }
                        
                        manager.dataSyncingBlock(DHCommandCodeSuccessfully, manager.dataSyncProgress, resultArray);
                        [self.receiveSliceDatas removeAllObjects];
                        
                        if (manager.dataSyncProgress >= 100) {
                            manager.isDataSyncing = NO;
                            manager.dataSyncingBlock = nil;
                        }
                    }
                    [manager jlHandleNextPacket];
                }
            }
            else if (tBleModel.keyFlag == BLE_KEY_FLAG_DELETE){
                NSLog(@"workout BLE_KEY_FLAG_DELETE 请求下一包步数历史");
                [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_WORKOUT2 opType:BLE_KEY_FLAG_READ value:[NSData data]];
            }
            break;
        }
        case BLE_KEY_LOG:{
#pragma mark- BLE_KEY_LOG
            int tOffset = 3;
            if (tBleModel.value.length > 3){
                NSString *resultStr = [[NSString alloc] initWithData:[tBleModel.value subdataWithRange:NSMakeRange(tOffset, tBleModel.value.length - 3)] encoding:NSUTF8StringEncoding];
                NSLog(@"resultStr %@", resultStr);
                DHSaveLog(resultStr);
            }
            break;
        }
#pragma mark- BLE_KEY_CONTACT
        case BLE_KEY_CONTACT:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                
                int tOffset = 3;
                UInt8 tDialIndex = 0;
                
                [tBleModel.value getBytes:&tDialIndex range:NSMakeRange(tOffset++, 1)];
                
                NSLog(@"BLE_KEY_CONTACT %02X", tDialIndex);
                if ((tDialIndex >> 4) > 0){
                    if (manager.contactSetBlock) {
                        manager.contactSetBlock(DHCommandCodeFailed, DHCommandMsgFailed);
                        manager.contactSetBlock = nil;
                    }
                }
                else{
                    if (manager.contactSetBlock) {
                        manager.contactSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                        manager.contactSetBlock = nil;
                    }
                }
            }
            else if (tBleModel.keyFlag == BLE_KEY_FLAG_DELETE){
                if (manager.contactSetBlock) {
                    manager.contactSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.contactSetBlock = nil;
                }
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_ALL_BIN_DATA:
        case BLE_KEY_UI_FILE:
        case BLE_KEY_FONT_FILE:
        case BLE_KEY_WATCH_FACE:{
#pragma mark- BLE_KEY_UI_FILE
            //0xab11000c73f2070100
            //00
            //00000400
            //00000400
            [manager jlHandleNextPacket];
            
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                int tOffset = 3;
                UInt8 tDialIndex = 0;
                UInt32 tDialFileSize = 0;
                UInt32 tDialFileIndex = 0;
                
                [tBleModel.value getBytes:&tDialIndex range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tDialFileSize range:NSMakeRange(tOffset, 4)];
                tDialFileSize = ntohl(tDialFileSize);
                tOffset += 4;
                [tBleModel.value getBytes:&tDialFileIndex range:NSMakeRange(tOffset, 4)];
                tDialFileIndex = ntohl(tDialFileIndex);
                tOffset += 4;
                
                NSLog(@"tDialIndex %02X tDialFileSize %d tDialFileIndex %d", tDialIndex, tDialFileSize, tDialFileIndex);
                
                if ((tDialIndex >> 4) > 0){ //出错
                    [manager dialSyncingFailed:DHCommandMsgFailed];
                }
                else{
                    if (tDialFileIndex < tDialFileSize){
                        manager.dialSyncDataIndex = tDialFileIndex;
                        [manager jlDialSyncingOutgoing:tBleModel.keytype];
                    }
                    else{
                        [manager dialSyncingFinished];
                    }
                }
            }
        }
        case BLE_KEY_SLEEP:{
#pragma mark- BLE_KEY_SLEEP
            if (tBleModel.keyFlag == BLE_KEY_FLAG_READ){
                int tOffset = 3;
                UInt32 tSleepTime = 0;
                UInt8 tSleepMode = 0;
                UInt8 tSleepLightMove = 0;
                UInt8 tSleepHeavyMove = 0;
                
                NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                while (tOffset < tBleModel.value.length) {
                    [tBleModel.value getBytes:&tSleepTime range:NSMakeRange(tOffset, 4)];
                    tSleepTime = ntohl(tSleepTime);
                    tSleepTime = tSleepTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                    tOffset += 4;
                    [tBleModel.value getBytes:&tSleepMode range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tSleepLightMove range:NSMakeRange(tOffset++, 1)];
                    [tBleModel.value getBytes:&tSleepHeavyMove range:NSMakeRange(tOffset++, 1)];
                    
                    [self.receiveSliceDatas addObject:@{@"sleeptime":@(tSleepTime), @"sleepmode":@(tSleepMode)}];
                    
                    NSLog(@"tSleepTime: %@ tSleepMode %d tSleepLightMove %d tSleepHeavyMove %d", [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tSleepTime]], tSleepMode, tSleepLightMove, tSleepHeavyMove);
                }
                
                if (tBleModel.payloadLen > 3){ //清除已读取的历史数据，释放空间
                    NSLog(@"已读取的历史数据 payloadLen %d 将清除已读取的历史数据 ", tBleModel.payloadLen);
                    [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_SLEEP opType:BLE_KEY_FLAG_DELETE value:[NSData data]];
                }
                else{
                    NSMutableArray *resultArray = [NSMutableArray array];
                    
                    DHDailySleepModel *tDailySleepModel = nil;
                    for (int i = 0; i < self.receiveSliceDatas.count; i++){
                        NSDictionary *tSleepItem = self.receiveSliceDatas[i];
                        UInt32 sleeptime = [tSleepItem[@"sleeptime"] unsignedIntValue];
                        UInt8 sleepmode = [tSleepItem[@"sleepmode"] intValue];
                        
                        if (sleepmode == 17){ //睡眠开始
                            tDailySleepModel = [[DHDailySleepModel alloc] init];
                            tDailySleepModel.isJLType = YES;
                            tDailySleepModel.items = [NSMutableArray arrayWithCapacity:0];
                            tDailySleepModel.beginTime = [NSString stringWithFormat:@"%ld", (long)sleeptime];
                        }
                        else if (sleepmode == 34){ //睡眠结束
                            NSString *tDateDay = [DHTool dateToStringFormat:@"yyyyMMdd" date:[NSDate dateWithTimeIntervalSince1970:sleeptime]];
                            tDailySleepModel.date = tDateDay;
                            tDailySleepModel.duration = (sleeptime - [tDailySleepModel.beginTime integerValue])/60;
                            tDailySleepModel.timestamp = [NSString stringWithFormat:@"%ld", (long)sleeptime];
                            tDailySleepModel.endTime = [NSString stringWithFormat:@"%ld", (long)sleeptime];
                            
                            [resultArray addObject:tDailySleepModel];
                        }
                        else{
                            //睡眠类型 0清醒 1浅睡 2 深睡  RW
                            int tSleepType = 0;
                            if (sleepmode == 1){ //深睡
                                tSleepType = 2;
                            }
                            else if (sleepmode == 2){ //浅睡
                                tSleepType = 1;
                            }
                            NSDictionary *tSleepNextItem = self.receiveSliceDatas[i + 1];
                            UInt32 sleeptimeNext = [tSleepNextItem[@"sleeptime"] unsignedIntValue];

                            int tDuration = (sleeptimeNext - sleeptime)/60;
                            NSLog(@"%@", @{@"status":@(tSleepType), @"value":@(tDuration)});
                            
                            [tDailySleepModel.items addObject:@{@"status":@(tSleepType), @"value":@(tDuration)}];
                        }
                    }
                    
                    if (manager.dataSyncingBlock) {
                        if (manager.dataSyncProgress < 100) {
                            manager.dataSyncProgress += [manager getSyncInterval];
                        }
                        
                        [self.receiveSliceDatas removeAllObjects];
                        manager.dataSyncingBlock(DHCommandCodeSuccessfully, manager.dataSyncProgress, resultArray);
                        
                        if (manager.dataSyncProgress >= 100) {
                            manager.isDataSyncing = NO;
                            manager.dataSyncingBlock = nil;
                        }
                    }
                    [manager jlHandleNextPacket];
                }
                
            }
            else if (tBleModel.keyFlag == BLE_KEY_FLAG_DELETE){
                NSLog(@"睡眠 BLE_KEY_FLAG_DELETE 请求下一包睡眠历史");
//                [manager startStepSyncing];
                [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_SLEEP opType:BLE_KEY_FLAG_READ value:[NSData data]];
            }
            
            break;
        }
        case BLE_KEY_APP_WORKOUT_CONTROL:{
#pragma mark- BLE_KEY_APP_WORKOUT_CONTROL
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE && ((tBleModel.protocolFlag >> 4) == 0x00)){ //非ACK数据处理
                //设备端控制暂停与结束
                Byte tSportType = 0;
                Byte tControlType = 0;
                int tOffset = 3;
                [tBleModel.value getBytes:&tSportType range:NSMakeRange(tOffset++, 1)];
                [tBleModel.value getBytes:&tControlType range:NSMakeRange(tOffset++, 1)];
                //{0x01, 0x03, 0x02, 0x04}; 0x01开始 0x03暂停 0x02继续 0x04结束
                if (tControlType == 0x02){
                    [DHNotificationCenter postNotificationName:BluetoothNotificationJLWorkoutContinue object:nil];
                }
                else if (tControlType == 0x03){
                    [DHNotificationCenter postNotificationName:BluetoothNotificationJLWorkoutPause object:nil];
                }
                else{
                    [DHNotificationCenter postNotificationName:BluetoothNotificationJLWorkoutEnd object:nil];
                }
                NSLog(@"设备端控制暂停与结束 tSportType %d tControlType %d", tSportType, tControlType);
            }
            else{
                if (manager.sportControlBlock) {
                    manager.sportControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                    manager.sportControlBlock = nil;
                }
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_APP_WORKOUT_DATA:{
#pragma mark- BLE_KEY_APP_WORKOUT_DATA
            if (manager.sportDataControlBlock) {
                manager.sportDataControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.sportDataControlBlock = nil;
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_CAMERA:{
            
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE && ((tBleModel.protocolFlag >> 4) == 0x00)){ //非ACK数据处理
                int tOffset = 3;
                UInt8 tTakePhotoValue = 0;
                [tBleModel.value getBytes:&tTakePhotoValue range:NSMakeRange(tOffset++, 1)];
                if (tTakePhotoValue == 1){ //进入相机
                    [DHNotificationCenter postNotificationName:BluetoothNotificationCameraTurnOn object:nil];
                }
                else if (tTakePhotoValue == 2){//拍照
                    if ([DHBluetoothManager shareInstance].isActive){
                        [DHNotificationCenter postNotificationName:BluetoothNotificationCameraTakePicture object:nil];
                    }
                    else{
                        NSLog(@"后台不能拍照");
                    }
                }
                else{ //退出相机界面
                    [DHNotificationCenter postNotificationName:BluetoothNotificationCameraTurnOff object:nil];
                }
//                if (manager.cameraControlBlock) {
//                    manager.cameraControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
//                    manager.cameraControlBlock = nil;
//                }
            }
            [manager jlHandleNextPacket];
            break;
        }
        case BLE_KEY_BLOOD_PRESSURE:{
            {
#pragma mark- BLE_KEY_BLOOD_PRESSURE
                if (tBleModel.keyFlag == BLE_KEY_FLAG_READ){
                    int tOffset = 3;
                    UInt32 tHrTime = 0;
                    UInt8 tHighPress = 0;
                    UInt8 tLowPress = 0;
                    
                    NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                    [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                    while (tOffset < tBleModel.value.length) {
                        [tBleModel.value getBytes:&tHrTime range:NSMakeRange(tOffset, 4)];
                        tHrTime = ntohl(tHrTime);
                        long tHrTime2 = tHrTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                        tOffset += 4;
                        [tBleModel.value getBytes:&tHighPress range:NSMakeRange(tOffset++, 1)]; //收缩压
                        [tBleModel.value getBytes:&tLowPress range:NSMakeRange(tOffset++, 1)];
                        
                        [self.receiveSliceDatas addObject:@{@"timestamp":@(tHrTime2), @"systolic":@(tHighPress), @"diastolic":@(tLowPress)}];
                        
                        NSLog(@"血压 time: %d %@ %d", tHrTime, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tHrTime2]], tHighPress);
                    }
                    
                    if (tBleModel.payloadLen > 3){ //清除已读取的历史数据，释放空间
                        NSLog(@"已读取的历史数据 payloadLen %d 将清除已读取的历史数据 ", tBleModel.payloadLen);
                        [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_BLOOD_PRESSURE opType:BLE_KEY_FLAG_DELETE value:[NSData data]];
                    }
                    else{
                        NSMutableArray *resultArray = [NSMutableArray array];
                        NSMutableDictionary *tDailyDic = [NSMutableDictionary dictionaryWithCapacity:0];
                        
                        for (NSDictionary *entry in self.receiveSliceDatas) {
                            UInt32 timestamp = [entry[@"timestamp"] unsignedIntValue];
                            int systolic = [entry[@"systolic"] intValue];
                            int diastolic = [entry[@"diastolic"] intValue];
                            NSString *tDateDay = [DHTool dateToStringFormat:@"yyyyMMdd" date:[NSDate dateWithTimeIntervalSince1970:timestamp]];
                            DHDailyBpModel *tDailyHrModel = [tDailyDic valueForKey:tDateDay];
            
                            if (tDailyHrModel == nil){
                                tDailyHrModel = [[DHDailyBpModel alloc] init];
                                tDailyHrModel.isJLType = YES;
                                tDailyHrModel.date = tDateDay;
                                tDailyHrModel.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                                [tDailyDic setObject:tDailyHrModel forKey:tDateDay];
                                NSMutableArray *tItems = [NSMutableArray arrayWithObject:@{@"timestamp":@(timestamp), @"systolic":@(systolic), @"diastolic":@(diastolic)}];
                                tDailyHrModel.items = tItems;
                                [resultArray addObject:tDailyHrModel];
                            }
                            else{
                                tDailyHrModel.isJLType = YES;
                                [tDailyHrModel.items addObject:@{@"timestamp":@(timestamp), @"systolic":@(systolic), @"diastolic":@(diastolic)}];
                            }
                        }
                        
                        NSLog(@"血压 历史请求完成,处理下一个类型");
                        if (manager.dataSyncingBlock) {
                            if (manager.dataSyncProgress < 100) {
                                manager.dataSyncProgress += [manager getSyncInterval];
                            }
                            
                            [self.receiveSliceDatas removeAllObjects];
                            manager.dataSyncingBlock(DHCommandCodeSuccessfully, manager.dataSyncProgress, resultArray);
                            
                            if (manager.dataSyncProgress >= 100) {
                                manager.isDataSyncing = NO;
                                manager.dataSyncingBlock = nil;
                            }
                        }
                        [manager jlHandleNextPacket];
                    }
                }
                else if (tBleModel.keyFlag == BLE_KEY_FLAG_DELETE){
                    NSLog(@"血压 BLE_KEY_FLAG_DELETE 请求下一包步数历史");
    //                [manager startStepSyncing];
                    [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_BLOOD_PRESSURE opType:BLE_KEY_FLAG_READ value:[NSData data]];
                }
                break;
            }
            break;
        }
        case BLE_KEY_APP_REAL_TIME_BLOOD_OXYGEN_DATA:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                int tOffset = 3;
                UInt32 tHrTime = 0;
                UInt8 tOO = 0;
                
                NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                while (tOffset < tBleModel.value.length) {
                    [tBleModel.value getBytes:&tHrTime range:NSMakeRange(tOffset, 4)];
                    tHrTime = ntohl(tHrTime);
                    long tHrTime2 = tHrTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                    tOffset += 4;
                    [tBleModel.value getBytes:&tOO range:NSMakeRange(tOffset++, 1)];
                    tOffset += 1;
                    
                    [self.receiveSliceDatas addObject:@{@"timestamp":@(tHrTime2), @"value":@(tOO)}];
                    
                    NSLog(@"实时血氧 time: %d %@ %d", tHrTime, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tHrTime2]], tOO);
                }
                
                NSMutableArray *resultArray = [NSMutableArray array];
                NSMutableDictionary *tDailyDic = [NSMutableDictionary dictionaryWithCapacity:0];
                
                for (NSDictionary *entry in self.receiveSliceDatas) {
                    UInt32 timestamp = [entry[@"timestamp"] unsignedIntValue];
                    int OOvalue = [entry[@"value"] intValue];
                    NSString *tDateDay = [DHTool dateToStringFormat:@"yyyyMMdd" date:[NSDate dateWithTimeIntervalSince1970:timestamp]];
                    DHDailyBoModel *tDailyHrModel = [tDailyDic valueForKey:tDateDay];
    
                    if (tDailyHrModel == nil){
                        tDailyHrModel = [[DHDailyBoModel alloc] init];
                        tDailyHrModel.isJLType = YES;
                        tDailyHrModel.date = tDateDay;
                        tDailyHrModel.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                        [tDailyDic setObject:tDailyHrModel forKey:tDateDay];
                        NSMutableArray *tItems = [NSMutableArray arrayWithObject:@{@"timestamp":@(timestamp), @"value":@(OOvalue)}];
                        tDailyHrModel.items = tItems;
                        [resultArray addObject:tDailyHrModel];
                    }
                    else{
                        tDailyHrModel.isJLType = YES;
                        [tDailyHrModel.items addObject:@{@"timestamp":@(timestamp), @"value":@(OOvalue)}];
                    }
                }
                
                for (DHDailyBoModel *tBoModel in resultArray){
                    [HealthDataManager saveDailyBoModel:tBoModel];
                }
                
                NSDictionary *dict = @{@"type":@(HealthDataTypeBO - 1)};
                //健康数据更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationHealthDataChange object:nil userInfo:dict];
                
                NSLog(@"实时血氧 历史请求完成,处理下一个类型");
                [self.receiveSliceDatas removeAllObjects];
                [manager jlHandleNextPacket];
            }
            break;
        }
        case BLE_KEY_BLOOD_OXYGEN:{
            {
#pragma mark- BLE_KEY_BLOOD_OXYGEN
                if (tBleModel.keyFlag == BLE_KEY_FLAG_READ){
                    int tOffset = 3;
                    UInt32 tHrTime = 0;
                    UInt8 tOO = 0;
                    
                    NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                    [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                    while (tOffset < tBleModel.value.length) {
                        [tBleModel.value getBytes:&tHrTime range:NSMakeRange(tOffset, 4)];
                        tHrTime = ntohl(tHrTime);
                        long tHrTime2 = tHrTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                        tOffset += 4;
                        [tBleModel.value getBytes:&tOO range:NSMakeRange(tOffset++, 1)];
                        tOffset += 1;
                        
                        [self.receiveSliceDatas addObject:@{@"timestamp":@(tHrTime2), @"value":@(tOO)}];
                        
                        NSLog(@"血氧 time: %d %@ %d", tHrTime, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tHrTime2]], tOO);
                    }
                    
                    if (tBleModel.payloadLen > 3){ //清除已读取的历史数据，释放空间
                        NSLog(@"已读取的历史数据 payloadLen %d 将清除已读取的历史数据 ", tBleModel.payloadLen);
                        [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_BLOOD_OXYGEN opType:BLE_KEY_FLAG_DELETE value:[NSData data]];
                    }
                    else{
                        NSMutableArray *resultArray = [NSMutableArray array];
                        NSMutableDictionary *tDailyDic = [NSMutableDictionary dictionaryWithCapacity:0];
                        
                        for (NSDictionary *entry in self.receiveSliceDatas) {
                            UInt32 timestamp = [entry[@"timestamp"] unsignedIntValue];
                            int OOvalue = [entry[@"value"] intValue];
                            NSString *tDateDay = [DHTool dateToStringFormat:@"yyyyMMdd" date:[NSDate dateWithTimeIntervalSince1970:timestamp]];
                            DHDailyBoModel *tDailyHrModel = [tDailyDic valueForKey:tDateDay];
            
                            if (tDailyHrModel == nil){
                                tDailyHrModel = [[DHDailyBoModel alloc] init];
                                tDailyHrModel.isJLType = YES;
                                tDailyHrModel.date = tDateDay;
                                tDailyHrModel.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                                [tDailyDic setObject:tDailyHrModel forKey:tDateDay];
                                NSMutableArray *tItems = [NSMutableArray arrayWithObject:@{@"timestamp":@(timestamp), @"value":@(OOvalue)}];
                                tDailyHrModel.items = tItems;
                                [resultArray addObject:tDailyHrModel];
                            }
                            else{
                                tDailyHrModel.isJLType = YES;
                                [tDailyHrModel.items addObject:@{@"timestamp":@(timestamp), @"value":@(OOvalue)}];
                            }
                        }
                        
                        NSLog(@"血氧 历史请求完成,处理下一个类型");
                        if (manager.dataSyncingBlock) {
                            if (manager.dataSyncProgress < 100) {
                                manager.dataSyncProgress += [manager getSyncInterval];
                            }
                            
                            [self.receiveSliceDatas removeAllObjects];
                            manager.dataSyncingBlock(DHCommandCodeSuccessfully, manager.dataSyncProgress, resultArray);
                            
                            if (manager.dataSyncProgress >= 100) {
                                manager.isDataSyncing = NO;
                                manager.dataSyncingBlock = nil;
                            }
                        }
                        [manager jlHandleNextPacket];
                    }
                }
                else if (tBleModel.keyFlag == BLE_KEY_FLAG_DELETE){
                    NSLog(@"血氧 BLE_KEY_FLAG_DELETE 请求下一包步数历史");
    //                [manager startStepSyncing];
                    [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_BLOOD_OXYGEN opType:BLE_KEY_FLAG_READ value:[NSData data]];
                }
                break;
            }
            break;
        }
        case BLE_KEY_APP_REAL_TIME_STRESS_DATA:{
            if (tBleModel.keyFlag == BLE_KEY_FLAG_UPDATE){
                int tOffset = 3;
                UInt32 tHrTime = 0;
                UInt8 tOO = 0;
                
                NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                while (tOffset < tBleModel.value.length) {
                    [tBleModel.value getBytes:&tHrTime range:NSMakeRange(tOffset, 4)];
                    tHrTime = ntohl(tHrTime);
                    long tHrTime2 = tHrTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                    tOffset += 4;
                    [tBleModel.value getBytes:&tOO range:NSMakeRange(tOffset++, 1)];
                    tOffset += 1;
                    
                    [self.receiveSliceDatas addObject:@{@"timestamp":@(tHrTime2), @"value":@(tOO)}];
                    
                    NSLog(@"实时压力 压力 time: %d %@ %d", tHrTime, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tHrTime2]], tOO);
                }
                
                NSMutableArray *resultArray = [NSMutableArray array];
                NSMutableDictionary *tDailyDic = [NSMutableDictionary dictionaryWithCapacity:0];
                
                for (NSDictionary *entry in self.receiveSliceDatas) {
                    UInt32 timestamp = [entry[@"timestamp"] unsignedIntValue];
                    int OOvalue = [entry[@"value"] intValue];
                    NSString *tDateDay = [DHTool dateToStringFormat:@"yyyyMMdd" date:[NSDate dateWithTimeIntervalSince1970:timestamp]];
                    DHDailyPressureModel *tDailyHrModel = [tDailyDic valueForKey:tDateDay];
    
                    if (tDailyHrModel == nil){
                        tDailyHrModel = [[DHDailyPressureModel alloc] init];
                        tDailyHrModel.isJLType = YES;
                        tDailyHrModel.date = tDateDay;
                        tDailyHrModel.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                        [tDailyDic setObject:tDailyHrModel forKey:tDateDay];
                        NSMutableArray *tItems = [NSMutableArray arrayWithObject:@{@"timestamp":@(timestamp), @"value":@(OOvalue)}];
                        tDailyHrModel.items = tItems;
                        [resultArray addObject:tDailyHrModel];
                    }
                    else{
                        tDailyHrModel.isJLType = YES;
                        [tDailyHrModel.items addObject:@{@"timestamp":@(timestamp), @"value":@(OOvalue)}];
                    }
                }
                
                for (DHDailyPressureModel *tStressModel in resultArray){
                    [HealthDataManager saveDailyPressureModel:tStressModel];
                }
                
                NSDictionary *dict = @{@"type":@(HealthDataTypePressure - 1)};
                //健康数据更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationHealthDataChange object:nil userInfo:dict];
                
                NSLog(@"实时压力 历史请求完成,处理下一个类型");
                [self.receiveSliceDatas removeAllObjects];
                [manager jlHandleNextPacket];
            
            }
            break;
        }
        case BLE_KEY_STRESS:{
            {
#pragma mark- BLE_KEY_STRESS
                if (tBleModel.keyFlag == BLE_KEY_FLAG_READ){
                    int tOffset = 3;
                    UInt32 tHrTime = 0;
                    UInt8 tOO = 0;
                    
                    NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
                    [tDateF setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                    while (tOffset < tBleModel.value.length) {
                        [tBleModel.value getBytes:&tHrTime range:NSMakeRange(tOffset, 4)];
                        tHrTime = ntohl(tHrTime);
                        long tHrTime2 = tHrTime + UTC_TO_YEAR2000_S - self.gTimezoneOffset;
                        tOffset += 4;
                        [tBleModel.value getBytes:&tOO range:NSMakeRange(tOffset++, 1)];
                        tOffset += 1;
                        
                        [self.receiveSliceDatas addObject:@{@"timestamp":@(tHrTime2), @"value":@(tOO)}];
                        
                        NSLog(@"压力 time: %d %@ %d", tHrTime, [tDateF stringFromDate:[NSDate dateWithTimeIntervalSince1970:tHrTime2]], tOO);
                    }
                    
                    if (tBleModel.payloadLen > 3){ //清除已读取的历史数据，释放空间
                        NSLog(@"已读取的历史数据 payloadLen %d 将清除已读取的历史数据 ", tBleModel.payloadLen);
                        [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_STRESS opType:BLE_KEY_FLAG_DELETE value:[NSData data]];
                    }
                    else{
                        NSMutableArray *resultArray = [NSMutableArray array];
                        NSMutableDictionary *tDailyDic = [NSMutableDictionary dictionaryWithCapacity:0];
                        
                        for (NSDictionary *entry in self.receiveSliceDatas) {
                            UInt32 timestamp = [entry[@"timestamp"] unsignedIntValue];
                            int OOvalue = [entry[@"value"] intValue];
                            NSString *tDateDay = [DHTool dateToStringFormat:@"yyyyMMdd" date:[NSDate dateWithTimeIntervalSince1970:timestamp]];
                            DHDailyPressureModel *tDailyHrModel = [tDailyDic valueForKey:tDateDay];
            
                            if (tDailyHrModel == nil){
                                tDailyHrModel = [[DHDailyPressureModel alloc] init];
                                tDailyHrModel.isJLType = YES;
                                tDailyHrModel.date = tDateDay;
                                tDailyHrModel.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                                [tDailyDic setObject:tDailyHrModel forKey:tDateDay];
                                NSMutableArray *tItems = [NSMutableArray arrayWithObject:@{@"timestamp":@(timestamp), @"value":@(OOvalue)}];
                                tDailyHrModel.items = tItems;
                                [resultArray addObject:tDailyHrModel];
                            }
                            else{
                                tDailyHrModel.isJLType = YES;
                                [tDailyHrModel.items addObject:@{@"timestamp":@(timestamp), @"value":@(OOvalue)}];
                            }
                        }
                        
                        NSLog(@"压力 历史请求完成,处理下一个类型");
                        if (manager.dataSyncingBlock) {
                            if (manager.dataSyncProgress < 100) {
                                manager.dataSyncProgress += [manager getSyncInterval];
                            }
                            
                            [self.receiveSliceDatas removeAllObjects];
                            manager.dataSyncingBlock(DHCommandCodeSuccessfully, manager.dataSyncProgress, resultArray);
                            
                            if (manager.dataSyncProgress >= 100) {
                                manager.isDataSyncing = NO;
                                manager.dataSyncingBlock = nil;
                            }
                        }
                        [manager jlHandleNextPacket];
                    }
                }
                else if (tBleModel.keyFlag == BLE_KEY_FLAG_DELETE){
                    NSLog(@"压力 BLE_KEY_FLAG_DELETE 请求下一包步数历史");
    //                [manager startStepSyncing];
                    [manager sendCommandNow:BLE_COMMAND_DATA keyType:BLE_KEY_STRESS opType:BLE_KEY_FLAG_READ value:[NSData data]];
                }
                break;
            }
            break;
        }
            
            
        default:
            break;
    }
    
    
}

- (void)clearData
{
    
}

@end
