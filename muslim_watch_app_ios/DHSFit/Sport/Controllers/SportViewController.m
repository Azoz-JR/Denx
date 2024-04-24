//
//  SportViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "SportViewController.h"
#import "HistoryViewController.h"
#import "RunningViewController.h"
#import "BaseSelectedView.h"
#import "SportMainView.h"
#import "SportCountdownView.h"
#import "SportSettingsViewController.h"

@interface SportViewController ()<BaseSelectedViewDelegate,SportMainViewDelegate,SportCountdownViewDelegate,UIScrollViewDelegate>

/// 运动类型选择
@property (nonatomic, strong) BaseSelectedView *topView;
/// 倒计时
@property (nonatomic, strong) SportCountdownView *countdownView;
/// 背景
@property (nonatomic, strong) UIScrollView *myScrollView;
/// 运动类型（0.室内跑步 1.室外跑步 2.健走 3.骑行 4.爬山）
@property (nonatomic, assign) SportType sportType;
/// 是否室外
@property (nonatomic, assign) BOOL isOutdoor;

@end

@implementation SportViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
    //监听距离单位变化
    [DHNotificationCenter addObserver:self selector:@selector(appDistanceUnitChange) name:AppNotificationDistanceUnitChange object:nil];
    //监听运动数据变化
    [DHNotificationCenter addObserver:self selector:@selector(appDistanceUnitChange) name:BluetoothNotificationSportDataChange object:nil];
    //监听健康数据下载完成
    [DHNotificationCenter addObserver:self selector:@selector(appDistanceUnitChange) name:BluetoothNotificationHealthDataDownloadCompleted object:nil];
    
    
}

- (void)appDistanceUnitChange {
    for (int i = 0; i < self.topView.titles.count; i++) {
        SportMainView *mainView = [self.myScrollView viewWithTag:1000+i];
        if (mainView) {
            NSInteger distance;
            if (i == 0) {
                distance = self.isOutdoor ? [HealthDataManager sportTotalDistance:SportTypeRunOutdoor] : [HealthDataManager sportTotalDistance:SportTypeRunIndoor];
            } else if (i == 1) {
                distance = [HealthDataManager sportTotalDistance:SportTypeWalk];
            } else if (i == 2) {
                distance = [HealthDataManager sportTotalDistance:SportTypeRide];
            } else {
                distance = [HealthDataManager sportTotalDistance:SportTypeClimb];
            }
            NSArray *strArray = @[[NSString stringWithFormat:@"%.02f", DistanceValue(distance)],DistanceUnit];
            NSArray *fontArray = @[HomeFont_Bold_30, HomeFont_SubTitleFont];
            NSArray *colorArray = @[[UIColor blackColor],[UIColor blackColor]];
            mainView.titleLabel.attributedText = [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
        }
    }
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    self.isOutdoor = NO;
    self.sportType = SportTypeRunIndoor;
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    CGFloat bgViewH = kScreenHeight-kNavAndStatusHeight-kBottomHeight-kTabBarHeight-60;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.offset(50);
    }];
    [self.topView setupSubViews];
    
    self.myScrollView = [[UIScrollView alloc] init];
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.delegate = self;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.myScrollView];
    
    UIView *lastView;
    for (int i = 0; i < self.topView.titles.count; i++) {
        SportMainView *mainView = [[SportMainView alloc] init];
        mainView.delegate = self;
        mainView.tag = 1000+i;
        [self.myScrollView addSubview:mainView];
        
        if (i == 0) {
            mainView.bgImageView.alpha = 0.85;
            [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.myScrollView.mas_left);
                make.width.equalTo(self.myScrollView);
                make.top.equalTo(self.myScrollView);
                make.height.equalTo(self.myScrollView);
            }];
        } else {
            [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right);
                make.top.bottom.equalTo(lastView);
                make.width.equalTo(lastView);
            }];
        }
        NSInteger distance;
        if (i == 0) {
            distance = self.isOutdoor ? [HealthDataManager sportTotalDistance:SportTypeRunOutdoor] : [HealthDataManager sportTotalDistance:SportTypeRunIndoor];
            mainView.subTitleLabel.text = self.isOutdoor ? [RunningManager runningTypeDataTitle:SportTypeRunOutdoor] : [RunningManager runningTypeDataTitle:SportTypeRunIndoor];
        } else if (i == 1) {
            distance = [HealthDataManager sportTotalDistance:SportTypeWalk];
            mainView.subTitleLabel.text = [RunningManager runningTypeDataTitle:SportTypeWalk];
        } else if (i == 2) {
            distance = [HealthDataManager sportTotalDistance:SportTypeRide];
            mainView.subTitleLabel.text = [RunningManager runningTypeDataTitle:SportTypeRide];
        } else {
            distance = [HealthDataManager sportTotalDistance:SportTypeClimb];
            mainView.subTitleLabel.text = [RunningManager runningTypeDataTitle:SportTypeClimb];
        }
        NSArray *strArray = @[[NSString stringWithFormat:@"%.02f",DistanceValue(distance)],DistanceUnit];
        NSArray *fontArray = @[HomeFont_Bold_30,HomeFont_SubTitleFont];
        NSArray *colorArray = @[[UIColor blackColor],[UIColor blackColor]];
        mainView.titleLabel.attributedText = [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
        //mainView.subTitleLabel.text = [RunningManager runningTypeDataTitle:i+1];
        mainView.indoorButton.hidden = i > 0;
        mainView.outdoorButton.hidden = i > 0;
        lastView = mainView;
    }
    
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.height.offset(bgViewH);
        make.right.equalTo(lastView.mas_right);
    }];
}


- (void)navRightButtonClick:(UIButton *)sender {
    //运动设置
    SportSettingsViewController *vc = [[SportSettingsViewController alloc] init];
    vc.navTitle = Lang(@"str_sport_setting");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navLeftButtonClick:(UIButton *)sender {
    //运动记录
    HistoryViewController *vc = [[HistoryViewController alloc] init];
    vc.navTitle = Lang(@"str_sport_record");
    vc.isHideNavRightButton = YES;
    vc.sportType = self.sportType;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.myScrollView) {
        int number = scrollView.contentOffset.x/kScreenWidth;
        [self.topView updateTypeSelected:number];
        [self updateScrollViewOffset:number];
    }
}


#pragma mark - BaseSelectedViewDelegate

- (void)onTypeSelected:(NSInteger)index {
    if (index == 0) {
        self.sportType = self.isOutdoor ? SportTypeRunOutdoor : SportTypeRunIndoor;
    } else {
        if (index == 1) {
            self.sportType = SportTypeWalk;
        } else if (index == 2) {
            self.sportType = SportTypeRide;
        } else {
            self.sportType = SportTypeClimb;
        }
    }
    [self updateScrollViewOffset:index];
}

#pragma mark - SportMainViewDelegate

- (void)onStartRunning {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.countdownView = [[SportCountdownView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.countdownView.delegate = self;
    [window addSubview:self.countdownView];
    [self.countdownView startCount];
}

- (void)onOutdoor {
    self.isOutdoor = YES;
    self.sportType = SportTypeRunOutdoor;
    
    SportMainView *mainView = [self.myScrollView viewWithTag:1000];
    if (mainView) {
        mainView.bgImageView.alpha = 1.0;
        
        NSInteger distance = [HealthDataManager sportTotalDistance:SportTypeRunOutdoor];
        mainView.subTitleLabel.text = [RunningManager runningTypeDataTitle:SportTypeRunOutdoor];
        NSArray *strArray = @[[NSString stringWithFormat:@"%.02f",DistanceValue(distance)],DistanceUnit];
        NSArray *fontArray = @[HomeFont_Bold_30,HomeFont_SubTitleFont];
        NSArray *colorArray = @[[UIColor blackColor],[UIColor blackColor]];
        mainView.titleLabel.attributedText = [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
    }
}
- (void)onIndoor {
    self.isOutdoor = NO;
    self.sportType = SportTypeRunIndoor;
    
    SportMainView *mainView = [self.myScrollView viewWithTag:1000];
    if (mainView) {
        mainView.bgImageView.alpha = 0.85;
        
        NSInteger distance = [HealthDataManager sportTotalDistance:SportTypeRunIndoor];
        mainView.subTitleLabel.text = [RunningManager runningTypeDataTitle:SportTypeRunIndoor];
        NSArray *strArray = @[[NSString stringWithFormat:@"%.02f",DistanceValue(distance)],DistanceUnit];
        NSArray *fontArray = @[HomeFont_Bold_30,HomeFont_SubTitleFont];
        NSArray *colorArray = @[[UIColor blackColor],[UIColor blackColor]];
        mainView.titleLabel.attributedText = [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
    }
}

#pragma mark - SportCountdownViewDelegate

- (void)countdownFinished {
    RunningViewController *vc = [[RunningViewController alloc] init];
    vc.isHideNavigationView = YES;
    vc.isGPS = self.sportType != SportTypeRunIndoor;
    vc.sportType = self.sportType;
    vc.isConnected = DHDeviceConnected;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)updateScrollViewOffset:(NSInteger)index {
    [self.myScrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:NO];
}

- (BaseSelectedView *)topView {
    if (!_topView) {
        _topView = [[BaseSelectedView alloc] init];
        _topView.titles = @[Lang(@"str_tab_sport_running"),
                            Lang(@"str_tab_sport_walking"),
                            Lang(@"str_tab_sport_biking"),
                            Lang(@"str_tab_sport_climing")];
        _topView.delegate = self;
        [self.view addSubview:_topView];
    }
    return _topView;
}

@end
