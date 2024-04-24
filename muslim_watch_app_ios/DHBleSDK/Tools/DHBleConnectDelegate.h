//
//  DHBleConnectDelegate.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import "DHPeripheralModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DHBleConnectDelegate <NSObject>

@optional

/// 搜索到设备
/// @param peripherals 设备列表
- (void)centralManagerDidDiscoverPeripheral:(NSArray <DHPeripheralModel *>*)peripherals;

/// 连接成功
/// @param peripheral 设备
- (void)centralManagerDidConnectPeripheral:(CBPeripheral *)peripheral;

/// Nofiy成功
/// @param peripheral 设备
- (void)centralManagerDidNotifyPeripheral:(CBPeripheral *)peripheral;

/// 断开连接
/// @param peripheral 设备
- (void)centralManagerDidDisconnectPeripheral:(CBPeripheral *)peripheral;

/// 蓝牙开关状态更新
/// @param isOn 状态
- (void)centralManagerDidUpdateState:(BOOL)isOn;

@end

NS_ASSUME_NONNULL_END
