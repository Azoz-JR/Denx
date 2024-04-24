//
//  BaseView.m
//  DHSFit
//
//  Created by 晏宝 on 2021/3/15.
//

#import "BaseView.h"

@implementation BaseView

+ (UILabel *)titleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = HomeFont_TitleFont;
    label.textColor = HomeColor_TitleColor;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

+ (UILabel *)subTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = HomeFont_SubTitleFont;
    label.textColor = HomeColor_SubTitleColor;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

+ (UILabel *)contentLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = HomeFont_ContentFont;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
}

+ (UIButton *)blueButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:HomeColor_MainColor];
    button.titleLabel.font = HomeFont_ButtonFont;
    [button setTitleColor:HomeColor_ButtonColor forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    button.userInteractionEnabled  = NO;
    return button;
}


+ (void)showCameraUnauthorized {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:Lang(@"str_camera_permission_title")
                     message:Lang(@"str_camera_permission_message")
                      cancel:@""
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
    }];
}

+ (void)showLocationUnauthorized {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:Lang(@"str_location_permission_title")
                     message:Lang(@"str_location_permission_message")
                      cancel:@""
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
    }];
}

+ (void)showBluetoothUnpaired {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_omit_device_message")
                      cancel:@""
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
    }];
}

+ (void)showDeviceIsBindedByOthers {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_device_others_binded_tips")
                      cancel:@""
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
    }];
}

+ (void)showDeviceIsRestore {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_device_restore_tips")
                      cancel:@""
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
    }];
}

+ (void)showDeviceBindedFailed {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_bind_fail")
                      cancel:@""
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
    }];
}

+ (void)showDeviceIsBinded {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_device_bound_to_other_tips")
                      cancel:@""
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
    }];
}

@end
