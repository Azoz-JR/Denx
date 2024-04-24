//
//  AboutHeaderView.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "AboutHeaderView.h"

@interface AboutHeaderView ()

/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 图片
@property (nonatomic, strong) UIImageView *imageView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 版本号
@property (nonatomic, strong) UILabel *versionLabel;

@end

@implementation AboutHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(90);
        make.top.offset(30);
        make.centerX.equalTo(self.bgView);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];

}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 10.0;
        _imageView.layer.masksToBounds = YES;
        _imageView.image = DHImage(@"mine_about_logo");
        [self.bgView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = HomeColor_TitleColor;
        _titleLabel.font = HomeFont_Bold_20;
        _titleLabel.text = [DHDevice appDisplayName];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc]init];
        _versionLabel.textColor = HomeColor_TitleColor;
        _versionLabel.font = HomeFont_TitleFont;
        _versionLabel.text = [DHDevice appShotVersion];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_versionLabel];
    }
    return _versionLabel;
}

@end
