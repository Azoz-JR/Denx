//
//  DHFileSyncingModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHFileSyncingModel : NSObject

/// 文件类型（0.在线表盘 1.文件 2.轨迹 3.自定义表盘 4.缩略图）
@property (nonatomic, assign) NSInteger fileType;
/// 文件大小（单位Byte）
@property (nonatomic, assign) NSInteger fileSize;
/// 文件内容
@property (nonatomic, strong, nullable) NSData *fileData;

@end

NS_ASSUME_NONNULL_END
