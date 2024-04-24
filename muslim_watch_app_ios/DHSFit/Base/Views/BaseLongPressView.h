//
//  BaseLongPressView.h
//  DHSFit
//
//  Created by DHS on 2022/8/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseLongPressViewDelegate <NSObject>

@optional

- (void)longPressEnd;

@end

@interface BaseLongPressView : UIView

/// 代理
@property (nonatomic, weak) id<BaseLongPressViewDelegate> delegate;
/// 按钮
@property (nonatomic, strong) UIButton *mainButton;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 圆角
@property (nonatomic, assign) CGFloat radius;
/// 停止动画
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
