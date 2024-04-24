//
//  HomeNavigationView.h
//  DHSFit
//
//  Created by DHS on 2022/6/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeNavigationView : UIView
/// 标题
@property (nonatomic, strong) UILabel *navTitleLabel;
/// 左按钮
@property (nonatomic, strong) UIButton *navLeftButton;
/// 右按钮
@property (nonatomic, strong) UIButton *navRightButton1;
/// 右按钮
@property (nonatomic, strong) UIButton *navRightButton2;

@end

NS_ASSUME_NONNULL_END
