//
//  BaseProgressView.h
//  DHSFit
//
//  Created by DHS on 2022/6/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseProgressView : UIView

/// 更新表盘同步进度
/// @param progress 进度
- (void)updateDialSyncingProgress:(CGFloat)progress;
/// 更新文件同步进度
/// @param progress 进度
- (void)updateFileSyncingProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
