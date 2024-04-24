//
//  DHBleCommandDelegate.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import "DHBleCommandEnums.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DHBleCommandDelegate <NSObject>

@optional

/// 设备主动广播内容
/// @param value 数据
/// @param type 指令类型
- (void)peripheralDidUpdateValue:(id _Nullable)value type:(DHBleCommandType)type;

@end

NS_ASSUME_NONNULL_END
