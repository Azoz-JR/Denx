//
//  BaseActionSheet.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BaseActionSheetClickBlock)(NSInteger tag);

@interface BaseActionSheet : UIView

/// 加载视图
/// @param titleArray 标题数组
/// @param block 回调
- (void)showWithTitles:(NSArray *)titleArray
                 block:(BaseActionSheetClickBlock)block;

@end

NS_ASSUME_NONNULL_END
