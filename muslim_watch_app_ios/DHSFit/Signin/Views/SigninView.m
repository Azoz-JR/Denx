//
//  SigninView.m
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import "SigninView.h"

@interface SigninView()<UITextFieldDelegate>

/// 协议
@property (nonatomic, strong) UILabel *agreementLabel;
/// 注册文案
@property (nonatomic, strong) UILabel *signupLabel;
/// 忘记密码
@property (nonatomic, strong) UIButton *passwordSetButton;
/// 登录
@property (nonatomic, strong) UIButton *signinButton;
/// 第三方文案
@property (nonatomic, strong) UILabel *thirdPartLabel;
/// 左线条
@property (nonatomic, strong) UIView *leftLine;
/// 右线条
@property (nonatomic, strong) UIView *rightLine;
/// 苹果登录
@property (nonatomic, strong) UIButton *appleButton;
/// QQ登录
@property (nonatomic, strong) UIButton *qqButton;
/// 内容
@property (nonatomic, strong) UIView *contentView;
/// 标题数组
@property (nonatomic, strong) NSArray *titles;
/// 图片数组
@property (nonatomic, strong) NSArray *images;

@end

@implementation SigninView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(60*2-10);
    }];
    
    [self.agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
    }];
    
    [self.signinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.top.equalTo(self.agreementLabel.mas_bottom).offset(30);
    }];
    
    [self.passwordSetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.signinButton.mas_bottom).offset(10);
        make.width.lessThanOrEqualTo(self).multipliedBy(0.4);
    }];
    
    [self.signupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-HomeViewSpace_Right);
        make.top.equalTo(self.signinButton.mas_bottom).offset(10);
        make.width.lessThanOrEqualTo(self).multipliedBy(0.4);
    }];
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.offset(-(kBottomHeight+25+40));
    }];
    
    [self.appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.wechatButton.mas_left).offset(-30);
        make.centerY.equalTo(self.wechatButton);
    }];
    
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wechatButton.mas_right).offset(30);
        make.centerY.equalTo(self.wechatButton);
    }];
    
    [self.thirdPartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.appleButton.mas_top).offset(-20);
        make.width.lessThanOrEqualTo(self).multipliedBy(0.5);
        make.centerX.equalTo(self);
        make.height.offset(20);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thirdPartLabel);
        make.height.offset(1);
        make.left.offset(40);
        make.right.equalTo(self.thirdPartLabel.mas_left).offset(-10);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thirdPartLabel);
        make.height.offset(1);
        make.right.offset(-40);
        make.left.equalTo(self.thirdPartLabel.mas_right).offset(10);
    }];
    
    UIView *lastView;
    for (int i = 0; i < self.titles.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_BlockColor;
        itemView.layer.cornerRadius = 10.0;
        itemView.layer.masksToBounds = YES;
        itemView.layer.borderWidth = 0.5;
        itemView.layer.borderColor = HomeColor_MainColor.CGColor;
        [self.contentView addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.offset(0);
                make.height.offset(50);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.equalTo(lastView.mas_bottom).offset(HomeViewSpace_Vertical);
                make.height.offset(50);
            }];
        }
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setImage:DHImage(self.images[i]) forState:UIControlStateNormal];
        [itemView addSubview:itemButton];
        
        UITextField *itemTextField = [[UITextField alloc] init];
        itemTextField.tag = 1000+i;
        itemTextField.tintColor = HomeColor_TitleColor;
        itemTextField.borderStyle = UITextBorderStyleNone;
        itemTextField.returnKeyType = UIReturnKeyDone;
        [itemTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [itemTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        itemTextField.keyboardType = UIKeyboardTypeEmailAddress;
        itemTextField.font = HomeFont_TitleFont;
        itemTextField.textColor = HomeColor_TitleColor;
        itemTextField.delegate = self;
        [itemTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.titles[i] attributes:@{NSForegroundColorAttributeName:HomeColor_TitleColor,NSFontAttributeName:HomeFont_TitleFont}];
        itemTextField.attributedPlaceholder = attrString;
        [itemView addSubview:itemTextField];
        if (i == 1) {
            UIButton *eyesButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [eyesButton setImage:DHImage(@"signin_eyes_unSelected") forState:UIControlStateNormal];
            [eyesButton setImage:DHImage(@"signin_eyes_selected") forState:UIControlStateSelected];
            eyesButton.frame = CGRectMake(0, 0, 20, 14);
            [eyesButton addTarget:self action:@selector(eyesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            itemTextField.rightView = eyesButton;
            itemTextField.rightViewMode =UITextFieldViewModeAlways;
            itemTextField.secureTextEntry = YES;

        }
        
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.width.height.offset(25);
            make.centerY.equalTo(itemView);
        }];
        
        [itemTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemButton.mas_right).offset(5);
            make.top.offset(5);
            make.bottom.offset(-5);
            make.right.offset(-10);
        }];
        
        lastView = itemView;
    }
    
}

- (void)signinClick {
    UITextField *accountTF = [self.contentView viewWithTag:1000];
    if (!accountTF.text.length) {
        SHOWHUD(Lang(@"str_please_input_legal_account"))
        return;
    }
    if (![DHPredicate checkForEmail:accountTF.text] && ![DHPredicate checkForNumber:accountTF.text]) {
        SHOWHUD(Lang(@"str_please_input_legal_account"))
        return;
    }
    UITextField *passwordTFA = [self.contentView viewWithTag:1001];
    if (passwordTFA.text.length < 6) {
        SHOWHUD(Lang(@"str_please_input_legal_pw"))
        return;
    }
    if (![DHPredicate checkForNumberAndCase:passwordTFA.text]) {
        SHOWHUD(Lang(@"str_please_input_legal_pw"))
        return;
    }
    if ([self.delegate respondsToSelector:@selector(onSignin:password:)]) {
        [self.delegate onSignin:accountTF.text password:passwordTFA.text];
    }
}

- (void)appleClick {
    if ([self.delegate respondsToSelector:@selector(onSigninApple)]) {
        [self.delegate onSigninApple];
    }
}

- (void)wechatClick {
    if ([self.delegate respondsToSelector:@selector(onSigninWechat)]) {
        [self.delegate onSigninWechat];
    }
}

- (void)qqClick {
    if ([self.delegate respondsToSelector:@selector(onSigninQQ)]) {
        [self.delegate onSigninQQ];
    }
}

- (void)signupClick {
    if ([self.delegate respondsToSelector:@selector(onSignup)]) {
        [self.delegate onSignup];
    }
}

- (void)passwordSetClick {
    if ([self.delegate respondsToSelector:@selector(onPasswordSet)]) {
        [self.delegate onPasswordSet];
    }
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

- (void)eyesButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    UITextField *itemTextField = [self.contentView viewWithTag:1001];
    itemTextField.secureTextEntry = !itemTextField.isSecureTextEntry;
}

- (void)updateSigninButtonState {
    UITextField *accountTF = [self.contentView viewWithTag:1000];
    UITextField *passwordTFA = [self.contentView viewWithTag:1001];
    
    BOOL isEnable = accountTF.text.length && passwordTFA.text.length;
    self.signinButton.backgroundColor = isEnable ? HomeColor_ButtonHighLight : HomeColor_ButtonNormal;
    self.signinButton.userInteractionEnabled = isEnable;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(onTextFieldSelected:)]) {
        [self.delegate onTextFieldSelected:textField.tag];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateSigninButtonState];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        NSInteger maxLength = textField.tag == 1000 ? 50 : 16;
        if (textField.text.length > maxLength) {
            textField.text = [textField.text substringToIndex:maxLength];
        }
        [self updateSigninButtonState];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

- (UIButton *)signinButton {
    if (!_signinButton) {
        _signinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signinButton.layer.cornerRadius = 10.0;
        _signinButton.layer.masksToBounds = YES;
        _signinButton.backgroundColor = HomeColor_ButtonNormal;
        _signinButton.userInteractionEnabled = NO;
        [_signinButton setTitle:Lang(@"str_login") forState:UIControlStateNormal];
        _signinButton.titleLabel.font = HomeFont_ButtonFont;
        [_signinButton setTitleColor:HomeColor_ButtonColor forState:UIControlStateNormal];
        [_signinButton addTarget:self action:@selector(signinClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_signinButton];
    }
    return _signinButton;
}

- (UIButton *)passwordSetButton {
    if (!_passwordSetButton) {
        _passwordSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _passwordSetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_passwordSetButton setTitle:[NSString stringWithFormat:@"%@？",Lang(@"str_forget_pw")] forState:UIControlStateNormal];
        _passwordSetButton.titleLabel.font = HomeFont_SubTitleFont;
        [_passwordSetButton setTitleColor:HomeColor_MainColor forState:UIControlStateNormal];
        [_passwordSetButton addTarget:self action:@selector(passwordSetClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_passwordSetButton];
    }
    return _passwordSetButton;
}

- (UIButton *)appleButton {
    if (!_appleButton) {
        _appleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appleButton setImage:DHImage(@"signin_main_apple") forState:UIControlStateNormal];
        [_appleButton addTarget:self action:@selector(appleClick) forControlEvents:UIControlEventTouchUpInside];
        _appleButton.hidden = YES;
        [self addSubview:_appleButton];
    }
    return _appleButton;
}

- (UIButton *)wechatButton {
    if (!_wechatButton) {
        _wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wechatButton setImage:DHImage(@"signin_main_wechat") forState:UIControlStateNormal];
        [_wechatButton addTarget:self action:@selector(wechatClick) forControlEvents:UIControlEventTouchUpInside];
        _wechatButton.hidden = YES;
        [self addSubview:_wechatButton];
    }
    return _wechatButton;
}

- (UIButton *)qqButton {
    if (!_qqButton) {
        _qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqButton setImage:DHImage(@"signin_main_qq") forState:UIControlStateNormal];
        [_qqButton addTarget:self action:@selector(qqClick) forControlEvents:UIControlEventTouchUpInside];
        _qqButton.hidden = YES;
        [self addSubview:_qqButton];
    }
    return _qqButton;
}

- (UILabel *)signupLabel {
    if (!_signupLabel) {
        _signupLabel = [BaseView subTitleLabel];
        _signupLabel.textAlignment = NSTextAlignmentRight;
        NSArray *strArray = @[Lang(@"str_has_not_account"),Lang(@"str_go"),Lang(@"str_register")];
        NSArray *fontArray = @[HomeFont_ContentFont,HomeFont_ContentFont,HomeFont_ContentFont];
        NSArray *colorArray = @[HomeColor_ContentColor,HomeColor_ContentColor,HomeColor_MainColor];
        _signupLabel.attributedText = [UILabel getAttributedStrings:strArray fonts:fontArray colors:colorArray];
        
        WEAKSELF
        [_signupLabel yb_addAttributeTapActionWithStrings:@[Lang(@"str_register")] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            [weakSelf signupClick];
        }];
        [self addSubview:_signupLabel];
    }
    return _signupLabel;
}

- (UILabel *)agreementLabel {
    if (!_agreementLabel) {
        _agreementLabel = [BaseView subTitleLabel];
        _agreementLabel.textAlignment = NSTextAlignmentLeft;
        _agreementLabel.numberOfLines = 0;
        _agreementLabel.lineBreakMode = NSLineBreakByWordWrapping;
        NSArray *strArray = @[Lang(@"str_please_read"),[NSString stringWithFormat:@"《%@》",Lang(@"str_user_protocol")],@"、",[NSString stringWithFormat:@"《%@》",Lang(@"str_privacy_policy")]];
        NSArray *fontArray = @[HomeFont_ContentFont,HomeFont_ContentFont,HomeFont_ContentFont,HomeFont_ContentFont];
        NSArray *colorArray = @[HomeColor_ContentColor,HomeColor_MainColor,HomeColor_ContentColor,HomeColor_MainColor];
        _agreementLabel.attributedText = [UILabel getAttributedStrings:strArray fonts:fontArray colors:colorArray];
        
        WEAKSELF
        [_agreementLabel yb_addAttributeTapActionWithStrings:@[[NSString stringWithFormat:@"《%@》",Lang(@"str_user_protocol")],[NSString stringWithFormat:@"《%@》",Lang(@"str_privacy_policy")]] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            if (index == 0) {
                [weakSelf userAgreementClick];
            } else {
                [weakSelf privacyPolicyClick];
            }
        }];
        [self addSubview:_agreementLabel];
    }
    return _agreementLabel;
}

- (UILabel *)thirdPartLabel {
    if (!_thirdPartLabel) {
        _thirdPartLabel = [BaseView subTitleLabel];
        _thirdPartLabel.textColor = HomeColor_TitleColor;
        _thirdPartLabel.text = Lang(@"str_other_login");
        _thirdPartLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_thirdPartLabel];
        _thirdPartLabel.hidden = YES;
    }
    return _thirdPartLabel;
}

- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = HomeColor_TitleColor;
        _leftLine.hidden = YES;
        [self addSubview:_leftLine];
    }
    return _leftLine;
}

- (UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = HomeColor_TitleColor;
        _rightLine.hidden = YES;
        [self addSubview:_rightLine];
    }
    return _rightLine;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = HomeColor_BackgroundColor;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[[NSString stringWithFormat:@"%@",Lang(@"str_email")],
                    Lang(@"str_password")];
    }
    return _titles;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"signin_main_account",
                    @"signin_main_password"];
    }
    return _images;
}

@end
