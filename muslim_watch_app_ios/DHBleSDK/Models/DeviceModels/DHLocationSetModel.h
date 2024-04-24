//
//  DHLocationSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2023/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHLocationSetModel : NSObject

/// 经度
@property (nonatomic, assign) NSInteger longitude;
/// 纬度
@property (nonatomic, assign) NSInteger latitude;
/// 标签
@property (nonatomic, copy) NSString *locationStr;

@end

NS_ASSUME_NONNULL_END
