//
//  NickNameSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "NickNameSetViewController.h"

@interface NickNameSetViewController ()<UITextFieldDelegate>

#pragma mark UI

/// 顶部视图
@property (nonatomic, strong) UIView *topView;
/// 昵称
@property (nonatomic, strong) UITextField *nickNameTF;
/// 文字数量
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation NickNameSetViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addGeusterHideKeyboard];
}

#pragma mark - custom action for UI 界面处理有关

- (void)navRightButtonClick:(UIButton *)sender {

    if (self.nickName.length && [self.delegate respondsToSelector:@selector(nickNameUpdate:)]) {
        [self.delegate nickNameUpdate:self.nickName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.offset(50);
    }];
    
    [self.nickNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.right.offset(0);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.right.offset(-HomeViewSpace_Right);
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

#pragma mark - get and set 属性的set和get方法

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
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:Lang(@"str_nick") attributes:@{NSForegroundColorAttributeName:HomeColor_PlaceholderColor,NSFontAttributeName:HomeFont_TitleFont}];
        _nickNameTF.attributedPlaceholder = attrString;
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

@end
