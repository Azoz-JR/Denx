//
//  DHCustomDialSyncingModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/10/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHCustomDialSyncingModel : NSObject

/// 时间位置（0.上方 1.下方）
@property (nonatomic, assign) NSInteger timePos;
/// 时间上方元素（0. 无 1.日期 2.睡眠 3.心率 4.计步）
@property (nonatomic, assign) NSInteger timeUp;
/// 时间下方元素（0. 无 1.日期 2.睡眠 3.心率 4.计步）
@property (nonatomic, assign) NSInteger timeDown;
/// 文字颜色 (RGB 例：0xFFFFFF）
@property (nonatomic, assign) NSInteger textColor;
/// 图片类型（0.不更改背景图片 1.系统背景图片 2.自定义背景图片）
@property (nonatomic, assign) NSInteger imageType;
/// 图片宽度（像素 例：240）
@property (nonatomic, assign) NSInteger imageWidth;
/// 图片高度（像素 例：280）
@property (nonatomic, assign) NSInteger imageHeight;
/// 图片内容
@property (nonatomic, strong, nullable) NSData *fileData;

@end

NS_ASSUME_NONNULL_END
