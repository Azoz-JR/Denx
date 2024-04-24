//
//  BaseAlertView.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "BaseAlertView.h"

@interface BaseAlertView ()

/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 标题
@property (nonatomic, strong) UILabel *titleLab;
/// 信息
@property (nonatomic, strong) UILabel *messageLab;
/// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
/// 确认按钮
@property (nonatomic, strong) UIButton *confirmButton;
/// 横线
@property (nonatomic, strong) UIView *horizontalLineView;
/// 竖线
@property (nonatomic, strong) UIView *verticalLineView;
/// 回调Block
@property (nonatomic, copy) BaseAlertViewClickBlock alertBlock;
/// 标题高度
@property (nonatomic, assign) CGFloat titleH;
/// 内容高度
@property (nonatomic, assign) CGFloat messageH;
///只有确认按钮
@property (nonatomic, assign) BOOL isOnlyConfirm;

@end

@implementation BaseAlertView

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
               cancel:(NSString *)cancel
              confirm:(NSString *)confirm
  textAlignmentCenter:(BOOL)isCenter
                block:(BaseAlertViewClickBlock)block {
    
    CGFloat labelW = self.frame.size.width-2*52.5-2*15;
    self.titleH = [UILabel getLabelheight:title width:labelW font:HomeFont_TitleFont];
    self.messageH = [UILabel getLabelheight:message width:labelW font:HomeFont_ContentFont];
    self.isOnlyConfirm = (cancel.length == 0);
    [self handleSubviews];
    
    self.titleLab.text = title;
    self.messageLab.text = message;
    if (!isCenter) {
        self.messageLab.textAlignment = NSTextAlignmentLeft;
    }
    if (self.isOnlyConfirm) {
        [self.confirmButton setTitle:confirm forState:UIControlStateNormal];
    } else {
        [self.confirmButton setTitle:confirm forState:UIControlStateNormal];
        [self.cancelButton setTitle:cancel forState:UIControlStateNormal];
    }
    

    self.alertBlock = block;
    [self showCustomAlertView];
}

- (void)handleSubviews {
    
    CGFloat buttonW = (self.frame.size.width-2*52.5)/2.0;
    CGFloat buttonH = 48;
    CGFloat buttonSpace_top = 20;
    CGFloat labelSpace_Top = 15;
    CGFloat labelSpace_left = 15;
    CGFloat bgViewH = 0;
    
    if (self.titleH > 0 && self.messageH > 0) {
        bgViewH = self.titleH+self.messageH+buttonH+labelSpace_Top*2+buttonSpace_top;
    } else if (self.titleH > 0) {
        labelSpace_Top = 20;
        bgViewH = self.titleH+buttonH+buttonSpace_top+labelSpace_Top;
    } else if (self.messageH > 0) {
        labelSpace_Top = 20;
        bgViewH = self.messageH+buttonH+buttonSpace_top+labelSpace_Top;
    }

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(bgViewH);
        make.left.offset(52.5);
        make.right.offset(-52.5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    if (self.titleH > 0 && self.messageH > 0) {
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(labelSpace_Top);
            make.left.offset(labelSpace_left);
            make.right.offset(-labelSpace_left);
        }];
        
        [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom).offset(labelSpace_Top);
            make.left.offset(labelSpace_left);
            make.right.offset(-labelSpace_left);
        }];
    } else if (self.titleH > 0) {
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(labelSpace_Top);
            make.left.offset(labelSpace_left);
            make.right.offset(-labelSpace_left);
        }];
    } else if (self.messageH > 0) {
        [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(labelSpace_Top);
            make.left.offset(labelSpace_left);
            make.right.offset(-labelSpace_left);
        }];
    }

    if (self.isOnlyConfirm) {
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(buttonH);
        }];
        [self.horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.confirmButton.mas_top);
            make.left.right.offset(0);
            make.height.offset(0.5);
        }];
    } else {
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.offset(0);
            make.height.offset(buttonH);
            make.width.offset(buttonW);
        }];
        
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(0);
            make.height.offset(buttonH);
            make.width.offset(buttonW);
        }];
        
        [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.width.offset(0.5);
            make.height.offset(buttonH);
            make.centerX.equalTo(self.bgView.mas_centerX);
        }];
        
        [self.horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.verticalLineView.mas_top);
            make.left.right.offset(0);
            make.height.offset(0.5);
        }];
    }
    
    
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
        _messageLab.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_messageLab];
    }
    return _messageLab;
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
        _cancelButton.tag = 1;
        _cancelButton.titleLabel.font = HomeFont_TitleFont;
        [_cancelButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_cancelButton];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.tag = 2;
        _confirmButton.titleLabel.font = HomeFont_TitleFont;
        [_confirmButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (void)buttonClick:(UIButton *)sender {
    
    if (self.alertBlock) {
        self.alertBlock(sender.tag);
    }
    [self hideCustomAlertView];
}

- (void)showCustomAlertView {
//    let scene = UIApplication.shared.connectedScenes.first
//    if let sd = (scene?.delegate as? SceneDelegate) {
    
    UIWindow *tWindow = nil;
    if(@available(iOS 13.0, *)) {
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *windowScene = (UIWindowScene*)array[0];
        UIWindow *mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
        if (mainWindow){
            tWindow = mainWindow;
        }
        else{
            tWindow = [UIApplication sharedApplication].windows.lastObject;
        }
    }
    else{
        tWindow = [UIApplication sharedApplication].windows.lastObject;
    }
    
    [tWindow addSubview:self];
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
