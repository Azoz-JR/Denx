//
//  DHBleCentralManager.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/24.
//

#import "DHBleCentralManager.h"
#import "DHBleAcceptManager.h"
#import "DHBleSendManager.h"
#import "DHBleCommand.h"
#import "DHTool.h"
#import "DHTimeSetModel.h"
#import "JLBleAcceptManager.h"

NSString *kFLT_BLE_FOUND        = @"FLT_BLE_FOUND";            //发现设备
NSString *kFLT_BLE_PAIRED       = @"FLT_BLE_PAIRED";           //BLE已配对
NSString *kFLT_BLE_CONNECTED    = @"FLT_BLE_CONNECTED";        //BLE已连接
NSString *kFLT_BLE_DISCONNECTED = @"FLT_BLE_DISCONNECTED";     //BLE断开连接
 
NSString *FLT_BLE_SERVICE = @"AE00"; //服务号
NSString *FLT_BLE_RCSP_W  = @"AE01"; //命令“写”通道
NSString *FLT_BLE_RCSP_R  = @"AE02"; //命令“读”通道

@interface DHBleCentralManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>

/// 蓝牙中心
@property (nonatomic, strong) CBCentralManager *centerManager;
/// 当前设备模型
@property (nonatomic,strong) DHPeripheralModel  *currentModel;
/// 搜索设备过滤
@property (nonatomic, strong) NSArray *filterUuids;
/// 配对设备过滤
@property (nonatomic, strong) NSArray *retrieveServices;
/// 正在发现设备特征值
@property (nonatomic, assign) BOOL discoverCharacteristics;
/// 自动重连的设备UUID
@property (nonatomic, copy) NSString *reconnectUuidSrting;
/// 自动重连定时器
@property (nonatomic, strong) NSTimer *reconnectTimer;
/// 搜索到的设备
@property (nonatomic,strong) NSMutableArray *peripherals;
/// 信号强度排序
@property (nonatomic,strong) NSSortDescriptor *rssiSortDesc;
/// 信号强度正则表达式
@property (nonatomic,strong) NSPredicate *rssiPredicate;
/// 信号强度过滤 范围0-200 默认200
@property (nonatomic, assign) NSInteger filterRssi;

@property (nonatomic, assign) BOOL isJLProtocol; //是否为杰里蓝牙协议;


@end

@implementation DHBleCentralManager

static DHBleCentralManager *_shared = nil;
+ (__kindof DHBleCentralManager *)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    }) ;
    return _shared ;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [DHBleCentralManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [DHBleCentralManager shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.discoverCharacteristics = NO;
        self.filterRssi = 200;
        _isJLProtocol = NO;
        
    }
    return self;
}

#pragma mark - 蓝牙和设备状态

+ (BOOL)isPoweredOff {
    BOOL isOff = NO;
    isOff  = [DHBleCentralManager shareInstance].centerManager.state == CBManagerStatePoweredOff;
 
    return isOff;
}

+ (BOOL)isConnected {
    if ([DHBleCentralManager isPoweredOff])return NO;
    if(![DHBleCentralManager shareInstance].currentModel.peripheral)return NO;
    return [DHBleCentralManager shareInstance].currentModel.peripheral.state == CBPeripheralStateConnected;
}

+ (BOOL)isBinded {
    NSString *uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:DHBindedUUID];
    if (!uuidStr || uuidStr.length == 0) {
        return NO;
    }
    return YES;
}

+ (void)setBindedStatus:(BOOL)isBinded {
    if (isBinded) {
        if ([DHBleCentralManager shareInstance].currentModel) {
            [[NSUserDefaults standardUserDefaults] setObject:[DHBleCentralManager shareInstance].currentModel.uuid forKey:DHBindedUUID];
            [[NSUserDefaults standardUserDefaults] setObject:[DHBleCentralManager shareInstance].currentModel.macAddr forKey:DHBindedMacAddress];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DHBindedUUID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DHBindedMacAddress];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)setLogStatus:(BOOL)isLog {
    [[NSUserDefaults standardUserDefaults] setBool:isLog forKey:DHLogStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)startScan {
    if ([DHBleCentralManager isPoweredOff])return;
    [DHBleCentralManager stopScan];
    
    DHBleCentralManager * manager = [DHBleCentralManager shareInstance];
    if (manager.peripherals.count > 0) [manager.peripherals removeAllObjects];
    NSMutableArray *connectedArray = [manager getPairedConnectedArray];
    if (connectedArray.count) {
        [manager.peripherals addObjectsFromArray:connectedArray];
    }
    if (!manager.reconnectTimer) {
        if (connectedArray.count && manager.connectDelegate && [manager.connectDelegate respondsToSelector:@selector(centralManagerDidDiscoverPeripheral:)]) {
            [manager.connectDelegate centralManagerDidDiscoverPeripheral:manager.peripherals];
        }
    }
    [manager.centerManager scanForPeripheralsWithServices:manager.filterUuids
                                                  options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
    
    DHSaveLog(@"scanForPeripherals");
}

+ (void)stopScan {
    if ([DHBleCentralManager isPoweredOff])return;
    [[DHBleCentralManager shareInstance].centerManager stopScan];
}

+ (void)initWithServiceUuids:(NSArray <NSString *>*)uuids {
    NSMutableArray *filterUuids = [NSMutableArray array];
    NSMutableArray *retriveUUIDs = [NSMutableArray array];
    for (NSString *uuid in uuids) {
        CBUUID * filterUUID = [CBUUID UUIDWithString:uuid];
        NSString *uuidStr = [NSString stringWithFormat:@"0000%@-0000-1000-8000-00805f9b34fb",[uuid lowercaseString]];
        CBUUID * retriveUUID = [CBUUID UUIDWithString:uuidStr];
        
        [filterUuids addObject:filterUUID];
        [retriveUUIDs addObject:retriveUUID];
//        [retriveUUIDs addObject:[CBUUID UUIDWithString:JLServiceUUID]];
    }
    
    [DHBleCentralManager shareInstance].filterUuids = filterUuids;
    [DHBleCentralManager shareInstance].retrieveServices = retriveUUIDs;
    
    [DHTool checkLogFiles];
    
    NSMutableString *message = [NSMutableString string];
    
    if ([DHBleCentralManager isBinded]) {
        [DHBleCentralManager autoReconnectDevice];
        [message appendString:@"autoReconnectDevice:"];
       
    } else {
        [DHBleCentralManager stopScan];
        [message appendString:@"initCentralManager:"];
    }
    
    for (NSString *uuid in uuids) {
        [message appendFormat:@"%@/",uuid];
    }
    DHSaveLog(message);
}

+ (void)autoReconnectDevice {
    [[DHBleCentralManager shareInstance] startReconnect];
}

+ (BOOL)isJLProtocol
{
    return [DHBleCentralManager shareInstance].isJLProtocol;
}

#pragma mark - 连接蓝牙设备

+ (void)connectHistoricalDeviceWithModel:(DHPeripheralModel *)model {
    DHBleCentralManager * manager = [DHBleCentralManager shareInstance];
    manager.currentModel = model;
    [self setBindedStatus:YES];
    if ([DHBleCentralManager isPoweredOff])return;
    
    [self stopScan];
    [manager stopReconnect];
    
    NSString *message = [NSString stringWithFormat:@"connecting:%@ %@",model.name, model.macAddr];
    DHSaveLog(message);
    [self autoReconnectDevice];
}

+ (void)connectDeviceWithModel:(DHPeripheralModel *)model {
    if ([DHBleCentralManager isPoweredOff])return;
    
    DHBleCentralManager * manager = [DHBleCentralManager shareInstance];
    [self stopScan];
    [manager stopReconnect];
    manager.currentModel = model;
    [manager.centerManager connectPeripheral:model.peripheral options:nil];
    
    NSString *message = [NSString stringWithFormat:@"connecting:%@ %@",model.name, model.macAddr];
    DHSaveLog(message);
    if (model.macAddr && model.macAddr.length > 2) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:DHAllBindedMacAddress]) {
            dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:DHAllBindedMacAddress]];
        }
        [dict setObject:model.macAddr forKey:model.uuid];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:DHAllBindedMacAddress];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (void)disconnectDevice{
    DHBleCentralManager * manager = [DHBleCentralManager shareInstance];
    [DHBleCentralManager stopScan];
    [manager stopReconnect];
    
    if (manager.currentModel.peripheral) {
        [manager.centerManager cancelPeripheralConnection:manager.currentModel.peripheral];
    }
}

- (NSMutableArray *)getPairedConnectedArray {
    NSMutableArray *connectedArray = [[NSMutableArray alloc] init];
    NSArray *connectedB = [self.centerManager retrieveConnectedPeripheralsWithServices:self.retrieveServices];
    
    NSMutableArray *allConnectedArray = [[NSMutableArray alloc] init];
    if (connectedB) {
        [allConnectedArray addObjectsFromArray:connectedB];
    }
    
    for (NSInteger i = 0; i < allConnectedArray.count; i ++) {
        CBPeripheral *peripheral = allConnectedArray[i];
        DHPeripheralModel *model = [[DHPeripheralModel alloc] init];
        model.peripheral = peripheral;
        model.rssi = 0;
        model.uuid = peripheral.identifier.UUIDString;
        model.macAddr = @"";
        model.name = peripheral.name;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:DHAllBindedMacAddress]) {
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:DHAllBindedMacAddress];
            if ([dict objectForKey:peripheral.identifier.UUIDString]) {
                model.macAddr = [dict objectForKey:peripheral.identifier.UUIDString];
            }
        }
        
        [connectedArray addObject:model];
    }
    return connectedArray;
}

- (void)clearData
{
    DHSaveLog(@"clearData");
    self.currentModel = nil;
}

#pragma mark - 设备自动重连

- (void)startReconnect {
    NSString *tstartReconnect20230228 = [NSString stringWithFormat:@"startReconnect 20230228 %@", self.reconnectTimer];
    DHSaveLog(tstartReconnect20230228);

    if (self.reconnectTimer) {
        return;
    }
    self.reconnectUuidSrting = [[NSUserDefaults standardUserDefaults] objectForKey:DHBindedUUID];
    
    NSString *tstartReconnect20230229 = [NSString stringWithFormat:@"startReconnect 20230229 %@", self.reconnectUuidSrting];
    DHSaveLog(tstartReconnect20230229);
    if (!self.reconnectUuidSrting || self.reconnectUuidSrting.length == 0) {
        return;
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoConnect:) userInfo:nil repeats:YES];
    [timer fire];
    self.reconnectTimer = timer;
}

- (void)autoConnect:(NSTimer *)timer {
    if (self.currentModel && self.currentModel.peripheral) {
        [self.centerManager connectPeripheral:self.currentModel.peripheral options:nil];
        [timer invalidate];
    } else {
        NSUUID *tSaveUuid = [[NSUUID alloc] initWithUUIDString:self.reconnectUuidSrting];
        NSArray *retPers = [self.centerManager retrievePeripheralsWithIdentifiers:@[tSaveUuid]];
//        NSMutableArray *connectedArray = [self getPairedConnectedArray];
        NSLog(@"autoConnect timer 3s connectedArray %zd", retPers.count);

        CBPeripheral *peripheral = [retPers firstObject];
        if (peripheral){
            DHPeripheralModel *bleModel = [[DHPeripheralModel alloc] init];
            bleModel.peripheral = peripheral;
            bleModel.rssi = 0;
            bleModel.uuid = peripheral.identifier.UUIDString;
            bleModel.macAddr = @"";
            bleModel.name = peripheral.name;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:DHAllBindedMacAddress]) {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:DHAllBindedMacAddress];
                if ([dict objectForKey:peripheral.identifier.UUIDString]) {
                    bleModel.macAddr = [dict objectForKey:peripheral.identifier.UUIDString];
                }
            }
            [DHBleCentralManager connectDeviceWithModel:bleModel];
            [timer invalidate];
        }
        else{
            [DHBleCentralManager startScan];
        }
    }
}

- (void)stopReconnect {
    if (self.reconnectTimer) {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
        DHSaveLog(@"stopReconnect");
    }
}

#pragma mark -  CBPeripheralDelegate methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    BOOL isOff = NO;
    if (@available(iOS 10.0, *)) {
        isOff  = central.state == CBManagerStatePoweredOff;
    } else {
        isOff  = central.state == CBCentralManagerStatePoweredOff;
    }
    
    BOOL isOn = NO;
    if (@available(iOS 10.0, *)) {
        isOn  = central.state == CBManagerStatePoweredOn;
    } else {
        isOn  = central.state == CBCentralManagerStatePoweredOn;
    }

    DHBleSendManager *sendManager = [DHBleSendManager shareInstance];
    if (isOff) {
        sendManager.peripheral = nil;
        sendManager.writeCharacteristic = nil;
        [sendManager clearSendDatalist];
        [[DHBleAcceptManager shareInstance] clearData];
        [self stopReconnect];
        DHSaveLog(@"CBCentralManagerStatePoweredOff");
    } else if(isOn) {
        [self startReconnect];
        DHSaveLog(@"CBCentralManagerStatePoweredOn");
    }
    if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(centralManagerDidUpdateState:)]) {
        if (isOff) {
            [self.connectDelegate centralManagerDidUpdateState:NO];
        } else if (isOn) {
            [self.connectDelegate centralManagerDidUpdateState:YES];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSData *factureData = advertisementData[@"kCBAdvDataManufacturerData"];
    if (DHIsSaveLog) {
//        NSLog(@"advertisementData=%@ %@", factureData, peripheral.name);
    }
    
    //0xd6050200810052 863018ac218c 804344
    NSString *deviceName = @"";
    NSString *macAddr = @"";
    if (advertisementData[@"kCBAdvDataLocalName"] &&  [advertisementData[@"kCBAdvDataLocalName"] isKindOfClass:[NSString class]]) {
        deviceName = advertisementData[@"kCBAdvDataLocalName"];
    }
    
    NSInteger tPidType = 0;
    NSLog(@"advertisementData=%@ %@ deviceName %@", factureData, peripheral.name, deviceName);
    
    if (factureData && factureData.length >= 10){
        UInt32 tJieLieFactureHead = 0;
        [factureData getBytes:&tJieLieFactureHead length:4];
        NSLog(@"tJieLieFactureHead %08X", tJieLieFactureHead);
        if (tJieLieFactureHead == 0x000205D6){ //杰里平台
            macAddr = [DHTool hexRepresentationWithSymbol:@":" data:[factureData subdataWithRange:NSMakeRange(7, 6)]];
            tPidType = 1;
        }
        else if (factureData.length == 10){ //瑞昱平台
            macAddr = [DHTool hexRepresentationWithSymbol:@":" data:[factureData subdataWithRange:NSMakeRange(factureData.length-6, 6)]];
        }
        else{
            return;
        }
    }
    else{
        return;
    }
    
    NSLog(@"kCBAdvDataManufacturerData %@ macAddr %@ uuid %@", deviceName, macAddr, peripheral.identifier.UUIDString);
    DHPeripheralModel *model = [[DHPeripheralModel alloc] init];
    model.peripheral = peripheral;
    model.rssi = abs([RSSI intValue]);
    model.uuid = peripheral.identifier.UUIDString;
    model.macAddr = macAddr;
    model.name = deviceName.length ? deviceName : peripheral.name;
    model.pidType = tPidType;
    if (self.reconnectTimer) {
        if ([peripheral.identifier.UUIDString isEqualToString:self.reconnectUuidSrting]) {
            [DHBleCentralManager connectDeviceWithModel:model];
        }
    } else {
        if (macAddr.length < 1){
            return;
        }
        NSPredicate * containPredicate = [NSPredicate predicateWithFormat:@"uuid == %@",peripheral.identifier.UUIDString];
        NSArray * containDevices = [self.peripherals filteredArrayUsingPredicate:containPredicate];
        if (containDevices.count == 0){
            model.rssi = abs(RSSI.intValue);
            NSLog(@"kCBAdvDataManufacturerData2222 %@", model.macAddr);
            [self.peripherals addObject:model];
        }else {
            NSLog(@"kCBAdvDataManufacturerData3333 %@", model.macAddr);
            DHPeripheralModel * containModel = [containDevices firstObject];
            containModel.rssi = abs(RSSI.intValue);
        }
        [self.peripherals sortUsingDescriptors:@[self.rssiSortDesc]];
        if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(centralManagerDidDiscoverPeripheral:)]) {
            [self.connectDelegate centralManagerDidDiscoverPeripheral:self.peripherals];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    DHSaveLog(@"didConnectPeripheral");
    [self stopReconnect];
    self.discoverCharacteristics = YES;
    
    [DHBleSendManager shareInstance].peripheral = peripheral;
    [DHBleSendManager shareInstance].peripheral.delegate = self;
    
    
    [[DHBleSendManager shareInstance].peripheral discoverServices:nil];

}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    DHSaveLog(@"didFailToConnectPeripheral");
    [DHBleSendManager shareInstance].peripheral = nil;
    [DHBleSendManager shareInstance].writeCharacteristic = nil;
    
    [[DHBleSendManager shareInstance] clearSendDatalist];
    [[DHBleAcceptManager shareInstance] clearData];
     
    if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(centralManagerDidDisconnectPeripheral:)]) {
        [self.connectDelegate centralManagerDidDisconnectPeripheral:peripheral];
    }
    
    [self stopReconnect];
    
    [self startReconnect];
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    DHSaveLog(@"didDisconnectPeripheral");
        
    [[DHBleSendManager shareInstance] clearSendDatalist];
    [[DHBleAcceptManager shareInstance] clearData];
    [DHBleSendManager shareInstance].peripheral = nil;
    [DHBleSendManager shareInstance].writeCharacteristic = nil;
    
    if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(centralManagerDidDisconnectPeripheral:)]) {
        [self.connectDelegate centralManagerDidDisconnectPeripheral:peripheral];
    }
    [self stopReconnect];
    [self startReconnect];
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error{
    
    self.isJLProtocol = NO;
    for (CBService * service in peripheral.services) {
        NSString *message = [NSString stringWithFormat:@"service:%@",service.UUID];
        DHSaveLog(message);

        if ([service.UUID.UUIDString isEqualToString:RWServiceUUID]){ //JieLi
            [peripheral discoverCharacteristics:nil forService:service];
        }
        else if ([service.UUID.UUIDString isEqualToString:JLServiceUUID]){//JLServiceUUID
            self.isJLProtocol = YES;
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error{
    
    for (CBCharacteristic * characteristic in service.characteristics) {
        NSString *message = [NSString stringWithFormat:@"characteristic:%@ %lu", characteristic.UUID, (unsigned long)characteristic.properties];
        DHSaveLog(message);
        
        if ([characteristic.UUID.UUIDString isEqualToString:RWCharWriteUUID]){
            [DHBleSendManager shareInstance].writeCharacteristic = characteristic;
            if (self.discoverCharacteristics) {
                self.discoverCharacteristics = NO;
                if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(centralManagerDidConnectPeripheral:)]) {
                    [self.connectDelegate centralManagerDidConnectPeripheral:peripheral];
                }
            }
        } else if ([characteristic.UUID.UUIDString isEqualToString:RWCharNotifyUUID]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ mtu %ld", characteristic.UUID.UUIDString, [peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse]);
    if ([characteristic.UUID.UUIDString isEqualToString:RWCharNotifyUUID]){
        
        [[DHBleSendManager shareInstance] jlCleanQueue];
        
        if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(centralManagerDidNotifyPeripheral:)]) {
            [self.connectDelegate centralManagerDidNotifyPeripheral:peripheral];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    NSLog(@"didUpdateValueForCharacteristic %@", characteristic.value);
    if (self.isJLProtocol){
        [[JLBleAcceptManager shareInstance] didUpdateValueWithResponse:characteristic.value];
    }
    else{
        [[DHBleAcceptManager shareInstance] didUpdateValueWithResponse:characteristic.value];
    }
}

- (CBCentralManager *)centerManager {
    if (!_centerManager) {
        _centerManager = [[CBCentralManager alloc] initWithDelegate:self
                                                              queue:dispatch_get_main_queue()
                                                            options:nil];
    }
    return _centerManager;
}

- (NSArray *)filterUuids {
    _filterUuids = @[];
//    if (JieLiChip){
//        _filterUuids = @[];
//    }
//    else{
//        if (!_filterUuids) {
//            CBUUID * filterUUID = [CBUUID UUIDWithString:@"A00A"];
//            _filterUuids = @[filterUUID];
//        }
//    }
    return _filterUuids;
}

- (NSArray *)retrieveServices {
    if (!_retrieveServices) {
        CBUUID * retriveUUID = [CBUUID UUIDWithString:@"0000a00a-0000-1000-8000-00805f9b34fb"];
        CBUUID * jlRetriveUUID = [CBUUID UUIDWithString:RWServiceUUID];
        _retrieveServices = @[retriveUUID, jlRetriveUUID];
    }
    return _retrieveServices;
}

- (NSMutableArray *)peripherals {
    if (!_peripherals) {
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}

- (NSSortDescriptor *)rssiSortDesc {
    if (!_rssiSortDesc) {
        _rssiSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"rssi" ascending:YES];
    }
    return _rssiSortDesc;
}

- (NSPredicate *)rssiPredicate {
    if(!_rssiPredicate) {
        _rssiPredicate = [NSPredicate predicateWithFormat:@"rssi < %ld",(long)_filterRssi];
    }
    return _rssiPredicate;
}

- (void)setCommandDelegate:(id<DHBleCommandDelegate>)commandDelegate {
    [DHBleSendManager shareInstance].commandDelegate = commandDelegate;
}

@end
