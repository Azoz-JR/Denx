//
//  PasswordUpdateView.m
//  DHSFit
//
//  Created by DHS on 2022/6/20.
//

#import "PasswordUpdateView.h"

@interface PasswordUpdateView()<UITextFieldDelegate>

/// 背景
@property (nonatomic, strong) UIView *contentView;
/// 确定
@property (nonatomic, strong) UIButton *confirmButton;
/// 标题
@property (nonatomic, strong) NSArray *titles;
/// icon
@property (nonatomic, strong) NSArray *images;

@end

@implementation PasswordUpdateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.height.offset(50);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountLabel.mas_bottom);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(60*3-10);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.top.equalTo(self.contentView.mas_bottom).offset(30);
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
        
        UIButton *eyesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        eyesButton.tag = 100+i;
        [eyesButton setImage:DHImage(@"signin_eyes_unSelected") forState:UIControlStateNormal];
        [eyesButton setImage:DHImage(@"signin_eyes_selected") forState:UIControlStateSelected];
        eyesButton.frame = CGRectMake(0, 0, 20, 14);
        [eyesButton addTarget:self action:@selector(eyesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        itemTextField.rightView = eyesButton;
        itemTextField.rightViewMode =UITextFieldViewModeAlways;
        itemTextField.secureTextEntry = YES;
        
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

- (void)confirmClick {
    UITextField *oldPasswordTF = [self.contentView viewWithTag:1000];
    if (!oldPasswordTF.text.length) {
        SHOWHUD(Lang(@"str_please_input_opw"))
        return;
    }
    if (oldPasswordTF.text.length < 6) {
        SHOWHUD(Lang(@"str_please_input_legal_pw"))
        return;
    }
    if (![DHPredicate checkForNumberAndCase:oldPasswordTF.text]) {
        SHOWHUD(Lang(@"str_please_input_legal_pw"))
        return;
    }

    UITextField *passwordTFA = [self.contentView viewWithTag:1001];
    UITextField *passwordTFB = [self.contentView viewWithTag:1002];
    
    if (!passwordTFA.text.length || !passwordTFB.text.length) {
        SHOWHUD(Lang(@"str_please_input_npw"))
        return;
    }
    
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
    if ([self.delegate respondsToSelector:@selector(onPasswordUpdate:newPassword:)]) {
        [self.delegate onPasswordUpdate:oldPasswordTF.text newPassword:passwordTFA.text];
    }
}

- (void)eyesButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.tag == 100) {
        UITextField *itemTextField = [self.contentView viewWithTag:1000];
        itemTextField.secureTextEntry = !itemTextField.isSecureTextEntry;
    } else if (sender.tag == 101) {
        UITextField *itemTextField = [self.contentView viewWithTag:1001];
        itemTextField.secureTextEntry = !itemTextField.isSecureTextEntry;
    } else {
        UITextField *itemTextField = [self.contentView viewWithTag:1002];
        itemTextField.secureTextEntry = !itemTextField.isSecureTextEntry;
    }
    
}

- (void)updateSigninButtonState {
    UITextField *oldPasswordTF = [self.contentView viewWithTag:1000];
    UITextField *passwordTFA = [self.contentView viewWithTag:1001];
    UITextField *passwordTFB = [self.contentView viewWithTag:1002];
    
    BOOL isEnable = oldPasswordTF.text.length && passwordTFA.text.length && passwordTFB.text.length;
    self.confirmButton.backgroundColor = isEnable ? HomeColor_ButtonHighLight : HomeColor_ButtonNormal;
    self.confirmButton.userInteractionEnabled = isEnable;
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

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.font = HomeFont_TitleFont;
        _accountLabel.textColor = HomeColor_TitleColor;
        _accountLabel.text = @"";
        [self addSubview:_accountLabel];
    }
    return _accountLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 10.0;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.backgroundColor = HomeColor_ButtonNormal;
        _confirmButton.userInteractionEnabled = NO;
        [_confirmButton setTitle:Lang(@"str_sure") forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = HomeFont_ButtonFont;
        [_confirmButton setTitleColor:HomeColor_ButtonColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
    }
    return _confirmButton;
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
        _titles = @[Lang(@"str_password_old"),
                    Lang(@"str_password_new"),
                    Lang(@"str_password_again")];
    }
    return _titles;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"signin_main_password",
                    @"signin_main_password",
                    @"signin_main_password"];
    }
    return _images;
}

@end
