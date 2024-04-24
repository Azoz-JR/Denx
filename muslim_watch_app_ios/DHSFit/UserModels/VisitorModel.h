//
//  VisitorModel.h
//  DHSFit
//
//  Created by DHS on 2022/9/2.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VisitorModel : DHBaseModel
/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// 头像URL
@property (nonatomic, copy) NSString *avatar;
/// 用户昵称
@property (nonatomic, copy) NSString *name;
/// 性别（0女 1男）
@property (nonatomic, assign) NSInteger gender;
/// 生日（时间戳，精确到日）
@property (nonatomic, copy) NSString *birthday;
/// 身高（cm）
@property (nonatomic, assign) CGFloat height;
/// 体重（kg）
@property (nonatomic, assign) CGFloat weight;
/// 步数目标（step）
@property (nonatomic, assign) NSInteger stepGoal;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof VisitorModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
