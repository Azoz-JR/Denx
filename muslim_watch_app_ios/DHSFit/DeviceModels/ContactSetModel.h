//
//  ContactSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 序号
@property (nonatomic, assign) BOOL contactIndex;
/// 名字
@property (nonatomic, copy) NSString *name;
/// 号码
@property (nonatomic, copy) NSString *mobile;

/// 查询数据库,如果查询不到初始化新的model对象
+ (NSArray <ContactSetModel *>*)queryAllContacts;

@end

NS_ASSUME_NONNULL_END
