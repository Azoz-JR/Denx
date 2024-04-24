//
//  DeviceViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "DeviceViewController.h"
#import "DeviceInfoCell.h"
#import "DeviceDialCell.h"
#import "DeviceBindCell.h"
#import "DeviceUnbindCell.h"

#import "SedentarySetViewController.h"
#import "DrinkingSetViewController.h"
#import "ReminderModeSetViewController.h"
#import "GuestureSetViewController.h"
#import "AlarmHomeViewController.h"
#import "BrightTimeSetViewController.h"
#import "HeartRateSetViewController.h"
#import "DisturbModeSetViewController.h"
#import "ContactListViewController.h"
#import "AncsSetViewController.h"
#import "AncsJLSetViewController.h"
#import "DialMarketViewController.h"
#import "DialDetailViewController.h"
#import "ScanViewController.h"
#import "QRCodeViewController.h"
#import "OTAViewController.h"
#import "CameraViewController.h"
#import "QRCodeListViewController.h"
#import "BreathSetViewController.h"
#import "MenstrualCycleViewController.h"
#import "MoreFuncViewController.h"
#import "DevcieModelInfo.h"

#import "DHTool.h"

@interface DeviceViewController ()<UITableViewDelegate,UITableViewDataSource,DeviceDialCellDelegate,ScanViewControllerDelegate,QRCodeViewControllerDelegate,DeviceBindCellDelegate,DialDetailViewControllerDelegate,OTAViewControllerDelegate,MoreFuncViewControllerDelegate,DeviceInfoCellDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// footer
@property (nonatomic, strong) UIView *footerView;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// icon
@property (nonatomic, strong) NSArray *images;
/// 设备信息cell高度
@property (nonatomic, assign) CGFloat deviceCellH;
/// 表盘cell高度
@property (nonatomic, assign) CGFloat dialCellH;
/// 云端表盘数组
@property (nonatomic, strong) NSMutableArray <DialMarketSetModel *>*dialArray;
/// 请求次数
@property (nonatomic, assign) NSInteger requestCount;
/// 功能表
@property (nonatomic, strong) DeviceFuncModel *funcModel;
/// 准备解绑设备
@property (nonatomic, assign) BOOL isReadyUnbind;
/// 固件信息
@property (nonatomic, strong) OnlineFirmwareVersionModel *onlineModel;
@property (nonatomic, strong) DevcieModelInfo *deviceModelInfo;

@property (nonatomic, strong) DeviceInfoCell *deviceInfoCell;

@end

@implementation DeviceViewController

#pragma mark - vc lift cycle 生命周期

-(void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    [self addObservers];
    
    self.requestCount = 1;
    if (DHDeviceBinded) {
        [self delayPerformBlock:^(id  _Nonnull object) {
            [self queryDialArray];
//            [self queryFirmwareVersion];
        } WithTime:0.5];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (DHDeviceBinded) {
        [self delayPerformBlock:^(id  _Nonnull object) {
//            [self queryDialArray];
            NSLog(@"delayPerformBlock queryFirmwareVersion");
            [self queryFirmwareVersion];
//            [self getModelInfo];
            if (![DHBluetoothManager shareInstance].isNeedActivatingDevice) { //不需要激活时,取电量;
                NSLog(@"delayPerformBlock isNeedActivatingDevice == NO getBattery");
                [[DHBluetoothManager shareInstance] getBattery];
            }
        } WithTime:0.5];
    }
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    
    CGFloat screenWidth = DHDialWidth;
    CGFloat screenHeight = DHDialHeight;

    NSInteger imageWidth = (kScreenWidth-30-80)/3.0;
    NSInteger imageHeight = 1.0*imageWidth*screenHeight/screenWidth;
    self.dialCellH = 50+50+imageHeight;
    self.deviceCellH = DHDeviceBinded ? 210 : 210;
    
    NSLog(@"initData screenWidth %lf screenHeight %lf imageWidth %zd imageHeight %zd", screenWidth, screenHeight, imageWidth, imageHeight);


    [self.dataArray removeAllObjects];
    
    self.funcModel = [DeviceFuncModel currentModel];
    self.onlineModel = [OnlineFirmwareVersionModel currentModel];
    
    if (DHDeviceBinded) {
        for (int i = 0; i < self.titles.count; i++) {
            NSString *titleStr = self.titles[i];
            if ((!self.funcModel.isDial && [titleStr isEqualToString:Lang(@"str_dial_market")]) ||
                (!self.funcModel.isAncs && [titleStr isEqualToString:Lang(@"str_msg_push")]) ||
                (!self.funcModel.isSedentary && [titleStr isEqualToString:Lang(@"str_long_sit")]) ||
                (!self.funcModel.isDrinking && [titleStr isEqualToString:Lang(@"str_drink")]) ||
                (!self.funcModel.isReminderMode && [titleStr isEqualToString:Lang(@"str_warn_model")]) ||
                (!self.funcModel.isAlarm && [titleStr isEqualToString:Lang(@"str_alarm")]) ||
                (!self.funcModel.isGesture && [titleStr isEqualToString:Lang(@"str_screen_light")]) ||
                (!self.funcModel.isBrightTime && [titleStr isEqualToString:Lang(@"str_screen_long")]) ||
                (!self.funcModel.isHeartRateMode && [titleStr isEqualToString:Lang(@"str_hr_watcher")]) ||
                (!self.funcModel.isDisturbMode && [titleStr isEqualToString:Lang(@"str_no_disturb")]) ||
                (!self.funcModel.isWeather && [titleStr isEqualToString:Lang(@"str_weather")]) ||
                (!self.funcModel.isContact && [titleStr isEqualToString:Lang(@"str_address_book")]) ||
                (!self.funcModel.isQRCode && [titleStr isEqualToString:Lang(@"str_qrcode_manager")]) ||
                (!self.funcModel.isMenstrualCycle && [titleStr isEqualToString:Lang(@"str_menstrual_cycle_reminder")]) ||
                (!self.funcModel.isBreath && [titleStr isEqualToString:Lang(@"str_breath_training")])) {
                continue;
            }
            MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
            cellModel.leftImage = self.images[i];
            cellModel.leftTitle = self.titles[i];
            if ([cellModel.leftTitle isEqualToString:Lang(@"str_take_photo")]) {
                cellModel.isHideSwitch = NO;
                cellModel.isHideArrow = YES;
                cellModel.isOpen = [ConfigureModel shareInstance].isCamera;
                cellModel.switchViewTag = 1000;
            } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_weather")]) {
                cellModel.isHideSwitch = NO;
                cellModel.isHideArrow = YES;
                cellModel.isOpen = [ConfigureModel shareInstance].isWeather;
                cellModel.switchViewTag = 2000;
            }
            [self.dataArray addObject:cellModel];
        }
    } else {
        [self.dialArray removeAllObjects];
        for (int i = 0; i < self.titles.count; i++) {
            NSString *titleStr = self.titles[i];
            if ([titleStr isEqualToString:@"deviceInfo"] ||
                [titleStr isEqualToString:Lang(@"str_dial_market")] ||
                [titleStr isEqualToString:Lang(@"str_msg_push")] ||
                [titleStr isEqualToString:Lang(@"str_take_photo")] ||
                [titleStr isEqualToString:Lang(@"str_search_device")] ||
                [titleStr isEqualToString:Lang(@"str_alarm")] ||
                [titleStr isEqualToString:Lang(@"str_hr_watcher")] ||
                [titleStr isEqualToString:Lang(@"str_weather")] ||
                [titleStr isEqualToString:Lang(@"str_more")] ||
                [titleStr isEqualToString:Lang(@"str_address_book")]) {
                MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
                cellModel.leftImage = self.images[i];
                cellModel.leftTitle = self.titles[i];
                if ([cellModel.leftTitle isEqualToString:Lang(@"str_take_photo")]) {
                    cellModel.isHideSwitch = NO;
                    cellModel.isHideArrow = YES;
                    cellModel.isOpen = NO;
                    cellModel.switchViewTag = 1000;
                } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_weather")]) {
                    cellModel.isHideSwitch = NO;
                    cellModel.isHideArrow = YES;
                    cellModel.isOpen = NO;
                    cellModel.switchViewTag = 2000;
                }
                [self.dataArray addObject:cellModel];
            }
        }
    }
}

- (void)activatingDevice {
    
    NSLog(@"activatingDevice deviceModel %@ isNeedActivatingDevice %d", [DHBluetoothManager shareInstance].deviceModel, [DHBluetoothManager shareInstance].isNeedActivatingDevice);
    if ([DHBluetoothManager shareInstance].deviceModel == nil && [DHBluetoothManager shareInstance].deviceModel.length > 0){
        return;
    }
    
    if (![DHBluetoothManager shareInstance].isNeedActivatingDevice) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[DHBluetoothManager shareInstance].deviceModel forKey:@"model"];
    [dict setObject:DHMacAddr forKey:@"deviceId"];
    
    //激活设备
    [DHBluetoothManager shareInstance].isNeedActivatingDevice = NO;
    [NetworkManager activatingDeviceWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        
    }];
     
}

- (void)queryFirmwareVersion {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //11:22:33:44:55:2F
//        [dict setObject:@"11:22:33:44:55:2F" forKey:@"deviceId"];
//        [dict setObject:[NSString stringWithFormat:@"%@", @"1.3.5"] forKey:@"currentVersion"];
    [dict setObject:DHMacAddr forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%@",[DHBluetoothManager shareInstance].firmwareVersion] forKey:@"currentVersion"];
    //查询固件版本
    WEAKSELF
    [NetworkManager queryFirmwareVersionWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (resultCode == 0 && [data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = data;
                OnlineFirmwareVersionModel *model = [OnlineFirmwareVersionModel currentModel];
                model.currentVersion = DHIsNotEmpty(dict, @"fromVersion") ? [dict objectForKey:@"fromVersion"] : @"";
                model.onlineVersion = DHIsNotEmpty(dict, @"toVersion") ? [dict objectForKey:@"toVersion"] : @"";
                model.filePath = DHIsNotEmpty(dict, @"downloadUrl") ? [dict objectForKey:@"downloadUrl"] : @"";
                model.fileSize = DHIsNotEmpty(dict, @"size") ? [[dict objectForKey:@"size"] integerValue] : 0;
                model.desc = DHIsNotEmpty(dict, @"summary") ? [dict objectForKey:@"summary"] : @"";
                [model saveOrUpdate];
                
                weakSelf.onlineModel = model;
                                
                [weakSelf updateOtaViewCell];
            }
        });
    }];
}

- (void)updateOtaViewCell {
    //刷新OTA信息
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)queryDialArray {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DHMacAddr forKey:@"deviceId"];
    [dict setObject:[[LanguageManager shareInstance] getHttpLanguageType] forKey:@"language"];

    WEAKSELF
    [NetworkManager queryMainRecommendDialWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (resultCode == 0 && [data isKindOfClass:[NSArray class]]) {
                NSArray *array = (NSArray *)data;
                if (array.count == 3) {
                    [weakSelf updateDialViewCell:array];
                }
            } else {
                if (weakSelf.requestCount < 3 && DHDeviceBinded) {
                    weakSelf.requestCount++;
                    [weakSelf performSelector:@selector(queryDialArray) withObject:nil afterDelay:3.0];
                }
            }
        });
    }];
}

- (void)updateDialViewCell:(NSArray *)array {
    NSMutableArray *dialArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSDictionary *item = array[i];
        DialMarketSetModel *model = [[DialMarketSetModel alloc] init];
        model.name = DHIsNotEmpty(item, @"name") ? [item objectForKey:@"name"] : @"";
        model.thumbnailPath = DHIsNotEmpty(item, @"previewUrl") ? [item objectForKey:@"previewUrl"] : @"";
        model.imagePath = DHIsNotEmpty(item, @"previewUrl") ? [item objectForKey:@"previewUrl"] : @"";
        model.filePath = DHIsNotEmpty(item, @"downloadUrl") ? [item objectForKey:@"downloadUrl"] : @"";
        model.fileSize = DHIsNotEmpty(item, @"size") ? [[item objectForKey:@"size"] integerValue] : 0;
        model.downlaod = DHIsNotEmpty(item, @"useCount") ? [[item objectForKey:@"useCount"] integerValue] : 0;
        model.price = 0;
        model.desc = DHIsNotEmpty(item, @"description") ? [item objectForKey:@"description"] : @"";
        model.dialId = DHIsNotEmpty(item, @"id") ? [[item objectForKey:@"id"] integerValue] : 0;
        [dialArray addObject:model];
    }
    self.dialArray = [NSMutableArray arrayWithArray:dialArray];
    //刷新表盘信息
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)addObservers {
    
    //监听设备解绑
    [DHNotificationCenter addObserver:self selector:@selector(unBindDeviceNotification) name:BluetoothNotificationAutoUnBindDevice object:nil];
    //监听设备连接状态
    [DHNotificationCenter addObserver:self selector:@selector(connectStateChange) name:BluetoothNotificationConnectStateChange object:nil];
    //监听设备信息更新
    [DHNotificationCenter addObserver:self selector:@selector(deviceInfoChange) name:BluetoothNotificationDeviceInfoChange object:nil];
    //监听电量信息更新
    [DHNotificationCenter addObserver:self selector:@selector(batteryInfoChange) name:BluetoothNotificationBatteryInfoChange object:nil];
    
    //监听设备功能表更新
    [DHNotificationCenter addObserver:self selector:@selector(deviceFunctionChange) name:BluetoothNotificationDeviceFunctionChange object:nil];
    //监听表盘信息变化
    [DHNotificationCenter addObserver:self selector:@selector(dialInfoChange) name:BluetoothNotificationDialInfoChange object:nil];
    
    //监听数据同步完成
    [DHNotificationCenter addObserver:self selector:@selector(dataSyncingCompleted) name:BluetoothNotificationDataSyncingCompleted object:nil];
    
    //监听重新绑定设备
    [DHNotificationCenter addObserver:self selector:@selector(connectHistoricalDevice) name:BluetoothNotificationConnectHistoricalDevice object:nil];
}

- (void)unBindDeviceNotification {
    [self initData];
    [self.myTableView reloadData];
}

- (void)deviceInfoChange {
    
    NSLog(@"deviceInfoChange");
    
    //刷新设备信息
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self activatingDevice];
    [self queryFirmwareVersion];
//    [self getModelInfo];
    [self queryDialArray];
}

- (void)batteryInfoChange {
    //刷新设备信息
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.deviceInfoCell){
        [self.deviceInfoCell updateCell];
    }
}

- (void)connectStateChange {
    NSString *imageStr = DHDeviceConnected ? @"public_nav_connected" : @"public_nav_disconnected";
    NSString *titleStr = DHDeviceConnected ? Lang(@"str_connected") : Lang(@"str_disconnected");
    [self.homeNavigationView.navLeftButton setImage:DHImage(imageStr) forState:UIControlStateNormal];
    self.homeNavigationView.navTitleLabel.text = titleStr;
}

- (void)dataSyncingCompleted {
    
    NSLog(@"dataSyncingCompleted");
    if (self.isReadyUnbind) {
        self.isReadyUnbind = NO;
        [self onUnbind];
    }
}

- (void)deviceFunctionChange {
    [self initData];
    [self.myTableView reloadData];
}

- (void)dialInfoChange {
    [self initData];
    [self.myTableView reloadData];
    
}

- (void)connectHistoricalDevice {
    [self initData];
    [self.myTableView reloadData];
    
    self.requestCount = 1;
    [self delayPerformBlock:^(id  _Nonnull object) {
        [self queryDialArray];
    } WithTime:0.5];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(kNavAndStatusHeight);
    }];
    
    NSString *imageStr = DHDeviceConnected ? @"public_nav_connected" : @"public_nav_disconnected";
    NSString *titleStr = DHDeviceConnected ? Lang(@"str_connected") : Lang(@"str_disconnected");
    [self.homeNavigationView.navLeftButton setImage:DHImage(imageStr) forState:UIControlStateNormal];
    self.homeNavigationView.navTitleLabel.text = titleStr;
}

- (void)navRightButton1Click:(UIButton *)sender {
    if (DHDeviceBinded) {
        [self showUnbindTips];
        return;
    }
    if ([DHBleCentralManager isPoweredOff]) {
        SHOWHUD(Lang(@"str_bluetooth_poweroff"))
        return;
    }
    ScanViewController *vc = [[ScanViewController alloc] init];
    vc.navTitle = Lang(@"str_device_scan");
    vc.navRightImage = @"public_nav_refresh";
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)navRightButton2Click:(UIButton *)sender {
    if (DHDeviceBinded) {
        [self showUnbindTips];
        return;
    }
    if ([DHBleCentralManager isPoweredOff]) {
        SHOWHUD(Lang(@"str_bluetooth_poweroff"))
        return;
    }
    QRCodeViewController *vc = [[QRCodeViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.navTitle = Lang(@"str_device_scan_qrcode");
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showUnbindTips {
    WEAKSELF
    if (DHDeviceConnected) {
        BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [alertView showWithTitle:@""
                         message:Lang(@"str_device_unbind_tips")
                          cancel:Lang(@"str_cancel")
                         confirm:Lang(@"str_sure")
             textAlignmentCenter:YES
                           block:^(BaseAlertViewClickType type) {
            if (type == BaseAlertViewClickTypeConfirm) {
//                weakSelf.isReadyUnbind = YES;
//                [[DHBluetoothManager shareInstance] startDataSyncing];
                [self onUnbind];
            }
        }];
    } else {
        BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [alertView showWithTitle:@""
                         message:Lang(@"str_disconnect_unbinding_tips")
                          cancel:Lang(@"str_cancel")
                         confirm:Lang(@"str_sure")
             textAlignmentCenter:YES
                           block:^(BaseAlertViewClickType type) {
            if (type == BaseAlertViewClickTypeConfirm) {
                [weakSelf unbindSuccess];
            }
        }];
    }
}

- (void)onUnbind {
    WEAKSELF
    [DHBleCommand controlUnbind:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf unbindSuccess];
        } else {
            SHOWHUD(Lang(@"str_unbinding_failed"))
        }
    }];

}

- (void)unbindSuccess {
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
    
    //清理当天步数数据,防止按小时计算时叠加
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyyMMdd"];
    DailyStepModel *stepModel = [DailyStepModel currentModel:[dayFormatter stringFromDate:[NSDate date]]];
    if (stepModel){
        [stepModel deleteObject];
    }
    
    [ConfigureModel shareInstance].macAddr = @"";
    [ConfigureModel archiveraModel];
    
    [DHBluetoothManager shareInstance].isBinded = NO;
    [DHBluetoothManager shareInstance].deviceName = Lang(@"str_disconnected");
    [DHBluetoothManager shareInstance].firmwareVersion = @"";
    
    [DHBluetoothManager shareInstance].dialInfoModel = [DialInfoSetModel currentModel];
    [DHBluetoothManager shareInstance].batteryModel = [[DHBatteryInfoModel alloc] init];
    [DHBluetoothManager shareInstance].batteryModel.battery = 50;
        
    //设备手动解绑
    [DHNotificationCenter postNotificationName:BluetoothNotificationHandUnBindDevice object:nil];
    
    [self initData];
    [self.myTableView reloadData];
    [self delayPerformBlock:^(id  _Nonnull object) {
        [BaseView showBluetoothUnpaired];
    } WithTime:1.0];
}

- (void)onFindDevice {
    
//    if ([DHBleCentralManager isJLProtocol]){
//        TestOTAController *TestOTAC = [[TestOTAController alloc] initWithNibName:@"TestOTAController" bundle:nil];
//        TestOTAC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:TestOTAC animated:YES];
//    }
//    else{
        [DHBleCommand controlFindDeviceBegin:^(int code, id  _Nonnull data) {
            
        }];
//    }
}

- (void)switchViewValueChanged:(UISwitch *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        sender.on = !sender.isOn;
        return;
    }
    
    [ConfigureModel shareInstance].isWeather = YES;
    
    if (sender.tag == 1000) {
        for (MWBaseCellModel *cellModel in self.dataArray) {
            if ([cellModel.leftTitle isEqualToString:Lang(@"str_take_photo")]) {
                cellModel.isOpen = sender.isOn;
                break;
            }
        }
        [ConfigureModel shareInstance].isCamera = sender.isOn;
        [ConfigureModel archiveraModel];
    } else if (sender.tag == 2000) {
        for (MWBaseCellModel *cellModel in self.dataArray) {
            if ([cellModel.leftTitle isEqualToString:Lang(@"str_weather")]) {
                cellModel.isOpen = sender.isOn;
                break;
            }
        }
        [ConfigureModel shareInstance].isWeather = sender.isOn;
        [ConfigureModel archiveraModel];
        
        if (sender.isOn) {
            [WeatherManager shareInstance].requestCount = 1;
            [[WeatherManager shareInstance] getLocationInfoAndRequestWeather];
        }
    }
    SHOWHUD(Lang(@"str_save_success"))
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        return self.deviceCellH;
    }
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_dial_market")]) {
        return self.dialCellH;
    }
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        if (DHDeviceBinded) {
            //设备信息
            DeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceInfoCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            [cell updateCell];
            [cell updateRedPoint:self.onlineModel.onlineVersion];
            
            NSLog(@"dialServiceInfoModel.showUrl %@", [DHBluetoothManager shareInstance].dialServiceInfoModel.showUrl);
            if ([DHBluetoothManager shareInstance].dialServiceInfoModel.showUrl){
                [cell updateDeviceImageView:[DHBluetoothManager shareInstance].dialServiceInfoModel.showUrl];
            }
            
            self.deviceInfoCell = cell;
            
            return cell;
        }
        //绑定设备
        DeviceBindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceBindCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_dial_market")]) {
        //表盘市场
        DeviceDialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDialCell" forIndexPath:indexPath];
        [cell setupSubViews];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dialArray = self.dialArray;
        cell.delegate = self;
        return cell;
    }
    
    //功能列表
    MWBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWBaseTableCell" forIndexPath:indexPath];
    cell.model = cellModel;
    if (!cellModel.isHideSwitch) {
        cell.switchView.tag = cellModel.switchViewTag;
        [cell.switchView addTarget:self action:@selector(switchViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    if ([cellModel.leftTitle isEqualToString:@"deviceInfo"] ||
        [cellModel.leftTitle isEqualToString:Lang(@"str_dial_market")] ||
        [cellModel.leftTitle isEqualToString:Lang(@"str_weather")]) {
//        SHOWHUD(Lang(@"条目不能点击"))
        DHSaveLog(@"条目不能点击");
        return;
    }
    
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_take_photo")]) {
        if (!DHDeviceConnected) {
            SHOWHUD(Lang(@"str_device_disconnected"))
            return;
        }
        if (![ConfigureModel shareInstance].isCamera) {
            SHOWHUD(Lang(@"str_please_open_camera"))
            return;
        }
        [DHBleCommand controlCamera:1 block:^(int code, id  _Nonnull data) {
            
        }];
        CameraViewController *cameraVC = [[CameraViewController alloc] init];
        cameraVC.isHideNavigationView = YES;
        cameraVC.hidesBottomBarWhenPushed = YES;
        cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [DHBluetoothManager shareInstance].isTakingPictures = YES;
        [self presentViewController:cameraVC animated:YES completion:nil];
        return;
    }
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_long_sit")]) {
        SedentarySetViewController *vc = [[SedentarySetViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_drink")]) {
        DrinkingSetViewController *vc = [[DrinkingSetViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_warn_model")]) {
        if ([DHBleCentralManager isJLProtocol]){
            NSLog(@"杰里不支持！");
        }
        else{
            ReminderModeSetViewController *vc = [[ReminderModeSetViewController alloc] init];
            vc.navTitle = cellModel.leftTitle;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_screen_light")]) {
        GuestureSetViewController *vc = [[GuestureSetViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_alarm")]) {
        AlarmHomeViewController *vc = [[AlarmHomeViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_screen_long")]) {
        BrightTimeSetViewController *vc = [[BrightTimeSetViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_hr_watcher")]) {
        HeartRateSetViewController *vc = [[HeartRateSetViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_no_disturb")]) {
        DisturbModeSetViewController *vc = [[DisturbModeSetViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_address_book")]) {
        ContactListViewController *vc = [[ContactListViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_msg_push")]) {
        if ([DHBleCentralManager isJLProtocol]){
            AncsJLSetViewController *vc = [[AncsJLSetViewController alloc] init];
            vc.navTitle = cellModel.leftTitle;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            AncsSetViewController *vc = [[AncsSetViewController alloc] init];
            vc.navTitle = cellModel.leftTitle;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_search_device")]) {
        [self onFindDevice];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_qrcode_manager")]) {
        if ([DHBleCentralManager isJLProtocol]){
            NSLog(@"杰里不支持！");
        }
        else{
            QRCodeListViewController *vc = [[QRCodeListViewController alloc] init];
            vc.navTitle = cellModel.leftTitle;
            vc.isHideNavRightButton = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_breath_training")]) {
        if ([DHBleCentralManager isJLProtocol]){
            NSLog(@"杰里不支持！");
        }
        else{
            BreathSetViewController *vc = [[BreathSetViewController alloc] init];
            vc.navTitle = cellModel.leftTitle;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_menstrual_cycle_reminder")]) {
        MenstrualCycleViewController *vc = [[MenstrualCycleViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_more")]) {
        MoreFuncViewController *vc = [[MoreFuncViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (DHDeviceBinded) {
        return 60.0;
    }
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (DHDeviceBinded) {
        return  self.footerView;
    }
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

#pragma mark - MoreFuncViewControllerDelegate

- (void)restoreSuccess {
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
    
    [DHBluetoothManager shareInstance].isBinded = NO;
    [DHBluetoothManager shareInstance].deviceName = Lang(@"str_disconnected");
    [DHBluetoothManager shareInstance].firmwareVersion = @"";
    
    [DHBluetoothManager shareInstance].dialInfoModel = [DialInfoSetModel currentModel];
    [DHBluetoothManager shareInstance].batteryModel = [[DHBatteryInfoModel alloc] init];
    [DHBluetoothManager shareInstance].batteryModel.battery = 50;
    
    //设备手动解绑
    [DHNotificationCenter postNotificationName:BluetoothNotificationHandUnBindDevice object:nil];
    
    [self initData];
    [self.myTableView reloadData];
    [self delayPerformBlock:^(id  _Nonnull object) {
        [BaseView showBluetoothUnpaired];
    } WithTime:1.0];
}

#pragma mark - DeviceInfoCellDelegate

- (void)onConfirmOTA:(BOOL)isHideRedPoint {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    if (isHideRedPoint) {
        SHOWHUD(Lang(@"str_is_latest_version"))
        return;
    }
    OTAViewController *vc = [[OTAViewController alloc] init];
    vc.navTitle = Lang(@"str_ota");
    vc.isHideNavRightButton = YES;
    vc.delegate = self;
    vc.onlieModel = self.onlineModel;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - OTAViewControllerDelegate

- (void)deviceOtaSucceed:(OnlineFirmwareVersionModel *)model {
    self.onlineModel = model;
    [self updateOtaViewCell];
}

#pragma mark - DialDetailViewControllerDelegate

- (void)dialUploadSuccess:(NSInteger)dialId {
    for (DialMarketSetModel *model in self.dialArray) {
        if (model.dialId == dialId) {
            model.downlaod = model.downlaod++;
            break;
        }
    }
    //刷新表盘信息
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - DeviceDialCellDelegate

- (void)onMoreDials {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    DialMarketViewController *vc = [[DialMarketViewController alloc] init];
    vc.navTitle = Lang(@"str_dial_market");
    vc.isHideNavRightButton = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onDial:(nullable DialMarketSetModel *)model {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    if (!model) {
        return;
    }
    DialDetailViewController *vc = [[DialDetailViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.navTitle = Lang(@"str_dial_detail");
    vc.model = model;
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ScanViewControllerDelegate

- (void)deviceBindedSucceed:(DeviceModel *)model {
    [DHBluetoothManager shareInstance].deviceName = model.name;

    [self initData];
    [self.myTableView reloadData];
    
    self.requestCount = 1;
    [self delayPerformBlock:^(id  _Nonnull object) {
        [self queryDialArray];
    } WithTime:0.5];
}

#pragma mark - DeviceBindCellDelegate

- (void)onBind {
    if ([DHBleCentralManager isPoweredOff]) {
        SHOWHUD(Lang(@"str_bluetooth_poweroff"))
        return;
    }
    ScanViewController *vc = [[ScanViewController alloc] init];
    vc.navTitle = Lang(@"str_device_scan");
    vc.navRightImage = @"public_nav_refresh";
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[MWBaseTableCell class] forCellReuseIdentifier:@"MWBaseTableCell"];
        [_myTableView registerClass:[DeviceInfoCell class] forCellReuseIdentifier:@"DeviceInfoCell"];
        [_myTableView registerClass:[DeviceDialCell class] forCellReuseIdentifier:@"DeviceDialCell"];
        [_myTableView registerClass:[DeviceUnbindCell class] forCellReuseIdentifier:@"DeviceUnbindCell"];
        [_myTableView registerClass:[DeviceBindCell class] forCellReuseIdentifier:@"DeviceBindCell"];
        
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _footerView.backgroundColor = HomeColor_BackgroundColor;
        
        UIView *addView = [[UIView alloc] init];
        addView.layer.cornerRadius = 10;
        addView.layer.masksToBounds = YES;
        addView.userInteractionEnabled = YES;
        addView.backgroundColor = HomeColor_BlockColor;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUnbindTips)];
        [addView addGestureRecognizer:tapGesture];
        [_footerView addSubview:addView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor redColor];
        titleLabel.font = HomeFont_TitleFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = Lang(@"str_unbind");
        [addView addSubview:titleLabel];
        
        [addView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(HomeViewSpace_Left);
            make.right.offset(-HomeViewSpace_Right);
            make.bottom.offset(-10);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(addView);
        }];
        
    }
    return _footerView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray <DialMarketSetModel *>*)dialArray {
    if (!_dialArray) {
        _dialArray = [NSMutableArray array];
    }
    return _dialArray;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"deviceInfo",
                    
                    Lang(@"str_dial_market"),
                    Lang(@"str_msg_push"),
                    Lang(@"str_take_photo"),
                    Lang(@"str_search_device"),
                    Lang(@"str_long_sit"),
                    
                    Lang(@"str_drink"),
                    Lang(@"str_warn_model"),
                    Lang(@"str_alarm"),
                    Lang(@"str_screen_light"),
                    Lang(@"str_screen_long"),
                    
                    Lang(@"str_hr_watcher"),
                    Lang(@"str_no_disturb"),
                    Lang(@"str_weather"),
                    Lang(@"str_address_book"),
                    Lang(@"str_qrcode_manager"),
                    
                    Lang(@"str_breath_training"),
                    Lang(@"str_menstrual_cycle_reminder"),
                    
                    Lang(@"str_more")];
    }
    return _titles;
}

- (NSArray *)images {
    if (!_images) {
            _images = @[@"",
        @"",
        @"device_func_ancs",
        @"device_func_camera",
        @"device_func_findDevice",
        @"device_func_sedentary",
        
        @"device_func_drinking",
        @"device_func_reminderMode",
        @"device_func_alarm",
        @"device_func_guesture",
        @"device_func_brightTime",
        
        @"device_func_heartRate",
        @"device_func_disturbMode",
        @"device_func_weather",
        @"device_func_contact",
        @"device_func_qrcode",
        
        @"device_func_breath",
        @"device_func_menstrualCycle",
        
        @"device_func_more"];
    }
    return _images;
}

@end
