//
//  NickNameSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "NickNameSetViewController.h"

@interface NickNameSetViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UITextField *nickNameTF;

@property (nonatomic, strong) UILabel *subTitleLabel;
/// 确定
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation NickNameSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self addGeusterHideKeyboard];
}

- (void)confirmButtonTouchUpInside:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(nickNameDidChange:)]) {
        [self.delegate nickNameDidChange:self.nickName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.offset(50);
    }];
    
    [self.nickNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.right.offset(0);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.right.offset(-15);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(44);
        make.bottom.offset(-(kBottomHeight+25));
    }];
    
    self.nickNameTF.text = self.nickName;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        // 没有高亮选择的字
        // 2. 截取
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
    self.nickName = textField.text;
    self.subTitleLabel.text = [NSString stringWithFormat:@"%ld/20",(long)self.nickName.length];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = HomeColor_BlockColor;
        _topView.layer.cornerRadius = 10.0;
        _topView.layer.masksToBounds = YES;
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (UITextField *)nickNameTF {
    if (!_nickNameTF) {
        _nickNameTF = [[UITextField alloc]init];
        _nickNameTF.placeholder = @"请输入昵称";
        _nickNameTF.tintColor = HomeColor_TitleColor;
        _nickNameTF.borderStyle = UITextBorderStyleNone;
        _nickNameTF.returnKeyType = UIReturnKeyDone;
        _nickNameTF.font = HomeFont_TitleFont;
        _nickNameTF.textColor = HomeColor_TitleColor;
        _nickNameTF.delegate = self;
        [_nickNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.topView addSubview:_nickNameTF];
    }
    return _nickNameTF;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = HomeColor_SubTitleColor;
        _subTitleLabel.font = HomeFont_SubTitleFont;
        _subTitleLabel.text = [NSString stringWithFormat:@"%ld/20",(long)self.nickName.length];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = HomeColor_MainColor;
        [_confirmButton addTarget:self action:@selector(confirmButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

@end
