//
//  AccountLogoutViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "AccountLogoutViewController.h"
#import "SignupView.h"

@interface AccountLogoutViewController ()<SignupViewDelegate>

/// 输入框
@property (nonatomic, strong) SignupView *signupView;
/// 计时
@property (nonatomic, assign) NSInteger countDown;

@end

@implementation AccountLogoutViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.countDown > 0) {
        [[TimerManager shareInstance] delTimerWithName:@"signup_timer"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addGeusterHideKeyboard];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    self.countDown = 0;
    self.signupView.delegate = self;
    
    self.signupView.agreementLabel.hidden = YES;
    self.signupView.signinLabel.hidden = YES;
    [self.signupView.signupButton setTitle:Lang(@"str_sure") forState:UIControlStateNormal];
    self.signupView.account = self.accountStr;
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
    [[TimerManager shareInstance] addTimerWithName:@"signup_timer" interval:1.0 target:self selector:@selector(timerRun) repeats:YES];
}

- (void)timerRun {
    self.countDown--;
    if (self.countDown == 0) {
        self.signupView.verifyCodeButton.userInteractionEnabled = YES;
        [self.signupView.verifyCodeButton setTitle:Lang(@"str_verification_code_rec") forState:UIControlStateNormal];
        [[TimerManager shareInstance] delTimerWithName:@"signup_timer"];
    } else {
        NSString *titleStr = [NSString stringWithFormat:@"%ld",(long)self.countDown];
        [self.signupView.verifyCodeButton setTitle:titleStr forState:UIControlStateNormal];
    }
}

#pragma mark - SignupViewDelegate

- (void)onSignup:(NSString *)account verifyCode:(NSString *)verifyCode password:(NSString *)password {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:password forKey:@"password"];
    [dict setObject:verifyCode forKey:@"verifyCode"];
    SHOWINDETERMINATE
    [NetworkManager deleteAccountWithParameter:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        HUDDISS
        if (resultCode == 0) {
            [AccountManager userLogout];
            //用户退出登录
            [DHNotificationCenter postNotificationName:AppNotificationUserSignout object:nil];
            
        } else if (resultCode == 10000){
            SHOWHUD(Lang(@"str_network_error"))
        } else {
            NSString *errorStr = [NetworkManager transformErrorCode:resultCode];
            if (errorStr.length) {
                SHOWHUD(errorStr)
            } else {
                SHOWHUD(Lang(@"str_del_acc_fai"))
            }
        }
        });
    }];
}

- (void)onSignin {
    
}

- (void)onGetVerifyCode:(NSString *)account {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:account forKey:@"account"];
    [dict setObject:@"3" forKey:@"verifyCodeType"];
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
    
}

- (void)onPrivacyPolicy {
    
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

