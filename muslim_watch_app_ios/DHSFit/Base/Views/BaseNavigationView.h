//
//  BaseNavigationView.h
//  DHSFit
//
//  Created by DHS on 2022/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavigationView : UIView

/// 标题
@property (nonatomic, strong) UILabel *navTitleLabel;
/// 左按钮
@property (nonatomic, strong) UIButton *navLeftButton;
/// 右按钮
@property (nonatomic, strong) UIButton *navRightButton;

@end

NS_ASSUME_NONNULL_END
