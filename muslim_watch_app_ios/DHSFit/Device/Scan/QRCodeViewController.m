//
//  QRCodeViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController ()<DHBleConnectDelegate>

#pragma mark UI

@property (nonatomic, strong) SGQRCodeObtain *QRCodeObtain;

@property (nonatomic, strong) SGQRCodeScanView *QRCodeScanView;

@property (nonatomic, strong) UILabel *promptLabel;

#pragma mark Data

@property (nonatomic, copy) NSString *macAddr;
/// 外设模型
@property (nonatomic, strong) DHPeripheralModel *deviceModel;

@end

@implementation QRCodeViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.QRCodeScanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.QRCodeScanView removeTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [DHBleCentralManager stopScan];
    [DHBleCentralManager shareInstance].connectDelegate = [DHBluetoothManager shareInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self setupQRCodeScanTool];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {

    [self.QRCodeScanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
    
    CGFloat originY = kScreenHeight*0.8;
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(originY);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(50);
        
    }];
}

- (void)setupQRCodeScanTool {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [BaseView showCameraUnauthorized];
        return;
    }

    self.QRCodeObtain = [SGQRCodeObtain QRCodeObtain];
    
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.openLog = YES;
    configure.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    configure.metadataObjectTypes = arr;
    [self.QRCodeObtain establishQRCodeObtainScanWithController:self configure:configure];
    [self.QRCodeObtain startRunningWithBefore:nil completion:nil];
        
    WEAKSELF
    [self.QRCodeObtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        //http://www.ruiwo168.com/app/download.html?model=01_DW02&mac=EE:EE:EE:EE:EE:EE
        NSLog(@"setBlockWithQRCodeObtainScanResult %@", result);
        if (result) {
            [obtain stopRunning];
            [weakSelf.QRCodeScanView removeTimer];
            [weakSelf checkResultAndconnect:result];
        } else {
            SHOWHUD(Lang(@"str_search_qrcode_error"))
        }
    }];
}

- (void)checkResultAndconnect:(NSString *)result {
    if (![result containsString:@"mac="]) {
        SHOWHUD(Lang(@"str_search_qrcode_error"))
        return;
    }
    NSArray *array = [result componentsSeparatedByString:@"mac="];
    NSString *macAddr = array.lastObject;
    self.macAddr = [macAddr uppercaseString];
    [DHBleCentralManager shareInstance].connectDelegate = self;
    [self startScan];
}

- (void)startScan {
    if ([DHBleCentralManager isPoweredOff]) {
        SHOWHUD(Lang(@"str_bluetooth_poweroff"))
        return;
    }
    
    SHOWHUDNODISS(Lang((@"str_device_connecting")))
    [DHBleCentralManager startScan];
    [self performSelector:@selector(scanTimeout) withObject:nil afterDelay:10.0];

}


- (void)scanTimeout {
    NSLog(@"scanTimeout");
    HUDDISS
    [DHBleCentralManager stopScan];
    SHOWHUD(Lang(@"str_connect_fail"));
    [self.navigationController popViewControllerAnimated:YES];
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


- (void)showAlertController {
    [BaseView showCameraUnauthorized];
}

- (void)removeScanningView {
    [self.QRCodeScanView removeTimer];
    [self.QRCodeScanView removeFromSuperview];
    
}

- (void)getBindInfo {
    WEAKSELF
    [DHBleCommand getBindInfo:^(int code, id  _Nonnull data) {
        if (code == 0) {
            DHBindSetModel *model = data;
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
    [ConfigureModel shareInstance].macAddr = self.deviceModel.macAddr;
    [ConfigureModel shareInstance].isNeedConnect = YES;
    [ConfigureModel archiveraModel];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [DHBleCentralManager shareInstance].connectDelegate = [DHBluetoothManager shareInstance];
    [[DHBluetoothManager shareInstance] configureDeviceInfo];
    if ([self.delegate respondsToSelector:@selector(deviceBindedSucceed:)]) {
        [self.delegate deviceBindedSucceed:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - get and set 属性的set和get方法

- (SGQRCodeScanView *)QRCodeScanView {
    if (!_QRCodeScanView) {
        _QRCodeScanView = [[SGQRCodeScanView alloc] init];
        _QRCodeScanView.scanImageName = @"QRCodeScanLine";
        _QRCodeScanView.scanAnimationStyle = ScanAnimationStyleDefault;
        _QRCodeScanView.cornerLocation = CornerLoactionOutside;
        _QRCodeScanView.cornerColor = HomeColor_MainColor;
        [self.view addSubview:_QRCodeScanView];
    }
    return _QRCodeScanView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = Lang(@"str_search_qrcode_tips");
        _promptLabel.font = HomeFont_ContentFont;
        _promptLabel.textColor = HomeColor_TitleColor;
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.numberOfLines = 0;
        [self.view addSubview:_promptLabel];
    }
    return _promptLabel;
}

#pragma mark - DHBleConnectDelegate

- (void)centralManagerDidDiscoverPeripheral:(NSArray <DHPeripheralModel *>*)peripherals {
    for (DHPeripheralModel *deviceModel in peripherals) {
        if (deviceModel.macAddr.length >= 17) {
            if ([self.macAddr isEqualToString:deviceModel.macAddr]) {
                HUDDISS
                
                SHOWHUDNODISS(Lang(@"str_device_connecting"))
                [DHBleCentralManager stopScan];
                [DHBleCentralManager connectDeviceWithModel:deviceModel];
                
                self.deviceModel = deviceModel;
                
                [self performSelector:@selector(checkConnecting) withObject:nil afterDelay:10.0];
                break;
            }
        }
    }
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

@end
