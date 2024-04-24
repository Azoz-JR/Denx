//
//  DHBleCommand.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHBleCommand.h"
#import "DHTool.h"
#import "DHBleCommandEnums.h"
#import "DHBleSendManager.h"

@implementation DHBleCommand

#pragma mark - 获取类

+ (void)callbackFail:(void(^)(int code, id data))block {
    if (block) {
        block(DHCommandCodeFailed, DHCommandMsgDisconnected);
    }
}

+ (void)getFirmwareVersion:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.firmwareVersionGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_FIRMWARE_VERSION opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeFirmwareVersionGet repeats:YES];
    }
}

+ (void)getBattery:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.batteryGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_POWER opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeBatteryGet repeats:YES];
    }
}

+ (void)getBindInfo:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.bindInfoGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){  //TODO 10.6杰里协议暂无法查版本信息,暂直接返回无绑定信息
        if (manager.bindInfoGetBlock) {
            DHBindSetModel *model = [[DHBindSetModel alloc] init];
            model.isBind = NO;
            model.bindOS = 2;
            model.userId = @"0";
            manager.bindInfoGetBlock(DHCommandCodeSuccessfully, model);
            manager.bindInfoGetBlock = nil;
        }
    }
    else{
        [manager sendCommand:DHBleCommandTypeBindInfoGet repeats:YES];
    }
}

+ (void)getJLBindInfoLogin:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.bindInfoGetBlock = block;
    }
    
    [manager sendCommand:BLE_COMMAND_CONNECT keyType:BLE_KEY_SESSION opType:BLE_KEY_FLAG_CREATE value:[NSData data]];
}

+ (void)getFunction:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.functionGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        DeviceFuncModel *funcModel = [DeviceFuncModel currentModel];

        DHFunctionInfoModel *model = [[DHFunctionInfoModel alloc] init];
        model.isStep = YES;
        model.isSleep = YES;
        model.isHeartRate = funcModel.isHeartRate;
        model.isBp = funcModel.isBp;
        model.isBo = funcModel.isBo;
        model.isTemp = funcModel.isTemp;
        model.isEcg = NO;
        model.isBreath = NO;
        model.isPressure = funcModel.isPressure;
        
        model.isDial = YES;
        model.isWallpaper = NO;
        model.isAncs = YES;
        model.isSedentary = YES;
        model.isDrinking = YES;
        model.isReminderMode = NO;
        model.isAlarm = YES;
        model.isGesture = YES;
        
        model.isBrightTime = YES;
        model.isHeartRateMode = YES;
        model.isDisturbMode = YES;
        model.isWeather = YES;
        model.isContact = YES;
        model.isRestore = NO;
        model.isOTA = YES;
        model.isNFC = NO;
        
        model.isQRCode = NO;
        model.isRestart = NO;
        model.isShutdown = YES;
        model.isBle3 = NO;
        model.isMenstrualCycle = funcModel.isMenstrualCycle;
        model.isLocation = YES;
        
        manager.functionGetBlock(DHCommandCodeSuccessfully, model);
        manager.functionGetBlock = nil;
        
    }
    else{
        [manager sendCommand:DHBleCommandTypeFunctionGet repeats:YES];
    }
}

+ (void)getDialInfo:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.dialInfoGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        DHDialInfoModel *model = [[DHDialInfoModel alloc] init];
        
        DialInfoSetModel *dialInfoModel = [DialInfoSetModel currentModel];
        model.screenType = dialInfoModel.screenType;
        model.screenWidth = dialInfoModel.screenWidth;
        model.screenHeight = dialInfoModel.screenHeight;
        
        if (manager.dialInfoGetBlock) {
            manager.dialInfoGetBlock(DHCommandCodeSuccessfully, model);
            manager.dialInfoGetBlock = nil;
        }
    }
    else{
        [manager sendCommand:DHBleCommandTypeDialInfoGet repeats:YES];
    }
}

+ (void)getAncs:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.ancsGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_NOTIFICATION_REMINDER opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeAncsGet repeats:YES];
    }
}

+ (void)getSedentary:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.sedentaryGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_SEDENTARINESS opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeSedentaryGet repeats:YES];
    }
}

+ (void)getDrinking:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.drinkingGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_DRINK_WATER_SITE opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeDrinkingGet repeats:YES];
    }
}

+ (void)getReminderMode:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.reminderModeGetBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeReminderModeGet repeats:YES];
}

+ (void)getAlarms:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.alarmsGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        UInt8 tAlarm = 0xff;//当AlarmID为0xFF时，表示查询/更改/删除全部闹钟
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_ALARM opType:BLE_KEY_FLAG_READ value:[NSData dataWithBytes:&tAlarm length:1]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeAlarmGet repeats:YES];
    }
}

+ (void)getPrayAlarms:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.prayAlarmGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_APP_PRAYER_TIME_SYNC opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypePrayAlarmGet repeats:YES];
    }
}

+ (void)getGesture:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.gestureGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_GESTURE_WAKE opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeGestureGet repeats:YES];
    }
}

+ (void)getBrightTime:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.brightTimeGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_BACK_LIGHT opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeBrightTimeGet repeats:YES];
    }
}

+ (void)getHeartRateMode:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.heartRateModeGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_HR_MONITORING opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeHeartRateModeGet repeats:YES];
    }
}

+ (void)getDisturbMode:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.disturbModeGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_NO_DISTURB_RANGE opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeDisturbModeGet repeats:YES];
    }
}

+ (void)getMacAddress:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.macAddressGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_BLE_ADDRESS opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeMacAddressGet repeats:YES];
    }
}

+ (void)getClassicBle:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.classicBleGetBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeClassicBleGet repeats:YES];
}

+ (void)getLocalDial:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.localDialGetBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeLocalDialGet repeats:YES];
}

+ (void)getOtaInfo:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.otaInfoGetBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeOtaInfoGet repeats:YES];
}

+ (void)getBreath:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.breathGetBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeBreathGet repeats:YES];
}

+ (void)getCustomDialInfo:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.customDialGetBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeCustomDialGet repeats:YES];
}

+ (void)getMenstrualCycle:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.menstrualCycleGetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_GIRL_CARE opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeMenstrualCycleGet repeats:YES];
    }
}


#pragma mark - 设置类

+ (void)setBind:(DHBindSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!model.userId.length) {
        if (block) {
            block(DHCommandCodeFailed, DHCommandMsgDataError);
        }
        return;
    }
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.bindSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        model.userIDJL = 0x1234;
        [manager sendCommand:BLE_COMMAND_CONNECT keyType:BLE_KEY_IDENTITY opType:BLE_KEY_FLAG_CREATE value:[model valueWithJL]];
    }
    else{
        NSData *userIdData = [model.userId dataUsingEncoding:NSUTF16LittleEndianStringEncoding];
        NSString *payload = [NSString stringWithFormat:@"%02lx%@",(long)model.bindOS,DHDecimalString(userIdData)];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeBindSet repeats:YES];
    }
}

+ (void)setTime:(DHTimeSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.timeSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_TIME opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%04lx%02lx%02lx%02lx%02lx%02lx",(long)model.year,(long)model.month,(long)model.day,(long)model.hour,(long)model.minute,(long)model.second];
        NSLog(@"setTime payload %@", payload);
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeTimeSet repeats:YES];
    }
}

+ (void)setAncs:(DHAncsSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.ancsSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_NOTIFICATION_REMINDER opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [DHTool transformAncs:model];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeAncsSet repeats:YES];
    }
}

+ (void)setUnit:(DHUnitSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.unitSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)model.language,(long)model.distanceUnit,(long)model.tempUnit,(long)model.timeformat];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeUnitSet repeats:YES];
    }
}

+ (void)setSedentary:(DHSedentarySetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.sedentarySetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_SEDENTARINESS opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSInteger repeats = [DHTool transformRepeats:model.repeats];
        NSString *payload = [NSString stringWithFormat:@"%02lx%04lx%02lx%02lx%02lx%02lx%02lx",(long)model.isOpen,(long)model.interval,(long)repeats,(long)model.startHour,(long)model.startMinute,(long)model.endHour,(long)model.endMinute];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeSedentarySet repeats:YES];
    }
}

+ (void)setDrinking:(DHDrinkingSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.drinkingSetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_DRINK_WATER_SITE opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx%04lx%02lx%02lx%02lx%02lx",(long)model.isOpen,(long)model.interval,(long)model.startHour,(long)model.startMinute,(long)model.endHour,(long)model.endMinute];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeDrinkingSet repeats:YES];
    }
}

+ (void)setReminderMode:(DHReminderModeSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.reminderModeSetBlock = block;
    }
    NSString *payload = [NSString stringWithFormat:@"%02lx",(long)model.reminderMode];
    [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeReminderModeSet repeats:YES];
}

+ (void)addJLAlarm:(DHAlarmSetModel *)alarm block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.alarmSetBlock = block;
    }
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_ALARM opType:BLE_KEY_FLAG_CREATE value:[alarm valueWithJL]];
}

+ (void)updateJLAlarm:(DHAlarmSetModel *)alarm block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.alarmSetBlock = block;
    }
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_ALARM opType:BLE_KEY_FLAG_UPDATE value:[alarm valueWithJL]];
}

+ (void)deleteJLAlarm:(DHAlarmSetModel *)alarm block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.alarmSetBlock = block;
    }
    UInt8 tAlarmId = alarm.jlAlarmId;
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_ALARM opType:BLE_KEY_FLAG_DELETE value:[NSData dataWithBytes:&tAlarmId length:1]];
}

+ (void)setPrayAlarms:(NSArray <DHPrayAlarmSetModel *> *)alarms block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.prayAlarmSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        NSMutableData *tPayloadData = [NSMutableData data];
        for (DHPrayAlarmSetModel *model in alarms) {
            [tPayloadData appendData:[model valueWithJL]];
        }
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_APP_PRAYER_TIME_SYNC opType:BLE_KEY_FLAG_UPDATE value:tPayloadData];
    }
    else{
        NSMutableString *payload = [NSMutableString stringWithFormat:@"%02lx",(long)alarms.count];
        if (alarms.count == 0) {
            [manager sendCommandWithPayload:payload writeType:DHBleCommandTypePrayAlarmSet repeats:YES];
        } else {
            for (DHPrayAlarmSetModel *model in alarms) {
                NSString *item = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx", (long)model.alarmType, (long)model.isOpen, (long)model.hour, (long)model.minute];
                [payload appendString:item];
            }
            
            NSData *tData = DHHexToBytes(payload);
            [manager sendCommandWithData:tData writeType:DHBleCommandTypePrayAlarmSet repeats:YES];
        }
    }
}

+ (void)setAlarms:(NSArray <DHAlarmSetModel *>*)alarms block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.alarmSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        if (alarms.count == 0) {
            UInt8 tAlarmId = 0xff;
            [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_ALARM opType:BLE_KEY_FLAG_DELETE value:[NSData dataWithBytes:&tAlarmId length:1]];
        }
        else{
            NSMutableData *tAlarmData = [NSMutableData data];
            for (DHAlarmSetModel *tAlarm in alarms){
                [tAlarmData appendData:[tAlarm valueWithJL]];
            }
            [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_ALARM opType:BLE_KEY_FLAG_UPDATE value:tAlarmData];
        }
    }
    else{
        NSMutableString * payload = [NSMutableString stringWithFormat:@"%02lx",(long)alarms.count];
        if (alarms.count == 0) {
            [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeAlarmSet repeats:YES];
        } else {
            for (DHAlarmSetModel *model in alarms) {
                NSString *item;
                if (model.alarmType.length) {
                    NSData *alarmTypeData = [model.alarmType dataUsingEncoding:NSUTF8StringEncoding];
                    NSInteger repeats = [DHTool transformRepeats:model.repeats];
                    item = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx%02lx%02lx%@",(long)model.isOpen,(long)model.hour,(long)model.minute,(long)repeats,(long)model.isRemindLater,(long)(alarmTypeData.length),DHDecimalString(alarmTypeData)];
                } else {
                    NSInteger repeats = [DHTool transformRepeats:model.repeats];
                    item = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx%02lx%02lx",(long)model.isOpen,(long)model.hour,(long)model.minute,(long)repeats,(long)model.isRemindLater,(long)0];
                }
                [payload appendString:item];
            }
            
            NSData *data = DHHexToBytes(payload);
            if (data.length <= manager.onePackageLength-8) {
                [manager sendCommandWithData:data writeType:DHBleCommandTypeAlarmSet repeats:YES];
            } else {
                NSInteger maxLength = manager.onePackageLength-12;
                NSInteger count = ceil(1.0*data.length/maxLength);
                for (int i = 0; i < count; i++) {
                    NSData *subData;
                    if (i == count-1) {
                        subData = [data subdataWithRange:NSMakeRange(i*maxLength, data.length-i*maxLength)];
                    } else {
                        subData = [data subdataWithRange:NSMakeRange(i*maxLength, maxLength)];
                    }
                    [manager sendCommandWithData:subData index:i+1 count:count writeType:DHBleCommandTypeAlarmSet repeats:YES];
                }
            }
        }
    }
}

+ (void)setGesture:(DHGestureSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.gestureSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_GESTURE_WAKE opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx%02lx",(long)model.isOpen,(long)model.startHour,(long)model.startMinute,(long)model.endHour,(long)model.endMinute];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeGestureSet repeats:YES];
    }
}

+ (void)setBrightTime:(DHBrightTimeSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.brightTimeSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_BACK_LIGHT opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx",(long)model.duration];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeBrightTimeSet repeats:YES];
    }
}

+ (void)setHeartRateMode:(DHHeartRateModeSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.heartRateModeSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_HR_MONITORING opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx%04lx%02lx%02lx%02lx%02lx",(long)model.isOpen,(long)model.interval,(long)model.startHour,(long)model.startMinute,(long)model.endHour,(long)model.endMinute];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeHeartRateModeSet repeats:YES];
    }
}

+ (void)setDisturbMode:(DHDisturbModeSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.disturbModeSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_NO_DISTURB_RANGE opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx%02lx%02lx",(long)model.isOpen,(long)model.isAllday,(long)model.startHour,(long)model.startMinute,(long)model.endHour,(long)model.endMinute];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeDisturbModeSet repeats:YES];
    }
}

+ (void)setContacts:(NSArray <DHContactSetModel *>*)contacts block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.contactSetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        if (contacts.count > 0){
            NSMutableData *tContactData = [NSMutableData dataWithCapacity:0];
            for (DHContactSetModel *tModel in contacts){
                [tContactData appendData:[tModel valueWithJL]];
            }
            manager.dialSyncDataLen = (UInt32)tContactData.length;
            [manager sendFileData:tContactData fileIndex:0 key:BLE_KEY_CONTACT];
        }
        else{ //调删除
            UInt8 tDeleteType = 1;
            [manager sendCommand:BLE_COMMAND_IO keyType:BLE_KEY_CONTACT opType:BLE_KEY_FLAG_DELETE value:[NSData dataWithBytes:&tDeleteType length:1]];
        }
    }
    else{
        NSMutableString *payload = [NSMutableString stringWithFormat:@"%02lx",(long)contacts.count];
        if (contacts.count == 0) {
            [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeContactSet repeats:YES];
        } else {
            for (DHContactSetModel *model in contacts) {
                NSData *nameData = [model.name dataUsingEncoding:NSUTF8StringEncoding];
                NSData *mobileData = [model.mobile dataUsingEncoding:NSUTF8StringEncoding];
                NSString *item = [NSString stringWithFormat:@"%02lx%@%02lx%@",(long)(nameData.length),DHDecimalString(nameData),(long)(mobileData.length),DHDecimalString(mobileData)];
                [payload appendString:item];
            }
            
            NSData *data = DHHexToBytes(payload);
            if (data.length <= manager.onePackageLength-8) {
                [manager sendCommandWithData:data writeType:DHBleCommandTypeContactSet repeats:YES];
            } else {
                NSInteger maxLength = manager.onePackageLength-12;
                NSInteger count = ceil(1.0*data.length/maxLength);
                for (int i = 0; i < count; i++) {
                    NSData *subData;
                    if (i == count-1) {
                        subData = [data subdataWithRange:NSMakeRange(i*maxLength, data.length-i*maxLength)];
                    } else {
                        subData = [data subdataWithRange:NSMakeRange(i*maxLength, maxLength)];
                    }
                    [manager sendCommandWithData:subData index:i+1 count:count writeType:DHBleCommandTypeContactSet repeats:YES];
                }
            }
        }
    }
}

+ (void)setUserInfo:(DHUserInfoSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.userInfoSetBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_USER_PROFILE opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
        //杰里平台协议,计步目标单独指令设置
        [self setJLUserInfoWithStepTarget:(UInt32)model.stepGoal block:^(int code, id  _Nonnull data) {
            
        }];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx%02lx%04lx%04lx%04lx",(long)model.gender,(long)model.age,(long)model.height,(long)model.weight,(long)model.stepGoal];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeUserInfoSet repeats:YES];
    }
}

+ (void)setQRCode:(DHQRCodeSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!model.title.length || !model.url.length) {
        if (block) {
            block(DHCommandCodeFailed, DHCommandMsgDataError);
        }
        return;
    }
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.qrCodeSetBlock = block;
    }
    NSData *titleData = [model.title dataUsingEncoding:NSUTF8StringEncoding];
    NSData *contentData = [model.url dataUsingEncoding:NSUTF8StringEncoding];
    NSString *payload = [NSString stringWithFormat:@"%02lx%02lx%@%04lx%@",(long)model.appType,(long)titleData.length,DHDecimalString(titleData),(long)contentData.length,DHDecimalString(contentData)];
    NSData *data = DHHexToBytes(payload);
    if (data.length <= manager.onePackageLength-8) {
        [manager sendCommandWithData:data writeType:DHBleCommandTypeQRCodeSet repeats:YES];
    } else {
        NSInteger maxLength = manager.onePackageLength-12;
        NSInteger count = ceil(1.0*data.length/maxLength);
        for (int i = 0; i < count; i++) {
            NSData *subData;
            if (i == count-1) {
                subData = [data subdataWithRange:NSMakeRange(i*maxLength, data.length-i*maxLength)];
            } else {
                subData = [data subdataWithRange:NSMakeRange(i*maxLength, maxLength)];
            }
            [manager sendCommandWithData:subData index:i+1 count:count writeType:DHBleCommandTypeQRCodeSet repeats:YES];
        }
    }
}

+ (void)setSportGoal:(DHSportGoalSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic || [DHBleCentralManager isJLProtocol]) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.sportGoalSetBlock = block;
    }
    NSString *payload = [NSString stringWithFormat:@"%04lx%04lx%04lx",(long)model.duration,(long)model.calorie,(long)model.distance];
    [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeSportGoalSet repeats:YES];
}

+ (void)setWeathers:(NSArray <DHWeatherSetModel *>*)weathers block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.weatherSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        NSMutableData *tWeatherData = [NSMutableData data];
        DHWeatherSetModel *tTodayWeatherData = weathers.firstObject;
        
        DeviceFuncModel *funcModel = [DeviceFuncModel currentModel];
        if (funcModel.isJLWeather2){
            [manager sendCommand:BLE_COMMAND_PUSH keyType:BLE_KEY_WEATHER_REALTIME2 opType:BLE_KEY_FLAG_UPDATE value:[tTodayWeatherData valueWithTodayJL2]];
        }
        else{
            [manager sendCommand:BLE_COMMAND_PUSH keyType:BLE_KEY_WEATHER_REALTIME opType:BLE_KEY_FLAG_UPDATE value:[tTodayWeatherData valueWithTodayJL]];
        }
        
        int j = 0;
        if (funcModel.isJLWeather2){
            for (DHWeatherSetModel *tWeather in weathers){
                if (j == 0){
                    [tWeatherData appendData:[tWeather valueWithTodayJL2]];
                }
                else{
                    [tWeatherData appendData:[tWeather valueWithJL2]];
                }
                j++;
            }
            [manager sendCommand:BLE_COMMAND_PUSH keyType:BLE_KEY_WEATHER_FORECAST2 opType:BLE_KEY_FLAG_UPDATE value:tWeatherData];
        }
        else{
            for (DHWeatherSetModel *tWeather in weathers){
                if (j == 0){
                    [tWeatherData appendData:[tWeather valueWithTodayJL]];
                }
                else{
                    [tWeatherData appendData:[tWeather valueWithJL]];
                }
                j++;
            }
            [manager sendCommand:BLE_COMMAND_PUSH keyType:BLE_KEY_WEATHER_FORECAST opType:BLE_KEY_FLAG_UPDATE value:tWeatherData];
        }
    }
    else{
        int tWeatherCount = 3;
        NSMutableString *payload = [NSMutableString stringWithFormat:@"%02lx", tWeatherCount];
        for (int i = 0; i < tWeatherCount; i++) {//瑞昱只能同步3天的
            DHWeatherSetModel *model = weathers[i];
            [payload appendFormat:@"%02lx%02lx%02lx%02lx",(long)model.weatherType,(long)model.maxTemp,(long)model.minTemp,(long)model.currentTemp];
        }
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeWeatherSet repeats:YES];
    }
}

+ (void)setBreath:(DHBreathSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (model.times != model.hourArray.count || model.hourArray.count != model.minuteArray.count || model.times == 0) {
        if (block) {
            block(DHCommandCodeFailed, DHCommandMsgDataError);
        }
        return;
    }
    if (!manager.peripheral || !manager.writeCharacteristic || [DHBleCentralManager isJLProtocol]) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.breathSetBlock = block;
    }
    NSMutableString * payload = [NSMutableString stringWithFormat:@"%02lx%02lx",(long)model.isOpen,(long)model.times];
    for (int i = 0; i < model.times; i++) {
        [payload appendFormat:@"%02lx%02lx",(long)[model.hourArray[i] integerValue],(long)[model.minuteArray[i] integerValue]];
    }
    
    [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeBreathSet repeats:YES];
}

+ (void)setMenstrualCycle:(DHMenstrualCycleSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.menstrualCycleSetBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_GIRL_CARE opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx%02lx%02lx%02lx%02lx%08lx%02lx%02lx",(long)model.type,(long)model.isOpen,(long)model.isRemindMenstrualPeriod,(long)model.isRemindOvulationPeriod,(long)model.isRemindOvulationPeriod,(long)model.isRemindOvulationEnd,(long)model.cycleDays,(long)model.menstrualDays,(long)model.timestamp+DHTimeInterval,(long)model.remindHour,(long)model.remindMinute];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeMenstrualCycleSet repeats:YES];
    }
}

+ (void)setLocation:(DHLocationSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.locationSetBlock = block;
    }
    
    NSData *locationData = [model.locationStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *payload = [NSString stringWithFormat:@"%08lx%08lx%02lx%@",(long)model.longitude,(long)model.latitude,(long)locationData.length,DHDecimalString(locationData)];
    NSData *data = DHHexToBytes(payload);
    [manager sendCommandWithData:data writeType:DHBleCommandTypeLocationSet repeats:YES];
}

+ (void)setJLTimeZone:(UInt8)timezone block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.timeSetBlock = block;
    }
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_TIME_ZONE opType:BLE_KEY_FLAG_UPDATE value:[NSData dataWithBytes:&timezone length:1]];
}

///0: 24小时制 1:12小时制
+ (void)setJLTimeformat:(UInt8)timeformat block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.unitSetBlock = block;
    }
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_HOUR_SYSTEM opType:BLE_KEY_FLAG_UPDATE value:[NSData dataWithBytes:&timeformat length:1]];
}

+ (void)setJLLanguage:(UInt8)language block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.unitSetBlock = block;
    }
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_LANGUAGE opType:BLE_KEY_FLAG_UPDATE value:[NSData dataWithBytes:&language length:1]];
}

///distanceUnit 0: 公制 1: 英制
+ (void)setJLDistanceUnit:(UInt8)distanceUnit block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.unitSetBlock = block;
    }
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_UNIT opType:BLE_KEY_FLAG_UPDATE value:[NSData dataWithBytes:&distanceUnit length:1]];
}
//tempUnit 0: 摄氏度 1: 华氏度
+ (void)setJLTempUnit:(UInt8)tempUnit block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.unitSetBlock = block;
    }
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_TEMPERATURE_UNIT opType:BLE_KEY_FLAG_UPDATE value:[NSData dataWithBytes:&tempUnit length:1]];
}

+ (void)setJLUserInfoWithStepTarget:(UInt32)stepTarget block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.userInfoSetBlock = block;
    }
    stepTarget = htonl(stepTarget);
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_STEP_GOAL opType:BLE_KEY_FLAG_UPDATE value:[NSData dataWithBytes:&stepTarget length:4]];
}

+ (void)setJLMuslimAngle:(int16_t)angle lat:(double)lat lon:(double)lon china:(Boolean)isChina block:(void(^)(int code, id data))block
{
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.userInfoSetBlock = block;
    }
    UInt8 tMuslimOn = 0;
    tMuslimOn = isChina ? 0 : 1;
    NSLog(@"setJLMuslimAngle lat %.6lf lon %.6lf angle %d tMuslimOn %d", lat, lon, angle, tMuslimOn);
    NSMutableData *tSendData = [NSMutableData dataWithCapacity:0];
    [tSendData appendBytes:&angle length:2];
    [tSendData appendBytes:&lat length:8];
    [tSendData appendBytes:&lon length:8];
    [tSendData appendBytes:&tMuslimOn length:1];
    
    [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_WORSHIP_ANGLE opType:BLE_KEY_FLAG_UPDATE value:tSendData];
}



#pragma mark - 控制类

+ (void)controlCamera:(NSInteger)type block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.cameraControlBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_CONTROL keyType:BLE_KEY_CAMERA opType:BLE_KEY_FLAG_UPDATE value:[NSData dataWithBytes:&type length:1]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx",(long)type];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeCameraControl repeats:YES];
    }
}

+ (void)controlFindDeviceBegin:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.findDeviceControlBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
//        NSLog(@"杰里协议不支持找设备!");
        Byte tFindDev = 1;
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_FIND_WATCH opType:BLE_KEY_FLAG_UPDATE value:[NSData dataWithBytes:&tFindDev length:1]];

    }
    else{
        [manager sendCommand:DHBleCommandTypeFindDeviceBeginControl repeats:YES];
    }
}

+ (void)controlFindPhoneEnd:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.findPhoneControlBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_FIND_PHONE opType:BLE_KEY_FLAG_UPDATE value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeFindPhoneEndControl repeats:YES];
    }
}

+ (void)controlDevice:(NSInteger)type block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.deviceControlBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_SHUT_DOWN opType:BLE_KEY_FLAG_UPDATE value:[NSData dataWithBytes:&type length:1]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx",(long)type];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeDeviceControl repeats:YES];
    }
}

+ (void)controlUnbind:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.unbindBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        UInt8 tValueByte = 0;
        [manager sendCommand:BLE_COMMAND_CONNECT keyType:BLE_KEY_IDENTITY opType:BLE_KEY_FLAG_DELETE value:[NSData dataWithBytes:&tValueByte length:1]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeUnbindControl repeats:YES];
    }
}

+ (void)controlSport:(DHSportControlModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.sportControlBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_CONTROL keyType:BLE_KEY_APP_WORKOUT_CONTROL opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx%02lx", (long)model.controlType, (long)model.sportType];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeSportControl repeats:NO];
    }
}

+ (void)controlSportData:(DHSportDataSetModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.sportDataControlBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_SET keyType:BLE_KEY_APP_WORKOUT_DATA opType:BLE_KEY_FLAG_UPDATE value:[model valueWithJL]];
    }
    else{
        NSString *payload = [NSString stringWithFormat:@"%02lx%04lx%04lx%04lx%06lx%04lx%04lx%04lx%08lx%02lx",(long)model.isStop,(long)model.duration,(long)model.step,(long)model.distance,(long)model.calorie,(long)model.metricPace,(long)model.imperialPace,(long)model.strideFrequency,(long)model.timestamp+DHTimeInterval,(long)model.isMap];
        [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeSportDataControl repeats:NO];
    }
}

+ (void)controlAppStatus:(BOOL)isActive block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.appstatusControlBlock = block;
    }
    NSString *payload = [NSString stringWithFormat:@"%02lx",(long)isActive];
    [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeAppStatusControl repeats:NO];
}

#pragma mark - 表盘传输类

+ (void)fileSyncingStart:(DHFileSyncingModel *)model block:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    
    if (block) {
        manager.fileSyncingStartBlock = block;
    }
    
    manager.connectInterval = 0.1;
    if (model.fileType == 2) {
        //轨迹
        if (model.fileData) {
            NSData *contentData = [DHTool transformCustomDialData:model.fileData];
            model.fileSize = contentData.length;
        }
    } else if (model.fileType == 3) {
        //自定义表盘
        model.fileType = 0;
        if (model.fileData) {
            NSData *contentData = [DHTool transformCustomDialData:model.fileData];
            model.fileSize = contentData.length+12;
        }
    } else if (model.fileType == 4) {
        //缩略图
        model.fileType = 3;
        if (model.fileData) {
            NSData *contentData = [DHTool transformCustomDialData:model.fileData];
            model.fileSize = contentData.length+9;
        }
    }
    NSString *payload = [NSString stringWithFormat:@"%02lx%08lx",(long)model.fileType,(long)model.fileSize];
    [manager sendCommandWithPayload:payload writeType:DHBleCommandTypeFileSyncingStart repeats:NO];
    
}

+ (void)startDialSyncing:(NSData *)fileData block:(void(^)(int code, CGFloat progress, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDisconnected);
        }
        return;
    }
    if (!fileData || fileData.length <= 0) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDataError);
        }
        return;
    }
    
    if (block) {
        manager.dialSyncingBlock = block;
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        NSMutableArray *fileSyncArray = [NSMutableArray array];
        NSInteger fileSize = fileData.length;
        NSInteger itemSize = 1024;
        NSInteger fileCount = ceil(1.0*fileSize/itemSize);
        
        for (int i = 0; i < fileCount; i++) {
            NSMutableData *itemData = [NSMutableData dataWithCapacity:0];
            if (i == fileCount-1) {
                [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, fileSize-i*itemSize)]];
            } else {
                [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, itemSize)]];
            }
            [fileSyncArray addObject:itemData];
        }
        manager.dialSyncDataIndex = 0;
        manager.dialSyncIndex = 0;
        manager.dialSyncProgress = 0;
        manager.dialSyncCount = fileSyncArray.count;
        manager.dialSyncArray = [NSMutableArray arrayWithArray:fileSyncArray];
        manager.dialSyncDataLen = (UInt32)fileSize;
        
        manager.isDialSyncing = YES;
        [manager jlStartSendDialData:BLE_KEY_WATCH_FACE];
    }
    else{
        NSMutableArray *fileSyncArray = [NSMutableArray array];
        NSInteger fileSize = fileData.length;
        NSInteger itemSize = manager.onePackageLength-25;
        NSInteger fileCount = ceil(1.0*fileSize/itemSize);
        
        NSString *command = [NSString stringWithFormat:@"%02lx",(long)3];
        NSString *fileSizeStr = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(fileSize & 0xFF),(long)(fileSize >> 8 & 0xFF),(long)(fileSize >> 16 & 0xFF),(long)(fileSize >> 24 & 0xFF)];
        NSString *pos;
        NSString *header;
        for (int i = 0; i < fileCount; i++) {
            pos = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(i*itemSize & 0xFF),(long)(i*itemSize >> 8 & 0xFF),(long)(i*itemSize >> 16 & 0xFF),(long)(i*itemSize >> 24 & 0xFF)];
            header = [NSString stringWithFormat:@"%@%@%@",command,fileSizeStr,pos];
            
            NSMutableData *itemData = [NSMutableData dataWithData:DHHexToBytes(header)];
            if (i == fileCount-1) {
                [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, fileSize-i*itemSize)]];
            } else {
                [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, itemSize)]];
            }
            [fileSyncArray addObject:itemData];
        }
        
        manager.dialSyncIndex = 0;
        manager.dialSyncProgress = 0;
        manager.dialSyncCount = fileSyncArray.count;
        manager.dialSyncArray = [NSMutableArray arrayWithArray:fileSyncArray];
        
        manager.isDialSyncing = YES;
        [manager startSendDialData];
    }
}

+ (void)startCustomDialSyncing:(DHCustomDialSyncingModel *)model block:(void(^)(int code, CGFloat progress, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDisconnected);
        }
        return;
    }
    if (model.imageType == 2 && (!model.fileData || model.fileData.length <= 0)) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDataError);
        }
        return;
    }
    
    if (block) {
        manager.dialSyncingBlock = block;
    }
    
    NSInteger fileSize = 8;
    NSInteger timeUp = [DHTool appElementToDevice:model.timeUp];
    NSInteger timeDown = [DHTool appElementToDevice:model.timeDown];
    if (model.imageType != 2) {
        NSString *dialFormat = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx%02lx%02lx%02lx%02lx",(long)model.timePos,(long)timeUp,(long)timeDown,(long)(model.textColor & 0xFF),(long)(model.textColor >> 8 & 0xFF),(long)(model.textColor >> 16 & 0xFF),(long)0xFF,(long)model.imageType];
        
        NSString *command = [NSString stringWithFormat:@"%02lx", (long)2];
        NSString *fileSizeStr = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(fileSize & 0xFF),(long)(fileSize >> 8 & 0xFF),(long)(fileSize >> 16 & 0xFF),(long)(fileSize >> 24 & 0xFF)];
        NSString *pos = @"00000000";
        NSString *header = [NSString stringWithFormat:@"%@%@%@",command,fileSizeStr,pos];
        NSString *payload = [NSString stringWithFormat:@"%@%@",header,dialFormat];
        
        [manager startCustomDialSyncing:payload];
        return;
    }
    
    NSString *dialFormat = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx%02lx%02lx%02lx%02lx%02lx%02lx%02lx%02lx",(long)model.timePos,(long)timeUp,(long)timeDown,(long)(model.textColor & 0xFF),(long)(model.textColor >> 8 & 0xFF),(long)(model.textColor >> 16 & 0xFF),(long)0xFF,(long)model.imageType,(long)(model.imageWidth & 0xFF),(long)(model.imageWidth >> 8 & 0xFF),(long)(model.imageHeight & 0xFF),(long)(model.imageHeight >> 8 & 0xFF)];
    
    NSData *dialFormatData = DHHexToBytes(dialFormat);
    NSMutableData *fileData = [NSMutableData dataWithData:dialFormatData];
    
    NSData *contentData = [DHTool transformCustomDialDataWithAlpha:model.fileData];
    [fileData appendData:contentData];
    
    fileSize = fileData.length;
    
    NSMutableArray *fileSyncArray = [NSMutableArray array];
    NSInteger itemSize = manager.onePackageLength-25;
    NSInteger fileCount = ceil(1.0*fileSize/itemSize);
    
    NSString *command = [NSString stringWithFormat:@"%02lx",(long)2];
    NSString *fileSizeStr = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(fileSize & 0xFF),(long)(fileSize >> 8 & 0xFF),(long)(fileSize >> 16 & 0xFF),(long)(fileSize >> 24 & 0xFF)];
    NSString *pos;
    NSString *header;
    for (int i = 0; i < fileCount; i++) {
        pos = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(i*itemSize & 0xFF),(long)(i*itemSize >> 8 & 0xFF),(long)(i*itemSize >> 16 & 0xFF),(long)(i*itemSize >> 24 & 0xFF)];
        header = [NSString stringWithFormat:@"%@%@%@",command,fileSizeStr,pos];
        
        NSMutableData *itemData = [NSMutableData dataWithData:DHHexToBytes(header)];
        if (i == fileCount-1) {
            [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, fileSize-i*itemSize)]];
        } else {
            [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, itemSize)]];
        }
        [fileSyncArray addObject:itemData];
    }
    
    manager.dialSyncIndex = 0;
    manager.dialSyncProgress = 0;
    manager.dialSyncCount = fileSyncArray.count;
    manager.dialSyncArray = [NSMutableArray arrayWithArray:fileSyncArray];
    manager.isDialSyncing = YES;
    [manager startSendDialData];
}

#pragma mark - 文件传输类

+ (void)startFileSyncing:(NSData *)fileData block:(void(^)(int code, CGFloat progress, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDisconnected);
        }
        return;
    }
    if (!fileData || fileData.length <= 0) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDataError);
        }
        return;
    }
    
    if (block) {
        manager.fileSyncingBlock = block;
    }
    
    NSMutableArray *fileSyncArray = [NSMutableArray array];
    NSInteger fileSize = fileData.length;
    NSInteger itemSize = manager.onePackageLength-25;
    NSInteger fileCount = ceil(1.0*fileSize/itemSize);
    
    NSString *crc16 = [NSString stringWithFormat:@"%02lx%02lx",(long)(100 & 0xFF),(long)(100 >> 8 & 0xFF)];
    NSString *fileSizeStr = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(fileSize & 0xFF),(long)(fileSize >> 8 & 0xFF),(long)(fileSize >> 16 & 0xFF),(long)(fileSize >> 24 & 0xFF)];
    NSString *pos;
    NSString *header;
    for (int i = 0; i < fileCount; i++) {
        pos = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(i*itemSize & 0xFF),(long)(i*itemSize >> 8 & 0xFF),(long)(i*itemSize >> 16 & 0xFF),(long)(i*itemSize >> 24 & 0xFF)];
        header = [NSString stringWithFormat:@"%@%@%@",crc16,fileSizeStr,pos];
        
        NSMutableData *itemData = [NSMutableData dataWithData:DHHexToBytes(header)];
        if (i == fileCount-1) {
            [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, fileSize-i*itemSize)]];
        } else {
            [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, itemSize)]];
        }
        [fileSyncArray addObject:itemData];
    }
    
    manager.fileSyncIndex = 0;
    manager.fileSyncProgress = 0;
    manager.fileSyncCount = fileSyncArray.count;
    manager.fileSyncArray = [NSMutableArray arrayWithArray:fileSyncArray];
    
    manager.isFileSyncing = YES;
    [manager startSendFileData];
}

+ (void)startUIFileSyncing:(NSData *)fileData bleKey:(BleKey)bleKey block:(void(^)(int code, CGFloat progress, id data))block
{
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDisconnected);
        }
        return;
    }
    if (!fileData || fileData.length <= 0) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDataError);
        }
        return;
    }
    
    if (block) {
        manager.dialSyncingBlock = block;
    }
    
    NSMutableArray *fileSyncArray = [NSMutableArray array];
    NSInteger fileSize = fileData.length;
    NSInteger itemSize = 2048;
    NSInteger fileCount = ceil(1.0*fileSize/itemSize);
    
    for (int i = 0; i < fileCount; i++) {
        NSMutableData *itemData = [NSMutableData dataWithCapacity:0];
        if (i == fileCount-1) {
            [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, fileSize-i*itemSize)]];
        } else {
            [itemData appendData:[fileData subdataWithRange:NSMakeRange(i*itemSize, itemSize)]];
        }
        [fileSyncArray addObject:itemData];
    }
    manager.dialSyncDataIndex = 0;
    manager.dialSyncIndex = 0;
    manager.dialSyncProgress = 0;
    manager.dialSyncCount = fileSyncArray.count;
    manager.dialSyncArray = [NSMutableArray arrayWithArray:fileSyncArray];
    manager.dialSyncDataLen = (UInt32)fileSize;
    
    manager.isDialSyncing = YES;
    [manager jlStartSendUIData:bleKey];
}

#pragma mark - 轨迹同步类

+ (void)startMapSyncing:(NSData *)fileData block:(void(^)(int code, CGFloat progress, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDisconnected);
        }
        return;
    }
    if (!fileData || fileData.length <= 0) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDataError);
        }
        return;
    }
    
    if (block) {
        manager.mapSyncingBlock = block;
    }
    
    NSData *contentData = [DHTool transformCustomDialData:fileData];
    
    NSMutableArray *fileSyncArray = [NSMutableArray array];
    NSInteger fileSize = contentData.length;
    NSInteger itemSize = manager.onePackageLength-25;
    NSInteger fileCount = ceil(1.0*fileSize/itemSize);
    
    NSString *fileSizeStr = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(fileSize & 0xFF),(long)(fileSize >> 8 & 0xFF),(long)(fileSize >> 16 & 0xFF),(long)(fileSize >> 24 & 0xFF)];
    NSString *pos;
    NSString *header;
    for (int i = 0; i < fileCount; i++) {
        pos = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(i*itemSize & 0xFF),(long)(i*itemSize >> 8 & 0xFF),(long)(i*itemSize >> 16 & 0xFF),(long)(i*itemSize >> 24 & 0xFF)];
        header = [NSString stringWithFormat:@"%@%@",fileSizeStr,pos];
        
        NSMutableData *itemData = [NSMutableData dataWithData:DHHexToBytes(header)];
        if (i == fileCount-1) {
            [itemData appendData:[contentData subdataWithRange:NSMakeRange(i*itemSize, fileSize-i*itemSize)]];
        } else {
            [itemData appendData:[contentData subdataWithRange:NSMakeRange(i*itemSize, itemSize)]];
        }
        [fileSyncArray addObject:itemData];
    }
    
    manager.mapSyncIndex = 0;
    manager.mapSyncProgress = 0;
    manager.mapSyncCount = fileSyncArray.count;
    manager.mapSyncArray = [NSMutableArray arrayWithArray:fileSyncArray];
    
    manager.isMapSyncing = YES;
    [manager startSendMapData];
}

#pragma mark - 缩略图同步类

/// 缩略图同步
/// @param fileData 模型
/// @param block 回调
+ (void)startThumbnailSyncing:(NSData *)fileData customDial:(BOOL)isCustomDial block:(void(^)(int code, CGFloat progress, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDisconnected);
        }
        return;
    }
    if (!fileData || fileData.length <= 0) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDataError);
        }
        return;
    }
    
    if (block) {
        manager.thumbnailSyncingBlock = block;
    }
    
    NSData *contentData = [DHTool transformCustomDialData:fileData];
    
    NSMutableArray *fileSyncArray = [NSMutableArray array];
    NSInteger fileSize = contentData.length;
    NSInteger itemSize = manager.onePackageLength-25;
    NSInteger fileCount = ceil(1.0*fileSize/itemSize);
    
    NSString *command = isCustomDial ? [NSString stringWithFormat:@"%02lx",(long)2] : [NSString stringWithFormat:@"%02lx",(long)3];
    NSString *fileSizeStr = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(fileSize & 0xFF),(long)(fileSize >> 8 & 0xFF),(long)(fileSize >> 16 & 0xFF),(long)(fileSize >> 24 & 0xFF)];
    NSString *pos;
    NSString *header;
    for (int i = 0; i < fileCount; i++) {
        pos = [NSString stringWithFormat:@"%02lx%02lx%02lx%02lx",(long)(i*itemSize & 0xFF),(long)(i*itemSize >> 8 & 0xFF),(long)(i*itemSize >> 16 & 0xFF),(long)(i*itemSize >> 24 & 0xFF)];
        header = [NSString stringWithFormat:@"%@%@%@",command,fileSizeStr,pos];
        
        NSMutableData *itemData = [NSMutableData dataWithData:DHHexToBytes(header)];
        if (i == fileCount-1) {
            [itemData appendData:[contentData subdataWithRange:NSMakeRange(i*itemSize, fileSize-i*itemSize)]];
        } else {
            [itemData appendData:[contentData subdataWithRange:NSMakeRange(i*itemSize, itemSize)]];
        }
        [fileSyncArray addObject:itemData];
    }
    
    manager.thumbnailSyncIndex = 0;
    manager.thumbnailSyncProgress = 0;
    manager.thumbnailSyncCount = fileSyncArray.count;
    manager.thumbnailSyncArray = [NSMutableArray arrayWithArray:fileSyncArray];
    
    manager.isThumbnailSyncing = YES;
    [manager startSendThumbnailData];
}


#pragma mark - 同步数据类

+ (void)startDataSyncing:(void(^)(int code, int progress, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            block(DHCommandCodeFailed, 0, DHCommandMsgDisconnected);
        }
        return;
    }
    if (block) {
        manager.dataSyncingBlock = block;
    }
    
    manager.isDataSyncing = YES;
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_ACTIVITY_REALTIME opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeDataSyncing repeats:YES];
    }
}

#pragma mark - 手动同步数据

+ (void)checkDataSyncing:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.checkDataSyncingBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeDataSyncing repeats:YES];
}

+ (void)startStepSyncing:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.stepSyncingBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeStepSyncing repeats:YES];
}

+ (void)startSleepSyncing:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.sleepSyncingBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeSleepSyncing repeats:YES];
}

+ (void)startHeartRateSyncing:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.hrSyncingBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeHeartRateSyncing repeats:YES];
}

+ (void)startBloodPressureSyncing:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.bpSyncingBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeBloodPressureSyncing repeats:YES];
}

+ (void)startBloodOxygenSyncing:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.boSyncingBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeBloodOxygenSyncing repeats:YES];
}

+ (void)startTempSyncing:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.tempSyncingBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeTempSyncing repeats:YES];
}

+ (void)startBreathSyncing:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.breathSyncingBlock = block;
    }
    [manager sendCommand:DHBleCommandTypeBreathSyncing repeats:YES];
}

+ (void)startSportSyncing:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    if (block) {
        manager.sportSyncingBlock = block;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [manager sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_WORKOUT opType:BLE_KEY_FLAG_READ value:[NSData data]];
    }
    else{
        [manager sendCommand:DHBleCommandTypeSportSyncing repeats:YES];
    }
}

+ (void)startLogSyncingJL:(void(^)(int code, id data))block {
    DHBleSendManager *manager = [DHBleSendManager shareInstance];
    if (!manager.peripheral || !manager.writeCharacteristic) {
        if (block) {
            [self callbackFail:block];
        }
        return;
    }
    
    [manager sendCommand:BLE_COMMAND_DATA keyType:BLE_KEY_LOG opType:BLE_KEY_FLAG_READ value:[NSData data]];

}


#pragma mark - 辅助方法

+ (BOOL)classicBluetoothCanOpen {
    NSString * defaultWork = [self getTheDefaultWork];
    NSString * bluetoothMethod = [self getBLUEMethod];
    
    Class LSApplicationWorkspace = NSClassFromString([self getWS]);
    id obj;
    SEL getObj = NSSelectorFromString(defaultWork);
    if ([LSApplicationWorkspace respondsToSelector:getObj]) {
        obj = [LSApplicationWorkspace performSelector:getObj];
    }
    if (obj) {
        SEL openSEL = NSSelectorFromString(bluetoothMethod);
        if ([obj respondsToSelector:openSEL]) {
            return YES;
        }
    }
    return NO;
}

+ (void)classicBluetoothOpen {
    NSString * defaultWork = [self getTheDefaultWork];
    NSString * bluetoothMethod = [self getBLUEMethod];
    NSURL*url=[NSURL URLWithString:[self getUrlString]];
    
    Class LSApplicationWorkspace = NSClassFromString([self getWS]);
    id obj;
    SEL getObj = NSSelectorFromString(defaultWork);
    if ([LSApplicationWorkspace respondsToSelector:getObj]) {
        obj = [LSApplicationWorkspace performSelector:getObj];
    }
    if (obj) {
        SEL openSEL = NSSelectorFromString(bluetoothMethod);
        if ([obj respondsToSelector:openSEL]) {
            [obj performSelector:openSEL withObject:url withObject:nil];
        }
    }
}

+ (NSString *)getWS {
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){
        0x4c, 0x53, 0x41, 0x70, 0x70, 0x6c, 0x69, 0x63, 0x61, 0x74, 0x69,
        0x6f, 0x6e, 0x57, 0x6f, 0x72, 0x6b, 0x73, 0x70, 0x61, 0x63, 0x65
    } length:22];
    
    NSString * ws = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return ws;
}

+ (NSString *)getUrlString {
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x41, 0x70, 0x70, 0x2D, 0x50, 0x72, 0x65, 0x66, 0x73, 0x3A,
        0x72, 0x6f, 0x6f, 0x74, 0x3d, 0x42, 0x6c, 0x75, 0x65, 0x74, 0x6f, 0x6f, 0x74, 0x68
    } length:24];
    NSString * url = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return url;
}

+ (NSString *)getTheDefaultWork{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
    
    NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return method;
}

+ (NSString *) getBLUEMethod{
    
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
    NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
    NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
    NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
    return method;
}

@end
