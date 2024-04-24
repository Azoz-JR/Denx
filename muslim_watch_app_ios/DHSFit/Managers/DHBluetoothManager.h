//
//  DHBluetoothManager.h
//  DHSFit
//
//  Created by DHS on 2022/10/13.
//

#import <Foundation/Foundation.h>
#import "DevcieModelInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHBluetoothManager : NSObject<DHBleConnectDelegate,DHBleCommandDelegate>

/// 单例
+ (__kindof DHBluetoothManager *)shareInstance;

/// 正在拍照页面
@property (nonatomic, assign) BOOL isTakingPictures;
/// 正在QQ登录
@property (nonatomic, assign) BOOL isSigninQQ;
/// APP启动
@property (nonatomic, assign) BOOL isAppLaunch;
/// 连接状态
@property (nonatomic, assign) BOOL isConnected;
/// 是否绑定
@property (nonatomic, assign) BOOL isBinded;
/// APP是否在前台
@property (nonatomic, assign) BOOL isActive;
/// 是否正在同步
@property (nonatomic, assign) BOOL isDataSyncing;
/// 是否激活设备
@property (nonatomic, assign) BOOL isNeedActivatingDevice;

#pragma mark 设备信息
/// 设备图片
@property (nonatomic, copy) NSString *deviceImage;
/// 设备名
@property (nonatomic, copy) NSString *deviceName;
/// 固件版本
@property (nonatomic, copy) NSString *firmwareVersion;
/// 设备型号 例：DW01
@property (nonatomic, copy) NSString *deviceModel;
/// 电量
@property (nonatomic, strong) DHBatteryInfoModel *batteryModel;
/// 表盘信息
@property (nonatomic, strong) DialInfoSetModel *dialInfoModel;

@property (nonatomic, strong) DevcieModelInfo *dialServiceInfoModel;

/// 初始化绑定设备
- (void)initBindedDevice;

/// 配置设备信息
- (void)configureDeviceInfo;

/// 获取绑定信息
- (void)getBindInfo;

/// 设置APP前后台状态
- (void)setAppStatus;

- (void)setTime;

- (void)setUnit;

- (void)setJLUnit;

- (void)getBattery;

/// 开始同步数据
- (void)startDataSyncing;

/// 绑定设备
- (void)bindDevice;

- (void)setJLMuslimArgs:(Boolean)isChina;

@end

NS_ASSUME_NONNULL_END
