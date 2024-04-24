//
//  DHDeviceLogModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDeviceLogModel : NSObject

/// 日期时间戳（秒）
@property (nonatomic, copy) NSString *timestamp;
/// 日期yyyyMMdd
@property (nonatomic, copy) NSString *date;

/// 内容
@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
