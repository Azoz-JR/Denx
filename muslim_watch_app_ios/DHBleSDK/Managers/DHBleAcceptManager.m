//
//  DHBleAcceptManager.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHBleAcceptManager.h"
#import "DHTool.h"
#import "DHBleSendManager.h"


@interface DHBleAcceptManager ()

/// 当前处理的蓝牙数据总长度
@property (nonatomic, assign) NSInteger currentTotalLength;
/// 数据
@property (nonatomic, strong) NSData *currentData;

@end

@implementation DHBleAcceptManager

static DHBleAcceptManager *_shared = nil;
+ (__kindof DHBleAcceptManager *)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    }) ;
    return _shared ;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [DHBleAcceptManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [DHBleAcceptManager shareInstance];
}

- (void)didUpdateValueWithResponse:(NSData *)response {
    if (response.length < 8) {
        DHSaveLog(@"response value error: no header");
        return;
    }
    NSString *identification = DHDecimalString([response subdataWithRange:NSMakeRange(0, 1)]);
    if (![identification isEqualToString:DHCommandIdentification]) {
        DHSaveLog(@"response value error: identification error");
        return;
    }
    
    NSInteger commandType = DHDecimalValue([response subdataWithRange:NSMakeRange(2, 1)]);
    NSString *commandId = DHDecimalString([response subdataWithRange:NSMakeRange(2, 1)]);
    NSInteger securityValue = DHDecimalValue([response subdataWithRange:NSMakeRange(3, 1)]);
    BOOL isMultipack = securityValue >> 3 & 0x01;
    
    NSInteger contentLength = DHDecimalValue([response subdataWithRange:NSMakeRange(4, 1)]);
    NSInteger serialValue = DHDecimalValue([response subdataWithRange:NSMakeRange(5, 2)]);
    NSInteger verifyCode = DHDecimalValue([response subdataWithRange:NSMakeRange(7, 1)]);
    
    DHBleSendManager *sendManager = [DHBleSendManager shareInstance];
    
    
    if ([commandId isEqualToString:DHCommandDeviceFeedback]) {
        NSString *message = [NSString stringWithFormat:@"终端通用应答:%@",DHDecimalStringLog(response)];
        DHSaveLog(message);
        if (contentLength < 4) {
            DHSaveLog(@"终端通用应答:response value error: no data");
            return;
        }
        NSData *payload = [response subdataWithRange:NSMakeRange(8, contentLength)];
        if ([DHTool verifyCode:payload] != verifyCode) {
            DHSaveLog(@"终端通用应答:response value error: verifyCode error");
            return;
        }
        commandId = DHDecimalString([payload subdataWithRange:NSMakeRange(2, 1)]);
        commandType = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
        if ([commandId isEqualToString:sendManager.currentCommondId]) {
            [self analyticalSettingsCommandType:commandType commandId:commandId];
        }
        return;
    }
    NSString *message = [NSString stringWithFormat:@"response:%@",DHDecimalStringLog(response)];
    DHSaveLog(message);
    if (!isMultipack) {
        NSData *payload;
        if (contentLength > 0) {
            payload = [response subdataWithRange:NSMakeRange(8, contentLength)];
            if ([DHTool verifyCode:payload] != verifyCode) {
                DHSaveLog(@"终端回复:response value error: verifyCode error");
                return;
            }
        } else {
            payload = DHHexToBytes(@"00");
            
        }
        
        [sendManager feedbackDeviceSerial:serialValue command:commandType];
        if ([commandId isEqualToString:sendManager.currentCommondId]) {
            NSString *message = [NSString stringWithFormat:@"单包，应答成功，移除重发命令列表ID:%@",[commandId uppercaseString]];
            DHSaveLog(message);
            [sendManager removeAllProcessDictionaryForCommand:commandId isTimeOut:NO];
        }
        [self analyticalPayload:payload commandType:commandType];
        
    } else {
        NSInteger count = DHDecimalValue([response subdataWithRange:NSMakeRange(8, 2)]);
        NSInteger index = DHDecimalValue([response subdataWithRange:NSMakeRange(10, 2)]);
        
        NSData *payload = [response subdataWithRange:NSMakeRange(12, contentLength)];
        if ([DHTool verifyCode:payload] != verifyCode) {
            DHSaveLog(@"终端回复:response value error: verifyCode error");
            return;
        }
        
        [sendManager feedbackDeviceSerial:serialValue command:commandType];
        NSMutableData *mData = [NSMutableData data];
        NSData *sliceData = [self.receiveSliceDatas valueForKey:commandId];
        if (sliceData) {
            [mData appendData:sliceData];
        }
        [mData appendData:payload];
        [self.receiveSliceDatas setValue:mData.copy forKey:commandId];
        
        if (count == index) {
            [self.receiveSliceDatas removeObjectForKey:commandId];
            if ([commandId isEqualToString:sendManager.currentCommondId]) {
                NSString *message = [NSString stringWithFormat:@"多包，应答成功，移除重发命令列表ID:%@",[commandId uppercaseString]];
                DHSaveLog(message);
                [sendManager removeAllProcessDictionaryForCommand:commandId isTimeOut:NO];
            }
            [self analyticalPayload:mData commandType:commandType];
        }
    }
}

- (void)analyticalSettingsCommandType:(DHBleCommandType)commandType commandId:(NSString *)commandId {
    BOOL isSucceed = NO;
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    switch (commandType) {
#pragma mark - 设置命令
        case DHBleCommandTypeBindSet:
        {
            isSucceed = YES;
            if (manager.bindSetBlock) {
                manager.bindSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.bindSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeTimeSet:
        {
            isSucceed = YES;
            if (manager.timeSetBlock) {
                manager.timeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.timeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSwitchSet:
        {
            isSucceed = YES;
        }
            break;
            
        case DHBleCommandTypeAncsSet:
        {
            isSucceed = YES;
            if (manager.ancsSetBlock) {
                manager.ancsSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.ancsSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeUnitSet:
        {
            isSucceed = YES;
            if (manager.unitSetBlock) {
                manager.unitSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.unitSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSedentarySet:
        {
            isSucceed = YES;
            if (manager.sedentarySetBlock) {
                manager.sedentarySetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.sedentarySetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeDrinkingSet:
        {
            isSucceed = YES;
            if (manager.drinkingSetBlock) {
                manager.drinkingSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.drinkingSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeReminderModeSet:
        {
            isSucceed = YES;
            if (manager.reminderModeSetBlock) {
                manager.reminderModeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.reminderModeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeAlarmSet:
        {
            isSucceed = YES;
            if (manager.alarmSetBlock) {
                manager.alarmSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.alarmSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypePrayAlarmSet:
        {
            isSucceed = YES;
            if (manager.prayAlarmSetBlock) {
                manager.prayAlarmSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.prayAlarmSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeGestureSet:
        {
            isSucceed = YES;
            if (manager.gestureSetBlock) {
                manager.gestureSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.gestureSetBlock = nil;
            }
        }
            break;
            
        case DHBleCommandTypeBrightTimeSet:
        {
            isSucceed = YES;
            if (manager.brightTimeSetBlock) {
                manager.brightTimeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.brightTimeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeHeartRateModeSet:
        {
            isSucceed = YES;
            if (manager.heartRateModeSetBlock) {
                manager.heartRateModeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.heartRateModeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeDisturbModeSet:
        {
            isSucceed = YES;
            if (manager.disturbModeSetBlock) {
                manager.disturbModeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.disturbModeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeContactSet:
        {
            isSucceed = YES;
            if (manager.contactSetBlock) {
                manager.contactSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.contactSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeUserInfoSet:
        {
            isSucceed = YES;
            if (manager.userInfoSetBlock) {
                manager.userInfoSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.userInfoSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeQRCodeSet:
        {
            isSucceed = YES;
            if (manager.qrCodeSetBlock) {
                manager.qrCodeSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.qrCodeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSportGoalSet:
        {
            isSucceed = YES;
            if (manager.sportGoalSetBlock) {
                manager.sportGoalSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.sportGoalSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeWeatherSet:
        {
            isSucceed = YES;
            if (manager.weatherSetBlock) {
                manager.weatherSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.weatherSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBreathSet:
        {
            isSucceed = YES;
            if (manager.breathSetBlock) {
                manager.breathSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.breathSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeMenstrualCycleSet:
        {
            isSucceed = YES;
            if (manager.menstrualCycleSetBlock) {
                manager.menstrualCycleSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.menstrualCycleSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeLocationSet:
        {
            isSucceed = YES;
            if (manager.locationSetBlock) {
                manager.locationSetBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.locationSetBlock = nil;
            }
        }
            break;
            
#pragma mark - 控制命令
        case DHBleCommandTypeCameraControl:
        {
            isSucceed = YES;
            if (manager.cameraControlBlock) {
                manager.cameraControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.cameraControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeFindDeviceBeginControl:
        {
            isSucceed = YES;
            if (manager.findDeviceControlBlock) {
                manager.findDeviceControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.findDeviceControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeFindPhoneEndControl:
        {
            isSucceed = YES;
            if (manager.findPhoneControlBlock) {
                manager.findPhoneControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.findPhoneControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeDeviceControl:
        {
            isSucceed = YES;
            if (manager.deviceControlBlock) {
                manager.deviceControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.deviceControlBlock = nil;
            }
        }
            break;
            
        case DHBleCommandTypeUnbindControl:
        {
            isSucceed = YES;
            if (manager.unbindBlock) {
                manager.unbindBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.unbindBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSportControl:
        {
            isSucceed = YES;
            if (manager.sportControlBlock) {
                manager.sportControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.sportControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSportDataControl:
        {
            isSucceed = YES;
            if (manager.sportDataControlBlock) {
                manager.sportDataControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.sportDataControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeAppStatusControl:
        {
            isSucceed = YES;
            if (manager.appstatusControlBlock) {
                manager.appstatusControlBlock(DHCommandCodeSuccessfully, DHCommandMsgSuccessfully);
                manager.appstatusControlBlock = nil;
            }
        }
            break;
            
        default:
            break;
    }
    
    if (isSucceed) {
        [manager removeAllProcessDictionaryForCommand:commandId isTimeOut:NO];
        NSString *message = [NSString stringWithFormat:@"设置，应答成功，移除重发命令列表ID:%@",[commandId uppercaseString]];
        DHSaveLog(message);
    }
    
}

- (void)analyticalPayload:(NSData *)payload commandType:(DHBleCommandType)commandType {
    
    id model = [DHTool modelForPayload:payload commandType:commandType];
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (model) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma mark - 同步数据
            if (commandType == DHBleCommandTypeDataSyncing) {
                if (manager.dataSyncingBlock) {
                    DHDataSyncingModel *dataModel = model;
                    if (dataModel.count > 0) {
                        manager.dataSyncProgress = 0;
                        manager.dataSyncInterval = 100/dataModel.count;
                        if (dataModel.isStep) {
                            [manager startStepSyncing];
                        }
                        if (dataModel.isSleep) {
                            [manager startSleepSyncing];
                        }
                        if (dataModel.isHeartRate) {
                            [manager startHeartRateSyncing];
                        }
                        if (dataModel.isBp) {
                            [manager startBloodPressureSyncing];
                        }
                        if (dataModel.isBo) {
                            [manager startBloodOxygenSyncing];
                        }
                        if (dataModel.isTemp) {
                            [manager startTempSyncing];
                        }
                        if (dataModel.isBreath) {
                            [manager startBreathSyncing];
                        }
                        if (dataModel.isSport) {
                            [manager startSportSyncing];
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
                return;
            }
            
#pragma mark - 获取命令
            switch (commandType) {
                case DHBleCommandTypeStepSyncing:
                case DHBleCommandTypeSleepSyncing:
                case DHBleCommandTypeHeartRateSyncing:
                case DHBleCommandTypeBloodPressureSyncing:
                case DHBleCommandTypeBloodOxygenSyncing:
                case DHBleCommandTypeTempSyncing:
                case DHBleCommandTypeBreathSyncing:
                case DHBleCommandTypeSportSyncing:
                {
                    if (manager.dataSyncingBlock) {
                        if (manager.dataSyncProgress < 100) {
                            manager.dataSyncProgress += [manager getSyncInterval];
                        }
                        manager.dataSyncingBlock(DHCommandCodeSuccessfully, manager.dataSyncProgress, model);
                        
                        if (manager.dataSyncProgress >= 100) {
                            manager.isDataSyncing = NO;
                            manager.dataSyncingBlock = nil;
                        }
                    } else if (commandType == DHBleCommandTypeStepSyncing && manager.stepSyncingBlock) {
                        manager.stepSyncingBlock(DHCommandCodeSuccessfully, model);
                        manager.stepSyncingBlock = nil;
                    } else if (commandType == DHBleCommandTypeSleepSyncing && manager.sleepSyncingBlock) {
                        manager.sleepSyncingBlock(DHCommandCodeSuccessfully, model);
                        manager.sleepSyncingBlock = nil;
                    } else if (commandType == DHBleCommandTypeHeartRateSyncing && manager.hrSyncingBlock) {
                        manager.hrSyncingBlock(DHCommandCodeSuccessfully, model);
                        manager.hrSyncingBlock = nil;
                    } else if (commandType == DHBleCommandTypeBloodPressureSyncing && manager.bpSyncingBlock) {
                        manager.bpSyncingBlock(DHCommandCodeSuccessfully, model);
                        manager.bpSyncingBlock = nil;
                    } else if (commandType == DHBleCommandTypeBloodOxygenSyncing && manager.boSyncingBlock) {
                        manager.boSyncingBlock(DHCommandCodeSuccessfully, model);
                        manager.boSyncingBlock = nil;
                    } else if (commandType == DHBleCommandTypeTempSyncing && manager.tempSyncingBlock) {
                        manager.tempSyncingBlock(DHCommandCodeSuccessfully, model);
                        manager.tempSyncingBlock = nil;
                    } else if (commandType == DHBleCommandTypeBreathSyncing && manager.breathSyncingBlock) {
                        manager.breathSyncingBlock(DHCommandCodeSuccessfully, model);
                        manager.breathSyncingBlock = nil;
                    } else if (commandType == DHBleCommandTypeSportSyncing && manager.sportSyncingBlock) {
                        manager.sportSyncingBlock(DHCommandCodeSuccessfully, model);
                        manager.sportSyncingBlock = nil;
                    }
                    
                }
                    break;
                case DHBleCommandTypeFirmwareVersionGet:
                {
                    if (manager.firmwareVersionGetBlock) {
                        manager.firmwareVersionGetBlock(DHCommandCodeSuccessfully, model);
                        manager.firmwareVersionGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeBatteryGet:
                {
                    if (manager.batteryGetBlock) {
                        manager.batteryGetBlock(DHCommandCodeSuccessfully, model);
                        manager.batteryGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeBindInfoGet:
                {
                    if (manager.bindInfoGetBlock) {
                        manager.bindInfoGetBlock(DHCommandCodeSuccessfully, model);
                        manager.bindInfoGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeFunctionGet:
                {
                    if (manager.functionGetBlock) {
                        manager.functionGetBlock(DHCommandCodeSuccessfully, model);
                        manager.functionGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeDialInfoGet:
                {
                    if (manager.dialInfoGetBlock) {
                        manager.dialInfoGetBlock(DHCommandCodeSuccessfully, model);
                        manager.dialInfoGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeAncsGet:
                {
                    if (manager.ancsGetBlock) {
                        manager.ancsGetBlock(DHCommandCodeSuccessfully, model);
                        manager.ancsGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeSedentaryGet:
                {
                    if (manager.sedentaryGetBlock) {
                        manager.sedentaryGetBlock(DHCommandCodeSuccessfully, model);
                        manager.sedentaryGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeDrinkingGet:
                {
                    if (manager.drinkingGetBlock) {
                        manager.drinkingGetBlock(DHCommandCodeSuccessfully, model);
                        manager.drinkingGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeReminderModeGet:
                {
                    if (manager.reminderModeGetBlock) {
                        manager.reminderModeGetBlock(DHCommandCodeSuccessfully, model);
                        manager.reminderModeGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeAlarmGet:
                {
                    if (manager.alarmsGetBlock) {
                        manager.alarmsGetBlock(DHCommandCodeSuccessfully, model);
                        manager.alarmsGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypePrayAlarmGet:
                {
                    if (manager.prayAlarmGetBlock) {
                        manager.prayAlarmGetBlock(DHCommandCodeSuccessfully, model);
                        manager.prayAlarmGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeGestureGet:
                {
                    if (manager.gestureGetBlock) {
                        manager.gestureGetBlock(DHCommandCodeSuccessfully, model);
                        manager.gestureGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeBrightTimeGet:
                {
                    if (manager.brightTimeGetBlock) {
                        manager.brightTimeGetBlock(DHCommandCodeSuccessfully, model);
                        manager.brightTimeGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeHeartRateModeGet:
                {
                    if (manager.heartRateModeGetBlock) {
                        manager.heartRateModeGetBlock(DHCommandCodeSuccessfully, model);
                        manager.heartRateModeGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeDisturbModeGet:
                {
                    if (manager.disturbModeGetBlock) {
                        manager.disturbModeGetBlock(DHCommandCodeSuccessfully, model);
                        manager.disturbModeGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeMacAddressGet:
                {
                    if (manager.macAddressGetBlock) {
                        manager.macAddressGetBlock(DHCommandCodeSuccessfully, model);
                        manager.macAddressGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeClassicBleGet:
                {
                    if (manager.classicBleGetBlock) {
                        manager.classicBleGetBlock(DHCommandCodeSuccessfully, model);
                        manager.classicBleGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeLocalDialGet:
                {
                    if (manager.localDialGetBlock) {
                        manager.localDialGetBlock(DHCommandCodeSuccessfully, model);
                        manager.localDialGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeOtaInfoGet:
                {
                    if (manager.otaInfoGetBlock) {
                        manager.otaInfoGetBlock(DHCommandCodeSuccessfully, model);
                        manager.otaInfoGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeBreathGet:
                {
                    if (manager.breathGetBlock) {
                        manager.breathGetBlock(DHCommandCodeSuccessfully, model);
                        manager.breathGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeCustomDialGet:
                {
                    if (manager.customDialGetBlock) {
                        manager.customDialGetBlock(DHCommandCodeSuccessfully, model);
                        manager.customDialGetBlock = nil;
                    }
                }
                    break;
                case DHBleCommandTypeMenstrualCycleGet:
                {
                    if (manager.menstrualCycleGetBlock) {
                        manager.menstrualCycleGetBlock(DHCommandCodeSuccessfully, model);
                        manager.menstrualCycleGetBlock = nil;
                    }
                }
                    break;
                    
                case DHBleCommandTypeMtuNotification:
                {
                    NSLog(@"DHBleCommandTypeMtuNotification mtu %d", [model integerValue]);
                    if ([model integerValue] >= 20) {
                        manager.onePackageLength = 185;//[model integerValue];
                    }
                }
                    break;
                case DHBleCommandTypeConnectIntervalNotification:
                {
                    manager.connectInterval = [model integerValue]/1000.0;
                    if (manager.fileSyncingStartBlock) {
                        manager.fileSyncingStartBlock(DHCommandCodeSuccessfully, model);
                        manager.fileSyncingStartBlock = nil;
                    }
                }
                    break;
                    
                case DHBleCommandTypeFileStatusNotification:
                {
                    NSArray *tModelArr = [model componentsSeparatedByString:@"_"];
                    NSInteger tModelStatus = [tModelArr.firstObject integerValue];
                    NSInteger tModelType = [tModelArr.lastObject integerValue];
                    NSLog(@"FileStatus tModelStatus %d tModelType %d", tModelStatus, tModelType);
                    if (tModelType == 0){ //0开始
                        [manager fileSyncingStart];
                    }
                    else if (tModelType == 1){ //
                        if (tModelStatus == 0){
                            [manager fileSyncingOutgoing];
                        }
                        else{
                            [manager fileSyncingFailed:DHCommandMsgFailed];
                        }
                    }
                    else{
                        if (tModelStatus == 0) {
                            [manager fileSyncingFinished];
                        } else {
                            [manager fileSyncingFailed:DHCommandMsgFailed];
                        }
                    }
                }
                    break;
                case DHBleCommandTypeDialStatusNotification:
                {
                    NSArray *tModelArr = [model componentsSeparatedByString:@"_"];
                    NSInteger tModelStatus = [tModelArr.firstObject integerValue];
                    NSInteger tModelType = [tModelArr.lastObject integerValue];
                    NSLog(@"DialStatus tModelStatus %d tModelType %d", tModelStatus, tModelType);
                    if (tModelType == 0){ //0开始
                        [manager dialSyncingStart];
                    }
                    else if (tModelType == 1){ //
                        if (tModelStatus == 0){
                            [manager dialSyncingOutgoing];
                        }
                        else{
                            [manager dialSyncingFailed:DHCommandMsgFailed];
                        }
                    }
                    else{
                        if (tModelStatus == 0) {
                            [manager dialSyncingFinished];
                        } else {
                            [manager dialSyncingFailed:DHCommandMsgFailed];
                        }
                    }
                }
                    break;
                case DHBleCommandTypeMapStatusNotification:
                {
                    NSArray *tModelArr = [model componentsSeparatedByString:@"_"];
                    NSInteger tModelStatus = [tModelArr.firstObject integerValue];
                    NSInteger tModelType = [tModelArr.lastObject integerValue];
                    NSLog(@"MapStatus tModelStatus %d tModelType %d", tModelStatus, tModelType);
                    if (tModelType == 0){ //0开始
                        [manager mapSyncingStart];
                    }
                    else if (tModelType == 1){ //
                        if (tModelStatus == 0){
                            [manager mapSyncingOutgoing];
                        }
                        else{
                            [manager mapSyncingFailed:DHCommandMsgFailed];
                        }
                    }
                    else{
                        if (tModelStatus == 0) {
                            [manager mapSyncingFinished];
                        } else {
                            [manager mapSyncingFailed:DHCommandMsgFailed];
                        }
                    }
                }
                    break;
                case DHBleCommandTypeThumbnailStatusNotification:
                {
                    NSArray *tModelArr = [model componentsSeparatedByString:@"_"];
                    NSInteger tModelStatus = [tModelArr.firstObject integerValue];
                    NSInteger tModelType = [tModelArr.lastObject integerValue];
                    NSLog(@"ThumbnailStatus tModelStatus %d tModelType %d", tModelStatus, tModelType);
                    if (tModelType == 0){ //0开始
                        [manager thumbnailSyncingStart];
                    }
                    else if (tModelType == 1){ //
                        if (tModelStatus == 0){
                            [manager thumbnailSyncingOutgoing];
                        }
                        else{
                            [manager thumbnailSyncingFailed:DHCommandMsgFailed];
                        }
                    }
                    else{
                        if (tModelStatus == 0) {
                            [manager thumbnailSyncingFinished];
                        } else {
                            [manager thumbnailSyncingFailed:DHCommandMsgFailed];
                        }
                    }
                    
                }
                    break;
                    
                default:
                {
                    if (manager.commandDelegate && [manager.commandDelegate respondsToSelector:@selector(peripheralDidUpdateValue:type:)]) {
                        [manager.commandDelegate peripheralDidUpdateValue:model type:commandType];
                    }
                }
                    break;
            }
        });
    }
}



- (void)clearData {
    self.receiveSliceDatas = [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)receiveSliceDatas {
    if (_receiveSliceDatas == nil) {
        _receiveSliceDatas = [NSMutableDictionary dictionary];
    }
    return _receiveSliceDatas;
}

@end
