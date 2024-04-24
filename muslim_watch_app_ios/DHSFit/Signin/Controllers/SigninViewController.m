//
//  SigninViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import "SigninViewController.h"
#import "SignupViewController.h"
#import "PasswordResetViewController.h"
#import "AccountBindViewController.h"
#import "SigninView.h"

@interface SigninViewController ()<SigninViewDelegate>

/// 输入框
@property (nonatomic, strong) SigninView *signinView;
/// 用户信息
@property (nonatomic, strong) NSDictionary *userData;

@end

@implementation SigninViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addGeusterHideKeyboard];
    [self addObservers];
    if (self.isRemoveLastVC) {
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        [navigationArray removeObjectAtIndex: navigationArray.count-2];
        self.navigationController.viewControllers = navigationArray;
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    self.signinView.delegate = self;
    
    self.signinView.wechatButton.hidden = YES;
}

- (void)addGeusterHideKeyboard{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willEndEditing)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)addObservers{
    
}

- (void)willEndEditing{
    [self.view endEditing:NO];
    
}

#pragma mark - SigninViewDelegate

- (void)onSignin:(NSString *)account password:(NSString *)password {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:account forKey:@"username"];
    [dict setObject:password forKey:@"password"];
    SHOWINDETERMINATE
    [NetworkManager loginWithParameter:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        HUDDISS
        if (resultCode == 0) {
            [AccountManager userSigninSucceed:account userInfo:data];
            [NetworkManager queryUserInformWithParameter:[NSDictionary dictionary] andBlock:nil];
            [NetworkManager querySwitchWithParam:[NSDictionary dictionary] andBlock:nil];
            //用户登录
            [DHNotificationCenter postNotificationName:AppNotificationUserSignin object:nil];
        } else if (resultCode == 10000){
            SHOWHUD(Lang(@"str_network_error"))
        } else {
            NSString *errorStr = [NetworkManager transformErrorCode:resultCode];
            if (errorStr.length) {
                SHOWHUD(errorStr)
            } else {
                SHOWHUD(Lang(@"str_login_fail"))
            }
        }
        });
    }];
}

- (void)onSignup {
    SignupViewController *vc = [[SignupViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.isRemoveLastVC = YES;
    vc.navTitle = Lang(@"str_register");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onPasswordSet {
    PasswordResetViewController *vc = [[PasswordResetViewController alloc] init];
    vc.isHideNavRightButton = YES;
    vc.navTitle = Lang(@"str_forget_pw");
    [self.navigationController pushViewController:vc animated:YES];
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

- (SigninView *)signinView {
    if (!_signinView) {
        _signinView = [[SigninView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHeight, kScreenWidth, kScreenHeight-kNavAndStatusHeight)];
        [self.view addSubview:_signinView];
    }
    return _signinView;
}

@end
