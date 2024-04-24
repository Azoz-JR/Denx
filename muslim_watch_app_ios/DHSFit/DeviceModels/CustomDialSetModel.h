//
//  CustomDialSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/10/6.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomDialSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 图片路径
@property (nonatomic, copy) NSString *imagePath;
/// 时间位置（0.上方 1.下方）
@property (nonatomic, assign) NSInteger timePos;
/// 时间上方元素（0. 无 1.日期 2.睡眠 3.心率 4.计步）
@property (nonatomic, assign) NSInteger timeUp;
/// 时间下方元素（0. 无 1.日期 2.睡眠 3.心率 4.计步）
@property (nonatomic, assign) NSInteger timeDown;
/// 文字颜色 (例：0xFFFFFF）
@property (nonatomic, assign) NSInteger textColor;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof CustomDialSetModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
