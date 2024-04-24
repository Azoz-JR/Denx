//
//  SigninView.h
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SigninViewDelegate <NSObject>

@optional

- (void)onSignin:(NSString *)account password:(NSString *)password;
- (void)onSigninApple;
- (void)onSigninWechat;
- (void)onSigninQQ;
- (void)onSignup;
- (void)onPasswordSet;
- (void)onUserAgreement;
- (void)onPrivacyPolicy;
- (void)onTextFieldSelected:(NSInteger)viewTag;

@end

@interface SigninView : UIView

/// 代理
@property (nonatomic, weak) id<SigninViewDelegate> delegate;
/// 微信登录
@property (nonatomic, strong) UIButton *wechatButton;

@end

NS_ASSUME_NONNULL_END
