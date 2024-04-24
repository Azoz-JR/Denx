//
//  SignupView.m
//  DHSFit
//
//  Created by DHS on 2022/6/2.
//

#import "SignupView.h"

@interface SignupView()<UITextFieldDelegate>

/// 背景
@property (nonatomic, strong) UIView *contentView;
/// 标题
@property (nonatomic, strong) NSArray *titles;
/// icon
@property (nonatomic, strong) NSArray *images;

@end

@implementation SignupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
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

- (void)signupClick {
    UITextField *accountTF = [self.contentView viewWithTag:1000];
    if (!accountTF.text.length) {
        SHOWHUD(Lang(@"str_please_input_legal_account"))
        return;
    }
    if (![DHPredicate checkForEmail:accountTF.text]) {
        SHOWHUD(Lang(@"str_please_input_legal_account"))
        return;
    }
    
    UITextField *verifyCodeTF = [self.contentView viewWithTag:1001];
    if (!verifyCodeTF.text.length) {
        SHOWHUD(Lang(@"str_please_input_legal_verify"))
        return;
    }
    UITextField *passwordTFA = [self.contentView viewWithTag:1002];
    UITextField *passwordTFB = [self.contentView viewWithTag:1003];
    if (passwordTFA.text.length < 6 || passwordTFB.text.length < 6) {
        SHOWHUD(Lang(@"str_please_input_legal_pw"))
        return;
    }
    if (![DHPredicate checkForNumberAndCase:passwordTFA.text] || ![DHPredicate checkForNumberAndCase:passwordTFB.text]) {
        SHOWHUD(Lang(@"str_please_input_legal_pw"))
        return;
    }
    if (![passwordTFA.text isEqualToString:passwordTFB.text]) {
        SHOWHUD(Lang(@"str_pw_diff"))
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(onSignup:verifyCode:password:)]) {
        [self.delegate onSignup:accountTF.text verifyCode:verifyCodeTF.text password:passwordTFA.text];
    }
}

- (void)signinClick {
    if ([self.delegate respondsToSelector:@selector(onSignin)]) {
        [self.delegate onSignin];
    }
}

- (void)getVerifyCodeClick {
    UITextField *accountTF = [self.contentView viewWithTag:1000];
    if (!accountTF.text.length) {
        SHOWHUD(Lang(@"str_please_input_legal_account"))
        return;
    }
    if (![DHPredicate checkForEmail:accountTF.text]) {
        SHOWHUD(Lang(@"str_please_input_legal_account"))
        return;
    }
    if ([self.delegate respondsToSelector:@selector(onGetVerifyCode:)]) {
        [self.delegate onGetVerifyCode:accountTF.text];
    }
}

- (void)eyesButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.tag == 102) {
        UITextField *itemTextField = [self.contentView viewWithTag:1002];
        itemTextField.secureTextEntry = !itemTextField.isSecureTextEntry;
    } else {
        UITextField *itemTextField = [self.contentView viewWithTag:1003];
        itemTextField.secureTextEntry = !itemTextField.isSecureTextEntry;
    }
}

- (void)updateSigninButtonState {
    UITextField *accountTF = [self.contentView viewWithTag:1000];
    UITextField *verifyCodeTF = [self.contentView viewWithTag:1001];
    UITextField *passwordTFA = [self.contentView viewWithTag:1002];
    UITextField *passwordTFB = [self.contentView viewWithTag:1003];
    
    BOOL isEnable = accountTF.text.length && verifyCodeTF.text.length && passwordTFA.text.length && passwordTFB.text.length;
    self.signupButton.backgroundColor = isEnable ? HomeColor_ButtonHighLight : HomeColor_ButtonNormal;
    self.signupButton.userInteractionEnabled = isEnable;
}

- (void)setAccount:(NSString *)account {
    UITextField *accountTF = [self.contentView viewWithTag:1000];
    accountTF.text = account;
    accountTF.enabled = NO;
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(60*4-10);
    }];
    
    [self.agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
    }];
    
    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.top.equalTo(self.agreementLabel.mas_bottom).offset(30);
    }];
    
    [self.signinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-HomeViewSpace_Right);
        make.top.equalTo(self.signupButton.mas_bottom).offset(10);
        make.width.lessThanOrEqualTo(self).multipliedBy(0.8);
    }];

    UIView *lastView;
    for (int i = 0; i < self.titles.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_BlockColor;
        itemView.layer.cornerRadius = 10.0;
        itemView.layer.masksToBounds = YES;
        itemView.layer.borderWidth = 1.0;
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
            itemTextField.rightView = self.verifyCodeButton;
            itemTextField.rightViewMode =UITextFieldViewModeAlways;

        } else if (i > 1) {
            UIButton *eyesButton = [UIButton buttonWithType:UIButtonTypeCustom];
            eyesButton.tag = 100+i;
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
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

- (UIButton *)signupButton {
    if (!_signupButton) {
        _signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signupButton.layer.cornerRadius = 10.0;
        _signupButton.layer.masksToBounds = YES;
        _signupButton.backgroundColor = HomeColor_ButtonNormal;
        _signupButton.userInteractionEnabled = NO;
        [_signupButton setTitle:Lang(@"str_register") forState:UIControlStateNormal];
        _signupButton.titleLabel.font = HomeFont_ButtonFont;
        [_signupButton setTitleColor:HomeColor_ButtonColor forState:UIControlStateNormal];
        [_signupButton addTarget:self action:@selector(signupClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_signupButton];
    }
    return _signupButton;
}

- (UILabel *)signinLabel {
    if (!_signinLabel) {
        _signinLabel = [BaseView subTitleLabel];
        _signinLabel.textAlignment = NSTextAlignmentRight;
        NSArray *strArray = @[Lang(@"str_has_account"),Lang(@"str_go"),Lang(@"str_login")];
        NSArray *fontArray = @[HomeFont_ContentFont,HomeFont_ContentFont,HomeFont_ContentFont];
        NSArray *colorArray = @[HomeColor_ContentColor,HomeColor_ContentColor,HomeColor_MainColor];
        _signinLabel.attributedText = [UILabel getAttributedStrings:strArray fonts:fontArray colors:colorArray];
        
        WEAKSELF
        [_signinLabel yb_addAttributeTapActionWithStrings:@[Lang(@"str_login")] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
            [weakSelf signinClick];
        }];
        [self addSubview:_signinLabel];
    }
    return _signinLabel;
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

- (UIButton *)verifyCodeButton {
    if (!_verifyCodeButton) {
        _verifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyCodeButton.titleLabel.font = HomeFont_SubTitleFont;
        [_verifyCodeButton setTitle:Lang(@"str_verification_code_rec") forState:UIControlStateNormal];
        [_verifyCodeButton setTitleColor:HomeColor_MainColor forState:UIControlStateNormal];
        [_verifyCodeButton addTarget:self action:@selector(getVerifyCodeClick) forControlEvents:UIControlEventTouchUpInside];
        _verifyCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _verifyCodeButton;
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
                    Lang(@"str_verification_code"),
                    Lang(@"str_password"),
                    Lang(@"str_password_again")];
    }
    return _titles;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"signin_main_account",
                    @"signin_main_verifycode",
                    @"signin_main_password",
                    @"signin_main_password"];
    }
    return _images;
}

@end
