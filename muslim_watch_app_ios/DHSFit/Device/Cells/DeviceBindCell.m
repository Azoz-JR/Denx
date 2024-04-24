//
//  DeviceBindCell.m
//  DHSFit
//
//  Created by DHS on 2022/6/17.
//

#import "DeviceBindCell.h"

@interface DeviceBindCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *deviceImageView;

@property (nonatomic, strong) UIButton *bindButton;

@end

@implementation DeviceBindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)bindClick {
    if ([self.delegate respondsToSelector:@selector(onBind)]) {
        [self.delegate onBind];
    }
}

- (void)setupSubViews {
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.height.offset(101);
        make.width.offset(59);
        make.centerX.equalTo(self.bgView);
    }];

    [self.bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(36);
        CGSize fitSize = [self.bindButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        make.width.equalTo(@(fitSize.width + 10));
        make.centerX.equalTo(self.bgView);
        make.bottom.offset(-20);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)deviceImageView {
    if (!_deviceImageView) {
        _deviceImageView = [[UIImageView alloc] init];
        _deviceImageView.contentMode = UIViewContentModeScaleAspectFit;
        _deviceImageView.image = DHImage(@"device_main_watch");
        [self.bgView addSubview:_deviceImageView];
    }
    return _deviceImageView;
}

- (UIButton *)bindButton {
    if (!_bindButton) {
        _bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bindButton.layer.cornerRadius = 10.0;
        _bindButton.layer.masksToBounds = YES;
        [_bindButton setTitle:Lang(@"str_bind") forState:UIControlStateNormal];
        [_bindButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        _bindButton.backgroundColor = HomeColor_MainColor;
        [_bindButton addTarget:self action:@selector(bindClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_bindButton];
    }
    return _bindButton;
}

@end
