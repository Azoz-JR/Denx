//
//  ScanViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "ScanViewController.h"
#import "ScanDeviceCell.h"

@interface ScanViewController ()<UITableViewDelegate,UITableViewDataSource,DHBleConnectDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *deviceArray;
/// 外设模型
@property (nonatomic, strong) DHPeripheralModel *deviceModel;

/// 列表数据源
@property (nonatomic, strong) NSArray *deviceTempArray;

@property (nonatomic, assign) BOOL isReady;

@end

@implementation ScanViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [DHBleCentralManager stopScan];
    [DHBleCentralManager shareInstance].connectDelegate = [DHBluetoothManager shareInstance];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [DHBleCentralManager shareInstance].connectDelegate = self;
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)navRightButtonClick:(UIButton *)sender {
    [self startScan];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
}

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 0.5;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    [self.navigationView.navRightButton.layer addAnimation:animation forKey:nil];
    self.navigationView.navRightButton.userInteractionEnabled = NO;
}

- (void)removeAnimation {
    [self.navigationView.navRightButton.layer removeAllAnimations];
    self.navigationView.navRightButton.userInteractionEnabled = YES;
}

- (void)startScan {
    if ([DHBleCentralManager isPoweredOff]) {
        SHOWHUD(Lang(@"str_bluetooth_poweroff"))
        return;
    }
    
    self.isReady = YES;
    self.deviceTempArray = [NSArray array];
    [self.deviceArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [self.myTableView reloadData];
    [self removeAnimation];
    [self startAnimation];
    [DHBleCentralManager startScan];
    
    [self performSelector:@selector(scanTimeout) withObject:nil afterDelay:5.0];
}

- (void)scanTimeout {
    [self removeAnimation];
    [DHBleCentralManager stopScan];
}

- (void)checkConnecting {
    [DHBluetoothManager shareInstance].isConnected = NO;
    SHOWHUD(Lang(@"str_connect_fail"))
    
    [DHBleCentralManager disconnectDevice];
}

- (void)bindFailed {
    HUDDISS
    [BaseView showDeviceBindedFailed];
}

- (NSString *)transferRssi:(NSInteger)rssi {
    if (rssi <= 60) {
        return @"4";
    }
    if (rssi <= 70) {
        return @"3";
    }
    if (rssi <= 80) {
        return @"2";
    }
    return @"1";
}

- (void)getBindInfo {
    WEAKSELF
    [DHBleCommand getBindInfo:^(int code, id  _Nonnull data) {
        if (code == 0) {
//            DHBindSetModel *model = data;
            [weakSelf bindDevice];
        } else {
            [weakSelf bindFailed];
            [DHBleCentralManager disconnectDevice];
        }
    }];
}

- (void)bindDevice {
    DHBindSetModel *model = [[DHBindSetModel alloc] init];
    model.bindOS = 2;
    model.userId = DHUserId;
    WEAKSELF
    [DHBleCommand setBind:model block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf bindSuccess];
        } else {
            [weakSelf bindFailed];
            [DHBleCentralManager disconnectDevice];
        }
    }];
}

- (void)bindSuccess {
    HUDDISS
    //连接状态更新
    [DHNotificationCenter postNotificationName:BluetoothNotificationConnectStateChange object:nil];
    [DHBluetoothManager shareInstance].isNeedActivatingDevice = YES;
    [DHBluetoothManager shareInstance].isBinded = YES;
    [DHBleCentralManager setBindedStatus:YES];
    
    DeviceModel *model = [DeviceModel currentModel];
    model.userId = DHUserId;
    model.macAddr = self.deviceModel.macAddr;
    model.name = self.deviceModel.name;
    model.uuid = self.deviceModel.uuid;
    NSString *timeStr = [[NSDate date] dateToStringFormat:@"yyyyMMddHHmmss"];
    model.timestamp = [NSDate timeStampFromtimeStr:timeStr];
    [model saveOrUpdate];
    
    [ConfigureModel shareInstance].weatherTime = 0;
    [ConfigureModel shareInstance].isNeedConnect = YES;
    [ConfigureModel shareInstance].macAddr = self.deviceModel.macAddr;
    [ConfigureModel archiveraModel];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [DHBleCentralManager shareInstance].connectDelegate = [DHBluetoothManager shareInstance];
    [[DHBluetoothManager shareInstance] configureDeviceInfo];
    if ([self.delegate respondsToSelector:@selector(deviceBindedSucceed:)]) {
        [self.delegate deviceBindedSucceed:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DHBleConnectDelegate

- (void)centralManagerDidDiscoverPeripheral:(NSArray <DHPeripheralModel *>*)peripherals {
    
    if (self.isReady) {
        self.isReady = NO;
        self.deviceTempArray = peripherals;
        [self performSelector:@selector(updateTableView) withObject:nil afterDelay:0.5];
    }
}

- (void)updateTableView {
    [self.deviceArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [self.deviceArray addObjectsFromArray:self.deviceTempArray];
    
    for (DHPeripheralModel *model in self.deviceArray) {
        if (model.macAddr.length == 0) {
            continue;
        }
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = model.name;
        cellModel.subTitle = [self transferRssi:model.rssi];
        cellModel.contentTitle = model.macAddr;
        [self.dataArray addObject:cellModel];
    }
    [self.myTableView reloadData];
    self.isReady = YES;
}

- (void)centralManagerDidConnectPeripheral:(CBPeripheral *)peripheral {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [DHBluetoothManager shareInstance].isConnected = YES;
    
    [self delayPerformBlock:^(id  _Nonnull object) {
        SHOWHUDNODISS(Lang(@"str_binding"))
        [self getBindInfo];
    } WithTime:2.0];
}

- (void)centralManagerDidDisconnectPeripheral:(CBPeripheral *)peripheral {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [DHBluetoothManager shareInstance].isConnected = NO;
    HUDDISS
}


- (void)centralManagerDidUpdateState:(BOOL)isOn {
    if (!isOn) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [DHBluetoothManager shareInstance].isConnected = NO;
        HUDDISS
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ScanDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScanDeviceCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([DHBleCentralManager isPoweredOff]) {
        SHOWHUD(Lang(@"str_bluetooth_poweroff"))
        return;
    }
    SHOWHUDNODISS(Lang(@"str_device_connecting"))
    [self removeAnimation];
    [DHBleCentralManager stopScan];
    
    DHPeripheralModel *deviceModel = self.deviceArray[indexPath.row];
    [DHBleCentralManager connectDeviceWithModel:deviceModel];
    
    self.deviceModel = deviceModel;
    
    [self performSelector:@selector(checkConnecting) withObject:nil afterDelay:10.0];
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = 90;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[ScanDeviceCell class] forCellReuseIdentifier:@"ScanDeviceCell"];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)deviceArray {
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}

@end
