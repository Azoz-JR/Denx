//
//  DHPeripheralModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHPeripheralModel : NSObject

/// 外围设备
@property (nonatomic,strong) CBPeripheral *peripheral;
/// MAC地址
@property (nonatomic,strong) NSString *macAddr;
/// UUID
@property (nonatomic,strong) NSString *uuid;
/// 设备名
@property (nonatomic,strong) NSString *name;
/// 信号强度（0-255 数值越小距离越近）
@property (nonatomic,assign) NSInteger rssi;

@property (nonatomic,assign) NSInteger pidType; //0 瑞昱 1 杰里

@end

NS_ASSUME_NONNULL_END
