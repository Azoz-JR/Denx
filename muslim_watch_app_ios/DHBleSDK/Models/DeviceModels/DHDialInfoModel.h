//
//  DHDialInfoModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDialInfoModel : NSObject

/// 表盘类型（ 0.方形 1.圆形）
@property (nonatomic, assign) NSInteger screenType;
/// 表盘宽度 例：240
@property (nonatomic, assign) NSInteger screenWidth;
/// 表盘高度 例：280
@property (nonatomic, assign) NSInteger screenHeight;

@end

NS_ASSUME_NONNULL_END
