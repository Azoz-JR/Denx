//
//  LocalDialSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/7/4.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalDialSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 序号
@property (nonatomic, assign) NSInteger dialIndex;
/// 表盘类型（ 0.内置表盘 1.云端/自定义表盘）
@property (nonatomic, assign) NSInteger dialType;
/// 表盘ID 例：1001
@property (nonatomic, assign) NSInteger dialId;

/// 查询数据库,如果查询不到初始化新的model对象
+ (NSArray <LocalDialSetModel *>*)queryAllDials;

///删除所有
+ (void)deleteAllDials;

@end

NS_ASSUME_NONNULL_END
