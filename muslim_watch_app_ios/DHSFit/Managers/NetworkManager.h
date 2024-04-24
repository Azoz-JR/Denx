//
//  NetworkManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

#pragma mark 错误码转换

/// 错误码转换
/// @param errorCode 错误码
+ (NSString *)transformErrorCode:(NSInteger)errorCode;

#pragma mark 注册登录接口
/// 用户注册
/// @param parameter 参数 {@"account" : @"test@163.com",@"password" : @"ab123456",@"verifyCode":@"1234" }
/// @param block 回调
+ (void)registerWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 用户登录
/// @param parameter 参数 {@"username" : @"test@163.com",@"password" : @"ab123456" }
/// @param block 回调
+ (void)loginWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 找回密码
/// @param parameter 参数 {@"account" : @"test@163.com",@"password" : @"ab123456",@"verifyCode" : @"1234" }
/// @param block 回调
+ (void)resetPasswordWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 发送邮箱验证码
/// @param parameter 参数  {@"account" : @"test@163.com",@"verifyCodeType" : @"1" } 备注verifyCodeType: 0注册，1找回密码，2绑定账号，3注销账户
/// @param block 回调
+ (void)sendEmailCodeWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 更新用户信息
/// @param parameter 参数 {@"portraitUrl" : @"http://xxx.png",@"name" : @"xx",@"sex" : @"xx",@"birthday" : @"xx",@"height" : @"xx",@"weight" : @"xx" }
/// @param block 回调
+ (void)updateUserInformWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 查询当前用户信息
/// @param parameter 参数
/// @param block 回调
+ (void)queryUserInformWithParameter:(NSDictionary *)parameter andBlock:(nullable void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 更改密码
/// @param parameter 参数 {@"oldPassword" : @"xx" ,@"newPassword" : @"xx" }
/// @param block 回调
+ (void)updatePasswordWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 退出登录
/// @param param 参数 nil
/// @param block 回调
+ (void)signoutWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 保存数据同步配置
/// @param param 参数 {@"dataSyncUser" : @"Y" ,@"dataSyncSport" : @"Y",@"dataSyncHealth" : @"Y" }
/// @param block 回调
+ (void)saveSwitchWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 查询数据同步配置
/// @param param 参数
/// @param block 回调
+ (void)querySwitchWithParam:(NSDictionary *)param andBlock:(nullable void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 查询APP版本
/// @param param 参数 {@"type" : @"1"}
/// @param block 回调
+ (void)queryAppVersionWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 意见反馈
/// @param param 参数 {@"desc" : @"xx" ,@"pictureUrls" : @"xx,xx" ,@"logUrls" : @"xx,xx" ,@"contact" : @"xx"  }
/// @param block 回调
+ (void)feedbackWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

///获取手表型号和图片信息
+ (void)getModelInfo:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;
/// 获取文档url(用户协议，隐私，帮助)
+ (void)getDocUrl:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

+ (void)getWellKnownUrl:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

#pragma mark 第三方登录相关接口

/// 第三方登录
/// @param param 参数 {@"type" : @"1",@"openId" : @"xxx" } 备注type 0其他，1微信，2facebook，3google，4apple， 5QQ
/// @param block 回调
+ (void)thirdLoginWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 第三方绑定
/// @param param 参数 {@"account":@"xx",@"password":@"xx",@"verifyCode" : @"xxx" }
/// @param block 回调
+ (void)thirdLoginBindWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 注销用户
/// @param parameter 参数 {@"password" : @"xx" ,@"verifyCode" : @"666666" }
/// @param block 回调
+ (void)deleteAccountWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

#pragma mark 设备模块

/// 查询固件版本
/// @param param 参数 {@"deviceId" : @"xx" ,@"currentVersion" : @"xx" }
/// @param block 回调
+ (void)queryFirmwareVersionWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 查询天气数据
/// @param param 参数
/// @param block 回调
+ (void)queryWeatherWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

+ (void)queryForeignWeatherWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;


/// 查询定位信息
/// @param param 参数
/// @param block 回调
+ (void)queryLocationWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;


/// 查询设备首页推荐表盘
/// @param param 参数
/// @param block 回调
+ (void)queryMainRecommendDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 查询推荐表盘
/// @param param 参数
/// @param block 回调
+ (void)queryRecommendDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 查询所有表盘
/// @param param 参数
/// @param block 回调
+ (void)queryAllDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 查询已安装表盘
/// @param param 参数
/// @param block 回调
+ (void)queryInstalledDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 查询自定义表盘
/// @param param 参数
/// @param block 回调
+ (void)queryCustomDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 保存表盘
/// @param param 参数
/// @param block 回调
+ (void)saveDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 删除表盘
/// @param param 参数
/// @param block 回调
+ (void)deleteDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 设备激活
/// @param param 参数 {@"deviceId" : @"x" ,@"model" : @"x" }
/// @param block 回调
+ (void)activatingDeviceWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

#pragma mark 数据相关

/// 清除数据
+ (void)clearDataWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 删除运动数据
/// @param param 参数 {@"timestamp" : @"x" }
/// @param block 回调
+ (void)deleteSportDataWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 步数数据上传
/// @param param 参数
/// @param block 回调
+ (void)uploadStepWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 睡眠数据上传
/// @param param 参数
/// @param block 回调
+ (void)uploadSleepWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 心率数据上传
/// @param param 参数
/// @param block 回调
+ (void)uploadHeartRateWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 血压数据上传
/// @param param 参数
/// @param block 回调
+ (void)uploadBpWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 血氧数据上传
/// @param param 参数
/// @param block 回调
+ (void)uploadBoWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 呼吸训练数据上传
/// @param param 参数
/// @param block 回调
+ (void)uploadBreathWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 体温数据上传
/// @param param 参数
/// @param block 回调
+ (void)uploadTempWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 运动数据上传
/// @param param 参数
/// @param block 回调
+ (void)uploadSportWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 步数数据下载
/// @param param 参数 {@"startDate" : @"x" ,@"endDate" : @"x" }
/// @param block 回调
+ (void)downloadStepWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 睡眠数据下载
/// @param param 参数 {@"startDate" : @"x" ,@"endDate" : @"x" }
/// @param block 回调
+ (void)downloadSleepWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 心率数据下载
/// @param param 参数 {@"startDate" : @"x" ,@"endDate" : @"x" }
/// @param block 回调
+ (void)downloadHeartRateWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 血压数据下载
/// @param param 参数 {@"startDate" : @"x" ,@"endDate" : @"x" }
/// @param block 回调
+ (void)downloadBpWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 血氧数据上传
/// @param param 参数 {@"startDate" : @"x" ,@"endDate" : @"x" }
/// @param block 回调
+ (void)downloadBoWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 呼吸训练数据下载
/// @param param 参数 {@"startDate" : @"x" ,@"endDate" : @"x" }
/// @param block 回调
+ (void)downloadBreathWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 体温数据下载
/// @param param 参数 {@"startDate" : @"x" ,@"endDate" : @"x" }
/// @param block 回调
+ (void)downloadTempWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

/// 运动数据下载
/// @param param 参数 {@"startDate" : @"x" ,@"endDate" : @"x" }
/// @param block 回调
+ (void)downloadSportWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;


#pragma mark 上传文件

/// 上传文件
/// @param fileData 文件内容
/// @param param 参数
/// @param block 回调
+ (void)uploadFile:(NSData *)fileData andParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;

#pragma mark 文件下载

/// 文件下载
/// @param parameter 参数
/// @param progress 进度回调
/// @param block 回调
+ (void)downloadFileWithParameter:(NSDictionary *)parameter progress:(nullable void (^)(NSProgress * _Nonnull))progress andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block;


@end

NS_ASSUME_NONNULL_END
