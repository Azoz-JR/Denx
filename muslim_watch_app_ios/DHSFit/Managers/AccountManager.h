//
//  AccountManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountManager : NSObject

/// 初始化游客
+ (void)initVisitor;

/// 游客登录
+ (void)signinVisitor:(VisitorModel *)visitorModel;

/// 注册成功
+ (void)userSignupSucceed:(NSString *)account userInfo:(NSDictionary *)userInfo;

/// 登录成功
+ (void)userSigninSucceed:(NSString *)account userInfo:(NSDictionary *)userInfo;

/// 第三方用户绑定成功
+ (void)thirdPartUserBindSucceed:(NSString *)account userInfo:(NSDictionary *)userInfo;

/// 游客绑定成功
+ (void)visitorBindSucceed:(NSString *)account userInfo:(NSDictionary *)userInfo;

/// 第三方登录成功
+ (void)thirdPardSigninSucceed:(NSString *)openId signinType:(NSInteger)signinType userInfo:(NSDictionary *)userInfo;

/// 退出登录
+ (void)userSignout;

/// 注销帐号
+ (void)userLogout;

/// 保存正式用户信息
/// @param userInfo 用户信息
+ (void)saveUserInfo:(NSDictionary *)userInfo;

/// 保存QQ用户信息
/// @param userInfo 用户信息
+ (void)saveQQUserInfo:(NSDictionary *)userInfo;

/// 保存微信用户信息
/// @param userInfo 用户信息
+ (void)saveWechatUserInfo:(NSDictionary *)userInfo;

/// 保存开关信息
/// @param switchInfo 开关信息
+ (void)saveSyncSwitch:(NSArray *)switchInfo;

/// 游客健康数据迁移
+ (void)visitorHealthDataTransfer;

@end

NS_ASSUME_NONNULL_END
