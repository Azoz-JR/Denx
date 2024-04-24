//
//  JLBleAcceptManager.h
//  DHSFit
//
//  Created by DHS on 2023/10/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLBleAcceptManager : NSObject

/// 单例
+ (__kindof JLBleAcceptManager *)shareInstance;

@property (nonatomic, strong) NSMutableArray *receiveSliceDatas;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, assign) NSInteger gTimezoneOffset;

@property (nonatomic, strong) NSString *jlDeviceModel; //靖云 08010100, 360x360圆形 02130101
/// 接收蓝牙数据并解析
/// @param response 蓝牙数据
- (void)didUpdateValueWithResponse:(NSData *)response;
/// 清空数据
- (void)clearData;

@end

NS_ASSUME_NONNULL_END
