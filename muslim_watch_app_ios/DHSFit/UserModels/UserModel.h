//
//  UserModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : DHBaseModel
/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// 帐号
@property (nonatomic, copy) NSString *account;
/// openId
@property (nonatomic, copy) NSString *openId;
/// 头像URL
@property (nonatomic, copy) NSString *avatar;
/// 用户昵称
@property (nonatomic, copy) NSString *name;
/// 性别（0其他 1男 2女）
@property (nonatomic, assign) NSInteger gender;
/// 生日（时间戳，精确到日）
@property (nonatomic, copy) NSString *birthday;
/// 身高（cm）
@property (nonatomic, assign) CGFloat height;
/// 体重（kg）
@property (nonatomic, assign) CGFloat weight;
/// 步数目标（step）
@property (nonatomic, assign) NSInteger stepGoal;
/// 是否同步个人信息
@property (nonatomic, assign) BOOL isSyncUserData;
/// 是否同步运动数据
@property (nonatomic, assign) BOOL isSyncSportData;
/// 是否同步健康数据
@property (nonatomic, assign) BOOL isSyncHealthData;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof UserModel *)currentModel;

/// 查询游客模型
+ (__kindof UserModel *)visitorModel;


@end

NS_ASSUME_NONNULL_END
