//
//  BaseAlertView.h
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BaseAlertViewClickType) {
    BaseAlertViewClickTypeCancel= 1,
    BaseAlertViewClickTypeConfirm
};

typedef void(^BaseAlertViewClickBlock)(BaseAlertViewClickType type);

@interface BaseAlertView : UIView

/// 加载视图
/// @param title 标题
/// @param message 内容
/// @param cancel 取消
/// @param confirm 确认
/// @param isCenter message居中
/// @param block 回调
- (void)showWithTitle:(NSString *)title
              message:(NSString *)message
               cancel:(NSString *)cancel
              confirm:(NSString *)confirm
  textAlignmentCenter:(BOOL)isCenter
                block:(BaseAlertViewClickBlock)block;

/// 隐藏弹框
- (void)hideCustomAlertView;

@end

NS_ASSUME_NONNULL_END
