//
//  HomeNavigationView.m
//  DHSFit
//
//  Created by DHS on 2022/6/16.
//

#import "HomeNavigationView.h"

@implementation HomeNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.navLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(0);
        make.height.width.offset(44);
    }];
    
    [self.navRightButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.width.offset(44);
    }];
    
    [self.navRightButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navRightButton1.mas_left);
        make.bottom.offset(0);
        make.height.width.offset(44);
    }];
    
    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navLeftButton.mas_right);
        make.right.equalTo(self.navRightButton2.mas_left);
        make.bottom.offset(0);
        make.height.offset(44);
    }];
}

- (UIButton *)navLeftButton {
    if (!_navLeftButton) {
        _navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navLeftButton setImage:DHImage(@"public_nav_disconnected") forState:UIControlStateNormal];
        
        [self addSubview:_navLeftButton];
    }
    return _navLeftButton;
}

- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc]init];
        _navTitleLabel.textColor = HomeColor_TitleColor;
        _navTitleLabel.font = HomeFont_TitleFont;
        _navTitleLabel.text = @"";
        [self addSubview:_navTitleLabel];
    }
    return _navTitleLabel;
}

- (UIButton *)navRightButton1 {
    if (!_navRightButton1) {
        _navRightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navRightButton1 setImage:DHImage(@"public_nav_share") forState:UIControlStateNormal];
        [self addSubview:_navRightButton1];
    }
    return _navRightButton1;
}

- (UIButton *)navRightButton2 {
    if (!_navRightButton2) {
        _navRightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navRightButton2 setImage:DHImage(@"public_nav_refresh") forState:UIControlStateNormal];
        [self addSubview:_navRightButton2];
    }
    return _navRightButton2;
}

@end
