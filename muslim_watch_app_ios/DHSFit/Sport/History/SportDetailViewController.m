//
//  SportDetailViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "SportDetailViewController.h"
#import "HistoryMapView.h"
#import "HistoryDataView.h"
#import "DataSyncingView.h"
#import "DataUploadManager.h"

@interface SportDetailViewController ()

#pragma mark UI
/// 背景
@property (nonatomic, strong) UIScrollView *myScrollView;
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 数据视图
@property (nonatomic, strong) HistoryDataView *dataView;
/// 轨迹视图
@property (nonatomic, strong) HistoryMapView *mapView;
/// 背景视图
@property (nonatomic, strong) UIImageView *logoImageView;
/// 同步视图
@property (nonatomic, strong) DataSyncingView *syncingView;

#pragma mark Data
/// 轨迹点
@property (nonatomic, strong) NSMutableArray *railModels;
/// 文件
@property (nonatomic, strong) NSData *fileData;

@end

@implementation SportDetailViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:!self.isEndRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
    [DataUploadManager uploadDailySports];
    //发送结束运动数据
    //传输轨迹图片
    if (self.isEndRunning && [RunningManager shareInstance].isConnected) {
        [[RunningManager shareInstance] controlSportData:self.model Step:self.model.step Stop:YES];
        
        if ([DHBleCentralManager isJLProtocol] == NO){ //杰里平台不传输轨迹
            if (self.model.gpsItems.length) {
                [self showProgressView];
                [self delayPerformBlock:^(id  _Nonnull object) {
                    [self fileSyncingStart];
                } WithTime:2.0];
            }
        }
    }
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    
    if (self.model.gpsItems.length) {
        NSArray *items = [self.model.gpsItems transToObject];
        if (items.count) {
            for (int i = 0; i < items.count; i++) {
                NSDictionary *item = items[i];
                RailModel *model = [[RailModel alloc] init];
                model.latitude = [item[@"latitude"] floatValue];
                model.longtitude = [item[@"longtitude"] floatValue];
                //model.timestamp = item[@"timestamp"];
                [self.railModels addObject:model];
            }
        }
    }
}

- (void)navLeftButtonClick:(UIButton *)sender {
    if (self.isEndRunning) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navRightButtonClick:(UIButton *)sender {
    [self onShare];
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
    
    if (self.railModels.count) {
        [self.mapView.mkMapView setMapRegin:self.railModels andIsCenter:NO];
    }

    UIImage* viewImage = nil;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(self.myScrollView.contentSize, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.myScrollView.contentSize);
    }
    
    CGPoint savedContentOffset = self.myScrollView.contentOffset;
    CGRect savedFrame = self.myScrollView.frame;
    
    self.myScrollView.contentOffset = CGPointZero;
    self.myScrollView.frame = CGRectMake(0, 0,  self.myScrollView.contentSize.width, self.myScrollView.contentSize.height);
    
    [self.myScrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.myScrollView.contentOffset = savedContentOffset;
    self.myScrollView.frame = savedFrame;
    
    return viewImage;
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.navTitleLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat scrollViewH = kScreenHeight-kBottomHeight-kNavAndStatusHeight;
    CGFloat bgViewH = kScreenHeight*1/3.0;
    
    BOOL isShowSteps = (self.model.type == SportTypeWalk || self.model.type == SportTypeRunIndoor || self.model.type == SportTypeRunOutdoor || self.model.type == SportTypeClimb);
    BOOL isShowHeartRate = self.model.heartRateItems.length;
    CGFloat dataViewH = 450 + isShowSteps*230 + isShowHeartRate*220;
    
    self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHeight, kScreenWidth, scrollViewH)];
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.contentSize = CGSizeMake(kScreenWidth, bgViewH+dataViewH);
    [self.view addSubview:self.myScrollView];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, bgViewH)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:self.bgView];
    
    self.dataView = [[HistoryDataView alloc] initWithFrame:CGRectMake(0, bgViewH, kScreenWidth, dataViewH)];
    [self.myScrollView addSubview:self.dataView];
    
    self.dataView.model = self.model;
    
    if (self.model.gpsItems.length) {
        self.mapView = [[HistoryMapView alloc] initWithFrame:self.bgView.bounds];
        self.mapView.mkMapView.type = MapTypeRunDetail;
        self.mapView.mkMapView.maxSpeed = [RunningManager maxSpeed:self.model.type];
        self.mapView.mkMapView.minSpeed = [RunningManager minSpeed:self.model.type];
        [self.bgView addSubview:self.mapView];
        [self.mapView.mkMapView drawMkMapKitViewWithArray:self.railModels];
    } else {
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, bgViewH)];
        self.logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.logoImageView.image = DHImage(@"sport_detail_bg");
        self.logoImageView.layer.masksToBounds = YES;
        [self.bgView addSubview:self.logoImageView];
    }
}

- (void)showProgressView {
    if (!DHDeviceConnected) {
        return;
    }
    self.syncingView = [[DataSyncingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.syncingView showSyncingView];
}

- (void)fileSyncingStart {
    CGFloat screenHeight = DHDialHeight*0.8;
    CGFloat screenWidth = DHDialWidth*0.8;
    UIImage *mapView = [self snapshotMapView];
    UIImage *image = [self imageScaleToSize:CGSizeMake(screenWidth, screenHeight) withImage:mapView];
    
    self.fileData = UIImagePNGRepresentation(image);
    if (self.fileData.length == 0) {
        self.syncingView.progress = -1;
        return;
    }
    
    DHFileSyncingModel *model = [[DHFileSyncingModel alloc] init];
    model.fileType = 2;
    model.fileSize = self.fileData.length;
    model.fileData = self.fileData;
    [DHBleCommand fileSyncingStart:model block:^(int code, id  _Nonnull data) {
        
    }];
    [self performSelector:@selector(startMapSyncing) withObject:nil afterDelay:1.3];
}


- (void)startMapSyncing {
    
    WEAKSELF
    [DHBleCommand startMapSyncing:self.fileData block:^(int code, CGFloat progress, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (code == 0) {
                weakSelf.syncingView.progress = progress*100;
            } else {
                weakSelf.syncingView.progress = -1;
            }
        });
    }];
    
}

- (UIImage *)snapshotMapView {
    
    UIImage* viewImage = nil;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(self.mapView.size, NO, 1.0);
    } else {
        UIGraphicsBeginImageContext(self.mapView.size);
    }
    
    [self.mapView.layer renderInContext: UIGraphicsGetCurrentContext()];
    viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return viewImage;
}

//裁剪图片
- (UIImage *)imageScaleToSize:(CGSize)size withImage:(UIImage *)image {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark - get and set 属性的set和get方法

- (NSMutableArray *)railModels {
    if (!_railModels) {
        _railModels = [NSMutableArray array];
    }
    return _railModels;
}

@end
