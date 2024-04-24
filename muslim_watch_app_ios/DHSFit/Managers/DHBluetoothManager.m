//
//  DHBluetoothManager.m
//  DHSFit
//
//  Created by DHS on 2022/10/13.
//

#import "DHBluetoothManager.h"
#import "DHTool.h"
#import "ZCChinaLocation.h"

@implementation DHBluetoothManager

static DHBluetoothManager * _shared = nil;

+ (__kindof DHBluetoothManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    }) ;
    return _shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [DHBluetoothManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [DHBluetoothManager shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [DHBleCentralManager shareInstance].connectDelegate = self;
        [DHBleCentralManager shareInstance].commandDelegate = self;
        
        self.isDataSyncing = NO;
        self.isActive = YES;
        self.isConnected = NO;
        self.isBinded = [DHBleCentralManager isBinded];
        
        DeviceModel *model = [DeviceModel currentModel];
        self.deviceImage = @"device_main_watch";
        
        self.deviceName = self.isBinded ? model.name : Lang(@"str_disconnected");
        self.firmwareVersion = model.firmwareVersion;
        self.deviceModel = model.deviceModel;
        
        self.dialInfoModel = [DialInfoSetModel currentModel];
        self.batteryModel = [[DHBatteryInfoModel alloc] init];
        self.batteryModel.battery = 50;
        
    }
    return self;
}

- (void)initBindedDevice {
    self.isBinded = [DHBleCentralManager isBinded];
    
    DeviceModel *model = [DeviceModel currentModel];
    self.deviceImage = @"device_main_watch";
    
    self.deviceName = self.isBinded ? model.name : Lang(@"str_disconnected");
    self.firmwareVersion = model.firmwareVersion;
    self.deviceModel = model.deviceModel;
    
    self.dialInfoModel = [DialInfoSetModel currentModel];
    self.batteryModel = [[DHBatteryInfoModel alloc] init];
    self.batteryModel.battery = 50;
}

- (void)bindDevice {
    DHBindSetModel *model = [[DHBindSetModel alloc] init];
    model.bindOS = 2;
    model.userId = DHUserId;
    WEAKSELF
    [DHBleCommand setBind:model block:^(int code, id  _Nonnull data) {
        [weakSelf configureDeviceInfo];
    }];
}

- (void)configureDeviceInfo {
    NSLog(@"configureDeviceInfo");
    
    if ([DHBleCentralManager isJLProtocol]){
        [self setJLTimeZone];
        [self setTime];
        [self setJLUnit];
        [self getBleMacAddress];
        
        [self setUserInfo];
        [self getFirmwareVersion];
        [self getBattery];
        [self getFunction];
        
        if ([ConfigureModel shareInstance].latitude.length > 0 && [ConfigureModel shareInstance].longitude.length > 0){
            double tLat = [[ConfigureModel shareInstance].latitude doubleValue];
            double tLon = [[ConfigureModel shareInstance].longitude doubleValue];
            
            BOOL tIsChina = [[ZCChinaLocation shared] isInsideChina:(CLLocationCoordinate2D){tLat, tLon}];
            [self setJLMuslimArgs:tIsChina];
        }
  
        //杰里的延迟1s执行,因为为立即返回,还未getFirmwareVersion获取到devicemodel时已返回
//        [self performSelector:@selector(getDialInfo) withObject:nil afterDelay:1.0];
//        [self getDialInfo];
        
        [self startDataSyncing];
    }
    else{
        [self setTime];
        [self setUnit];
        [self getBleMacAddress];
        [self setUserInfo];
        [self setSportGoal];
        
        //[self setAppStatus];
        
        [self getFirmwareVersion];
        [self getBattery];
        [self getFunction];
        [self getDialInfo];
        [self getCustomDialInfo];
        [self startDataSyncing];
    }
}

- (void)setTime {
    NSLog(@"DHBBluetoothManager setTime");
    DHTimeSetModel *model = [[DHTimeSetModel alloc] init];
    [DHBleCommand setTime:model block:^(int code, id  _Nonnull data) {
        NSLog(@"DHBBluetoothManager setTime code %d", code);
    }];
}

- (void)setUnit {
    DHUnitSetModel *model = [[DHUnitSetModel alloc] init];
    model.language = [LanguageManager shareInstance].languageType;
    model.distanceUnit = [ConfigureModel shareInstance].distanceUnit;
    model.tempUnit = [ConfigureModel shareInstance].tempUnit;
    model.timeformat = [BaseTimeModel isHasAMPM];
    [DHBleCommand setUnit:model block:^(int code, id  _Nonnull data) {
        
    }];
}

- (void)getBleMacAddress{
    [DHBleCommand getMacAddress:^(int code, id  _Nonnull data) {
        if (code == DHCommandCodeSuccessfully){
            DHDeviceInfoModel *tDeviceInfoData = data;
            DeviceModel *model = [DeviceModel currentModel];
            model.macAddr = tDeviceInfoData.macAddr;
            
            [model saveOrUpdate];
            
            [ConfigureModel shareInstance].macAddr = tDeviceInfoData.macAddr;
            [ConfigureModel archiveraModel];
            
            //保存已连接的设备的mac与udid关联, 主要设备ANCS已绑定时无法获取mac地址;
            if (tDeviceInfoData.macAddr && tDeviceInfoData.macAddr.length > 2) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:DHAllBindedMacAddress]) {
                    dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:DHAllBindedMacAddress]];
                }
                [dict setObject:tDeviceInfoData.macAddr forKey:model.uuid];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:DHAllBindedMacAddress];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
        
}

- (void)setJLUnit{
    UInt8 tTimeFormat = 0;
    if ([BaseTimeModel isHasAMPM]){
        tTimeFormat = 1;
    }
    [DHBleCommand setJLTimeformat:tTimeFormat block:^(int code, id  _Nonnull data) {
        
    }];
    UInt8 tJLLanguage = [[LanguageManager shareInstance] getJLLanguageType];
    [DHBleCommand setJLLanguage:tJLLanguage block:^(int code, id  _Nonnull data) {
        
    }];
    UInt8 tDistanceUnit = [ConfigureModel shareInstance].distanceUnit;
    [DHBleCommand setJLDistanceUnit:tDistanceUnit block:^(int code, id  _Nonnull data) {
        
    }];
    UInt8 tTempUnit = [ConfigureModel shareInstance].tempUnit;
    [DHBleCommand setJLTempUnit:tTempUnit block:^(int code, id  _Nonnull data) {
        
    }];
}

- (void)setUserInfo {
    UserModel *model = [UserModel currentModel];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.birthday integerValue]];
    
    DHUserInfoSetModel *userModel = [[DHUserInfoSetModel alloc] init];
    userModel.gender = model.gender;
    userModel.age = [NSDate date].year-date.year;
    userModel.height = model.height;
    userModel.weight = model.weight*10;
    userModel.stepGoal = model.stepGoal;
    [DHBleCommand setUserInfo:userModel block:^(int code, id  _Nonnull data) {
        
    }];
}

- (void)setSportGoal {
    SportGoalSetModel *model = [SportGoalSetModel currentModel];
    
    DHSportGoalSetModel *goalModel = [[DHSportGoalSetModel alloc] init];
    goalModel.duration = model.duration;
    goalModel.calorie = model.calorie;
    goalModel.distance = model.distance;
    [DHBleCommand setSportGoal:goalModel block:^(int code, id  _Nonnull data) {
        
    }];
}

- (void)setAppStatus {
    if (!self.isConnected) {
        return;
    }
    if (self.isDataSyncing) {
        return;
    }
    [DHBleCommand controlAppStatus:self.isActive block:^(int code, id  _Nonnull data) {
        
    }];
}

- (void)getBindInfo {
    
    WEAKSELF
    if ([DHBleCentralManager isJLProtocol]){
        [DHBleCommand getJLBindInfoLogin:^(int code, id  _Nonnull data) {
            if (code == 0) {
                DHBindSetModel *model = data;
                NSLog(@"DHBleCommand getBindInfo %d", model.isBind);
                if (!model.isBind) {
                    [BaseView showDeviceIsRestore];
                    [weakSelf deviceRestore];
                }
                else {
                    [weakSelf configureDeviceInfo];
                }
            } else {
                [weakSelf configureDeviceInfo];
            }
        }];
    }
    else{
        [DHBleCommand getBindInfo:^(int code, id  _Nonnull data) {
            if (code == 0) {
                DHBindSetModel *model = data;
                NSLog(@"DHBleCommand getBindInfo %d", model.isBind);
                if (!model.isBind) {
                    [BaseView showDeviceIsRestore];
                    [weakSelf deviceRestore];
                }
                else {
                    [weakSelf bindDevice];
                }
            } else {
                [weakSelf configureDeviceInfo];
            }
        }];
    }
}

- (void)deviceRestore {
    NSString *macAddr = [DHMacAddr stringByReplacingOccurrencesOfString:@":" withString:@""];
    [DHFile removeLocalImageWithFolderName:DHDialFolder fileName:[NSString stringWithFormat:@"%@.png",macAddr]];
    
    OnlineFirmwareVersionModel *onlineModel = [OnlineFirmwareVersionModel currentModel];
    if (onlineModel.onlineVersion.length) {
        [onlineModel deleteObject];
    }
    
    [DHBleCentralManager setBindedStatus:NO];
    [DHBleCentralManager disconnectDevice];
    
    DeviceModel *model = [DeviceModel currentModel];
    [model deleteObject];
    
    [ConfigureModel shareInstance].macAddr = @"";
    [ConfigureModel archiveraModel];
    
    self.isBinded = NO;
    self.deviceName = Lang(@"str_disconnected");
    self.firmwareVersion = @"";
    self.deviceModel = @"";
    
    self.dialInfoModel = [DialInfoSetModel currentModel];
    self.batteryModel = [[DHBatteryInfoModel alloc] init];
    self.batteryModel.battery = 50;
    
    //自动绑定设备
    [DHNotificationCenter postNotificationName:BluetoothNotificationAutoUnBindDevice object:nil];
}

- (void)getFirmwareVersion {
    WEAKSELF
    [DHBleCommand getFirmwareVersion:^(int code, id  _Nonnull data) {
        if (code == 0) {
            DHFirmwareVersionModel *model = data;
            DeviceModel *deviceModel = [DeviceModel currentModel];
            deviceModel.firmwareVersion = model.firmwareVersion;
            deviceModel.deviceModel = model.deviceModel;
            [deviceModel saveOrUpdate];
            
            weakSelf.firmwareVersion = model.firmwareVersion;
            weakSelf.deviceModel = model.deviceModel;
        }
    }];
}

- (void)getBattery {
    WEAKSELF
    [DHBleCommand getBattery:^(int code, id  _Nonnull data) {
        if (code == 0) {
            weakSelf.batteryModel = data;
            
            [weakSelf getDialInfo]; ////杰里的延迟电量获取完成后执行,因为为立即返回,还未getFirmwareVersion获取到devicemodel时已返回
            //设备信息更新
            [DHNotificationCenter postNotificationName:BluetoothNotificationDeviceInfoChange object:nil];
        }
    }];
}

- (void)getFunction {
    [DHBleCommand getFunction:^(int code, id  _Nonnull data) {
        if (code == 0) {
            DHFunctionInfoModel *model = data;
            DeviceFuncModel *funcModel = [DeviceFuncModel currentModel];
            
            funcModel.isStep = model.isStep;
            funcModel.isSleep = model.isSleep;
            funcModel.isHeartRate = model.isHeartRate;
            funcModel.isBp = model.isBp;
           funcModel.isBo = model.isBo;
            funcModel.isTemp = model.isTemp;
            funcModel.isEcg = model.isEcg;
            funcModel.isBreath = model.isBreath;
            funcModel.isPressure = model.isPressure;
            
            funcModel.isDial = model.isDial;
            funcModel.isWallpaper = model.isWallpaper;
            funcModel.isAncs = model.isAncs;
            funcModel.isSedentary = model.isSedentary;
            funcModel.isDrinking = model.isDrinking;
            funcModel.isReminderMode = model.isReminderMode;
            funcModel.isAlarm = model.isAlarm;
            funcModel.isGesture = model.isGesture;
            
            funcModel.isBrightTime = model.isBrightTime;
            funcModel.isHeartRateMode = model.isHeartRateMode;
            funcModel.isDisturbMode = model.isDisturbMode;
            funcModel.isWeather = model.isWeather;
            funcModel.isContact = model.isContact;
            funcModel.isRestore = model.isRestore;
            funcModel.isOTA = model.isOTA;
            funcModel.isNFC = model.isNFC;
                        
            funcModel.isQRCode = model.isQRCode;
            funcModel.isRestart = model.isRestart;
            funcModel.isShutdown = model.isShutdown;
            funcModel.isBle3 = model.isBle3;
            funcModel.isMenstrualCycle = model.isMenstrualCycle;
            [funcModel saveOrUpdate];
            
            //设备功能表更新
            [DHNotificationCenter postNotificationName:BluetoothNotificationDeviceFunctionChange object:nil];
        }
    }];
}

- (void)getDialInfo {
    WEAKSELF
    [DHBleCommand getDialInfo:^(int code, id  _Nonnull data) {
        if (code == 0) {
            DHDialInfoModel *model = data;
            DialInfoSetModel *dialInfoModel = [DialInfoSetModel currentModel];
            NSLog(@"getDialInfo screenType %zd width %zd height %zd", model.screenType, model.screenWidth, model.screenHeight);

            dialInfoModel.screenType = model.screenType;
            dialInfoModel.screenWidth = model.screenWidth;
            dialInfoModel.screenHeight = model.screenHeight;
            [dialInfoModel saveOrUpdate];
            weakSelf.dialInfoModel = dialInfoModel;
            
            //表盘信息更新
            [DHNotificationCenter postNotificationName:BluetoothNotificationDialInfoChange object:nil];
            
            [weakSelf getModelInfo];
        }
    }];
}

- (void)getCustomDialInfo {
    [DHBleCommand getCustomDialInfo:^(int code, id  _Nonnull data) {
        if (code == 0) {
            DHCustomDialSyncingModel *model = data;
            CustomDialSetModel *dialModel = [CustomDialSetModel currentModel];
            dialModel.timePos = model.timePos;
            dialModel.timeUp = model.timeUp;
            dialModel.timeDown = model.timeDown;
            dialModel.textColor = model.textColor;
            [dialModel saveOrUpdate];
        }
    }];
}

- (void)startDataSyncing {
    NSDictionary *dict = @{@"progress":@"0"};
    //同步数据
    [DHNotificationCenter postNotificationName:BluetoothNotificationDataSyncing object:nil userInfo:dict];
}

- (void)centralManagerDidConnectPeripheral:(CBPeripheral *)peripheral {
    self.isConnected = YES;
    //设备连接状态更新
    [DHNotificationCenter postNotificationName:BluetoothNotificationConnectStateChange object:nil];
//    if (self.isBinded) {
//        [self delayPerformBlock:^(id  _Nonnull object) {
//            [self getBindInfo];
//        } WithTime:2.0];
//    }
}

- (void)centralManagerDidNotifyPeripheral:(CBPeripheral *)peripheral
{
    if (self.isBinded){
        [self getBindInfo];
    }
}

- (void)centralManagerDidDisconnectPeripheral:(CBPeripheral *)peripheral {
    self.isConnected = NO;
    //设备连接状态更新
    [DHNotificationCenter postNotificationName:BluetoothNotificationConnectStateChange object:nil];
}

- (void)centralManagerDidUpdateState:(BOOL)isOn {
    if (!isOn) {
        self.isConnected = NO;
        //设备连接状态更新
        [DHNotificationCenter postNotificationName:BluetoothNotificationConnectStateChange object:nil];
    }
}

-(void)peripheralDidUpdateValue:(id _Nullable)value type:(DHBleCommandType)type {
    switch (type) {
        case DHBleCommandTypeBatteryNotification:
        {
            if ([value isKindOfClass:[DHBatteryInfoModel class]]) {
                self.batteryModel = value;
                //设备电量更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationBatteryInfoChange object:nil];
            }
        }
            break;
        case DHBleCommandTypeSedentaryNotification:
        {
            if ([value isKindOfClass:[DHSedentarySetModel class]]) {
                DHSedentarySetModel *model = value;
                SedentarySetModel *sedentaryModel = [SedentarySetModel currentModel];
                
                sedentaryModel.isOpen = model.isOpen;
                sedentaryModel.interval = model.interval;
                sedentaryModel.repeats = [model.repeats transToJsonString];
                sedentaryModel.startHour = model.startHour;
                sedentaryModel.startMinute = model.startMinute;
                sedentaryModel.endHour = model.endHour;
                sedentaryModel.endMinute = model.endMinute;
                [sedentaryModel saveOrUpdate];
                //久坐提醒更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationSedentaryChange object:nil];
            }
        }
            break;
        case DHBleCommandTypeDrinkingNotification:
        {
            if ([value isKindOfClass:[DHDrinkingSetModel class]]) {
                DHDrinkingSetModel *model = value;
                DrinkingSetModel *drinkModel = [DrinkingSetModel currentModel];
                
                drinkModel.isOpen = model.isOpen;
                drinkModel.interval = model.interval;
                drinkModel.startHour = model.startHour;
                drinkModel.startMinute = model.startMinute;
                drinkModel.endHour = model.endHour;
                drinkModel.endMinute = model.endMinute;
                [drinkModel saveOrUpdate];
                //喝水提醒更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationDrinkingChange object:nil];
            }
        }
            break;
        case DHBleCommandTypeReminderModeNotification:
        {
            if ([value isKindOfClass:[DHReminderModeSetModel class]]) {
                DHReminderModeSetModel *model = value;
                ReminderModeSetModel *reminderModel = [ReminderModeSetModel currentModel];
                
                reminderModel.reminderMode = model.reminderMode;
                [reminderModel saveOrUpdate];
                //提醒模式更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationReminderModeChange object:nil];
            }
        }
            break;
        case DHBleCommandTypeAlarmNotification:
        {
            if ([value isKindOfClass:[NSArray class]]) {
                [AlarmSetModel deleteAllAlarms];
                NSArray *alarms = value;
                if (alarms.count) {
                    NSMutableArray *resultArray = [NSMutableArray array];
                    for (int i = 0; i < alarms.count; i++) {
                        DHAlarmSetModel *model = alarms[i];
                        AlarmSetModel *alarmModel = [[AlarmSetModel alloc] init];
                        
                        alarmModel.alarmIndex = i;
                        alarmModel.isOpen = model.isOpen;
                        alarmModel.hour = model.hour;
                        alarmModel.minute = model.minute;
                        alarmModel.repeats = [model.repeats transToJsonString];
                        alarmModel.alarmType = model.alarmType;
                        [resultArray addObject:alarmModel];
                    }
                    [AlarmSetModel saveObjects:resultArray];
                }
                //闹钟提醒更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationAlarmChange object:nil];
            }
        }
            break;
        case DHBleCommandTypeGestureNotification:
        {
            if ([value isKindOfClass:[DHGestureSetModel class]]) {
                DHGestureSetModel *model = value;
                GuestureSetModel *gestureModel = [GuestureSetModel currentModel];
                
                gestureModel.isOpen = model.isOpen;
                gestureModel.startHour = model.startHour;
                gestureModel.startMinute = model.startMinute;
                gestureModel.endHour = model.endHour;
                gestureModel.endMinute = model.endMinute;
                [gestureModel saveOrUpdate];
                //抬腕亮屏更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationGestureChange object:nil];
            }
        }
            break;
        case DHBleCommandTypeBrightTimeNotification:
        {
            if ([value isKindOfClass:[DHBrightTimeSetModel class]]) {
                DHBrightTimeSetModel *model = value;
                BrightTimeSetModel *brightTimeModel = [BrightTimeSetModel currentModel];
                
                brightTimeModel.duration = model.duration;
                [brightTimeModel saveOrUpdate];
                //亮屏时长更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationBrightTimeChange object:nil];
            }
        }
            break;
        case DHBleCommandTypeHeartRateModeNotification:
        {
            if ([value isKindOfClass:[DHHeartRateModeSetModel class]]) {
                DHHeartRateModeSetModel *model = value;
                HeartRateSetModel *heartRateModel = [HeartRateSetModel currentModel];
                
                heartRateModel.isOpen = model.isOpen;
                heartRateModel.interval = model.interval;
                heartRateModel.startHour = model.startHour;
                heartRateModel.startMinute = model.startMinute;
                heartRateModel.endHour = model.endHour;
                heartRateModel.endMinute = model.endMinute;
                [heartRateModel saveOrUpdate];
                //心率监测更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationHeartRateModeChange object:nil];
            }
        }
            break;
        case DHBleCommandTypeDisturbModeNotification:
        {
            if ([value isKindOfClass:[DHDisturbModeSetModel class]]) {
                DHDisturbModeSetModel *model = value;
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
        }
            break;
        case DHBleCommandTypeHealthDataNotification:
        {
            if ([value isKindOfClass:[DHHealthDataModel class]]) {
                DHHealthDataModel *model = value;
                if (model.type == 0) {
                    [HealthDataManager saveDailyStepItem:model];
                } else if (model.type == 1) {
                    [HealthDataManager saveDailyHrItem:model];
                } else if (model.type == 2) {
                    [HealthDataManager saveDailyBpItem:model];
                } else if (model.type == 3) {
                    [HealthDataManager saveDailyBoItem:model];
                } else if (model.type == 4) {
                    [HealthDataManager saveDailyTempItem:model];
                } else if (model.type == 5) {
                    [HealthDataManager saveDailyBreathItem:model];
                } else if (model.type == 6 || model.type == 7) {
                    [self startDataSyncing];
                }
                if (model.type <= 5) {
                    NSDictionary *dict = @{@"type":@(model.type)};
                    //健康数据更新
                    [DHNotificationCenter postNotificationName:BluetoothNotificationHealthDataChange object:nil userInfo:dict];
                }
            }
        }
            break;
        case DHBleCommandTypeCameraNotification:
        {
            NSString *command = value;
            if ([command integerValue] == 0) {
                //关闭相机
                [DHNotificationCenter postNotificationName:BluetoothNotificationCameraTurnOff object:nil];
            } else if ([command integerValue] == 1) {
                //打开相机
                [DHNotificationCenter postNotificationName:BluetoothNotificationCameraTurnOn object:nil];
            } else if ([command integerValue] == 2) {
                //拍照
                if ([DHBluetoothManager shareInstance].isActive){
                    [DHNotificationCenter postNotificationName:BluetoothNotificationCameraTakePicture object:nil];
                }
                else{
                    NSLog(@"后台不能拍照");
                }
            }
        }
            break;
        case DHBleCommandTypeFindPhoneNotification:
        {
            NSString *command = value;
            if ([command integerValue] == 0) {
                //寻找手机结束
                [DHNotificationCenter postNotificationName:BluetoothNotificationFindPhoneEnd object:nil];
            } else {
                //寻找手机开始
                [DHNotificationCenter postNotificationName:BluetoothNotificationFindPhoneStart object:nil];
            }
        }
            break;
        case DHBleCommandTypeTimeSyncNotification:
        {
            [self setTime];
        }
            break;
        case DHBleCommandTypeLocationNotification:
        {
            [[WeatherManager shareInstance] requestLocation];
        }
            break;
        default:
            break;
    }
}

#pragma mark- 杰里平台协议处理
- (void)setJLTimeZone {
    NSLog(@"DHBBluetoothManager setJLTimeZone %zd", [DHTool getTimeZoneInterval]);
    //DHTimeInterval
    NSInteger timeZone = [DHTool getTimeZoneInterval]/3600;
    [DHBleCommand setJLTimeZone:timeZone * 4 block:^(int code, id  _Nonnull data) {
        
    }];
}

- (void)setJLMuslimArgs:(Boolean)isChina{
    NSLog(@"setJLMuslimArgs lat %@ lon %@", [ConfigureModel shareInstance].latitude, [ConfigureModel shareInstance].longitude);
    
    double tLat = [[ConfigureModel shareInstance].latitude doubleValue];
    double tLon = [[ConfigureModel shareInstance].longitude doubleValue];
    
    
    CGFloat tQiblaAngle = [ConfigureModel qiblaAngleFrom:tLat lon:tLon];
    [DHBleCommand setJLMuslimAngle:tQiblaAngle lat:tLat lon:tLon china:isChina  block:^(int code, id  _Nonnull data) {
        
    }];
}

#pragma mark- 获取网络上表盘信息
- (void)getModelInfo{
    NSLog(@"getModelInfo %@", self.deviceModel);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.deviceModel forKey:@"model"];
    
    WEAKSELF
    [NetworkManager getModelInfo:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        NSLog(@"getModelInfo %zd message %@ data %@", resultCode, message, data);
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (resultCode == 0 && [data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = data;
                DevcieModelInfo *model = [[DevcieModelInfo alloc] init];
                model.customizeDialShowUrl = DHIsNotEmpty(dict, @"customizeDialShowUrl") ? [dict objectForKey:@"customizeDialShowUrl"] : @"";
                model.defaultCustomizeDialFlag = DHIsNotEmpty(dict, @"defaultCustomizeDialFlag") ? [[dict objectForKey:@"defaultCustomizeDialFlag"]  integerValue] : 0;
                model.defaultCustomizeDialUrl = DHIsNotEmpty(dict, @"defaultCustomizeDialUrl") ? [dict objectForKey:@"defaultCustomizeDialUrl"] : @"";
                model.height = DHIsNotEmpty(dict, @"height") ? [[dict objectForKey:@"height"] integerValue]  : 0;
                model.width = DHIsNotEmpty(dict, @"width") ? [[dict objectForKey:@"width"] integerValue] : 0;
                model.showUrl = DHIsNotEmpty(dict, @"showUrl") ? [dict objectForKey:@"showUrl"] : @"";
//                [model saveOrUpdate];
                model.thumbHeight = DHIsNotEmpty(dict, @"thumbHeight") ? [[dict objectForKey:@"thumbHeight"] integerValue]  : 0;
                model.thumbWidth = DHIsNotEmpty(dict, @"thumbWidth") ? [[dict objectForKey:@"thumbWidth"] integerValue] : 0;
                
                [DHBluetoothManager shareInstance].dialServiceInfoModel = model;
                
                [DHNotificationCenter postNotificationName:BluetoothNotificationDialInfoChange object:nil];
            }
        });
    }];
}

@end
