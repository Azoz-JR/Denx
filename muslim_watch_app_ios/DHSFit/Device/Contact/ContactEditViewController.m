//
//  ContactEditViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "ContactEditViewController.h"

@interface ContactEditViewController ()<UITextFieldDelegate>

#pragma mark UI

@property (nonatomic, strong) UIView *nickNameView;

@property (nonatomic, strong) UIView *mobileView;

@property (nonatomic, strong) UITextField *nickNameTF;

@property (nonatomic, strong) UITextField *mobileTF;

@property (nonatomic, copy) NSString *lastNickNameContent;

@property (nonatomic, copy) NSString *lastMobileContent;

@end

@implementation ContactEditViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addGeusterHideKeyboard];
}

#pragma mark - custom action for UI 界面处理有关

-(void)navRightButtonClick:(UIButton *)sender {
    NSString *nickNameStr = [self.nickNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (nickNameStr.length == 0) {
        SHOWHUD(Lang(@"str_please_input_person"))
        return;
    }
    
    NSString *mobileStr = [self.mobileTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobileStr.length == 0) {
        SHOWHUD(Lang(@"str_please_input_contact"))
        return;
    }
    self.model.name = nickNameStr;
    self.model.mobile = mobileStr;
    if ([self.delegate respondsToSelector:@selector(contactUpdate:)]) {
        [self.delegate contactUpdate:self.model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    [self.nickNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.offset(50);
    }];
    
    [self.nickNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.right.offset(0);
    }];
    
    [self.mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.top.equalTo(self.nickNameView.mas_bottom).offset(HomeViewSpace_Vertical);
        make.height.offset(50);
    }];
    
    [self.mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.right.offset(0);
    }];
    
    self.nickNameTF.text = self.model.name;
    self.mobileTF.text = self.model.mobile;
}

- (void)addGeusterHideKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willEndEditing)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)willEndEditing{
    [self.view endEditing:NO];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.lastNickNameContent = textField.text;
    } else {
        self.lastMobileContent = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        // 没有高亮选择的字
        // 2. 截取
        if (textField.tag == 1000) {
            self.lastNickNameContent = textField.text;
        } else {
            self.lastMobileContent = textField.text;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark - get and set 属性的set和get方法

- (UIView *)nickNameView {
    if (!_nickNameView) {
        _nickNameView = [[UIView alloc] init];
        _nickNameView.backgroundColor = HomeColor_BlockColor;
        _nickNameView.layer.cornerRadius = 10.0;
        _nickNameView.layer.masksToBounds = YES;
        [self.view addSubview:_nickNameView];
    }
    return _nickNameView;
}

- (UIView *)mobileView {
    if (!_mobileView) {
        _mobileView = [[UIView alloc] init];
        _mobileView.backgroundColor = HomeColor_BlockColor;
        _mobileView.layer.cornerRadius = 10.0;
        _mobileView.layer.masksToBounds = YES;
        [self.view addSubview:_mobileView];
    }
    return _mobileView;
}

- (UITextField *)nickNameTF {
    if (!_nickNameTF) {
        _nickNameTF = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:Lang(@"str_contact_person") attributes:@{NSForegroundColorAttributeName:HomeColor_PlaceholderColor,NSFontAttributeName:HomeFont_TitleFont}];
        _nickNameTF.attributedPlaceholder = attrString;
        _nickNameTF.tintColor = HomeColor_TitleColor;
        _nickNameTF.borderStyle = UITextBorderStyleNone;
        _nickNameTF.returnKeyType = UIReturnKeyDone;
        _nickNameTF.font = HomeFont_TitleFont;
        _nickNameTF.textColor = HomeColor_TitleColor;
        _nickNameTF.delegate = self;
        _nickNameTF.tag = 1000;
        [_nickNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.nickNameView addSubview:_nickNameTF];
    }
    return _nickNameTF;
}

- (UITextField *)mobileTF {
    if (!_mobileTF) {
        _mobileTF = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:Lang(@"str_contact") attributes:@{NSForegroundColorAttributeName:HomeColor_PlaceholderColor,NSFontAttributeName:HomeFont_TitleFont}];
        _mobileTF.attributedPlaceholder = attrString;
        _mobileTF.tintColor = HomeColor_TitleColor;
        _mobileTF.borderStyle = UITextBorderStyleNone;
        _mobileTF.returnKeyType = UIReturnKeyDone;
        _mobileTF.font = HomeFont_TitleFont;
        _mobileTF.textColor = HomeColor_TitleColor;
        _mobileTF.delegate = self;
        _mobileTF.tag = 1001;
        [_mobileTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.mobileView addSubview:_mobileTF];
    }
    return _mobileTF;
}

@end
