//
//  LaunchAlertView.h
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LaunchAlertViewDelegate <NSObject>

@optional

- (void)onUserAgreement;
- (void)onPrivacyPolicy;
- (void)onCancel;
- (void)onConfirm;

@end


@interface LaunchAlertView : UIView

/// 代理
@property (nonatomic, weak) id<LaunchAlertViewDelegate> delegate;

/// 加载视图
/// @param title 标题
/// @param message 内容
/// @param content 内容
/// @param tip 提示
/// @param agreement 用户协议
/// @param privacy 隐私政策
/// @param cancel 取消
/// @param confirm 确认
/// @param controller 控制器
- (void)showWithTitle:(NSString *)title
               message:(NSString *)message
               content:(NSString *)content
              tip:(NSString *)tip
             agreement:(NSString *)agreement
               privacy:(NSString *)privacy
               cancel:(NSString *)cancel
               confirm:(NSString *)confirm
           controller:(UIViewController*)controller;


@end

NS_ASSUME_NONNULL_END
