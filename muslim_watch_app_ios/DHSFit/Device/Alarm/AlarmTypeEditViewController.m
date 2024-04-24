//
//  AlarmTypeEditViewController.m
//  DHSFit
//
//  Created by DHS on 2022/7/1.
//

#import "AlarmTypeEditViewController.h"

@interface AlarmTypeEditViewController ()<UITextFieldDelegate>

#pragma mark UI

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UITextField *alarmTypeTF;

@property (nonatomic, copy) NSString *lastTextFieldContent;

@end

@implementation AlarmTypeEditViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addGeusterHideKeyboard];
}

#pragma mark - custom action for UI 界面处理有关

-(void)navRightButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(alarmTypeUpdate:)]) {
        [self.delegate alarmTypeUpdate:self.alarmTypeTF.text];
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
    
    [self.alarmTypeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.right.offset(0);
    }];
    self.alarmTypeTF.text = self.alarmType;
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
    self.lastTextFieldContent = textField.text;
    return YES;
}

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
        NSData *data = [textField.text dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 20) {
            textField.text = self.lastTextFieldContent;
        } else {
            self.lastTextFieldContent = textField.text;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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

- (UITextField *)alarmTypeTF {
    if (!_alarmTypeTF) {
        _alarmTypeTF = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:Lang(@"str_tag") attributes:@{NSForegroundColorAttributeName:HomeColor_PlaceholderColor,NSFontAttributeName:HomeFont_TitleFont}];
        _alarmTypeTF.attributedPlaceholder = attrString;
        _alarmTypeTF.tintColor = HomeColor_TitleColor;
        _alarmTypeTF.borderStyle = UITextBorderStyleNone;
        _alarmTypeTF.returnKeyType = UIReturnKeyDone;
        _alarmTypeTF.font = HomeFont_TitleFont;
        _alarmTypeTF.textColor = HomeColor_TitleColor;
        _alarmTypeTF.delegate = self;
        [_alarmTypeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.topView addSubview:_alarmTypeTF];
    }
    return _alarmTypeTF;
}

@end
