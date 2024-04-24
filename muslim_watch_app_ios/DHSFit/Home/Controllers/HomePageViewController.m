//
//  HomePageViewController.m
//  DHSFit
//
//  Created by DHS on 2022/9/14.
//

#import "HomePageViewController.h"
#import "HomePageSleepCell.h"
#import "HomePageHeartRateCell.h"
#import "HomePageBpCell.h"
#import "HomePageBoCell.h"
#import "HomePageTempCell.h"
#import "HomePageBreathCell.h"
#import "HomePageHeaderView.h"
#import "DataSyncingView.h"
#import "DataUploadManager.h"

#import "StepReportViewController.h"
#import "SleepReportViewController.h"
#import "HRReportViewController.h"
#import "BPReportViewController.h"
#import "BOReportViewController.h"
#import "TempReportViewController.h"
#import "BreathReportViewController.h"
#import "CameraViewController.h"


@interface HomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

#pragma mark UI

/// 列表视图
@property (nonatomic, strong) UICollectionView *myCollectionView;
/// 同步视图
@property (nonatomic, strong) DataSyncingView *syncingView;
/// 头部视图
@property (nonatomic, strong) HomePageHeaderView *headerView;
/// 头部高度
@property (nonatomic, assign) CGFloat headerViewH;

/// 查找手机视图
@property (nonatomic, strong) BaseAlertView *findPhoneAlertView;
/// 是否停止查找手机
@property (nonatomic, assign) BOOL isFindPhoneStop;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// icon
@property (nonatomic, strong) NSArray *images;

@end


@implementation HomePageViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HealthKitManager shareInstance];
    [self initData];
    [self setupUI];
    [self addObservers];
    [self delayUpdateCollectionView];

    [[OnceLocationManager shareInstance] startOnceRequestLocationWithBlock:^(NSString * _Nonnull locationStr) {
        
    }];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    
    self.isFindPhoneStop = YES;
    CGFloat circleH = kScreenWidth/3.0;
    self.headerViewH = 120 + circleH;
    
    [self.dataArray removeAllObjects];
    
    if (DHDeviceBinded) {
        DeviceFuncModel *funcModel = [DeviceFuncModel currentModel];
        for (int i = 0; i < self.titles.count; i++) {
            NSString *titleStr = self.titles[i];
            if ((!funcModel.isSleep && [titleStr isEqualToString:Lang(@"str_sleep_title")]) ||
                (!funcModel.isHeartRate && [titleStr isEqualToString:Lang(@"str_hr_title")]) ||
                (!funcModel.isBp && [titleStr isEqualToString:Lang(@"str_bp_title")]) ||
                (!funcModel.isBo && [titleStr isEqualToString:Lang(@"str_bo_title")]) ||
                (!funcModel.isTemp && [titleStr isEqualToString:Lang(@"str_bt_title")]) ||
                (!funcModel.isBreath && [titleStr isEqualToString:Lang(@"str_breath_training")])) {
                continue;
            }
            HomeCellModel *cellModel = [[HomeCellModel alloc] init];
            if ([titleStr isEqualToString:Lang(@"str_bt_title")]) {
                cellModel.cellType = HealthDataTypeTemp;
            } else if ([titleStr isEqualToString:Lang(@"str_breath_training")]) {
                cellModel.cellType = HealthDataTypeBreath;
            } else {
                cellModel.cellType = i+1;
            }
            cellModel.leftImage = self.images[i];
            cellModel.leftTitle = self.titles[i];
            cellModel.dataModel = [HealthDataManager dayChartDatas:[NSDate date] type:cellModel.cellType];
            if (cellModel.cellType != HealthDataTypeBreath) {
                cellModel.chartModel = [HealthDataManager homeCellChartModel:[NSDate date] type:cellModel.cellType];
            }
            [self.dataArray addObject:cellModel];
        }
    } else {
        for (int i = 0; i < self.titles.count; i++) {
            NSString *titleStr = self.titles[i];
            if (([titleStr isEqualToString:Lang(@"str_hr_title")]) ||
                ([titleStr isEqualToString:Lang(@"str_bp_title")]) ||
                ([titleStr isEqualToString:Lang(@"str_bo_title")]) ||
                ([titleStr isEqualToString:Lang(@"str_bt_title")]) ||
                ([titleStr isEqualToString:Lang(@"str_breath_training")])) {
                continue;
            }
            
            HomeCellModel *cellModel = [[HomeCellModel alloc] init];
            if ([titleStr isEqualToString:Lang(@"str_bt_title")]) {
                cellModel.cellType = HealthDataTypeTemp;
            } else if ([titleStr isEqualToString:Lang(@"str_breath_training")]) {
                cellModel.cellType = HealthDataTypeBreath;
            } else {
                cellModel.cellType = i + 1;
            }
            
            cellModel.leftImage = self.images[i];
            cellModel.leftTitle = self.titles[i];
            cellModel.dataModel = [HealthDataManager dayChartDatas:[NSDate date] type:cellModel.cellType];
            if (cellModel.cellType != HealthDataTypeBreath) {
                cellModel.chartModel = [HealthDataManager homeCellChartModel:[NSDate date] type:cellModel.cellType];
            }
            [self.dataArray addObject:cellModel];
        }
    }
    
}

- (void)addObservers {
    //监听设备解绑
    [DHNotificationCenter addObserver:self selector:@selector(unBindDeviceNotification) name:BluetoothNotificationAutoUnBindDevice object:nil];
    [DHNotificationCenter addObserver:self selector:@selector(unBindDeviceNotification) name:BluetoothNotificationHandUnBindDevice object:nil];
    //监听设备连接状态
    [DHNotificationCenter addObserver:self selector:@selector(connectStateChange) name:BluetoothNotificationConnectStateChange object:nil];
    //监听功能表变化
    [DHNotificationCenter addObserver:self selector:@selector(deviceFuncNotification) name:BluetoothNotificationDeviceFunctionChange object:nil];
    //监听开始寻找手机通知
    [DHNotificationCenter addObserver:self selector:@selector(findPhoneStartNotification) name:BluetoothNotificationFindPhoneStart object:nil];
    //监听结束寻找手机通知
    [DHNotificationCenter addObserver:self selector:@selector(findPhoneEndNotification) name:BluetoothNotificationFindPhoneEnd object:nil];
    
    //监听公英制变化
    [DHNotificationCenter addObserver:self selector:@selector(appDistanceUnitChange) name:AppNotificationDistanceUnitChange object:nil];
    //监听单位变化
    [DHNotificationCenter addObserver:self selector:@selector(appTempUnitChange) name:AppNotificationTempUnitChange object:nil];
    
    //监听数据同步开始
    [DHNotificationCenter addObserver:self selector:@selector(dataSyncingNotification:) name:BluetoothNotificationDataSyncing object:nil];
    //监听健康数据变化
    [DHNotificationCenter addObserver:self selector:@selector(healthDataChange:) name:BluetoothNotificationHealthDataChange object:nil];
    //监听游客绑定新用户
    [DHNotificationCenter addObserver:self selector:@selector(visitorChange) name:AppNotificationVisitorChange object:nil];
    
    [DHNotificationCenter addObserver:self selector:@selector(healthDataDownloadCompleted) name:BluetoothNotificationHealthDataDownloadCompleted object:nil];
    
    //监听打开相机
    [DHNotificationCenter addObserver:self selector:@selector(cameraTurnOnNotification) name:BluetoothNotificationCameraTurnOn object:nil];
    //监听拍照
    [DHNotificationCenter addObserver:self selector:@selector(cameraTakePictureNotification) name:BluetoothNotificationCameraTakePicture object:nil];
    //监听目标变化
    [DHNotificationCenter addObserver:self selector:@selector(stepGoalChange) name:AppNotificationStepGoalChange object:nil];
    
}

#pragma mark - NSNotification

- (void)dataSyncingNotification:(NSNotification *)sender {
    //同步中
    if ([DHBluetoothManager shareInstance].isDataSyncing) {
        return;
    }
    //运动中
    if ([RunningManager shareInstance].isRunning && [RunningManager shareInstance].isConnected) {
        return;
    }
    if (self.syncingView) {
        self.syncingView = nil;
    }
    self.syncingView = [[DataSyncingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.syncingView showSyncingView];
    
    [self startDataSyncing];
    [self performSelector:@selector(checkDataSyncingTimeout) withObject:nil afterDelay:30.0];
}

- (void)checkDataSyncingTimeout {
    if ([DHBluetoothManager shareInstance].isDataSyncing) {
        [DHBluetoothManager shareInstance].isDataSyncing = NO;
        if (self.syncingView) {
            self.syncingView.progress = -1;
        }
    }
}

- (void)startDataSyncing {
    [DHBluetoothManager shareInstance].isDataSyncing = YES;
    WEAKSELF
    [DHBleCommand startDataSyncing:^(int code, int progress, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (code == 0) {
                if ([data isKindOfClass:[NSArray class]]) {
                    NSArray *array = data;
                    for (id model in array) {
                        if ([model isKindOfClass:[DHDailyStepModel class]]) {
                            [HealthDataManager saveDailyStepModel:model];
                        } else if ([model isKindOfClass:[DHDailySleepModel class]]) {
                            [HealthDataManager saveDailySleepModel:model];
                        } else if ([model isKindOfClass:[DHDailyHrModel class]]) {
                            [HealthDataManager saveDailyHrModel:model];
                        } else if ([model isKindOfClass:[DHDailyBpModel class]]) {
                            [HealthDataManager saveDailyBpModel:model];
                        } else if ([model isKindOfClass:[DHDailyBoModel class]]) {
                            [HealthDataManager saveDailyBoModel:model];
                        } else if ([model isKindOfClass:[DHDailyTempModel class]]) {
                            [HealthDataManager saveDailyTempModel:model];
                        } else if ([model isKindOfClass:[DHDailyBreathModel class]]) {
                            [HealthDataManager saveDailyBreathModel:model];
                        } else if ([model isKindOfClass:[DHDailySportModel class]]) {
                            [HealthDataManager saveDailySportModel:model];
                            //运动数据更新
                            [DHNotificationCenter postNotificationName:BluetoothNotificationSportDataChange object:nil];
                        }
                    }
                }
                weakSelf.syncingView.progress = progress;
                if (progress >= 100) {
                    [weakSelf updateCollectionView];
                    [weakSelf performSelector:@selector(setAppStatus) withObject:nil afterDelay:1.5];
                    //数据同步完成
                    [DHNotificationCenter postNotificationName:BluetoothNotificationDataSyncingCompleted object:nil];
                    [DHBluetoothManager shareInstance].isDataSyncing = NO;
                    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(checkDataSyncingTimeout) object:nil];
                    [DataUploadManager uploadAllHealthData];
                }
            } else {
                weakSelf.syncingView.progress = -1;
                [weakSelf performSelector:@selector(setAppStatus) withObject:nil afterDelay:1.5];
                //数据同步完成
                [DHNotificationCenter postNotificationName:BluetoothNotificationDataSyncingCompleted object:nil];
                [DHBluetoothManager shareInstance].isDataSyncing = NO;
                [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(checkDataSyncingTimeout) object:nil];
            }
        });
    }];
}

- (void)healthDataChange:(NSNotification *)sender {
    NSDictionary *dict = sender.userInfo;
    NSInteger type = [dict[@"type"] integerValue];

    if (type == 0) {
        self.headerView.model = [HealthDataManager dayChartDatas:[NSDate date] type:HealthDataTypeStep];
    } else {
        type += 1;
        for (int i = 0; i < self.dataArray.count; i++) {
            HomeCellModel *cellModel = self.dataArray[i];
            if (cellModel.cellType == type) {
                cellModel.dataModel = [HealthDataManager dayChartDatas:[NSDate date] type:cellModel.cellType];
                if (type != HealthDataTypeBreath) {
                    cellModel.chartModel = [HealthDataManager homeCellChartModel:[NSDate date] type:cellModel.cellType];
                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.myCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                break;
            }
        }
    }
}

- (void)stepGoalChange {
    self.headerView.model = [HealthDataManager dayChartDatas:[NSDate date] type:HealthDataTypeStep];
}

- (void)appDistanceUnitChange {
    self.headerView.model = [HealthDataManager dayChartDatas:[NSDate date] type:HealthDataTypeStep];
}

- (void)appTempUnitChange {
    for (int i = 0; i < self.dataArray.count; i++) {
        HomeCellModel *cellModel = self.dataArray[i];
        if (cellModel.cellType == HealthDataTypeTemp) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.myCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            break;
        }
    }
}

- (void)visitorChange {
    [self updateCollectionView];
    [self uploadAvatar];
}

- (void)unBindDeviceNotification {
    [self updateCollectionView];
}

- (void)healthDataDownloadCompleted {
    [self updateCollectionView];
}

- (void)connectStateChange {
    NSString *imageStr = DHDeviceConnected ? @"public_nav_connected" : @"public_nav_disconnected";
    NSString *titleStr = DHDeviceConnected ? Lang(@"str_connected") : Lang(@"str_disconnected");
    [self.homeNavigationView.navLeftButton setImage:DHImage(imageStr) forState:UIControlStateNormal];
    self.homeNavigationView.navTitleLabel.text = titleStr;
}

- (void)deviceFuncNotification {
    [self updateCollectionView];
}

- (void)findPhoneStartNotification {
    if (self.isFindPhoneStop) {
        self.isFindPhoneStop = NO;
        if (!self.findPhoneAlertView) {
            [self showFindPhoneTips];
        }
        [self callBell];
    }
}

- (void)findPhoneEndNotification {
    if (self.findPhoneAlertView) {
        [self.findPhoneAlertView hideCustomAlertView];
        self.isFindPhoneStop = YES;
        self.findPhoneAlertView = nil;
    }
}

- (void)showFindPhoneTips {
    self.findPhoneAlertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WEAKSELF
    [self.findPhoneAlertView showWithTitle:@""
                     message:Lang(@"str_cancel_search_device")
                      cancel:@""
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            weakSelf.isFindPhoneStop = YES;
            weakSelf.findPhoneAlertView = nil;
            [DHBleCommand controlFindPhoneEnd:^(int code, id  _Nonnull data) {
                
            }];
        }
    }];
}

- (void)callBell {
    SystemSoundID sound = kSystemSoundID_Vibrate;
    if (self.isFindPhoneStop) {
        AudioServicesDisposeSystemSoundID(sound);
    } else {
        
        NSString *path = @"/System/Library/Audio/UISounds/sms-received6.caf";
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        if (error != kAudioServicesNoError) {
            sound = 0;
        }
        
        AudioServicesPlaySystemSound(sound);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callBell) object:nil];
        [self performSelector:@selector(callBell) withObject:nil afterDelay:1];
    }
}

- (void)setAppStatus {
    if (![DHBleCentralManager isJLProtocol]){
        [[DHBluetoothManager shareInstance] setAppStatus];
        [self performSelector:@selector(getClassicBleInfo) withObject:nil afterDelay:1.0];
    }
    else{
        [self setWeatherInfo];
    }
}

- (void)getClassicBleInfo {
    if (![ConfigureModel shareInstance].isNeedConnect) {
        [self setWeatherInfo];
        return;
    }
    
    DeviceFuncModel *funcModel = [DeviceFuncModel currentModel];
    if (!funcModel.isBle3) {
        [ConfigureModel shareInstance].isNeedConnect = NO;
        [ConfigureModel archiveraModel];
        [self setWeatherInfo];
        return;
    }
    WEAKSELF
    [DHBleCommand getClassicBle:^(int code, id  _Nonnull data) {
        if (code == 0) {
            DHDeviceInfoModel *model = data;
            if (model.isNeedConnect) {
                //需要连接
                if (model.name.length) {
                    [weakSelf setClassicBleInfo:model.name];
                    [ConfigureModel shareInstance].isNeedConnect = NO;
                    [ConfigureModel archiveraModel];
                }
            } else {
                //不需要连接
                [ConfigureModel shareInstance].isNeedConnect = NO;
                [ConfigureModel archiveraModel];
            }
            
            [weakSelf setWeatherInfo];
        }
    }];
}

- (void)setClassicBleInfo:(NSString *)deviceName {

    NSString *message = [NSString stringWithFormat:@"%@\"%@\"",Lang(@"str_bluetooth_permission_message"),deviceName];
    BOOL canOpen = [DHBleCommand classicBluetoothCanOpen];
    if (canOpen) {
        BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [alertView showWithTitle:@""
                         message:message
                          cancel:Lang(@"str_cancel")
                         confirm:Lang(@"str_sure")
             textAlignmentCenter:YES
                           block:^(BaseAlertViewClickType type) {
            if (type == BaseAlertViewClickTypeConfirm) {
                [DHBleCommand classicBluetoothOpen];
            }
        }];
    } else {
        BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [alertView showWithTitle:@""
                         message:message
                          cancel:@""
                         confirm:Lang(@"str_sure")
             textAlignmentCenter:YES
                           block:^(BaseAlertViewClickType type) {
            if (type == BaseAlertViewClickTypeConfirm) {
                
            }
        }];
    }
}

- (void)setWeatherInfo {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayUpdateWeatherInfo) object:nil];
    if (![ConfigureModel shareInstance].isWeather) {
        return;
    }
    DeviceFuncModel *funcModel = [DeviceFuncModel currentModel];
    if (!funcModel.isWeather) {
        return;
    }
    if ([ConfigureModel shareInstance].weatherTime == 0) {
        [WeatherManager shareInstance].requestCount = 1;
        [[WeatherManager shareInstance] getLocationInfoAndRequestWeather];
    } else {
        NSInteger lastTimestamp = [ConfigureModel shareInstance].weatherTime;
        NSInteger currentTimestamp = [[NSDate date] timeIntervalSince1970];
        if (currentTimestamp - lastTimestamp >= 3600) {
            [WeatherManager shareInstance].requestCount = 1;
            [[WeatherManager shareInstance] getLocationInfoAndRequestWeather];
        } else if ([NSDate date].hour >= 23) {
            NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
            NSString *fullTimeStr = [NSString stringWithFormat:@"%@235959",dateStr];
            NSDate *fullDate = [fullTimeStr dateByStringFormat:@"yyyyMMddHHmmss"];
            NSTimeInterval inteval = [fullDate timeIntervalSinceDate:[NSDate date]];
            [self performSelector:@selector(delayUpdateWeatherInfo) withObject:nil afterDelay:inteval+2];
        } else {
            NSInteger inteval = 3600-(currentTimestamp-lastTimestamp);
            [self performSelector:@selector(delayUpdateWeatherInfo) withObject:nil afterDelay:inteval];
        }
    }
}

- (void)delayUpdateWeatherInfo {
    [WeatherManager shareInstance].requestCount = 1;
    [[WeatherManager shareInstance] getLocationInfoAndRequestWeather];
}

- (void)uploadAvatar {
    NSData *data = [DHFile queryLocalImageWithFolderName:DHAvatarFolder fileName:[NSString stringWithFormat:@"%@.png",DHUserId]];
    if (!data) {
        [self uploadUserInfo];
        return;
    }
    UIImage *image = [UIImage imageWithData:data];
    NSData *avatarData = UIImagePNGRepresentation(image);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"file" forKey:@"name"];
    [dict setObject:@"img.png" forKey:@"fileName"];
    [dict setObject:@"image/png" forKey:@"mimeType"];
    
    WEAKSELF
    [NetworkManager uploadFile:avatarData andParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (resultCode == 0) {
                NSDictionary *result = data;
                if (result[@"url"]) {
                    [weakSelf saveAvatarUrl:result[@"url"]];
                    [weakSelf uploadUserInfo];
                }
            } else {
                [weakSelf uploadUserInfo];
            }
        });
    }];
}

- (void)uploadUserInfo {
    UserModel *model = [UserModel currentModel];
        
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:model.name forKey:@"name"];
    [dict setObject:model.birthday forKey:@"birthday"];
    [dict setObject:@(model.height) forKey:@"height"];
    [dict setObject:@(model.weight) forKey:@"weight"];
    [dict setObject:model.avatar forKey:@"portraitUrl"];
    [dict setObject:@(model.stepGoal) forKey:@"sportTarget"];
    NSInteger gender = model.gender == 0 ? 2 : 1;
    [dict setObject:@(gender) forKey:@"sex"];
    
    [NetworkManager updateUserInformWithParameter:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        
    }];
}

- (void)saveAvatarUrl:(NSString *)url {
    UserModel *model = [UserModel currentModel];
    model.avatar = url;
    [model saveOrUpdate];
}

- (void)cameraTurnOnNotification {
    if (![ConfigureModel shareInstance].isCamera) {
        SHOWHUD(Lang(@"str_please_open_camera"))
        return;
    }
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        if (![DHBluetoothManager shareInstance].isTakingPictures) {
            CameraViewController *cameraVC = [[CameraViewController alloc] init];
            cameraVC.isHideNavigationView = YES;
            cameraVC.hidesBottomBarWhenPushed = YES;
            cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
            UIViewController *vc = [self theTopviewControler];
            if (vc) {
                [DHBluetoothManager shareInstance].isTakingPictures = YES;
                [vc presentViewController:cameraVC animated:YES completion:nil];
            }
        }
    });
}

- (void)cameraTakePictureNotification {
    if (![ConfigureModel shareInstance].isCamera) {
        SHOWHUD(Lang(@"str_please_open_camera"))
        return;
    }
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        if (![DHBluetoothManager shareInstance].isTakingPictures) {
            CameraViewController *cameraVC = [[CameraViewController alloc] init];
            cameraVC.isHideNavigationView = YES;
            cameraVC.hidesBottomBarWhenPushed = YES;
            cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
            UIViewController *vc = [self theTopviewControler];
            if (vc) {
                [DHBluetoothManager shareInstance].isTakingPictures = YES;
                [vc presentViewController:cameraVC animated:YES completion:nil];
            }
        }
    });
}

//需要获取到显示在最上面的viewController
- (UIViewController *)theTopviewControler{
    //获取根控制器
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    UIViewController *parent = rootVC;
    //遍历 如果是presentViewController
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
   
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    return rootVC;
}



#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.view addSubview:self.myCollectionView];
    
    NSString *imageStr = DHDeviceConnected ? @"public_nav_connected" : @"public_nav_disconnected";
    NSString *titleStr;
    if (DHDeviceBinded) {
        titleStr = DHDeviceConnected ? Lang(@"str_connected") : Lang(@"str_connecting");
    } else {
        titleStr = DHDeviceConnected ? Lang(@"str_connected") : Lang(@"str_disconnected");
    }
    [self.homeNavigationView.navLeftButton setImage:DHImage(imageStr) forState:UIControlStateNormal];
    self.homeNavigationView.navTitleLabel.text = titleStr;
}

- (void)delayUpdateCollectionView {
    NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
    NSString *fullTimeStr = [NSString stringWithFormat:@"%@235959",dateStr];
    NSDate *fullDate = [fullTimeStr dateByStringFormat:@"yyyyMMddHHmmss"];
    NSTimeInterval inteval = [fullDate timeIntervalSinceDate:[NSDate date]];
    [self performSelector:@selector(updateCollectionView) withObject:nil afterDelay:inteval + 2];
}

- (void)updateCollectionView {
    [self initData];
    [self.myCollectionView reloadData];
    self.headerView.model = [HealthDataManager dayChartDatas:[NSDate date] type:HealthDataTypeStep];
}
    
- (void)navRightButton1Click:(UIButton *)sender {
    [self onShare];
}

- (void)navRightButton2Click:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    if ([DHBluetoothManager shareInstance].isDataSyncing) {
        return;
    }
    if (self.syncingView) {
        self.syncingView = nil;
    }
    self.syncingView = [[DataSyncingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.syncingView showSyncingView];
    
    [self startDataSyncing];
    [self performSelector:@selector(checkDataSyncingTimeout) withObject:nil afterDelay:30.0];
}

- (void)onShare {
    UIImage *imageToShare = [self snapshotScreen];
    NSArray *activityItems = @[imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
        
    };
    activityVC.excludedActivityTypes = @[
        UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,
        UIActivityTypeMessage,UIActivityTypeMail,
        UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,
        UIActivityTypePrint,UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (UIImage *)snapshotScreen {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(self.myCollectionView.contentSize, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.myCollectionView.contentSize);
    }
    CGPoint savedContentOffset =self.myCollectionView.contentOffset;
    CGRect savedFrame =self.myCollectionView.frame;
    CGSize contentSize =self.myCollectionView.contentSize;
    CGRect oldBounds =self.myCollectionView.layer.bounds;
    if(@available(iOS 13, *)){
        [self.myCollectionView.layer setBounds:CGRectMake(oldBounds.origin.x, oldBounds.origin.y, contentSize.width, contentSize.height+20)];
    }
    self.myCollectionView.contentOffset = CGPointZero;
    self.myCollectionView.frame = CGRectMake(0, 0, self.myCollectionView.contentSize.width, self.myCollectionView.contentSize.height+20);
    [self.myCollectionView.layer renderInContext:UIGraphicsGetCurrentContext()];
    if(@available(iOS 13,*)){
        [self.myCollectionView.layer setBounds:oldBounds];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.myCollectionView.frame= savedFrame;
    self.myCollectionView.contentOffset= savedContentOffset;
    
    return image;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HomePageHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeaderView" forIndexPath:indexPath];
        reusableView = headerView;
        headerView.model = [HealthDataManager dayChartDatas:[NSDate date] type:HealthDataTypeStep];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap)];
        [headerView addGestureRecognizer:tap];
        
        self.headerView = headerView;
    }
    return reusableView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    HomeCellModel *cellModel = self.dataArray[indexPath.row];
    if (cellModel.cellType == HealthDataTypeSleep) {
        HomePageSleepCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageSleepCell" forIndexPath:indexPath];
        cell.model = cellModel;
        return cell;
    }
    if (cellModel.cellType == HealthDataTypeHeartRate) {
        HomePageHeartRateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHeartRateCell" forIndexPath:indexPath];
        cell.model = cellModel;
        return cell;
    }
    if (cellModel.cellType == HealthDataTypeBP) {
        HomePageBpCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageBpCell" forIndexPath:indexPath];
        cell.model = cellModel;
        return cell;
    }
    if (cellModel.cellType == HealthDataTypeBO) {
        HomePageBoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageBoCell" forIndexPath:indexPath];
        cell.model = cellModel;
        return cell;
    }
    if (cellModel.cellType == HealthDataTypeTemp) {
        HomePageTempCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageTempCell" forIndexPath:indexPath];
        cell.model = cellModel;
        return cell;
    }
    HomePageBreathCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageBreathCell" forIndexPath:indexPath];
    cell.model = cellModel;
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCellModel *cellModel = self.dataArray[indexPath.row];
    if (cellModel.cellType == HealthDataTypeSleep) {
        SleepReportViewController *vc = [[SleepReportViewController alloc] init];
        vc.cellType = cellModel.cellType;
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (cellModel.cellType == HealthDataTypeHeartRate) {
        HRReportViewController *vc = [[HRReportViewController alloc] init];
        vc.cellType = cellModel.cellType;
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (cellModel.cellType == HealthDataTypeBP) {
        BPReportViewController *vc = [[BPReportViewController alloc] init];
        vc.cellType = cellModel.cellType;
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (cellModel.cellType == HealthDataTypeBO) {
        BOReportViewController *vc = [[BOReportViewController alloc] init];
        vc.cellType = cellModel.cellType;
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (cellModel.cellType == HealthDataTypeTemp) {
        TempReportViewController *vc = [[TempReportViewController alloc] init];
        vc.cellType = cellModel.cellType;
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (cellModel.cellType == HealthDataTypeBreath) {
        BreathReportViewController *vc = [[BreathReportViewController alloc] init];
        vc.cellType = cellModel.cellType;
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)headerViewTap {
    StepReportViewController *vc = [[StepReportViewController alloc] init];
    vc.cellType = HealthDataTypeStep;
    vc.navTitle = Lang(@"str_step_title");
    vc.isHideNavRightButton = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get and set 属性的set和get方法

- (UICollectionView *)myCollectionView {
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((kScreenWidth-45)/2.0, 180);
        layout.minimumLineSpacing = 15.0;
        layout.minimumInteritemSpacing = 15.0;
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, self.headerViewH);
        
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHeight, kScreenWidth, kScreenHeight-kNavAndStatusHeight-kBottomHeight-kTabBarHeight) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = HomeColor_BackgroundColor;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_myCollectionView registerClass:[HomePageSleepCell class] forCellWithReuseIdentifier:@"HomePageSleepCell"];
        [_myCollectionView registerClass:[HomePageHeartRateCell class] forCellWithReuseIdentifier:@"HomePageHeartRateCell"];
        [_myCollectionView registerClass:[HomePageBpCell class] forCellWithReuseIdentifier:@"HomePageBpCell"];
        [_myCollectionView registerClass:[HomePageBoCell class] forCellWithReuseIdentifier:@"HomePageBoCell"];
        [_myCollectionView registerClass:[HomePageTempCell class] forCellWithReuseIdentifier:@"HomePageTempCell"];
        [_myCollectionView registerClass:[HomePageBreathCell class] forCellWithReuseIdentifier:@"HomePageBreathCell"];
//        [_myCollectionView registerNib:[UINib nibWithNibName:@"HomeQuranCell" bundle:nil] forCellWithReuseIdentifier:@"HomeQuranCell"];
        [_myCollectionView registerClass:[HomePageHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeaderView"];
        
    }
    return _myCollectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_sleep_title"),
                    Lang(@"str_hr_title"),
                    Lang(@"str_bp_title"),
                    Lang(@"str_bo_title"),
                    Lang(@"str_breath_training"),
                    Lang(@"str_bt_title")];
    }
    return _titles;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"home_main_sleep",
                    @"home_main_hr",
                    @"home_main_bp",
                    @"home_main_bo",
                    @"home_main_breath",
                    @"home_main_temp"];
    }
    return _images;
}
@end
