//
//  MWBaseController.m
//  DHSFit
//
//  Created by DHS on 2022/5/30.
//

#import "MWBaseController.h"

@implementation MWBaseController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = HomeColor_BackgroundColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self setupNavigationView];
}

#pragma mark - custom action for UI 界面处理有关

- (void)navLeftButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navRightButtonClick:(UIButton *)sender {
    
}

- (void)navRightButton1Click:(UIButton *)sender {
    
}

- (void)navRightButton2Click:(UIButton *)sender {
    
}

- (void)setupNavigationView {
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(kNavAndStatusHeight);
    }];
    self.navigationView.hidden = self.isHideNavigationView;
    
    if (!self.isHideNavigationView) {
        [self.navigationView.navLeftButton addTarget:self action:@selector(navLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationView.navRightButton addTarget:self action:@selector(navRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationView.navTitleLabel.text = self.navTitle;
        self.navigationView.navRightButton.hidden = self.isHideNavRightButton;
        self.navigationView.navLeftButton.hidden = self.isHideNavLeftButton;
        
        if (self.navRightImage) {
            [self.navigationView.navRightButton setImage:DHImage(self.navRightImage) forState:UIControlStateNormal];
        }
        if (self.navLeftImage) {
            [self.navigationView.navLeftButton setImage:DHImage(self.navLeftImage) forState:UIControlStateNormal];
        }
    }
    if (self.isHomeViewController) {
        [self.homeNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.height.offset(kNavAndStatusHeight);
        }];
        
        self.homeNavigationView.navRightButton2.hidden = self.isHideNavRightButton;
        self.homeNavigationView.navTitleLabel.text = self.navTitle;
        [self.homeNavigationView.navLeftButton setImage:DHImage(self.navLeftImage) forState:UIControlStateNormal];
        [self.homeNavigationView.navRightButton1 setImage:DHImage(self.navRightImage) forState:UIControlStateNormal];
        [self.homeNavigationView.navRightButton2 setImage:DHImage(self.navRightImage2) forState:UIControlStateNormal];
        [self.homeNavigationView.navRightButton1 addTarget:self action:@selector(navRightButton1Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.homeNavigationView.navRightButton2 addTarget:self action:@selector(navRightButton2Click:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - get and set 属性的set和get方法

- (BaseNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[BaseNavigationView alloc] init];
        [self.view addSubview:_navigationView];
    }
    return _navigationView;
}

- (HomeNavigationView *)homeNavigationView {
    if (!_homeNavigationView) {
        _homeNavigationView= [[HomeNavigationView alloc] init];
        [self.view addSubview:_homeNavigationView];
    }
    return _homeNavigationView;
}

@end
