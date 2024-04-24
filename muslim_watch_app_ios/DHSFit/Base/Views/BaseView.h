//
//  BaseView.h
//  DHSFit
//
//  Created by 晏宝 on 2021/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseView : UIView

/// 初始化标题Label
+ (UILabel *)titleLabel;

/// 初始化小标题Label
+ (UILabel *)subTitleLabel;

/// 初始化内容Label
+ (UILabel *)contentLabel;

/// 初始化蓝色Button
+ (UIButton *)blueButton;


/// 相机未授权弹框
+ (void)showCameraUnauthorized;

/// 定位未授权弹框
+ (void)showLocationUnauthorized;

/// 取消配对弹框
+ (void)showBluetoothUnpaired;

/// 设备已被其他人绑定
+ (void)showDeviceIsBindedByOthers;

/// 设备已恢复出厂设置
+ (void)showDeviceIsRestore;

/// 绑定失败
+ (void)showDeviceBindedFailed;

/// 设备已绑定
+ (void)showDeviceIsBinded;


@end

NS_ASSUME_NONNULL_END
