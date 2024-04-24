//
//  SportDetailViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "SportDetailViewJLController.h"
#import "HistoryDataJLView.h"
#import "DataSyncingView.h"
#import "DataUploadManager.h"

@interface SportDetailViewJLController ()

#pragma mark UI
/// 背景
@property (nonatomic, strong) UIScrollView *myScrollView;
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 数据视图
@property (nonatomic, strong) HistoryDataJLView *dataView;

/// 背景视图
@property (nonatomic, strong) UIImageView *logoImageView;

#pragma mark Data
/// 文件
@property (nonatomic, strong) NSData *fileData;

@end

@implementation SportDetailViewJLController

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
    if (self.isEndRunning && [RunningManager shareInstance].isConnected) {
        [[RunningManager shareInstance] controlSportData:self.model Step:self.model.step Stop:YES];
    }
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    
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
    
    UIImage *viewImage = nil;
    
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
    
    BOOL isShowSteps = false;
    if (self.model.viewType == 1 || self.model.viewType == 2 || self.model.viewType == 3){ //类型2有步数，平均配速, 无步频
        isShowSteps = YES;
    }
    BOOL isShowHeartRate = true;
    CGFloat dataViewH = 450 + isShowSteps*250 + isShowHeartRate*230;
    
    self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHeight, kScreenWidth, scrollViewH)];
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.contentSize = CGSizeMake(kScreenWidth, bgViewH+dataViewH);
    [self.view addSubview:self.myScrollView];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, bgViewH)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:self.bgView];
    
    self.dataView = [[HistoryDataJLView alloc] initWithFrame:CGRectMake(0, bgViewH, kScreenWidth, dataViewH) model:self.model];
    [self.myScrollView addSubview:self.dataView];
    
    self.dataView.model = self.model;
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, bgViewH)];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImageView.image = DHImage(@"sport_detail_bg");
    self.logoImageView.layer.masksToBounds = YES;
    [self.bgView addSubview:self.logoImageView];
}

- (UIImage *)getmakeImageWithView:(UIView *)view andWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 1.0);
//    BOOL success = [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

    return image;
}

//裁剪图片
- (UIImage *)imageScaleToSize:(CGSize)size withImage:(UIImage *)image {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
