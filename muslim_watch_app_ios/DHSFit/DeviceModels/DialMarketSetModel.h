//
//  DialMarketSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/6/17.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialMarketSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

/// 图片路径
@property (nonatomic, copy) NSString *imagePath;
/// 文件路径
@property (nonatomic, copy) NSString *filePath;
/// 缩略图路径
@property (nonatomic, copy) NSString *thumbnailPath;
/// 名字
@property (nonatomic, copy) NSString *name;
/// 描述
@property (nonatomic, copy) NSString *desc;
/// 价格
@property (nonatomic, assign) NSInteger price;
/// 下载次数
@property (nonatomic, assign) NSInteger downlaod;
/// 文件大小
@property (nonatomic, assign) NSInteger fileSize;
/// 表盘ID
@property (nonatomic, assign) NSInteger dialId;

/// 查询数据库,如果查询不到初始化新的model对象
+ (NSArray <DialMarketSetModel *>*)queryAllDials;

@end

NS_ASSUME_NONNULL_END
