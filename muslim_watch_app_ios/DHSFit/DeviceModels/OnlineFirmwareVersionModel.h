//
//  OnlineFirmwareVersionModel.h
//  DHSFit
//
//  Created by DHS on 2022/11/12.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OnlineFirmwareVersionModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 当前版本
@property (nonatomic, copy) NSString *currentVersion;
/// 线上版本
@property (nonatomic, copy) NSString *onlineVersion;
/// 文件路径
@property (nonatomic, copy) NSString *filePath;
/// 文件大小
@property (nonatomic, assign) NSInteger fileSize;
/// 描述
@property (nonatomic, copy) NSString *desc;

/// 查询数据库,如果查询不到初始化新的model对象
+ (__kindof OnlineFirmwareVersionModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
