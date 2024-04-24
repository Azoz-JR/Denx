//
//  AccountManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "AccountManager.h"
#import "DataUploadManager.h"

@implementation AccountManager

+ (void)initVisitor {
    
    VisitorModel *visitorModel = [[VisitorModel alloc] init];
    visitorModel.userId = [NSString stringWithFormat:@"v%lld",(long long)[[NSDate date] timeIntervalSince1970]];
    [visitorModel saveOrUpdate];
    
    UserModel *model = [UserModel currentModel];
    model.userId = visitorModel.userId;
    model.account = @"";
    model.openId = @"";
    
    model.name = visitorModel.name;
    model.avatar = visitorModel.avatar;
    model.gender = visitorModel.gender;
    model.height = visitorModel.height;
    model.weight = visitorModel.weight;
    model.stepGoal = visitorModel.stepGoal;
    model.birthday = visitorModel.birthday;
    
    model.isSyncUserData = YES;
    model.isSyncSportData = YES;
    model.isSyncHealthData = YES;
    
    [model saveOrUpdate];
    
    [ConfigureModel shareInstance].appStatus = 2;
    [ConfigureModel shareInstance].visitorId = visitorModel.userId;
    [ConfigureModel shareInstance].userId = visitorModel.userId;
    [ConfigureModel shareInstance].token = @"";
    [ConfigureModel archiveraModel];
    
}

+ (void)signinVisitor:(VisitorModel *)visitorModel {
    UserModel *model = [UserModel currentModel];
    model.userId = visitorModel.userId;
    model.account = @"";
    model.openId = @"";
    
    model.name = visitorModel.name;
    model.avatar = visitorModel.avatar;
    model.gender = visitorModel.gender;
    model.height = visitorModel.height;
    model.weight = visitorModel.weight;
    model.stepGoal = visitorModel.stepGoal;
    model.birthday = visitorModel.birthday;
    
    model.isSyncUserData = YES;
    model.isSyncSportData = YES;
    model.isSyncHealthData = YES;
    
    [model saveOrUpdate];
    
    [ConfigureModel shareInstance].appStatus = 2;
    [ConfigureModel shareInstance].visitorId = visitorModel.userId;
    [ConfigureModel shareInstance].userId = visitorModel.userId;
    [ConfigureModel shareInstance].token = @"";
    [ConfigureModel archiveraModel];
    
    [self connectHistoricalDevice];
}

+ (void)userSignupSucceed:(NSString *)account userInfo:(NSDictionary *)userInfo {
    [ConfigureModel shareInstance].appStatus = 3;
    if (DHIsNotEmpty(userInfo, @"memberId")) {
        [ConfigureModel shareInstance].userId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"memberId"]];
    }
    if (DHIsNotEmpty(userInfo, @"accessToken")) {
        [ConfigureModel shareInstance].token = [userInfo objectForKey:@"accessToken"];
    }
    
    [ConfigureModel archiveraModel];
    
    UserModel *model = [UserModel currentModel];
    model.userId = DHUserId;
    model.account = account;
    model.openId = @"";
    
    model.name = @"";
    model.avatar = @"";
    model.gender = 1;
    model.height = 170.0;
    model.weight = 65.0;
    model.stepGoal = 5000;
    model.birthday = [NSDate get1970timeTempWithYear:[NSDate date].year-25 andMonth:[NSDate date].month andDay:[NSDate date].day];
    
    model.isSyncUserData = YES;
    model.isSyncSportData = YES;
    model.isSyncHealthData = YES;

    [model saveOrUpdate];
}

+ (void)userSigninSucceed:(NSString *)account userInfo:(NSDictionary *)userInfo {
    
    if (DHIsNotEmpty(userInfo, @"memberId")) {
        [ConfigureModel shareInstance].userId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"memberId"]];
    }
    if (DHIsNotEmpty(userInfo, @"accessToken")) {
        [ConfigureModel shareInstance].token = [userInfo objectForKey:@"accessToken"];
    }
    [ConfigureModel shareInstance].appStatus = 3;
    [ConfigureModel archiveraModel];
    
    UserModel *model = [UserModel currentModel];
    model.userId = DHUserId;
    model.account = account;
    model.openId = @"";
    
    model.name = @"";
    model.avatar = @"";
    model.gender = 1;
    model.height = 170.0;
    model.weight = 65.0;
    model.stepGoal = 5000;
    model.birthday = [NSDate get1970timeTempWithYear:[NSDate date].year-25 andMonth:[NSDate date].month andDay:[NSDate date].day];
    
    model.isSyncUserData = YES;
    model.isSyncSportData = YES;
    model.isSyncHealthData = YES;
    [model saveOrUpdate];
}

+ (void)thirdPartUserBindSucceed:(NSString *)account userInfo:(NSDictionary *)userInfo {
    if (DHIsNotEmpty(userInfo, @"memberId")) {
        [ConfigureModel shareInstance].userId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"memberId"]];
    }
    if (DHIsNotEmpty(userInfo, @"accessToken")) {
        [ConfigureModel shareInstance].token = [userInfo objectForKey:@"accessToken"];
    }
    [ConfigureModel shareInstance].appStatus = 3;
    [ConfigureModel archiveraModel];
    
    UserModel *model = [UserModel currentModel];
    model.userId = DHUserId;
    model.account = account;
    [model saveOrUpdate];
}

+ (void)visitorBindSucceed:(NSString *)account userInfo:(NSDictionary *)userInfo {
    if (DHIsNotEmpty(userInfo, @"memberId")) {
        [ConfigureModel shareInstance].userId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"memberId"]];
    }
    if (DHIsNotEmpty(userInfo, @"accessToken")) {
        [ConfigureModel shareInstance].token = [userInfo objectForKey:@"accessToken"];
    }
    
    [self visitorHealthDataTransfer];
    
    VisitorModel *visitorModel = [VisitorModel currentModel];
    if (visitorModel) {
        [visitorModel deleteObject];
    }
    [ConfigureModel shareInstance].visitorId = @"";
    
    NSData *data = [DHFile queryLocalImageWithFolderName:DHAvatarFolder fileName:[NSString stringWithFormat:@"%@.png",DHVisitorId]];
    if (data) {
        UIImage *avatar = [UIImage imageWithData:data];
        [DHFile saveLocalImageWithImage:avatar folderName:DHAvatarFolder fileName:[NSString stringWithFormat:@"%@.png",DHUserId]];
    }
    
    if (DHDeviceBinded) {
        DeviceModel *deviceModel = [DeviceModel currentModel];
        if (deviceModel) {
            deviceModel.userId = DHUserId;
            [deviceModel saveOrUpdate];
        }
        if (DHDeviceConnected) {
            [self delayPerformBlock:^(id  _Nonnull object) {
                [[DHBluetoothManager shareInstance] bindDevice];
            } WithTime:1.0];
        }
    }

    [ConfigureModel shareInstance].appStatus = 3;
    [ConfigureModel archiveraModel];
    
    UserModel *model = [UserModel currentModel];
    model.userId = DHUserId;
    model.account = account;
    [model saveOrUpdate];
    
    //游客绑定成功
    [DHNotificationCenter postNotificationName:AppNotificationVisitorChange object:nil];
}

+ (void)thirdPardSigninSucceed:(NSString *)openId signinType:(NSInteger)signinType userInfo:(NSDictionary *)userInfo {
    [ConfigureModel shareInstance].appStatus = 3;
    if (DHIsNotEmpty(userInfo, @"memberId")) {
        [ConfigureModel shareInstance].userId = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"memberId"]];
    }
    if (DHIsNotEmpty(userInfo, @"accessToken")) {
        [ConfigureModel shareInstance].token = [userInfo objectForKey:@"accessToken"];
    }
    [ConfigureModel archiveraModel];
    
    UserModel *model = [UserModel currentModel];
    model.userId = DHUserId;
    model.openId = openId;
    model.account = @"";
    
    model.name = @"";
    model.avatar = @"";
    model.gender = 1;
    model.height = 170.0;
    model.weight = 65.0;
    model.stepGoal = 5000;
    model.birthday = [NSDate get1970timeTempWithYear:[NSDate date].year-25 andMonth:[NSDate date].month andDay:[NSDate date].day];
    
    model.isSyncUserData = YES;
    model.isSyncSportData = YES;
    model.isSyncHealthData = YES;
    [model saveOrUpdate];
}

+ (void)userSignout {
    UserModel *model = [UserModel currentModel];
    model.account = @"";
    model.openId = @"";
    [model saveOrUpdate];
    
    [DHFile removeLocalImageWithFolderName:DHAvatarFolder fileName:@"avatar.png"];
    
    if (DHDeviceBinded) {
        [DHBleCentralManager setBindedStatus:NO];
        [DHBleCentralManager disconnectDevice];
    }

    [ConfigureModel shareInstance].appStatus = 1;
    [ConfigureModel shareInstance].userId = @"";
    [ConfigureModel shareInstance].token = @"";
    [ConfigureModel shareInstance].macAddr = @"";
    [ConfigureModel archiveraModel];
}

+ (void)userLogout {
    UserModel *model = [UserModel currentModel];
    [model deleteObject];
    
    [DHFile removeLocalImageWithFolderName:DHAvatarFolder fileName:@"avatar.png"];
    
    if (DHDeviceBinded) {
        NSString *macAddr = [DHMacAddr stringByReplacingOccurrencesOfString:@":" withString:@""];
        [DHFile removeLocalImageWithFolderName:DHDialFolder fileName:[NSString stringWithFormat:@"%@.png",macAddr]];
        
        OnlineFirmwareVersionModel *onlineModel = [OnlineFirmwareVersionModel currentModel];
        if (onlineModel.onlineVersion.length) {
            [onlineModel deleteObject];
        }
        
        [DHBleCentralManager setBindedStatus:NO];
        [DHBleCentralManager disconnectDevice];
        
        DeviceModel *deviceModel = [DeviceModel currentModel];
        [deviceModel deleteObject];
    }
    
    [ConfigureModel shareInstance].appStatus = 1;
    [ConfigureModel shareInstance].userId = @"";
    [ConfigureModel shareInstance].token = @"";
    [ConfigureModel shareInstance].macAddr = @"";
    [ConfigureModel archiveraModel];
}

+ (void)saveUserInfo:(NSDictionary *)userInfo {
    UserModel *model = [UserModel currentModel];
    
    if (DHIsNotEmpty(userInfo, @"name")) {
        model.name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"name"]];
    }
    if (DHIsNotEmpty(userInfo, @"birthday")) {
        model.birthday = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"birthday"]];
    }
    if (DHIsNotEmpty(userInfo, @"sex")) {
        NSInteger gender = [[userInfo objectForKey:@"sex"] integerValue];
        model.gender = gender == 2 ? 0 : 1;
    }
    if (DHIsNotEmpty(userInfo, @"height")) {
        model.height = [[userInfo objectForKey:@"height"] integerValue];
    }
    if (DHIsNotEmpty(userInfo, @"weight")) {
        model.weight = [[userInfo objectForKey:@"weight"] integerValue];
    }
    if (DHIsNotEmpty(userInfo, @"portraitUrl")) {
        model.avatar = [userInfo objectForKey:@"portraitUrl"];
    }
    if (DHIsNotEmpty(userInfo, @"sportTarget")) {
        model.stepGoal = [[userInfo objectForKey:@"sportTarget"] integerValue];
    }
    
    if (model.stepGoal == 0) {
        model.stepGoal = 5000;
    }
    [model saveOrUpdate];
    if (![DHBluetoothManager shareInstance].isAppLaunch) {
        [self connectHistoricalDevice];
    }
    
    //用户信息更新
    [DHNotificationCenter postNotificationName:AppNotificationUserInfoChange object:nil];
}

+ (void)saveQQUserInfo:(NSDictionary *)userInfo {
    UserModel *model = [UserModel currentModel];
    if (DHIsNotEmpty(userInfo, @"nickname")) {
        model.name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"nickname"]];
    }
    if (DHIsNotEmpty(userInfo, @"figureurl_2")) {
        model.avatar = [userInfo objectForKey:@"figureurl_2"];
    }
    
    if (DHIsNotEmpty(userInfo, @"gender_type")) {
        NSInteger gender = [[userInfo objectForKey:@"gender_type"] integerValue];
        model.gender = gender == 2 ? 1 : 0;
    }
    if (DHIsNotEmpty(userInfo, @"year")) {
        NSInteger year = [[userInfo objectForKey:@"year"] integerValue];
        if (year >= 1900) {
            model.birthday = [NSDate get1970timeTempWithYear:year andMonth:1 andDay:1];
        }
        
    }
    [model saveOrUpdate];
    
}

+ (void)saveWechatUserInfo:(NSDictionary *)userInfo {
    UserModel *model = [UserModel currentModel];
    if (DHIsNotEmpty(userInfo, @"nickname")) {
        model.name = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"nickname"]];
    }
    if (DHIsNotEmpty(userInfo, @"headimgurl")) {
        model.avatar = [userInfo objectForKey:@"headimgurl"];
    }
    
    if (DHIsNotEmpty(userInfo, @"sex")) {
        NSInteger gender = [[userInfo objectForKey:@"sex"] integerValue];
        model.gender = gender == 0 ? 1 : 0;
    }
    [model saveOrUpdate];
}

+ (void)saveSyncSwitch:(NSArray *)switchInfo {
    UserModel *model = [UserModel currentModel];
    if (switchInfo.count == 0) {
        model.isSyncUserData = YES;
        model.isSyncSportData = YES;
        model.isSyncHealthData = YES;
    } else {
        for (NSDictionary *dict in switchInfo) {
            if ([dict[@"paraName"] isEqualToString:@"isPerson"]) {
                model.isSyncUserData = [dict[@"paraValue"] integerValue];
            } else if ([dict[@"paraName"] isEqualToString:@"isSport"]) {
                model.isSyncSportData = [dict[@"paraValue"] integerValue];
            } else if ([dict[@"paraName"] isEqualToString:@"isHealth"]) {
                model.isSyncHealthData = [dict[@"paraValue"] integerValue];
            }
        }
    }
    [model saveOrUpdate];
    
    if (DHAppStatus == 3) {
        [DataUploadManager downloadAllHealthData];
        //监控数据下载完成
        [self delayPerformBlock:^(id  _Nonnull object) {
            [DHNotificationCenter postNotificationName:BluetoothNotificationHealthDataDownloadCompleted object:nil];
        } WithTime:3.0];
        
    }
}

+ (void)visitorHealthDataTransfer {
    NSArray *stepModels = [DailyStepModel queryVisitorModels];
    if (stepModels.count) {
        for (DailyStepModel *model in stepModels) {
            model.userId = DHUserId;
            [model saveOrUpdate];
        }
    }
    
    NSArray *sleepModels = [DailySleepModel queryVisitorModels];
    if (sleepModels.count) {
        for (DailySleepModel *model in sleepModels) {
            model.userId = DHUserId;
            [model saveOrUpdate];
        }
    }
    
    NSArray *hrModels = [DailyHeartRateModel queryVisitorModels];
    if (hrModels.count) {
        for (DailyHeartRateModel *model in hrModels) {
            model.userId = DHUserId;
            [model saveOrUpdate];
        }
    }
    
    NSArray *bpModels = [DailyBpModel queryVisitorModels];
    if (bpModels.count) {
        for (DailyBpModel *model in bpModels) {
            model.userId = DHUserId;
            [model saveOrUpdate];
        }
    }
    
    NSArray *boModels = [DailyBoModel queryVisitorModels];
    if (boModels.count) {
        for (DailyBoModel *model in boModels) {
            model.userId = DHUserId;
            [model saveOrUpdate];
        }
    }
    
    NSArray *tempModels = [DailyTempModel queryVisitorModels];
    if (tempModels.count) {
        for (DailyTempModel *model in tempModels) {
            model.userId = DHUserId;
            [model saveOrUpdate];
        }
    }
    
    NSArray *breathModels = [DailyBreathModel queryVisitorModels];
    if (breathModels.count) {
        for (DailyBreathModel *model in breathModels) {
            model.userId = DHUserId;
            [model saveOrUpdate];
        }
    }
    
    NSArray *sportModels = [DailySportModel queryVisitorModels];
    if (sportModels.count) {
        for (DailySportModel *model in sportModels) {
            model.userId = DHUserId;
            [model saveOrUpdate];
        }
    }
}

+ (void)connectHistoricalDevice {
    DeviceModel *historyModel = [DeviceModel historyModel];
    if (historyModel.macAddr.length) {
        DHPeripheralModel *peripheralModel = [[DHPeripheralModel alloc] init];
        peripheralModel.macAddr = historyModel.macAddr;
        peripheralModel.uuid = historyModel.uuid;
        peripheralModel.name = historyModel.name;
        [DHBleCentralManager connectHistoricalDeviceWithModel:peripheralModel];
        
        [ConfigureModel shareInstance].macAddr = historyModel.macAddr;
        [ConfigureModel shareInstance].weatherTime = 0;
        [ConfigureModel shareInstance].isNeedConnect = YES;
        [ConfigureModel archiveraModel];
        
        [[DHBluetoothManager shareInstance] initBindedDevice];
        
        //连接历史设备
        [DHNotificationCenter postNotificationName:BluetoothNotificationConnectHistoricalDevice object:nil];
    }
}

@end
