//
//  SportMainView.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "SportMainView.h"

@interface SportMainView ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 开始
@property (nonatomic, strong) UIButton *startButton;
/// 单位
@property (nonatomic, strong) UILabel *unitLabel;

@end

@implementation SportMainView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)startRunningClick {
    if ([self.delegate respondsToSelector:@selector(onStartRunning)]) {
        [self.delegate onStartRunning];
    }
}

- (void)outdoorClick {
    if ([self.delegate respondsToSelector:@selector(onOutdoor)]) {
        [self.delegate onOutdoor];
    }
    self.outdoorButton.backgroundColor = HomeColor_MainColor;
    self.indoorButton.backgroundColor = COLOR(@"#666666");
    [self.indoorButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
    [self.outdoorButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
}

- (void)indoorClick {
    if ([self.delegate respondsToSelector:@selector(onIndoor)]) {
        [self.delegate onIndoor];
    }
    self.outdoorButton.backgroundColor = COLOR(@"#666666");
    self.indoorButton.backgroundColor = HomeColor_MainColor;
    [self.indoorButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
    [self.outdoorButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];

   
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(0.3);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        
    }];
    
    [self.indoorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize fitSize = [self.indoorButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        make.left.offset(15+15);
        make.bottom.offset(-15-10);
        make.height.offset(36);
        make.width.offset(fitSize.width + 10);
    }];
    
    [self.outdoorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize fitSize = [self.outdoorButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        make.right.offset(-15-15);
        make.bottom.offset(-15-10);
        make.height.offset(36);
        make.width.offset(fitSize.width + 10);
    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.image = DHImage(@"sport_main_map_bg");
        _bgImageView.alpha = 1.0;
        [self.bgView addSubview:_bgImageView];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        NSArray *strArray = @[@"0.00",DistanceUnit];
        NSArray *fontArray = @[HomeFont_Bold_30,HomeFont_SubTitleFont];
        NSArray *colorArray = @[[UIColor blackColor],[UIColor blackColor]];
        _titleLabel.attributedText = [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = [UIColor blackColor];
        _subTitleLabel.font = HomeFont_SubTitleFont;
        _subTitleLabel.text = @"";
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UIButton *)outdoorButton {
    if (!_outdoorButton) {
        _outdoorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_outdoorButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_outdoorButton setTitle:Lang(@"str_outdoor") forState:UIControlStateNormal];
        _outdoorButton.titleLabel.font = HomeFont_ButtonFont;
        _outdoorButton.layer.cornerRadius = 18.0;
        _outdoorButton.layer.masksToBounds = YES;
        _outdoorButton.backgroundColor = COLOR(@"#666666");
        [_outdoorButton addTarget:self action:@selector(outdoorClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_outdoorButton];
    }
    return _outdoorButton;
}

- (UIButton *)indoorButton {
    if (!_indoorButton) {
        _indoorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_indoorButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_indoorButton setTitle:Lang(@"str_indoor") forState:UIControlStateNormal];
        _indoorButton.titleLabel.font = HomeFont_ButtonFont;
        _indoorButton.layer.cornerRadius = 18.0;
        _indoorButton.layer.masksToBounds = YES;
        _indoorButton.backgroundColor = HomeColor_MainColor;
        [_indoorButton addTarget:self action:@selector(indoorClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_indoorButton];
    }
    return _indoorButton;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setImage:DHImage(@"sport_main_start") forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startRunningClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_startButton];
    }
    return _startButton;
}

@end
