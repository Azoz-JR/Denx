//
//  GuestureSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuestureSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 开关
@property (nonatomic, assign) BOOL isOpen;
/// 开始小时
@property (nonatomic, assign) NSInteger startHour;
/// 开始分钟
@property (nonatomic, assign) NSInteger startMinute;
/// 结束小时
@property (nonatomic, assign) NSInteger endHour;
/// 结束分钟
@property (nonatomic, assign) NSInteger endMinute;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof GuestureSetModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
