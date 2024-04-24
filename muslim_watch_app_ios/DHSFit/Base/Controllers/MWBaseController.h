//
//  MWBaseController.h
//  DHSFit
//
//  Created by DHS on 2022/5/30.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationView.h"
#import "HomeNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MWBaseController : UIViewController

/// 导航栏标题
@property (nonatomic, copy) NSString *navTitle;
/// 导航栏右按钮
@property (nonatomic, copy) NSString *navRightImage;
/// 导航栏左按钮
@property (nonatomic, copy) NSString *navLeftImage;
/// 导航栏右按钮
@property (nonatomic, copy) NSString *navRightImage2;
/// 是否隐藏导航栏
@property (nonatomic, assign) BOOL isHideNavigationView;
/// 是否隐藏导航栏右按钮
@property (nonatomic, assign) BOOL isHideNavRightButton;
/// 是否隐藏导航栏左按钮
@property (nonatomic, assign) BOOL isHideNavLeftButton;
/// 是否主页导航栏
@property (nonatomic, assign) BOOL isHomeViewController;
/// 导航栏
@property (nonatomic, strong) BaseNavigationView *navigationView;
/// 主页导航栏
@property (nonatomic, strong) HomeNavigationView *homeNavigationView;
/// 左按钮点击事件
- (void)navLeftButtonClick:(UIButton *)sender;
/// 右按钮点击事件
- (void)navRightButtonClick:(UIButton *)sender;
/// 右按钮点击事件
- (void)navRightButton1Click:(UIButton *)sender;
/// 右按钮点击事件
- (void)navRightButton2Click:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
