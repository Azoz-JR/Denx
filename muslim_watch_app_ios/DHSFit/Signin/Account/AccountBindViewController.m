//
//  AccountBindViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "AccountBindViewController.h"
#import "SignupView.h"

@interface AccountBindViewController ()<SignupViewDelegate>

/// 输入框
@property (nonatomic, strong) SignupView *signupView;
/// 计时
@property (nonatomic, assign) NSInteger countDown;

@end

@implementation AccountBindViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addGeusterHideKeyboard];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.countDown > 0) {
        [[TimerManager shareInstance] delTimerWithName:@"bind_timer"];
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    self.countDown = 0;
    self.signupView.delegate = self;
    
    self.signupView.signinLabel.hidden = YES;
    [self.signupView.signupButton setTitle:Lang(@"str_sure") forState:UIControlStateNormal];
}

- (void)addGeusterHideKeyboard{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willEndEditing)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)willEndEditing{
    [self.view endEditing:NO];
    
}

- (void)startTimer {
    self.countDown = 120;
    self.signupView.verifyCodeButton.userInteractionEnabled = NO;
    NSString *titleStr = [NSString stringWithFormat:@"%ld",(long)self.countDown];
    [self.signupView.verifyCodeButton setTitle:titleStr forState:UIControlStateNormal];
    [[TimerManager shareInstance] addTimerWithName:@"bind_timer" interval:1.0 target:self selector:@selector(timerRun) repeats:YES];
}

- (void)timerRun {
    self.countDown--;
    if (self.countDown == 0) {
        self.signupView.verifyCodeButton.userInteractionEnabled = YES;
        [self.signupView.verifyCodeButton setTitle:Lang(@"str_verification_code_rec") forState:UIControlStateNormal];
        [[TimerManager shareInstance] delTimerWithName:@"bind_timer"];
    } else {
        NSString *titleStr = [NSString stringWithFormat:@"%ld",(long)self.countDown];
        [self.signupView.verifyCodeButton setTitle:titleStr forState:UIControlStateNormal];
    }
}

#pragma mark - SignupViewDelegate

- (void)onSignup:(NSString *)account verifyCode:(NSString *)verifyCode password:(NSString *)password {
    if (DHAppStatus == 2) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:account forKey:@"account"];
        [dict setObject:password forKey:@"password"];
        [dict setObject:verifyCode forKey:@"verifyCode"];
        SHOWINDETERMINATE
        WEAKSELF
        [NetworkManager registerWithParameter:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue, ^{
            HUDDISS
            if (resultCode == 0) {
                [AccountManager visitorBindSucceed:account userInfo:data];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else if (resultCode == 10000){
                SHOWHUD(Lang(@"str_network_error"))
            } else {
                NSString *errorStr = [NetworkManager transformErrorCode:resultCode];
                if (errorStr.length) {
                    SHOWHUD(errorStr)
                } else {
                    SHOWHUD(Lang(@"str_bind_account_fail"))
                }
            }
            });
        }];
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:account forKey:@"account"];
        [dict setObject:password forKey:@"password"];
        [dict setObject:verifyCode forKey:@"verifyCode"];
        SHOWINDETERMINATE
        WEAKSELF
        [NetworkManager thirdLoginBindWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue, ^{
            HUDDISS
            if (resultCode == 0) {
                [AccountManager thirdPartUserBindSucceed:account userInfo:data];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else if (resultCode == 10000){
                SHOWHUD(Lang(@"str_network_error"))
            } else {
                NSString *errorStr = [NetworkManager transformErrorCode:resultCode];
                if (errorStr.length) {
                    SHOWHUD(errorStr)
                } else {
                    SHOWHUD(Lang(@"str_bind_account_fail"))
                }
            }
            });
        }];
    }
    
}

- (void)onSignin {
    
}

- (void)onGetVerifyCode:(NSString *)account {
    NSString *verifyCodeType = DHAppStatus == 2 ? @"0" : @"2";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:account forKey:@"account"];
    [dict setObject:verifyCodeType forKey:@"verifyCodeType"];
    SHOWINDETERMINATE
    WEAKSELF
    [NetworkManager sendEmailCodeWithParameter:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        HUDDISS
        if (resultCode == 0) {
            [weakSelf startTimer];
        } else if (resultCode == 10000){
            SHOWHUD(Lang(@"str_network_error"))
        } else {
            NSString *errorStr = [NetworkManager transformErrorCode:resultCode];
            if (errorStr.length) {
                SHOWHUD(errorStr)
            } else {
                SHOWHUD(Lang(@"str_verify_code_fail"))
            }
        }
        });
    }];
}

- (void)onUserAgreement {
    MWHtmlViewController *vc = [[MWHtmlViewController alloc] init];
    vc.navTitle = Lang(@"str_user_protocol");
    vc.isHideNavRightButton = YES;
    vc.urlString = UserProtocolUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onPrivacyPolicy {
    MWHtmlViewController *vc = [[MWHtmlViewController alloc] init];
    vc.navTitle = Lang(@"str_privacy_policy");
    vc.isHideNavRightButton = YES;
    vc.urlString = PrivacyPolicyUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTextFieldSelected:(NSInteger)viewTag {
    
}

- (SignupView *)signupView {
    if (!_signupView) {
        _signupView = [[SignupView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHeight, kScreenWidth, kScreenHeight-kNavAndStatusHeight)];
        [self.view addSubview:_signupView];
    }
    return _signupView;
}

@end
