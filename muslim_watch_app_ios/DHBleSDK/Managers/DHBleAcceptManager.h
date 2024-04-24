//
//  DHBleAcceptManager.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHBleAcceptManager : NSObject

/// 单例
+ (__kindof DHBleAcceptManager *)shareInstance;
/// 接收命令原始数据
@property (nonatomic, strong) NSMutableDictionary *receiveSliceDatas;
/// 接收蓝牙数据并解析
/// @param response 蓝牙数据
- (void)didUpdateValueWithResponse:(NSData *)response;
/// 清空数据
- (void)clearData;


@end

NS_ASSUME_NONNULL_END
