//
//  DeviceModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceModel : DHBaseModel
/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// Mac地址
@property (nonatomic, copy) NSString *macAddr;
/// UUID
@property (nonatomic, copy) NSString *uuid;
/// 设备名称
@property (nonatomic, copy) NSString *name;
/// 固件版本 例：1.0.0
@property (nonatomic, copy) NSString *firmwareVersion;
/// 设备型号 例：DW01
@property (nonatomic, copy) NSString *deviceModel;
/// 绑定时间戳（秒）
@property (nonatomic, copy) NSString *timestamp;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof DeviceModel *)currentModel;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof DeviceModel *)historyModel;

@end

NS_ASSUME_NONNULL_END
