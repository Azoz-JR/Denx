//
//  DialInfoSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialInfoSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 表盘类型 0方形 1圆形
@property (nonatomic, assign) NSInteger screenType;
/// 表盘宽度
@property (nonatomic, assign) NSInteger screenWidth;
/// 表盘长度
@property (nonatomic, assign) NSInteger screenHeight;

+ (__kindof DialInfoSetModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
