//
//  DHLocalDialModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHLocalDialModel : NSObject

/// 表盘类型（ 0.内置表盘 1.云端/自定义表盘）
@property (nonatomic, assign) NSInteger dialType;
/// 表盘ID 例：1001
@property (nonatomic, assign) NSInteger dialId;

@end

NS_ASSUME_NONNULL_END
