//
//  MWBaseCellModel.h
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWBaseCellModel : NSObject
/// 左icon
@property (nonatomic, copy) NSString *leftImage;
/// 左标题
@property (nonatomic, copy) NSString *leftTitle;
/// 小标题
@property (nonatomic, copy) NSString *subTitle;
/// 内容
@property (nonatomic, copy) NSString *contentTitle;
/// 右icon
@property (nonatomic, copy) NSString *rightImage;
/// 开关tag
@property (nonatomic, assign) NSInteger switchViewTag;
/// 开关状态
@property (nonatomic, assign) BOOL isOpen;
/// 是否隐藏开关
@property (nonatomic, assign) BOOL isHideSwitch;
/// 是否隐藏红点
@property (nonatomic, assign) BOOL isHideRedPoint;
/// 是否隐藏箭头
@property (nonatomic, assign) BOOL isHideArrow;
/// 是否隐藏头像
@property (nonatomic, assign) BOOL isHideAvatar;

@end

NS_ASSUME_NONNULL_END
