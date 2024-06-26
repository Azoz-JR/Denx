//
//  BrightTimeSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrightTimeSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 时长
@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) NSString *durationNums;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof BrightTimeSetModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
