//
//  LaunchAlertView.m
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import "LaunchAlertView.h"

@interface LaunchAlertView ()

/// 背景视图
@property (nonatomic, strong) UIView *bgView;
/// 标题Lab
@property (nonatomic, strong) UILabel *titleLab;
/// 内容Lab
@property (nonatomic, strong) UILabel *messageLab;
/// 内容Lab
@property (nonatomic, strong) UILabel *contentLab;
/// 提示Lab
@property (nonatomic, strong) UILabel *tipLab;
/// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
/// 确认按钮
@property (nonatomic, strong) UIButton *confirmButton;
/// 横线
@property (nonatomic, strong) UIView *horizontalLineView;
/// 竖线
@property (nonatomic, strong) UIView *verticalLineView;
/// 控制器
@property (strong, nonatomic) UIViewController *viewController;
/// 内容高度
@property (nonatomic, assign) CGFloat messageH;
/// 内容高度
@property (nonatomic, assign) CGFloat contentH;
/// 提示高度
@property (nonatomic, assign) CGFloat tipH;

@end

@implementation LaunchAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = COLORANDALPHA(@"#000000", 0.4);
    }
    return self;
}

- (void)showWithTitle:(NSString *)title
               message:(NSString *)message
               content:(NSString *)content
              tip:(NSString *)tip
             agreement:(NSString *)agreement
               privacy:(NSString *)privacy
               cancel:(NSString *)cancel
               confirm:(NSString *)confirm
           controller:(UIViewController*)controller {
    
    CGFloat labelW = self.frame.size.width-60;
    self.messageH = [UILabel getLabelheight:message width:labelW font:HomeFont_ContentFont];
    self.contentH = [UILabel getLabelheight:content width:labelW font:HomeFont_ContentFont];
    self.tipH = [UILabel getLabelheight:tip width:labelW font:HomeFont_ContentFont];
    [self setupSubViews];
    
    
    self.titleLab.text = title;
    self.messageLab.text = message;
    self.tipLab.text = tip;
    [self.cancelButton setTitle:cancel forState:UIControlStateNormal];
    [self.confirmButton setTitle:confirm forState:UIControlStateNormal];
    
    NSArray *strArray = @[Lang(@"str_please_read"),[NSString stringWithFormat:@"《%@》",Lang(@"str_user_protocol")],@"、",[NSString stringWithFormat:@"《%@》",Lang(@"str_privacy_policy")]];
    NSArray *fontArray = @[HomeFont_ContentFont,HomeFont_ContentFont,HomeFont_ContentFont,HomeFont_ContentFont];
    NSArray *colorArray = @[HomeColor_ContentColor,HomeColor_MainColor,HomeColor_ContentColor,HomeColor_MainColor];
    self.contentLab.attributedText = [UILabel getAttributedStrings:strArray fonts:fontArray colors:colorArray];
    
    WEAKSELF
    [self.contentLab yb_addAttributeTapActionWithStrings:@[[NSString stringWithFormat:@"《%@》",Lang(@"str_user_protocol")],[NSString stringWithFormat:@"《%@》",Lang(@"str_privacy_policy")]] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        if (index == 0) {
            [weakSelf userAgreementClick];
        } else {
            [weakSelf privacyPolicyClick];
        }
    }];

    self.viewController = controller;
    [self showCustomAlertView];
}

- (void)userAgreementClick {
    if ([self.delegate respondsToSelector:@selector(onUserAgreement)]) {
        [self.delegate onUserAgreement];
    }
}

- (void)privacyPolicyClick {
    if ([self.delegate respondsToSelector:@selector(onPrivacyPolicy)]) {
        [self.delegate onPrivacyPolicy];
    }
}

- (void)cancelClick {
    if ([self.delegate respondsToSelector:@selector(onCancel)]) {
        [self.delegate onCancel];
    }
    [self hideCustomAlertView];
}

- (void)confirmClick {
    if ([self.delegate respondsToSelector:@selector(onConfirm)]) {
        [self.delegate onConfirm];
    }
    [self hideCustomAlertView];
}

- (void)setupSubViews {
    
    CGFloat buttonW = (self.frame.size.width-2*15.0)/2.0;
    CGFloat bgViewH = self.messageH+self.contentH+self.tipH+25+48+25*2+12*3;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(bgViewH);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.left.offset(14);
        make.right.offset(-14);
    }];
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(12);
        make.left.offset(14);
        make.right.offset(-14);
        
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLab.mas_bottom).offset(0);
        make.left.offset(14);
        make.right.offset(-14);
    }];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(15);
        make.left.offset(14);
        make.right.offset(-14);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.offset(48);
        make.width.offset(buttonW);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.offset(48);
        make.width.offset(buttonW);
    }];
    
    [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.width.offset(0.5);
        make.height.offset(48);
        make.centerX.equalTo(self.bgView.mas_centerX);
    }];
    
    [self.horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.verticalLineView.mas_top);
        make.left.right.offset(0);
        make.height.offset(0.5);
    }];
    
}


#pragma mark - Subviews 视图实例化懒加载

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [BaseView titleLabel];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_titleLab];
    }
    return _titleLab;
}

- (UILabel *)messageLab {
    if (!_messageLab) {
        _messageLab = [BaseView contentLabel];
        [self.bgView addSubview:_messageLab];
    }
    return _messageLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByCharWrapping;
        [self.bgView addSubview:_contentLab];
    }
    return _contentLab;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [BaseView contentLabel];
        [self.bgView addSubview:_tipLab];
    }
    return _tipLab;
}

- (UIView *)horizontalLineView {
    if (!_horizontalLineView) {
        _horizontalLineView = [[UIView alloc] init];
        _horizontalLineView.backgroundColor = HomeColor_LineColor;
        [self.bgView addSubview:_horizontalLineView];
    }
    return _horizontalLineView;
}

- (UIView *)verticalLineView {
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = HomeColor_LineColor;
        [self.bgView addSubview:_verticalLineView];
    }
    return _verticalLineView;
}


- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = HomeFont_ButtonFont;
        [_cancelButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_cancelButton];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.font = HomeFont_ButtonFont;
        [_confirmButton setTitleColor:HomeColor_MainColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (void)showCustomAlertView {
    [self.viewController.view addSubview:self];
    self.bgView.transform = CGAffineTransformMakeScale(0.70, 0.70);
    WEAKSELF
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)hideCustomAlertView {
    
    self.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    WEAKSELF
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.bgView.alpha = 0.0;
        weakSelf.alpha = 0.0;
        weakSelf.bgView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
