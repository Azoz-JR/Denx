//
//  SignupView.h
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SignupViewDelegate <NSObject>

@optional

- (void)onSignup:(NSString *)account verifyCode:(NSString *)verifyCode password:(NSString *)password;
- (void)onSignin;
- (void)onGetVerifyCode:(NSString *)account;
- (void)onUserAgreement;
- (void)onPrivacyPolicy;
- (void)onTextFieldSelected:(NSInteger)viewTag;

@end

@interface SignupView : UIView
/// 代理
@property (nonatomic, weak) id<SignupViewDelegate> delegate;
/// 登录
@property (nonatomic, strong) UILabel *signinLabel;
/// 注册
@property (nonatomic, strong) UIButton *signupButton;
/// 协议
@property (nonatomic, strong) UILabel *agreementLabel;
/// 验证码
@property (nonatomic, strong) UIButton *verifyCodeButton;
/// 账号
@property (nonatomic, copy) NSString *account;

@end

NS_ASSUME_NONNULL_END
