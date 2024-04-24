//
//  MWPickerViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "MWPickerViewController.h"

@interface MWPickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

/// 选择器
@property (nonatomic, strong) UIPickerView *picker;
/// 确定
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation MWPickerViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(44);
        make.bottom.offset(-(kBottomHeight+25));
    }];
    
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(216);
        make.centerY.equalTo(self.view);
    }];
    
    for (int i = 0; i < self.selectedRows.count; i++) {
        NSInteger row = [self.selectedRows[i] integerValue];
        [self updateSelectRow:row inComponent:i];
    }
}

- (void)confirmClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(customPickerViewConfirm:viewTag:)]) {
        [self.delegate customPickerViewConfirm:self.picker viewTag:self.viewTag];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.picker selectRow:row inComponent:component animated:YES];
}

- (void)reloadAllComponents:(NSArray *)dataArray {
    self.dataArray = dataArray;
    [self.picker reloadAllComponents];
}

#pragma mark UIPickerViewDataSource,UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSArray *itemArray = self.dataArray[component];
    return itemArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *itemArray = self.dataArray[component];
    NSString *titleStr = [NSString stringWithFormat:@"%@",itemArray[row]];
    return titleStr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(customPickerViewDidSelectRow:inComponent:viewTag:)]) {
        [self.delegate customPickerViewDidSelectRow:row inComponent:component viewTag:self.viewTag];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = (UILabel *)view;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, 44.0)];
    }
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = HomeColor_TitleColor;
    titleLabel.font = HomeFont_TitleFont;
    titleLabel.text= [self pickerView:pickerView titleForRow:row forComponent:component];
    return titleLabel;
}

#pragma mark - get and set 属性的set和get方法

- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] init];
        _picker.dataSource = self;
        _picker.delegate = self;
        _picker.backgroundColor = HomeColor_BackgroundColor;
        [self.view addSubview:_picker];
    }
    return _picker;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 10.0;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton setTitle:Lang(@"str_sure") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.backgroundColor = HomeColor_MainColor;
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

@end
