//
//  LaunchViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import "LaunchViewController.h"
#import "LaunchAlertView.h"
#import "SignHomeViewController.h"

@interface LaunchViewController ()<LaunchAlertViewDelegate>

@end

@implementation LaunchViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    LaunchAlertView *alertView = [[LaunchAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    alertView.delegate = self;
    [alertView showWithTitle:Lang(@"str_welcome_use")
                     message:Lang(@"str_user_protocol_tips")
                     content:[NSString stringWithFormat:@"%@《%@》、《%@》",Lang(@"str_please_read"),Lang(@"str_user_protocol"),Lang(@"str_privacy_policy")]
                         tip:Lang(@"str_protocol_read_tips")
                   agreement:[NSString stringWithFormat:@"《%@》",Lang(@"str_user_protocol")]
                     privacy:[NSString stringWithFormat:@"《%@》",Lang(@"str_privacy_policy")]
                      cancel:Lang(@"str_refuse")
                     confirm:Lang(@"str_sure_enter")
                  controller:self];
}

#pragma mark - LaunchAlertViewDelegate

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

- (void)onCancel {
    exit(0);
}

- (void)onConfirm {
    [ConfigureModel shareInstance].appStatus = 1;
    [ConfigureModel shareInstance].agreementTime = [[NSDate date] timeIntervalSince1970];
    [ConfigureModel archiveraModel];
    SignHomeViewController *vc = [[SignHomeViewController alloc] init];
    vc.isHideNavigationView = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
