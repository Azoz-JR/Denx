//
//  NetworkManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/13.
//

#import "NetworkManager.h"

@implementation NetworkManager

#pragma mark 错误码转换

+ (NSString *)transformErrorCode:(NSInteger)errorCode {
    if (errorCode == 401) {
        return Lang(@"str_login_overdue");
    }
    if (errorCode == 1010) {
        return Lang(@"str_account_not_exist_login");
    }
    if (errorCode == 1011) {
        return Lang(@"str_account_pw_error");
    }
    if (errorCode == 1020) {
        return Lang(@"str_account_exist");
    }
    if (errorCode == 1021) {
        return Lang(@"str_old_pw_error");
    }
    if (errorCode == 1022) {
        return Lang(@"str_verify_overdue");
    }
    if (errorCode == 1023) {
        return Lang(@"str_verify_overdue");
    }
    if (errorCode == 1024) {
        return Lang(@"str_verify_error");
    }
    if (errorCode == 1025) {
        return Lang(@"str_verify_overdue");
    }
    return @"";
}

#pragma mark 注册登录接口

+ (void)registerWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl registerWithParam:parameter andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)loginWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl loginWithParam:parameter andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)resetPasswordWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl resetPasswordWithParam:parameter andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)sendEmailCodeWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl sendEmailCodeWithParam:parameter andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)updateUserInformWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl updateUserInformWithParam:parameter andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)queryUserInformWithParameter:(NSDictionary *)parameter andBlock:(nullable void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl queryUserInformWithParam:parameter andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            [AccountManager saveUserInfo:data];
        }
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)updatePasswordWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl updatePasswordWithParam:parameter andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)signoutWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl signoutWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)saveSwitchWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl saveSwitchWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)querySwitchWithParam:(NSDictionary *)param andBlock:(nullable void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl querySwitchWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            [AccountManager saveSyncSwitch:data];
        }
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)queryAppVersionWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl queryAppVersionWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)feedbackWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl feedbackWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

///获取手表型号和图片信息
+ (void)getModelInfo:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block
{
    NSLog(@"getModelInfo param: %@", param);
    [DHNetworkControl getModelInfo:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode, message, data);
        }
    }];
}
/// 获取文档url(用户协议，隐私，帮助)
+ (void)getDocUrl:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block
{
    [DHNetworkControl getDocUrl:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode, message, data);
        }
    }];
}

+ (void)getWellKnownUrl:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block
{
    NSLog(@"getWellKnownUrl %@", param);
    [DHNetworkControl getWellKnownUrl:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode, message, data);
        }
    }];
}

#pragma mark 第三方登录相关接口


+ (void)thirdLoginWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl thirdLoginWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)thirdLoginBindWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl thirdLoginBindWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)deleteAccountWithParameter:(NSDictionary *)parameter andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl deleteAccountWithParam:parameter andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

#pragma mark 设备模块

+ (void)queryFirmwareVersionWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl queryFirmwareVersionWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)queryWeatherWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl queryWeatherWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)queryForeignWeatherWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block
{
    [DHNetworkControl queryForeignWeatherWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)queryLocationWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl queryLocationWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)queryMainRecommendDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    NSLog(@"queryMainRecommendDialWithParam %@", param);
    [DHNetworkControl queryMainRecommendDialWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)queryRecommendDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    NSLog(@"queryRecommendDialWithParam %@", param);
    [DHNetworkControl queryRecommendDialWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode, message, data);
        }
    }];
}

+ (void)queryAllDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl queryAllDialWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)queryInstalledDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl queryInstalledDialWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)queryCustomDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl queryCustomDialWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)saveDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl saveDialWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)deleteDialWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl deleteDialWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)activatingDeviceWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl activatingDeviceWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

#pragma mark 数据相关

+ (void)clearDataWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl clearDataWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)deleteSportDataWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl deleteSportDataWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)uploadStepWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl uploadStepWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)uploadSleepWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl uploadSleepWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)uploadHeartRateWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl uploadHeartRateWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)uploadBpWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl uploadBpWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)uploadBoWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl uploadBoWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)uploadBreathWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl uploadBreathWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)uploadTempWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl uploadTempWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)uploadSportWithParam:(NSArray *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl uploadSportWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)downloadStepWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl downloadStepWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)downloadSleepWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl downloadSleepWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)downloadHeartRateWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl downloadHeartRateWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)downloadBpWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl downloadBpWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)downloadBoWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl downloadBoWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)downloadBreathWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl downloadBreathWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)downloadTempWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl downloadTempWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (void)downloadSportWithParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl downloadSportWithParam:param andHeader:[self header] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

#pragma mark 文件上传

+ (void)uploadFile:(NSData *)fileData andParam:(NSDictionary *)param andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl uploadFile:fileData andHeader:[self header] andParam:param andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

#pragma mark 文件下载

+ (void)downloadFileWithParameter:(NSDictionary *)parameter progress:(nullable void (^)(NSProgress * _Nonnull))progress andBlock:(void(^)(NSInteger resultCode,NSString *message, id data))block {
    [DHNetworkControl downloadFileWithParameter:parameter progress:^(NSProgress * _Nonnull progress) {
        
    } andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (block) {
            block(resultCode,message,data);
        }
    }];
}

+ (NSDictionary *)header {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([ConfigureModel shareInstance].token.length) {
        [dict setObject:[NSString stringWithFormat:@"bearer %@",[ConfigureModel shareInstance].token] forKey:@"Authorization"];
    }
    return dict;
}


@end
