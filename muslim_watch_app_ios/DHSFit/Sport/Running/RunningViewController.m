//
//  RunningViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "RunningViewController.h"
#import "SportDetailViewController.h"
#import "RunningView.h"
#import "RunningGPSView.h"
#import "SportSettingsViewController.h"

#define RUN_MIN_MILE 20

@interface RunningViewController ()<RunningViewDelegate,RunningGPSViewDelegate,RunningManagerDelegate>

/// 背景
@property (nonatomic, strong) UIScrollView *myScrollView;
/// 数据视图
@property (nonatomic, strong) RunningView *runningView;
/// GPS视图
@property (nonatomic, strong) RunningGPSView *runningGPSView;
/// 管理器
@property (nonatomic, strong) RunningManager *manager;
/// 最后的位置点
@property (nonatomic, assign) MAMapPoint lastPoint;
/// 用户模型
@property (nonatomic, strong) UserModel *userModel;
/// 运动模型
@property (nonatomic, strong) DailySportModel *model;
/// 步长
@property (nonatomic, assign) NSInteger strideLength;

@end

@implementation RunningViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.manager.goalModel.isAlwaysBright) {
        [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.manager.goalModel.isAlwaysBright) {
        [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self initManager];
    [self initLocation];
    
}

- (void)initManager {

    self.userModel = [UserModel currentModel];
    self.strideLength = [RunningManager kStrideLength:self.userModel.height];
    
    NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
    NSString *timeStr = [[NSDate date] dateToStringFormat:@"yyyyMMddHHmmss"];
        
    self.model = [[DailySportModel alloc] init];
    self.model.isDevice = NO;
    
    self.model.type = self.sportType;
    self.model.date = dateStr;
    self.model.timestamp = [NSDate timeStampFromtimeStr:timeStr];
    
    self.manager = [RunningManager shareInstance];
    self.manager.delegate = self;
    self.manager.isConnected = self.isConnected;
    self.manager.sportType = self.sportType;
    
    [self.manager initData];
    [self.manager startTimer];
    
    
    
}

- (void)initLocation {
    if (self.isGPS) {
        [[LocationManager shareInstance] startUpdatingLocation];
        WEAKSELF
        [LocationManager shareInstance].locationBlock = ^(CLLocation *location) {
            [weakSelf.runningGPSView.dataView updateGpsRssi:location.horizontalAccuracy];
            if (location.horizontalAccuracy > 0 && location.horizontalAccuracy <= 65) {
                [weakSelf addLocation:MAMapPointForCoordinate(location.coordinate)];
            }
        };
        
        [LocationManager shareInstance].headingBlock = ^(CLHeading * _Nonnull heading) {
            [weakSelf updateHeading:heading];
        };
    }
}

//添加新的定位点
- (void)addLocation:(MAMapPoint)point{
    if (self.manager.isRunning) {
        self.lastPoint = MAMapPointMake(point.x, point.y);
        self.runningGPSView.mapView.endPoint = point;
    }
}

- (void)updateHeading:(CLHeading *)heading {
        [self.runningGPSView.mapView updateHeading:heading];
}


#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    if (self.isGPS) {
        CGFloat bgViewH = kScreenHeight-kBottomHeight;
        
        self.myScrollView = [[UIScrollView alloc] init];
        self.myScrollView.scrollEnabled = NO;
        self.myScrollView.pagingEnabled = YES;
        self.myScrollView.showsVerticalScrollIndicator = NO;
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.myScrollView];
        
        [self.myScrollView addSubview:self.runningView];
        [self.myScrollView addSubview:self.runningGPSView];
        
        
        [self.runningView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myScrollView.mas_left);
            make.width.equalTo(self.myScrollView);
            make.top.equalTo(self.myScrollView);
            make.height.equalTo(self.myScrollView);
        }];
        
        [self.runningGPSView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.runningView.mas_right);
            make.top.bottom.equalTo(self.runningView);
            make.width.equalTo(self.runningView);
        }];
        
        [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.height.offset(bgViewH);
            make.right.equalTo(self.runningGPSView.mas_right);
        }];
        
        self.runningGPSView.model = self.model;
        
    } else {
        
        [self.view addSubview:self.runningView];
        [self.runningView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(-kBottomHeight);
        }];
    }
    
}

- (void)showSportEndTips {
    NSString *message = self.model.distance >= RUN_MIN_MILE ? Lang(@"str_sport_end_message") : Lang(@"str_sport_end_nodata_message");
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WEAKSELF
    [alertView showWithTitle:@""
                     message:message
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            [weakSelf endRunning];
        }
    }];
}

- (void)endRunning {
    if (self.isGPS) {
        [[LocationManager shareInstance] endUpdatingLocation];
    }
    [self.manager stopTimer];
    if (self.model.distance < RUN_MIN_MILE) {
        if (self.isGPS) {
            if (self.runningGPSView.mapView.mkMapView.mk_mapView) {
                [self.runningGPSView.mapView.mkMapView.mk_mapView removeFromSuperview];
                self.runningGPSView.mapView.mkMapView.mk_mapView = nil;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //增加不足一公里/英里配速
    [self addLastSportItems];
    
    NSMutableArray *railItems = [NSMutableArray array];
    NSMutableArray *hrItems = [NSMutableArray array];
    
    for (int i = 0; i < self.manager.gpsItems.count; i++) {
        RailModel *model = self.manager.gpsItems[i];
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        //[item setObject:model.timestamp forKey:@"timestamp"];
        [item setObject:@(model.longtitude) forKey:@"longtitude"];
        [item setObject:@(model.latitude) forKey:@"latitude"];
        [railItems addObject:item];
         
    }
    
    if (railItems.count) {
        self.model.gpsItems = [railItems transToJsonString];
    }
    if (hrItems.count) {
        self.model.heartRateItems = [hrItems transToJsonString];
    }
    if (self.manager.metricPaceItems.count) {
        self.model.metricPaceItems = [self.manager.metricPaceItems transToJsonString];
    }
    if (self.manager.imperialPaceItems.count) {
        self.model.imperialPaceItems = [self.manager.imperialPaceItems transToJsonString];
    }
    if (self.manager.strideFrequencyItems.count) {
        self.model.strideFrequencyItems = [self.manager.strideFrequencyItems transToJsonString];
    }
    
    self.model.step = self.manager.totalStep;
    [self.model saveOrUpdate];
    //运动数据更新
    [DHNotificationCenter postNotificationName:BluetoothNotificationSportDataChange object:nil];
    
    if (self.isGPS) {
        //轨迹居中
        self.runningGPSView.mapView.endPoint = self.runningGPSView.mapView.endPoint;
        if (self.runningGPSView.mapView.mkMapView.mk_mapView) {
            [self.runningGPSView.mapView.mkMapView.mk_mapView removeFromSuperview];
            self.runningGPSView.mapView.mkMapView.mk_mapView = nil;
        }
    }
    
    SportDetailViewController *vc = [[SportDetailViewController alloc] init];
    vc.navTitle = Lang(@"str_sport_detail");
    vc.navLeftImage = @"public_nav_back_sport";
    vc.navRightImage = @"public_nav_share";
    vc.model = self.model;
    vc.isEndRunning = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RunningViewDelegate

- (void)onContinue {
    [self.manager continueTimer:self.manager.isAutoPause];
}
- (void)onPause {
    [self.manager pauseTimer:NO];
}
- (void)onEnd {
    [self showSportEndTips];
}

- (void)onMap {
    [self.myScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

- (void)onLocation {
    [self.runningGPSView.mapView backCurrentPoint];
}

- (void)onSettings {
    SportSettingsViewController *vc = [[SportSettingsViewController alloc] init];
    vc.navTitle = Lang(@"str_sport_setting");
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RunningGPSViewDelegate

- (void)onBack {
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - RunningManagerDelegate

- (void)cotinueRunning {
    if (!self.manager.goalModel.isAutoPause) {
        return;
    }
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [self.runningView autoContinueClick];
        [self.manager continueTimer:YES];
    });
    
}

- (void)runningTimeAdd:(NSInteger)duration {
    
    self.model.duration = duration;
    if (self.isGPS) {
        self.model.distance = self.strideLength*(self.manager.totalStep+self.manager.addStep)/100.0;
        self.model.calorie = self.userModel.weight * self.model.distance * 0.8214;
        self.runningGPSView.model = self.model;
    } else {
        self.model.distance = self.strideLength*(self.manager.totalStep+self.manager.addStep)/100.0;
        self.model.calorie = self.userModel.weight * self.model.distance * 0.8214;
    }
    self.runningView.model = self.model;
    [self addSportItems];
    [self checkSportGoal];
    [self checkAutoPause];
    
    if (duration >= 6 * 3600) {
        //达到极限自动结束6小时
        [self endRunning];
    } else {
        //交换数据
        [self.manager controlSportData:self.model Step:(self.manager.totalStep+self.manager.addStep) Stop:NO];
    }
}

- (void)checkAutoPause {
    if (!self.manager.goalModel.isAutoPause) {
        return;
    }
    if (self.manager.isStepChange) {
        self.manager.isStepChange = NO;
        self.manager.pauseCount = 0;
    } else {
        self.manager.pauseCount++;
    }
    
    if (self.manager.pauseCount >= 15) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self.runningView autoPauseClick];
            [self.manager pauseTimer:YES];
        });
    }
}

- (void)checkSportGoal {
    //运动时长
    if (!self.manager.isTimeGoalAchieved) {
        if (self.model.duration >= self.manager.goalModel.duration*60) {
            self.manager.isTimeGoalAchieved = YES;
            SHOWHUD(Lang(@"str_time_goal_reached"))
            if (self.manager.goalModel.isVibration) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
        }
    }
    
    //运动距离
    if (!self.manager.isDistanceGoalAchieved) {
        if (DistanceValue(self.model.distance) >= self.manager.goalModel.distance) {
            self.manager.isDistanceGoalAchieved = YES;
            SHOWHUD(Lang(@"str_distance_goal_reached"))
            if (self.manager.goalModel.isVibration) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
        }
    }
    
    //运动卡路里
    if (!self.manager.isCalorieGoalAchieved) {
        if (self.model.calorie >= self.manager.goalModel.calorie*1000) {
            self.manager.isCalorieGoalAchieved = YES;
            SHOWHUD(Lang(@"str_calorie_goal_reached"))
            if (self.manager.goalModel.isVibration) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
        }
    }
}

- (void)addSportItems {
    CGFloat km = floor(self.model.distance/1000.0);
    CGFloat mi = floor(0.621*self.model.distance/1000.0);
    //公制配速
    if (km > self.manager.metricPaceIndex) {
        self.manager.metricPaceIndex++;
        NSInteger lastDuration = 0;
        if (self.manager.metricPaceItems.count) {
            for (NSDictionary *dict in self.manager.metricPaceItems) {
                lastDuration += [dict[@"value"] integerValue];
            }
        }
        NSInteger pace = self.model.duration-lastDuration;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(self.manager.metricPaceIndex) forKey:@"index"];
        [dict setObject:@(pace) forKey:@"value"];
        [dict setObject:@(1) forKey:@"isInt"];
        [self.manager.metricPaceItems addObject:dict];
    }
    //英制配速
    if (mi > self.manager.imperialPaceIndex) {
        self.manager.imperialPaceIndex++;
        NSInteger lastDuration = 0;
        if (self.manager.imperialPaceItems.count) {
            for (NSDictionary *dict in self.manager.imperialPaceItems) {
                lastDuration += [dict[@"value"] integerValue];
            }
        }
        NSInteger pace = self.model.duration-lastDuration;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(self.manager.imperialPaceIndex) forKey:@"index"];
        [dict setObject:@(pace) forKey:@"value"];
        [dict setObject:@(1) forKey:@"isInt"];
        [self.manager.imperialPaceItems addObject:dict];
    }
    //步频
    if (self.model.duration > 0 && self.model.duration%60 == 0) {
        NSInteger addStep = self.manager.totalStep+self.manager.addStep-self.manager.lastStep;
        if (addStep) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSInteger index = self.model.duration/60;
            [dict setObject:@(index) forKey:@"index"];
            [dict setObject:@(addStep) forKey:@"value"];
            [self.manager.strideFrequencyItems addObject:dict];
            
            self.manager.lastStep = self.manager.totalStep+self.manager.addStep;
        }
    }
}

- (void)addLastSportItems {
    CGFloat km = self.model.distance/1000.0-self.manager.metricPaceIndex;
    CGFloat mi = 0.621*self.model.distance/1000.0-self.manager.metricPaceIndex;
    //公制配速
    if (km > 0) {
        NSInteger lastDuration = 0;
        if (self.manager.metricPaceItems.count) {
            for (NSDictionary *dict in self.manager.metricPaceItems) {
                lastDuration += [dict[@"value"] integerValue];
            }
        }
        if (self.model.duration-lastDuration > 0) {
            NSInteger pace = (self.model.duration-lastDuration)/km;
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(self.manager.metricPaceIndex) forKey:@"index"];
            [dict setObject:@(pace) forKey:@"value"];
            [dict setObject:@(0) forKey:@"isInt"];
            [self.manager.metricPaceItems addObject:dict];
        }
    }
    //英制配速
    if (mi > 0) {
        NSInteger lastDuration = 0;
        if (self.manager.imperialPaceItems.count) {
            for (NSDictionary *dict in self.manager.imperialPaceItems) {
                lastDuration += [dict[@"value"] integerValue];
            }
        }
        if (self.model.duration-lastDuration > 0) {
            NSInteger pace = (self.model.duration-lastDuration)/mi;
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(self.manager.imperialPaceIndex) forKey:@"index"];
            [dict setObject:@(pace) forKey:@"value"];
            [dict setObject:@(0) forKey:@"isInt"];
            [self.manager.imperialPaceItems addObject:dict];
        }
    }
}

#pragma mark - get and set

- (RunningView *)runningView {
    if (!_runningView) {
        _runningView  = [[RunningView alloc] init];
        _runningView.delegate = self;
        _runningView.mapButton.hidden = !self.isGPS;
        _runningView.leftTitleLabel.text = [RunningManager runningTypeTitle:self.sportType];
        [_runningView.leftButton setImage:DHImage([RunningManager runningTypeImage:self.sportType]) forState:UIControlStateNormal];
    }
    return _runningView;
}

- (RunningGPSView *)runningGPSView {
    if (!_runningGPSView) {
        _runningGPSView  = [[RunningGPSView alloc] init];
        _runningGPSView.delegate = self;
        _runningGPSView.mapView.mkMapView.maxSpeed = [RunningManager maxSpeed:self.sportType];
        _runningGPSView.mapView.mkMapView.minSpeed = [RunningManager minSpeed:self.sportType];
    }
    return _runningGPSView;
}

@end
