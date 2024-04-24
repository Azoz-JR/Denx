//
//  FeedbackViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "FeedbackViewController.h"
#import "PlaceholderTextView.h"

@interface FeedbackViewController ()<UITextFieldDelegate,UITextViewDelegate>

#pragma mark UI

/// 背景
@property (nonatomic, strong) UIScrollView *myScrollView;
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 问题
@property (nonatomic, strong) UILabel *problemLabel;
/// 文字数量
@property (nonatomic, strong) UILabel *countLabel;
/// 问题
@property (nonatomic, strong) UIView *problemView;
/// 联系方式
@property (nonatomic, strong) UIView *contactView;
/// 问题
@property (nonatomic, strong) PlaceholderTextView *problemTextView;
/// 联系方式
@property (nonatomic, strong) UILabel *contactLabel;
/// 联系方式
@property (nonatomic, strong) UITextField *contactTextField;
/// 反馈
@property (nonatomic, strong) UIButton *confirmButton;


#pragma mark Data
/// 文字数量
@property (nonatomic, assign) NSInteger labelCount;
/// 文字最大数量
@property (nonatomic, assign) NSInteger maxCount;
/// 键盘Tag
@property (nonatomic, assign) NSInteger keyboardTag;
/// 键盘高度
@property (nonatomic, assign) NSInteger keyboardHight;

@end

@implementation FeedbackViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    [self addGeusterHideKeyboard];
    [self registNotification];
}

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

#pragma mark notification 通知管理
- (void)registNotification
{
    // observe keyboard hide and show notifications to resize the text view appropriately
    //弹出键盘
    [DHNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark --键盘弹出收起管理
-(void)keyboardWillShow:(NSNotification *)note{
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keyboardHight = kbSize.height;
    
    if (self.keyboardTag == 100) {
        if (self.bgView.frame.size.height - self.keyboardHight <= self.contactView.frame.origin.y + self.contactView.frame.size.height) {
            CGFloat y = self.contactView.frame.origin.y - (self.bgView.frame.size.height - self.keyboardHight - self.contactView.frame.size.height - 5);
            [UIView beginAnimations:@"srcollView" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.275f];
            self.bgView.frame = CGRectMake(self.bgView.frame.origin.x, -y, self.bgView.frame.size.width, self.bgView.frame.size.height);
            [UIView commitAnimations];
        }
    }
    
}

- (void)initData {
    self.labelCount = 0;
    self.maxCount = 400;
}

- (void)setupUI {
    
    self.myScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.myScrollView];
    
    CGFloat bgViewH = kScreenHeight-kNavAndStatusHeight-kBottomHeight;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myScrollView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.offset(bgViewH);
    }];
    
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(kNavAndStatusHeight);
        make.height.offset(bgViewH);
        make.bottom.equalTo(self.bgView.mas_bottom);
    }];
    
    [self.problemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(HomeViewSpace_Left);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.right.offset(-HomeViewSpace_Right);
    }];
    
    [self.problemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.problemLabel.mas_bottom).offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(200);
    }];
    
    [self.problemTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.problemView.mas_bottom).offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
    }];
    
    [self.contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactLabel.mas_bottom).offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
    }];
    
    [self.contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.bottom.right.offset(0);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactView.mas_bottom).offset(20);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
    }];
}

#pragma mark 添加隐藏键盘方法
- (void)addGeusterHideKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willEndEditing)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)willEndEditing{
    [self.view endEditing:NO];
}

- (void)confirmClick:(UIButton *)sender {
    [self willEndEditing];
    if (self.problemTextView.text.length == 0) {
        SHOWHUD(Lang(@"str_your_question"))
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.problemTextView.text forKey:@"desc"];
    [dict setObject:DHUserId forKey:@"memberId"];
    if (self.contactTextField.text.length) {
        [dict setObject:self.contactTextField.text forKey:@"contact"];
    }
    SHOWINDETERMINATE
    WEAKSELF
    [NetworkManager feedbackWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        HUDDISS
        if (resultCode == 0) {
            SHOWHUD(Lang(@"str_feedback_success"))
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            SHOWHUD(Lang(@"str_feedback_fail"))
        }
        });
    }];
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.keyboardTag = 0;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.keyboardTag = 0;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > self.maxCount)
    {
        NSString *s = [nsTextContent substringToIndex:self.maxCount];
        [textView setText:s];
        existTextNum = self.maxCount;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)existTextNum,(long)self.maxCount];
    self.labelCount = existTextNum;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqual:@"\n"]) {
        [self.problemTextView resignFirstResponder];
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < self.maxCount) {
            return YES;
        }else return NO;
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = self.maxCount - comcatstr.length;
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.maxCount,(long)self.maxCount];
        }
        return NO;
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.keyboardTag = 100;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.bgView.frame = CGRectMake(self.bgView.frame.origin.x, 0, self.bgView.frame.size.width, self.bgView.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (textField.text.length > 50) {
            textField.text = [textField.text substringToIndex:50];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}


#pragma mark - get and set 属性的set和get方法

- (UILabel *)problemLabel {
    if (!_problemLabel) {
        _problemLabel = [[UILabel alloc]init];
        NSArray *strArray = @[Lang(@"str_questions_and_suggestions"),@"*"];
        NSArray *fontArray = @[HomeFont_TitleFont,HomeFont_TitleFont];
        NSArray *colorArray = @[HomeColor_TitleColor,[UIColor redColor]];
        _problemLabel.attributedText = [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
        [self.bgView addSubview:_problemLabel];
    }
    return _problemLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]init];
        _countLabel.textColor = HomeColor_TitleColor;
        _countLabel.font = HomeFont_ContentFont;
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.labelCount,(long)self.maxCount];
        [self.bgView addSubview:_countLabel];
    }
    return _countLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BackgroundColor;
        [self.myScrollView addSubview:_bgView];
    }
    return _bgView;
}

- (UIView *)problemView {
    if (!_problemView) {
        _problemView = [[UIView alloc] init];
        _problemView.backgroundColor = HomeColor_BlockColor;
        _problemView.layer.cornerRadius = 10.0;
        _problemView.layer.masksToBounds = YES;
        [self.bgView addSubview:_problemView];
    }
    return _problemView;
}

- (UIView *)contactView {
    if (!_contactView) {
        _contactView = [[UIView alloc] init];
        _contactView.backgroundColor = HomeColor_BlockColor;
        _contactView.layer.cornerRadius = 10.0;
        _contactView.layer.masksToBounds = YES;
        [self.bgView addSubview:_contactView];
    }
    return _contactView;
}

- (UILabel *)contactLabel {
    if (!_contactLabel) {
        _contactLabel = [[UILabel alloc]init];
        _contactLabel.textColor = HomeColor_TitleColor;
        _contactLabel.font = HomeFont_TitleFont;
        _contactLabel.text = Lang(@"str_contact_details");
        [self.bgView addSubview:_contactLabel];
    }
    return _contactLabel;
}

- (UITextField *)contactTextField {
    if (!_contactTextField) {
        _contactTextField = [[UITextField alloc]init];
        _contactTextField.tintColor = HomeColor_TitleColor;
        _contactTextField.borderStyle = UITextBorderStyleNone;
        _contactTextField.returnKeyType = UIReturnKeyDone;
        _contactTextField.font = HomeFont_TitleFont;
        _contactTextField.textColor = HomeColor_TitleColor;
        _contactTextField.delegate = self;
        [_contactTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:Lang(@"str_please_input_contact") attributes:@{NSForegroundColorAttributeName:HomeColor_PlaceholderColor,NSFontAttributeName:HomeFont_TitleFont}];
        _contactTextField.attributedPlaceholder = attrString;
        [self.contactView addSubview:_contactTextField];
    }
    return _contactTextField;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 10.0;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton setTitle:Lang(@"str_submit_feedback") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        _confirmButton.backgroundColor = HomeColor_MainColor;
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (PlaceholderTextView *)problemTextView {
    if (!_problemTextView) {
        _problemTextView = [[PlaceholderTextView alloc] init];
        _problemTextView.tintColor = HomeColor_TitleColor;
        _problemTextView.delegate = self;
        _problemTextView.showsVerticalScrollIndicator = YES;
        _problemTextView.font = HomeFont_TitleFont;
        _problemTextView.textColor = HomeColor_TitleColor;
        _problemTextView.textAlignment = NSTextAlignmentLeft;
        _problemTextView.backgroundColor = HomeColor_BlockColor;
        _problemTextView.editable = YES;
        _problemTextView.placeholderColor = HomeColor_PlaceholderColor;
        _problemTextView.placeholder = Lang(@"str_your_question");
        _problemTextView.keyboardType = UIKeyboardTypeDefault;
        _problemTextView.returnKeyType = UIReturnKeyDone;
        [self.problemView addSubview:_problemTextView];
        
    }
    return _problemTextView;
}

@end
