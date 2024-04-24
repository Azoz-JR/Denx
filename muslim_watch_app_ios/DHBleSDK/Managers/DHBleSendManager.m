//
//  DHBleSendManager.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHBleSendManager.h"
#import "DHTool.h"
#import "JLBleProtocol.h"
#import "JLSendModel.h"

@interface DHBleSendManager ()

/// 重发定时器
@property (nonatomic, strong) NSTimer *reSendDataTimer;
@property (nonatomic, assign) NSInteger jlSendState; //0 idal 1 发送中
@property (nonatomic, strong) NSMutableArray *jlSendQueue;
@end

@implementation DHBleSendManager

static DHBleSendManager *_shared = nil;
+ (__kindof DHBleSendManager *)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    }) ;
    return _shared ;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [DHBleSendManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [DHBleSendManager shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSyncInterval = 20;
        self.onePackageLength = 185; //185
        self.commandSerial = 1;
        self.connectInterval = 0.1;
        
        _jlSendQueue = [NSMutableArray arrayWithCapacity:0];
        _jlSendState = 0;
    }
    return self;
}

- (void)sendCommand {
    if (self.sendDataList.count == 1) {
        [self checkIfWriteData];
    }
    [self resendTimerStart];
}

-(void)checkIfWriteData {
    if (self.sendCommandList.count > 0) {
        self.currentCommondId = self.sendCommandList.firstObject;
        NSData * value = self.sendDataList.firstObject ;
        if (!value) {
            return;
        }
        NSString *message = [NSString stringWithFormat:@"send:%@",DHDecimalStringLog(value)];
        DHSaveLog(message);
        [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)checkSendlistTimeout {
    NSString * time = self.sendTimeList.firstObject;
    if (!time) {
        return;
    }
    int duration = [time intValue];
    
    BOOL isIncrease = YES;
    NSInteger interval = 10;
    NSInteger limit = 30;
    DHBleCommandType commandType = [DHTool typeOfCommand:self.currentCommondId];
    
    if (commandType == DHBleCommandTypeStepSyncing ||
        commandType == DHBleCommandTypeSleepSyncing ||
        commandType == DHBleCommandTypeHeartRateSyncing ||
        commandType == DHBleCommandTypeBloodPressureSyncing ||
        commandType == DHBleCommandTypeBloodOxygenSyncing ||
        commandType == DHBleCommandTypeTempSyncing ||
        commandType == DHBleCommandTypeBreathSyncing ||
        commandType == DHBleCommandTypeSportSyncing) {
        interval = 20;
        limit = 60;
    }
    if (duration == interval || duration == 2*interval || duration == 3*interval) {
        NSData * sendData = self.sendDataList.firstObject;
        if (!sendData) {
            return;
        }
        NSString *message = [NSString stringWithFormat:@"resend:%@",DHDecimalStringLog(sendData)];
        DHSaveLog(message);
        [self.peripheral writeValue:sendData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }else if (duration > limit ){
        NSString *message = [NSString stringWithFormat:@"命令超时，移除重发命令列表ID:%@",[self.currentCommondId uppercaseString]];
        DHSaveLog(message);
        [self removeAllProcessDictionaryForCommand:self.currentCommondId isTimeOut:YES];
        isIncrease = NO;
    }
    
    duration ++;
    if (self.sendTimeList.count > 0 && isIncrease) {
        [self.sendTimeList replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",duration]];
    }
    
}

-(void)removeAllProcessDictionaryForCommand:(NSString *)command
                                  isTimeOut:(BOOL)isTimeOut {
    if (self.sendDataList.count) {
        [self.sendDataList removeObjectAtIndex:0];
    }
    if (self.sendTimeList.count) {
        [self.sendTimeList removeObjectAtIndex:0];
    }
    if (self.sendSerialList.count) {
        [self.sendSerialList removeObjectAtIndex:0];
    }
    if (self.sendCommandList.count) {
        [self.sendCommandList removeObjectAtIndex:0];
    }
    
    if (isTimeOut) {
        DHBleCommandType commandType = [DHTool typeOfCommand:command];
        if (commandType == DHBleCommandTypeDataSyncing ||
            commandType == DHBleCommandTypeStepSyncing ||
            commandType == DHBleCommandTypeSleepSyncing ||
            commandType == DHBleCommandTypeHeartRateSyncing ||
            commandType == DHBleCommandTypeBloodPressureSyncing ||
            commandType == DHBleCommandTypeBloodOxygenSyncing ||
            commandType == DHBleCommandTypeTempSyncing ||
            commandType == DHBleCommandTypeBreathSyncing ||
            commandType == DHBleCommandTypeSportSyncing) {
            [self removeDataSyncingBlock:commandType message:DHCommandMsgTimeout];
        } else {
            [self removeCommandBlock:commandType message:DHCommandMsgTimeout];
        }
    }
    
    if (self.sendDataList.count == 0) {
        [self resendTimerStop];
    }else{
        [self checkIfWriteData];
    }
}

-(void)clearSendDatalist{
    if (self.sendCommandList.count) {
        for (NSString *command in self.sendCommandList) {
            DHBleCommandType commandType = [DHTool typeOfCommand:command];
            if (commandType == DHBleCommandTypeDataSyncing ||
                commandType == DHBleCommandTypeStepSyncing ||
                commandType == DHBleCommandTypeSleepSyncing ||
                commandType == DHBleCommandTypeHeartRateSyncing ||
                commandType == DHBleCommandTypeBloodPressureSyncing ||
                commandType == DHBleCommandTypeBloodOxygenSyncing ||
                commandType == DHBleCommandTypeTempSyncing ||
                commandType == DHBleCommandTypeBreathSyncing ||
                commandType == DHBleCommandTypeSportSyncing) {
                [self removeDataSyncingBlock:commandType message:DHCommandMsgDisconnected];
            } else {
                [self removeCommandBlock:commandType message:DHCommandMsgDisconnected];
            }
        }
    }
    
    self.sendDataList  = [NSMutableArray array];
    self.sendCommandList = [NSMutableArray array];
    self.sendTimeList = [NSMutableArray array];
    self.sendSerialList = [NSMutableArray array];
    
    [self jlCleanQueue];
        
    self.isDataSyncing = NO;
    
    self.dataSyncInterval = 20;
    
    if (self.isDialSyncing) {
        [self dialSyncingFailed:DHCommandMsgDisconnected];
    }
    if (self.isFileSyncing) {
        [self fileSyncingFailed:DHCommandMsgDisconnected];
    }
    if (self.isMapSyncing) {
        [self mapSyncingFailed:DHCommandMsgDisconnected];
    }
    if (self.isThumbnailSyncing) {
        [self thumbnailSyncingFailed:DHCommandMsgDisconnected];
    }
    

    [self resendTimerStop];
}

- (void)removeCommandBlock:(DHBleCommandType)commandType message:(NSString *)message {
    switch (commandType) {
        case DHBleCommandTypeBindSet:
        {
            if (self.bindSetBlock) {
                self.bindSetBlock(DHCommandCodeFailed, message);
                self.bindSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeTimeSet:
        {
            if (self.timeSetBlock) {
                self.timeSetBlock(DHCommandCodeFailed, message);
                self.timeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeUnitSet:
        {
            if (self.unitSetBlock) {
                self.unitSetBlock(DHCommandCodeFailed, message);
                self.unitSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeAncsSet:
        {
            if (self.ancsSetBlock) {
                self.ancsSetBlock(DHCommandCodeFailed, message);
                self.ancsSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeAlarmSet:
        {
            if (self.alarmSetBlock) {
                self.alarmSetBlock(DHCommandCodeFailed, message);
                self.alarmSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypePrayAlarmSet:
        {
            if (self.prayAlarmSetBlock) {
                self.prayAlarmSetBlock(DHCommandCodeFailed, message);
                self.prayAlarmSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBrightTimeSet:
        {
            if (self.brightTimeSetBlock) {
                self.brightTimeSetBlock(DHCommandCodeFailed, message);
                self.brightTimeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeContactSet:
        {
            if (self.contactSetBlock) {
                self.contactSetBlock(DHCommandCodeFailed, message);
                self.contactSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSedentarySet:
        {
            if (self.sedentarySetBlock) {
                self.sedentarySetBlock(DHCommandCodeFailed, message);
                self.sedentarySetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeDrinkingSet:
        {
            if (self.drinkingSetBlock) {
                self.drinkingSetBlock(DHCommandCodeFailed, message);
                self.drinkingSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeReminderModeSet:
        {
            if (self.reminderModeSetBlock) {
                self.reminderModeSetBlock(DHCommandCodeFailed, message);
                self.reminderModeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeGestureSet:
        {
            if (self.gestureSetBlock) {
                self.gestureSetBlock(DHCommandCodeFailed, message);
                self.gestureSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeHeartRateModeSet:
        {
            if (self.heartRateModeSetBlock) {
                self.heartRateModeSetBlock(DHCommandCodeFailed, message);
                self.heartRateModeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeDisturbModeSet:
        {
            if (self.disturbModeSetBlock) {
                self.disturbModeSetBlock(DHCommandCodeFailed, message);
                self.disturbModeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeUserInfoSet:
        {
            if (self.userInfoSetBlock) {
                self.userInfoSetBlock(DHCommandCodeFailed, message);
                self.userInfoSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeQRCodeSet:
        {
            if (self.qrCodeSetBlock) {
                self.qrCodeSetBlock(DHCommandCodeFailed, message);
                self.qrCodeSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSportGoalSet:
        {
            if (self.sportGoalSetBlock) {
                self.sportGoalSetBlock(DHCommandCodeFailed, message);
                self.sportGoalSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeWeatherSet:
        {
            if (self.weatherSetBlock) {
                self.weatherSetBlock(DHCommandCodeFailed, message);
                self.weatherSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBreathSet:
        {
            if (self.breathSetBlock) {
                self.breathSetBlock(DHCommandCodeFailed, message);
                self.breathSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeMenstrualCycleSet:
        {
            if (self.menstrualCycleSetBlock) {
                self.menstrualCycleSetBlock(DHCommandCodeFailed, message);
                self.menstrualCycleSetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeLocationSet:
        {
            if (self.locationSetBlock) {
                self.locationSetBlock(DHCommandCodeFailed, message);
                self.locationSetBlock = nil;
            }
        }
            break;
            
        case DHBleCommandTypeCameraControl:
        {
            if (self.cameraControlBlock) {
                self.cameraControlBlock(DHCommandCodeFailed, message);
                self.cameraControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeFindDeviceBeginControl:
        {
            if (self.findDeviceControlBlock) {
                self.findDeviceControlBlock(DHCommandCodeFailed, message);
                self.findDeviceControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeFindPhoneEndControl:
        {
            if (self.findPhoneControlBlock) {
                self.findPhoneControlBlock(DHCommandCodeFailed, message);
                self.findPhoneControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeDeviceControl:
        {
            if (self.deviceControlBlock) {
                self.deviceControlBlock(DHCommandCodeFailed, message);
                self.deviceControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeUnbindControl:
        {
            if (self.unbindBlock) {
                self.unbindBlock(DHCommandCodeFailed, message);
                self.unbindBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSportControl:
        {
            if (self.sportControlBlock) {
                self.sportControlBlock(DHCommandCodeFailed, message);
                self.sportControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSportDataControl:
        {
            if (self.sportDataControlBlock) {
                self.sportDataControlBlock(DHCommandCodeFailed, message);
                self.sportDataControlBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeAppStatusControl:
        {
            if (self.appstatusControlBlock) {
                self.appstatusControlBlock(DHCommandCodeFailed, message);
                self.appstatusControlBlock = nil;
            }
        }
            break;
            
        case DHBleCommandTypeFirmwareVersionGet:
        {
            if (self.firmwareVersionGetBlock) {
                self.firmwareVersionGetBlock(DHCommandCodeFailed, message);
                self.firmwareVersionGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBatteryGet:
        {
            if (self.batteryGetBlock) {
                self.batteryGetBlock(DHCommandCodeFailed, message);
                self.batteryGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBindInfoGet:
        {
            if (self.bindInfoGetBlock) {
                self.bindInfoGetBlock(DHCommandCodeFailed, message);
                self.bindInfoGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeFunctionGet:
        {
            if (self.functionGetBlock) {
                self.functionGetBlock(DHCommandCodeFailed, message);
                self.functionGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeDialInfoGet:
        {
            if (self.dialInfoGetBlock) {
                self.dialInfoGetBlock(DHCommandCodeFailed, message);
                self.dialInfoGetBlock = nil;
            }
        }
            break;
            
        case DHBleCommandTypeAncsGet:
        {
            if (self.ancsGetBlock) {
                self.ancsGetBlock(DHCommandCodeFailed, message);
                self.ancsGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSedentaryGet:
        {
            if (self.sedentaryGetBlock) {
                self.sedentaryGetBlock(DHCommandCodeFailed, message);
                self.sedentaryGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeDrinkingGet:
        {
            if (self.drinkingGetBlock) {
                self.drinkingGetBlock(DHCommandCodeFailed, message);
                self.drinkingGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeReminderModeGet:
        {
            if (self.reminderModeGetBlock) {
                self.reminderModeGetBlock(DHCommandCodeFailed, message);
                self.reminderModeGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeAlarmGet:
        {
            if (self.alarmsGetBlock) {
                self.alarmsGetBlock(DHCommandCodeFailed, message);
                self.alarmsGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypePrayAlarmGet:{
            if (self.prayAlarmGetBlock) {
                self.prayAlarmGetBlock(DHCommandCodeFailed, message);
                self.prayAlarmGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeGestureGet:
        {
            if (self.gestureGetBlock) {
                self.gestureGetBlock(DHCommandCodeFailed, message);
                self.gestureGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBrightTimeGet:
        {
            if (self.brightTimeGetBlock) {
                self.brightTimeGetBlock(DHCommandCodeFailed, message);
                self.brightTimeGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeHeartRateModeGet:
        {
            if (self.heartRateModeGetBlock) {
                self.heartRateModeGetBlock(DHCommandCodeFailed, message);
                self.heartRateModeGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeDisturbModeGet:
        {
            if (self.disturbModeGetBlock) {
                self.disturbModeGetBlock(DHCommandCodeFailed, message);
                self.disturbModeGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeMacAddressGet:
        {
            if (self.macAddressGetBlock) {
                self.macAddressGetBlock(DHCommandCodeFailed, message);
                self.macAddressGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeClassicBleGet:
        {
            if (self.classicBleGetBlock) {
                self.classicBleGetBlock(DHCommandCodeFailed, message);
                self.classicBleGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeLocalDialGet:
        {
            if (self.localDialGetBlock) {
                self.localDialGetBlock(DHCommandCodeFailed, message);
                self.localDialGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeOtaInfoGet:
        {
            if (self.otaInfoGetBlock) {
                self.otaInfoGetBlock(DHCommandCodeFailed, message);
                self.otaInfoGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBreathGet:
        {
            if (self.breathGetBlock) {
                self.breathGetBlock(DHCommandCodeFailed, message);
                self.breathGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeCustomDialGet:
        {
            if (self.customDialGetBlock) {
                self.customDialGetBlock(DHCommandCodeFailed, message);
                self.customDialGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeMenstrualCycleGet:
        {
            if (self.menstrualCycleGetBlock) {
                self.menstrualCycleGetBlock(DHCommandCodeFailed, message);
                self.menstrualCycleGetBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeFileSyncingStart:
        {
            if (self.fileSyncingStartBlock) {
                self.fileSyncingStartBlock(DHCommandCodeFailed, message);
                self.fileSyncingStartBlock = nil;
            }
        }
            break;
        default:
            break;
    }
}

-(void)resendTimerStart {
    if (!_reSendDataTimer) {
        _reSendDataTimer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(checkSendlistTimeout) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_reSendDataTimer forMode:NSDefaultRunLoopMode];
    }
}

-(void)resendTimerStop{
    if (_reSendDataTimer) {
        [_reSendDataTimer invalidate];
        _reSendDataTimer = nil;
    }
}

#pragma mark- 杰里平台协议方法
- (void)sendCommand:(BleCommand)cmdType keyType:(BleKey)keyType opType:(BleKeyFlag)opType value:(NSData *)value
{
    JLBleProtocol *tModel = [[JLBleProtocol alloc] initDataCmd:cmdType key:keyType opType:opType value:value];
    
    JLSendModel *tSendModel = [[JLSendModel alloc] initBleKey:keyType sendData:[tModel packProtocolData]];
    [self jlPushQueue:tSendModel];
    
}

- (void)sendCommandNow:(BleCommand)cmdType keyType:(BleKey)keyType opType:(BleKeyFlag)opType value:(NSData *)value
{
    JLBleProtocol *tModel = [[JLBleProtocol alloc] initDataCmd:cmdType key:keyType opType:opType value:value];
    JLSendModel *tSendModel = [[JLSendModel alloc] initBleKey:keyType sendData:[tModel packProtocolData]];
    NSLog(@"sendCommandNow %@", [tModel packProtocolData]);
    [self jlPushQueueToTop:tSendModel];
}

- (void)sendAck:(NSData *)ackData
{
    NSLog(@"sendAckData %@", ackData);
    [self.peripheral writeValue:ackData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

- (void)sendFileData:(NSData *)fileData fileIndex:(UInt32)fileIndex key:(BleKey)key
{
    NSLog(@"sendFileData %d", fileIndex);
    Byte tFileIndex = 0; //预留
    UInt32 tFileSize = self.dialSyncDataLen; //文件总长度
    UInt32 tFileOffset = fileIndex;
    NSMutableData *tFileData = [NSMutableData dataWithCapacity:0];
    [tFileData appendBytes:&tFileIndex length:1];
    tFileSize = htonl(tFileSize);
    tFileOffset = htonl(tFileOffset);
    [tFileData appendBytes:&tFileSize length:4];
    [tFileData appendBytes:&tFileOffset length:4];
    [tFileData appendData:fileData];
    
    [self sendCommand:BLE_COMMAND_IO keyType:key opType:BLE_KEY_FLAG_UPDATE value:tFileData];
}

- (void)jlPushQueue:(JLSendModel *)sendModel{
    [self.jlSendQueue addObject:sendModel];
    NSLog(@"jlPushQueue %zd", self.jlSendQueue.count);
    
    [self jlHandleNextPacket];
}

- (void)jlPushQueueToTop:(JLSendModel *)sendModel{
    [self.jlSendQueue insertObject:sendModel atIndex:0];
    NSLog(@"jlPushQueueToTop %zd", self.jlSendQueue.count);
    
    [self jlHandleNextPacket];
}

- (void)jlPopQueue{
    if (self.jlSendQueue.count > 0){
        [self.jlSendQueue removeObjectAtIndex:0];
        NSLog(@"jlPopQueue %zd", self.jlSendQueue.count);
        _jlSendState = 0;
    }
    else{
        NSLog(@"jlPopQueue %zd 0000", self.jlSendQueue.count);
    }
}

- (void)jlHandleNextPacket{
    NSLog(@"jlHandleNextPacket %d jlSendQueue %zd", _jlSendState, self.jlSendQueue.count);
    if (_jlSendState == 0 && self.jlSendQueue.count > 0){ //
        JLSendModel *tTopModel = [self.jlSendQueue firstObject];
        
        _jlSendState = 1;
        
        while ([tTopModel sendFinished] == NO) {
            NSData *tWillSendData = [tTopModel nextFrame];
            NSLog(@"jlHandleNextPacket sendData %@", tWillSendData);
            [self.peripheral writeValue:tWillSendData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

- (void)jlCleanQueue{
    _jlSendState = 0;
    [self.jlSendQueue removeAllObjects];
}

#pragma mark - 更新同步数据进度

- (void)removeDataSyncingBlock:(DHBleCommandType)commandType message:(NSString *)message {
    if (commandType ==  DHBleCommandTypeDataSyncing) {
        self.isDataSyncing = NO;
        if (self.dataSyncingBlock) {
            self.dataSyncingBlock(DHCommandCodeFailed, 100, message);
            self.dataSyncingBlock = nil;
        } else if (self.checkDataSyncingBlock) {
            self.checkDataSyncingBlock(DHCommandCodeFailed, message);
            self.checkDataSyncingBlock = nil;
        }
        return;
    }
    switch (commandType) {
        case DHBleCommandTypeStepSyncing:
        {
            if (self.stepSyncingBlock) {
                self.stepSyncingBlock(DHCommandCodeFailed, message);
                self.stepSyncingBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSleepSyncing:
        {
            if (self.sleepSyncingBlock) {
                self.sleepSyncingBlock(DHCommandCodeFailed, message);
                self.sleepSyncingBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeHeartRateSyncing:
        {
            if (self.hrSyncingBlock) {
                self.hrSyncingBlock(DHCommandCodeFailed, message);
                self.hrSyncingBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBloodPressureSyncing:
        {
            if (self.bpSyncingBlock) {
                self.bpSyncingBlock(DHCommandCodeFailed, message);
                self.bpSyncingBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBloodOxygenSyncing:
        {
            if (self.boSyncingBlock) {
                self.boSyncingBlock(DHCommandCodeFailed, message);
                self.boSyncingBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeTempSyncing:
        {
            if (self.tempSyncingBlock) {
                self.tempSyncingBlock(DHCommandCodeFailed, message);
                self.tempSyncingBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeBreathSyncing:
        {
            if (self.breathSyncingBlock) {
                self.breathSyncingBlock(DHCommandCodeFailed, message);
                self.breathSyncingBlock = nil;
            }
        }
            break;
        case DHBleCommandTypeSportSyncing:
        {
            if (self.sportSyncingBlock) {
                self.sportSyncingBlock(DHCommandCodeFailed, message);
                self.sportSyncingBlock = nil;
            }
        }
            break;
            
        default:
            break;
    }
    if (self.dataSyncProgress < 100) {
        self.dataSyncProgress += [self getSyncInterval];
    }
    if (self.dataSyncProgress >= 100) {
        self.isDataSyncing = NO;
        if (self.dataSyncingBlock) {
            self.dataSyncingBlock(DHCommandCodeFailed, 100, message);
        }
    }
}

- (int)getSyncInterval {
    if (100-self.dataSyncProgress >= 2*self.dataSyncInterval) {
        return self.dataSyncInterval;
    }
    return 100-self.dataSyncProgress;
}

#pragma mark - 表盘传输

- (void)dialSyncingStart
{
    
}
- (void)dialSyncingOutgoing
{
    [self startSendDialData];
}

- (void)startSendDialData {
    if (self.dialSyncIndex >= self.dialSyncCount) {
        [self dialSyncingSuccess];
        return;
    } else {
        self.dialSyncProgress = 1.0*self.dialSyncIndex/self.dialSyncCount;
        if (self.dialSyncingBlock) {
            self.dialSyncingBlock(DHCommandCodeSuccessfully, self.dialSyncProgress, DHCommandMsgSuccessfully);
        }
        NSData *dialData = self.dialSyncArray[self.dialSyncIndex];
        [self sendDialData:dialData];
    }
    self.dialSyncIndex++;
    if (self.dialSyncIndex % 10 != 0){
        [self startSendDialData];
    }
//    [self performSelector:@selector(startSendDialData) withObject:nil afterDelay:self.connectInterval];
}

- (void)jlDialSyncingOutgoing:(BleKey)blekey
{
    [self jlStartSendDialData:blekey];
}

- (void)jlStartSendDialData:(BleKey)blekey {
    NSLog(@"jlStartSendDialData %d %d dialSyncDataIndex %d", self.dialSyncIndex, self.dialSyncCount, self.dialSyncDataIndex);
    if (self.dialSyncIndex >= self.dialSyncCount) {
        [self dialSyncingSuccess];
        return;
    } else {
        self.dialSyncProgress = 1.0*self.dialSyncIndex/self.dialSyncCount;
        if (self.dialSyncingBlock) {
            self.dialSyncingBlock(DHCommandCodeSuccessfully, self.dialSyncProgress, DHCommandMsgSuccessfully);
        }
        NSData *dialData = self.dialSyncArray[self.dialSyncIndex];
        [self sendFileData:dialData fileIndex:self.dialSyncDataIndex key:blekey];
    }
    self.dialSyncIndex++;
}

- (void)jlStartSendUIData:(BleKey)bleKey {
    NSLog(@"jlStartSendDialData %d %d dialSyncDataIndex %d", self.dialSyncIndex, self.dialSyncCount, self.dialSyncDataIndex);
    if (self.dialSyncIndex >= self.dialSyncCount) {
        [self dialSyncingSuccess];
        return;
    } else {
        self.dialSyncProgress = 1.0*self.dialSyncIndex/self.dialSyncCount;
        if (self.dialSyncingBlock) {
            self.dialSyncingBlock(DHCommandCodeSuccessfully, self.dialSyncProgress, DHCommandMsgSuccessfully);
        }
        NSData *dialData = self.dialSyncArray[self.dialSyncIndex];
        [self sendFileData:dialData fileIndex:self.dialSyncDataIndex key:bleKey];
    }
    self.dialSyncIndex++;
}


- (void)dialSyncingFinished {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendDialData) object:nil];
    if (self.dialSyncingBlock) {
        self.dialSyncingBlock(DHCommandCodeSuccessfully, 1.0, DHCommandMsgFinished);
        self.dialSyncingBlock = nil;
    }
    
    [self.dialSyncArray removeAllObjects];
    self.dialSyncIndex = 0;
    self.dialSyncCount = 0;
    self.dialSyncProgress = 0;
    self.isDialSyncing = NO;
    self.dialSyncDataIndex = 0;
}
    

- (void)dialSyncingSuccess {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendDialData) object:nil];
    if (self.dialSyncingBlock) {
        self.dialSyncingBlock(DHCommandCodeSuccessfully, 1.0, DHCommandMsgSuccessfully);
    }
    
    [self.dialSyncArray removeAllObjects];
    self.dialSyncIndex = 0;
    self.dialSyncCount = 0;
    self.dialSyncProgress = 0;
    self.dialSyncDataIndex = 0;
}

- (void)dialSyncingFailed:(NSString *)message {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendDialData) object:nil];
    if (self.dialSyncingBlock) {
        self.dialSyncingBlock(DHCommandCodeFailed, self.dialSyncProgress, message);
        self.dialSyncingBlock = nil;
    }
    
    [self.dialSyncArray removeAllObjects];
    self.dialSyncIndex = 0;
    self.dialSyncCount = 0;
    self.dialSyncProgress = 0;
    self.isDialSyncing = NO;
    self.dialSyncDataIndex = 0;
}

- (void)sendDialData:(NSData *)data {
    
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)DHBleCommandTypeDialSyncing];
    NSData *value = [DHTool transformCommand:command serial:self.commandSerial contentData:data];
    if (self.commandSerial > 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    DHSaveLog(@"sendDialData");
    if (self.dialSyncIndex == 0) {
        NSString *message = [NSString stringWithFormat:@"单次send:%@",DHDecimalStringLog(value)];
        DHSaveLog(message);
    }
    [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark - 文件传输

- (void)startSendFileData {
    
    if (self.fileSyncIndex >= self.fileSyncCount) {
        [self fileSyncingSuccess];
        return;
    } else {
        self.fileSyncProgress = 1.0*self.fileSyncIndex/self.fileSyncCount;
        if (self.fileSyncingBlock) {
            self.fileSyncingBlock(DHCommandCodeSuccessfully, self.fileSyncProgress, DHCommandMsgSuccessfully);
        }
        NSData *fileData = self.fileSyncArray[self.fileSyncIndex];
        [self sendFileData:fileData];
    }
    self.fileSyncIndex++;
    if (self.fileSyncIndex % 10 != 0){
        [self startSendFileData];
//        [self performSelector:@selector(startSendFileData) withObject:nil afterDelay:self.connectInterval];
    }
//    [self performSelector:@selector(startSendFileData) withObject:nil afterDelay:self.connectInterval];
}

- (void)fileSyncingStart{
    NSLog(@"fileSyncingStart");
//    [self startSendFileData];
}

- (void)fileSyncingOutgoing{
    [self startSendFileData];
}


- (void)fileSyncingFinished {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendFileData) object:nil];
    if (self.fileSyncingBlock) {
        self.fileSyncingBlock(DHCommandCodeSuccessfully, 1.0, DHCommandMsgFinished);
        self.fileSyncingBlock = nil;
    }
    
    [self.fileSyncArray removeAllObjects];
    self.fileSyncIndex = 0;
    self.fileSyncCount = 0;
    self.fileSyncProgress = 0;
    self.isFileSyncing = NO;
}
    
- (void)fileSyncingSuccess {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendFileData) object:nil];
    if (self.fileSyncingBlock) {
        self.fileSyncingBlock(DHCommandCodeSuccessfully, 1.0, DHCommandMsgSuccessfully);
    }
    
    [self.fileSyncArray removeAllObjects];
    self.fileSyncIndex = 0;
    self.fileSyncCount = 0;
    self.fileSyncProgress = 0;
}

- (void)fileSyncingFailed:(NSString *)message {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendFileData) object:nil];
    if (self.fileSyncingBlock) {
        self.fileSyncingBlock(DHCommandCodeFailed, self.fileSyncProgress, message);
        self.fileSyncingBlock = nil;
    }
    
    [self.fileSyncArray removeAllObjects];
    self.fileSyncIndex = 0;
    self.fileSyncCount = 0;
    self.fileSyncProgress = 0;
    self.isFileSyncing = NO;
}

- (void)sendFileData:(NSData *)data {
    
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)DHBleCommandTypeFileSyncing];
    NSData *value = [DHTool transformCommand:command serial:self.commandSerial contentData:data];
    if (self.commandSerial > 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    DHSaveLog(@"sendFileData");
    if (self.fileSyncIndex == 0) {
        NSString *message = [NSString stringWithFormat:@"单次send:%@",DHDecimalStringLog(value)];
        DHSaveLog(message);
    }
    [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark - 轨迹同步

- (void)mapSyncingStart
{
    
}
- (void)mapSyncingOutgoing
{
    [self startSendMapData];
}

- (void)startSendMapData {
    NSLog(@"startSendMapData %zd %zd", self.mapSyncIndex, self.mapSyncCount);
    if (self.mapSyncIndex >= self.mapSyncCount) {
        [self mapSyncingSuccess];
        return;
    } else {
        self.mapSyncProgress = 1.0*self.mapSyncIndex/self.mapSyncCount;
        if (self.mapSyncingBlock) {
            self.mapSyncingBlock(DHCommandCodeSuccessfully, self.mapSyncProgress, DHCommandMsgSuccessfully);
        }
        NSData *mapData = self.mapSyncArray[self.mapSyncIndex];
        [self sendMapData:mapData];
    }
    
    self.mapSyncIndex++;
    if (self.mapSyncIndex % 10 != 0){
        [self startSendMapData];
    }
//    [self performSelector:@selector(startSendMapData) withObject:nil afterDelay:self.connectInterval];
}

- (void)mapSyncingFinished {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendMapData) object:nil];
    if (self.mapSyncingBlock) {
        self.mapSyncingBlock(DHCommandCodeSuccessfully, 1.0, DHCommandMsgFinished);
        self.mapSyncingBlock = nil;
    }
    
    [self.mapSyncArray removeAllObjects];
    self.mapSyncIndex = 0;
    self.mapSyncCount = 0;
    self.mapSyncProgress = 0;
    self.isMapSyncing = NO;
}
    
- (void)mapSyncingSuccess {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendMapData) object:nil];
    if (self.mapSyncingBlock) {
        self.mapSyncingBlock(DHCommandCodeSuccessfully, 1.0, DHCommandMsgSuccessfully);
    }
    
    [self.mapSyncArray removeAllObjects];
    self.mapSyncIndex = 0;
    self.mapSyncCount = 0;
    self.mapSyncProgress = 0;
}

- (void)mapSyncingFailed:(NSString *)message {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendMapData) object:nil];
    if (self.mapSyncingBlock) {
        self.mapSyncingBlock(DHCommandCodeFailed, self.mapSyncProgress, message);
        self.mapSyncingBlock = nil;
    }
    
    [self.mapSyncArray removeAllObjects];
    self.mapSyncIndex = 0;
    self.mapSyncCount = 0;
    self.mapSyncProgress = 0;
    self.isMapSyncing = NO;
}

- (void)sendMapData:(NSData *)data {
    
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)DHBleCommandTypeMapSyncing];
    NSData *value = [DHTool transformCommand:command serial:self.commandSerial contentData:data];
    if (self.commandSerial > 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    DHSaveLog(@"sendMapData");
    if (self.mapSyncIndex == 0) {
        NSString *message = [NSString stringWithFormat:@"单次send:%@",DHDecimalStringLog(value)];
        DHSaveLog(message);
    }
    [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark - 缩略图同步

- (void)thumbnailSyncingStart
{
    
}
- (void)thumbnailSyncingOutgoing
{
    [self startSendThumbnailData];
}

/// 开始缩略图传输
- (void)startSendThumbnailData {
    if (self.thumbnailSyncIndex >= self.thumbnailSyncCount) {
        [self thumbnailSyncingSuccess];
        return;
    } else {
        self.thumbnailSyncProgress = 1.0*self.thumbnailSyncIndex/self.thumbnailSyncCount;
        if (self.thumbnailSyncingBlock) {
            self.thumbnailSyncingBlock(DHCommandCodeSuccessfully, self.thumbnailSyncProgress, DHCommandMsgSuccessfully);
        }
        NSData *thumbnailData = self.thumbnailSyncArray[self.thumbnailSyncIndex];
        [self sendThumbnailData:thumbnailData];
    }
    self.thumbnailSyncIndex++;
    if (self.thumbnailSyncIndex % 10 != 0){
        [self startSendThumbnailData];
    }

//    [self performSelector:@selector(startSendThumbnailData) withObject:nil afterDelay:self.connectInterval];
}
/// 缩略图同步失败
/// @param message 错误信息
- (void)thumbnailSyncingFailed:(NSString *)message {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendThumbnailData) object:nil];
    if (self.thumbnailSyncingBlock) {
        self.thumbnailSyncingBlock(DHCommandCodeFailed, self.thumbnailSyncProgress, message);
        self.thumbnailSyncingBlock = nil;
    }
    
    [self.thumbnailSyncArray removeAllObjects];
    self.thumbnailSyncIndex = 0;
    self.thumbnailSyncCount = 0;
    self.thumbnailSyncProgress = 0;
    self.isThumbnailSyncing = NO;
}
/// 缩略图同步完成
- (void)thumbnailSyncingFinished {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendThumbnailData) object:nil];
    if (self.thumbnailSyncingBlock) {
        self.thumbnailSyncingBlock(DHCommandCodeSuccessfully, 1.0, DHCommandMsgFinished);
        self.thumbnailSyncingBlock = nil;
    }
    
    [self.thumbnailSyncArray removeAllObjects];
    self.thumbnailSyncIndex = 0;
    self.thumbnailSyncCount = 0;
    self.thumbnailSyncProgress = 0;
    self.isThumbnailSyncing = NO;
}

- (void)thumbnailSyncingSuccess {
    [NSObject  cancelPreviousPerformRequestsWithTarget:self selector:@selector(startSendThumbnailData) object:nil];
    if (self.thumbnailSyncingBlock) {
        self.thumbnailSyncingBlock(DHCommandCodeSuccessfully, 1.0, DHCommandMsgSuccessfully);
    }
    
    [self.thumbnailSyncArray removeAllObjects];
    self.thumbnailSyncIndex = 0;
    self.thumbnailSyncCount = 0;
    self.thumbnailSyncProgress = 0;
}

- (void)sendThumbnailData:(NSData *)data {
    
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)DHBleCommandTypeThumbnailSyncing];
    NSData *value = [DHTool transformCommand:command serial:self.commandSerial contentData:data];
    if (self.commandSerial > 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    DHSaveLog(@"sendThumbnailData");
    if (self.thumbnailSyncIndex == 0) {
        NSString *message = [NSString stringWithFormat:@"单次send:%@",DHDecimalStringLog(value)];
        DHSaveLog(message);
    }
    [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}


#pragma mark - 自定义表盘设置小控件、恢复默认

- (void)startCustomDialSyncing:(NSString *)payload {
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)DHBleCommandTypeDialSyncing];
    NSData *value = [DHTool transformCommand:command serial:self.commandSerial payload:payload];
    if (self.commandSerial > 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    
    NSString *message = [NSString stringWithFormat:@"单次send:%@",DHDecimalStringLog(value)];
    DHSaveLog(message);
    [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    
    [self performSelector:@selector(customDialSyncingSuccess) withObject:nil afterDelay:0.5];
}

- (void)customDialSyncingSuccess {
    if (self.dialSyncingBlock) {
        self.dialSyncingBlock(DHCommandCodeSuccessfully, 1.0, DHCommandMsgSuccessfully);
        self.dialSyncingBlock = nil;
    }
}

#pragma mark - 发送指令

- (void)sendJieLiTest{
    Byte bindInfo[13] = {0xAB,0x01,0x00,0x07,0xD7,0x33,0x03,0x01,0x20,0xEA,0xB8,0x4C,0x50};
    [self.peripheral writeValue:[NSData dataWithBytes:bindInfo length:13] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)sendCommand:(DHBleCommandType)writeType
            repeats:(BOOL)repeats {
    
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)writeType];
    NSData *value = [DHTool transformCommand:command serial:self.commandSerial];
    if (self.commandSerial >= 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    if (repeats) {
        [self.sendDataList addObject:value];
        [self.sendTimeList addObject:@"0"];
        [self.sendSerialList addObject:[NSString stringWithFormat:@"%ld",(long)self.commandSerial]];
        [self.sendCommandList addObject:command];
        [self sendCommand];
        
    } else {
        NSString *message = [NSString stringWithFormat:@"单次send:%@", DHDecimalStringLog(value)];
        DHSaveLog(message);
        [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)sendCommandWithData:(NSData *)data
                  writeType:(DHBleCommandType)writeType
                    repeats:(BOOL)repeats {
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)writeType];
    NSData *value = [DHTool transformCommand:command serial:self.commandSerial contentData:data];
    if (self.commandSerial >= 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    if (repeats) {
        [self.sendDataList addObject:value];
        [self.sendTimeList addObject:@"0"];
        [self.sendSerialList addObject:[NSString stringWithFormat:@"%ld",(long)self.commandSerial]];
        [self.sendCommandList addObject:command];
        [self sendCommand];
        
    } else {
        NSString *message = [NSString stringWithFormat:@"单次send:%@",DHDecimalStringLog(value)];
        DHSaveLog(message);
        [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)sendCommandWithPayload:(NSString *)payload
                     writeType:(DHBleCommandType)writeType
                       repeats:(BOOL)repeats {
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)writeType];
    NSData *value = [DHTool transformCommand:command serial:self.commandSerial payload:payload];
    if (self.commandSerial >= 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    if (repeats) {
        [self.sendDataList addObject:value];
        [self.sendTimeList addObject:@"0"];
        [self.sendSerialList addObject:[NSString stringWithFormat:@"%ld",(long)self.commandSerial]];
        [self.sendCommandList addObject:command];
        [self sendCommand];
        
    } else {
        NSString *message = [NSString stringWithFormat:@"单次send:%@",DHDecimalStringLog(value)];
        DHSaveLog(message);
        [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)sendCommandWithData:(NSData *)data
                          index:(NSInteger)index
                          count:(NSInteger)count
                     writeType:(DHBleCommandType)writeType
                       repeats:(BOOL)repeats {
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)writeType];
    NSData *value = [DHTool transformCommand:command serial:self.commandSerial index:index count:count contentData:data];
    if (self.commandSerial >= 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    if (repeats) {
        [self.sendDataList addObject:value];
        [self.sendTimeList addObject:@"0"];
        [self.sendSerialList addObject:[NSString stringWithFormat:@"%ld",(long)self.commandSerial]];
        [self.sendCommandList addObject:command];
        [self sendCommand];
        
    } else {
        NSString *message = [NSString stringWithFormat:@"单次send:%@",DHDecimalStringLog(value)];
        DHSaveLog(message);
        [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)feedbackDeviceSerial:(NSInteger)serial command:(NSInteger)command {
    NSString *payload = [NSString stringWithFormat:@"%04lx%02lx00",(long)serial,(long)command];
    NSData *value = [DHTool transformCommand:DHCommandAppFeedback serial:self.commandSerial payload:payload];
    if (self.commandSerial >= 65535) {
        self.commandSerial = 1;
    } else {
        self.commandSerial++;
    }
    
    NSString *message = [NSString stringWithFormat:@"APP通用应答:%@",DHDecimalStringLog(value)];
    DHSaveLog(message);
    [self.peripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)startStepSyncing {
    if ([DHBleCentralManager isJLProtocol]){
        [self sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_ACTIVITY opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [self sendCommand:DHBleCommandTypeStepSyncing repeats:YES];
    }
}

- (void)startSleepSyncing {
    if ([DHBleCentralManager isJLProtocol]){
        [self sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_SLEEP opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [self sendCommand:DHBleCommandTypeSleepSyncing repeats:YES];
    }
}

- (void)startHeartRateSyncing {
    if ([DHBleCentralManager isJLProtocol]){
        [self sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_HEART_RATE opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [self sendCommand:DHBleCommandTypeHeartRateSyncing repeats:YES];
    }
}

- (void)startBloodPressureSyncing {
    if ([DHBleCentralManager isJLProtocol]){
        [self sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_BLOOD_PRESSURE opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [self sendCommand:DHBleCommandTypeBloodPressureSyncing repeats:YES];
    }
}

- (void)startBloodOxygenSyncing {
    if ([DHBleCentralManager isJLProtocol]){
        [self sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_BLOOD_OXYGEN opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [self sendCommand:DHBleCommandTypeBloodOxygenSyncing repeats:YES];
    }
}

- (void)startTempSyncing {
    [self sendCommand:DHBleCommandTypeTempSyncing repeats:YES];
}

- (void)startBreathSyncing {
    [self sendCommand:DHBleCommandTypeBreathSyncing repeats:YES];
}

- (void)startSportSyncing {
    NSLog(@"DHBleSendManager startSportSyncing");
    if ([DHBleCentralManager isJLProtocol]){
        [self sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_WORKOUT2 opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [self sendCommand:DHBleCommandTypeSportSyncing repeats:YES];
    }
}

- (void)startJLPressSyncing {
    NSLog(@"DHBleSendManager startJLPressSyncing");
    
    [self sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_STRESS opType:BLE_KEY_FLAG_READ value:[NSData data]];
}

#pragma mark - setter and getter

-(NSMutableArray *)sendDataList{
    if (_sendDataList == nil) {
        _sendDataList = [NSMutableArray array];
    }
    return _sendDataList;
}

-(NSMutableArray *)sendTimeList{
    if (_sendTimeList == nil) {
        _sendTimeList = [NSMutableArray array];
    }
    return _sendTimeList;
}

-(NSMutableArray *)sendSerialList{
    if (_sendSerialList == nil) {
        _sendSerialList = [NSMutableArray array];
    }
    return _sendSerialList;
}

-(NSMutableArray *)sendCommandList{
    if (_sendCommandList == nil) {
        _sendCommandList = [NSMutableArray array];
    }
    return _sendCommandList;
}

@end
