//
//  DeviceBatteryView.m
//  DHSFit
//
//  Created by DHS on 2022/6/17.
//

#import "DeviceBatteryView.h"

@interface DeviceBatteryView ()

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *flashImageView;

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DeviceBatteryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(DHBatteryInfoModel *)model {
    NSString *imageStr = model.isLower ? @"device_main_battery_red" : @"device_main_battery";
    self.leftImageView.image = DHImage(imageStr);
    self.titleLabel.text = [NSString stringWithFormat:@"%ld%%",(long)model.battery];
    self.flashImageView.hidden = model.status == 0;
    if (model.battery > 99){
        self.flashImageView.hidden = YES;
    }
    
    CGFloat viewWidth = 1.0*21*model.battery/100;
    [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(viewWidth);
    }];
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BlockColor;
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(2.0);
        make.width.offset(10.5);
        make.height.offset(8.2);
        make.centerY.equalTo(self).offset(0.2);
    }];
    
    [self.flashImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftImageView);
        make.centerY.equalTo(self.leftImageView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(5);
        make.centerY.equalTo(self.leftImageView);
    }];
    
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
        _leftView.backgroundColor = HomeColor_MainColor;
        _leftView.layer.cornerRadius = 1.0;
        _leftView.layer.masksToBounds = YES;
        [self addSubview:_leftView];
    }
    return _leftView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = DHImage(@"device_main_battery");
        [self addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView *)flashImageView {
    if (!_flashImageView) {
        _flashImageView = [[UIImageView alloc] init];
        _flashImageView.image = DHImage(@"device_main_flash");
        _flashImageView.hidden = YES;
        [self addSubview:_flashImageView];
    }
    return _flashImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = HomeColor_TitleColor;
        _titleLabel.font = HomeFont_SubTitleFont;
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
