//
//  SignHomeViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import "SignHomeViewController.h"
#import "SigninViewController.h"
#import "SignupViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SignHomeViewController ()
/// 跳过
@property (nonatomic, strong) UIButton *skipButton;
/// 登录
@property (nonatomic, strong) UIButton *signinButton;
/// 注册
@property (nonatomic, strong) UIButton *signupButton;

//播放视频
@property (strong,nonatomic) AVPlayer *avPlayer;
@property (weak, nonatomic) AVPlayerLayer *avplayerLayer;
@property (weak, nonatomic) AVPlayerItem *avitem;

@end

@implementation SignHomeViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    self.avplayerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    //视频播放完成
    [DHNotificationCenter addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avitem];
    //程序进入前台
    [DHNotificationCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.avPlayer play];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [DHNotificationCenter removeObserver:self];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.avPlayer pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPlayer];
    [self setupUI];
}

#pragma mark - custom action for UI 界面处理有关

-(void)setupPlayer{
    NSString *itemPath = [[NSBundle mainBundle] pathForResource:@"Welcome2" ofType:@"mp4"];
    NSURL *sourceMovieUrl = [NSURL fileURLWithPath:itemPath];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieUrl options:nil];
    AVPlayerItem *avitem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.avitem = avitem;
    self.avPlayer = [AVPlayer playerWithPlayerItem:avitem];
    self.avplayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avplayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.avplayerLayer.contentsScale = [UIScreen mainScreen].scale;
    self.avplayerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view.layer addSublayer:self.avplayerLayer];
    [self.avPlayer pause];

}


- (void)setupUI {
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kStatusHeight+8);
        make.right.offset(-HomeViewSpace_Right);
        make.width.offset(80);
        make.height.offset(36);
    }];
    
    [self.signinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.bottom.offset(-(kBottomHeight+25));
    }];
    
    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.bottom.equalTo(self.signinButton.mas_top).offset(-20);
    }];
    
}

//监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            [self.avPlayer play];
        }
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self.avPlayer play];
}

//重复播放
-(void)playerItemDidReachEnd:(NSNotification*)item{
    [[item object] seekToTime:kCMTimeZero];
    [self.avPlayer play];
}

- (void)skipClick {
    VisitorModel *model = [VisitorModel currentModel];
    if (model.userId.length) {
        [AccountManager signinVisitor:model];
    } else {
        [AccountManager initVisitor];
    }
    //用户登录
    [DHNotificationCenter postNotificationName:AppNotificationUserSignin object:nil];
}

- (void)signupClick {
    SignupViewController *vc = [[SignupViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.navTitle = Lang(@"str_register");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)signinClick {
    SigninViewController *vc = [[SigninViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.navTitle = Lang(@"str_login");
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.layer.cornerRadius = 18.0;
        _skipButton.layer.masksToBounds = YES;
        _skipButton.backgroundColor = HomeColor_BlockColor;
        [_skipButton setTitle:Lang(@"str_pass") forState:UIControlStateNormal];
        _skipButton.titleLabel.font = HomeFont_ButtonFont;
        [_skipButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_skipButton];
    }
    return _skipButton;
}

- (UIButton *)signupButton {
    if (!_signupButton) {
        _signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signupButton.layer.cornerRadius = 10.0;
        _signupButton.layer.masksToBounds = YES;
        _signupButton.layer.borderColor = HomeColor_MainColor.CGColor;
        _signupButton.layer.borderWidth = 1.0;
        _signupButton.backgroundColor = [UIColor clearColor];
        [_signupButton setTitle:Lang(@"str_register") forState:UIControlStateNormal];
        _signupButton.titleLabel.font = HomeFont_ButtonFont;
        [_signupButton setTitleColor:HomeColor_ButtonColor forState:UIControlStateNormal];
        [_signupButton addTarget:self action:@selector(signupClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_signupButton];
    }
    return _signupButton;
}

- (UIButton *)signinButton {
    if (!_signinButton) {
        _signinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signinButton.layer.cornerRadius = 10.0;
        _signinButton.layer.masksToBounds = YES;
        _signinButton.layer.borderColor = HomeColor_MainColor.CGColor;
        _signinButton.layer.borderWidth = 1.0;
        _signinButton.backgroundColor = [UIColor clearColor];
        [_signinButton setTitle:Lang(@"str_login") forState:UIControlStateNormal];
        _signinButton.titleLabel.font = HomeFont_ButtonFont;
        [_signinButton setTitleColor:HomeColor_ButtonColor forState:UIControlStateNormal];
        [_signinButton addTarget:self action:@selector(signinClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_signinButton];
    }
    return _signinButton;
}

@end
