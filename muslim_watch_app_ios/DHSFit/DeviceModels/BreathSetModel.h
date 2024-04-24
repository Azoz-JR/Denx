//
//  BreathSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/8/10.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BreathSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 开关
@property (nonatomic, assign) BOOL isOpen;
/// 小时
@property (nonatomic, copy) NSString *hourItems;
/// 分钟
@property (nonatomic, copy) NSString *minuteItems;


/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof BreathSetModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
