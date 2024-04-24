//
//  PasswordUpdateViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/20.
//

#import "PasswordUpdateViewController.h"
#import "PasswordUpdateView.h"

@interface PasswordUpdateViewController ()<PasswordUpdateViewDelegate>
/// 输入框
@property (nonatomic, strong) PasswordUpdateView *passwordView;

@end

@implementation PasswordUpdateViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addGeusterHideKeyboard];
}


#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    self.passwordView.delegate = self;
    self.passwordView.accountLabel.text = self.accountStr;
}

- (void)addGeusterHideKeyboard{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willEndEditing)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)willEndEditing{
    [self.view endEditing:NO];
}

#pragma mark - PasswordUpdateViewDelegate
- (void)onPasswordUpdate:(NSString *)oldPassword newPassword:(NSString *)newPassword {
    //修改密码
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:oldPassword forKey:@"oldPassword"];
    [dict setObject:newPassword forKey:@"newPassword"];
    SHOWINDETERMINATE
    [NetworkManager updatePasswordWithParameter:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        HUDDISS
        if (resultCode == 0) {
            SHOWHUD(Lang(@"str_reset_pw_success"))
            [AccountManager userSignout];
            //用户退出登录
            [DHNotificationCenter postNotificationName:AppNotificationUserSignout object:nil];
        } else if (resultCode == 10000){
            SHOWHUD(Lang(@"str_network_error"))
        } else {
            NSString *errorStr = [NetworkManager transformErrorCode:resultCode];
            if (errorStr.length) {
                SHOWHUD(errorStr)
            } else {
                SHOWHUD(Lang(@"str_reset_pw_fail"))
            }
        }
        });
    }];
}

- (void)onTextFieldSelected:(NSInteger)viewTag {
    
}

- (PasswordUpdateView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[PasswordUpdateView alloc] initWithFrame:CGRectMake(0, kNavAndStatusHeight, kScreenWidth, kScreenHeight-kNavAndStatusHeight)];
        [self.view addSubview:_passwordView];
    }
    return _passwordView;
}

@end
