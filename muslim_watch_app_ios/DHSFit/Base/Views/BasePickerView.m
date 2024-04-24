//
//  BasePickerView.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "BasePickerView.h"

@interface BasePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 取消
@property (nonatomic, strong) UIButton *cancelButton;
/// 确认
@property (nonatomic, strong) UIButton *confirmButton;
/// 选择器
@property (nonatomic, strong) UIPickerView *picker;
/// 单位
@property (nonatomic, strong) UILabel *unitLabel;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 标签
@property (nonatomic, assign) NSInteger viewTag;
/// 视图高度
@property (nonatomic, assign) CGFloat viewH;

@end

@implementation BasePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = COLORANDALPHA(@"#000000", 0.4);
    }
    return self;
}

- (void)setupPickerView:(NSArray *)dataArray
                unitStr:(NSString *)unitStr
                viewTag:(NSInteger)viewTag {
    
    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    self.viewTag = viewTag;
    [self setupSubViews];
    
    self.unitLabel.text = unitStr;
    [self showCustomPickerView];
}


- (void)setupSubViews {
    
    self.viewH = kBottomHeight+266;
    CGFloat buttonW = self.frame.size.width/3.0;
    CGFloat centerX = self.frame.size.width/2.0;
    
    self.bgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width,self.viewH);
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(buttonW);
        make.height.offset(50);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.offset(0);
        make.width.offset(buttonW);
        make.height.offset(50);
    }];
    
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelButton.mas_bottom).offset(12);
        make.left.right.offset(0);
        make.height.offset(216);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.picker.mas_centerY);
        make.left.offset(centerX+45);
        make.height.offset(40);
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;

}

- (void)updateSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.picker selectRow:row inComponent:component animated:YES];
}

- (void)reloadAllComponents:(NSArray *)dataArray {
    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
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
    if ([self.delegate respondsToSelector:@selector(basePickerViewDidSelectRow:inComponent:viewTag:)]) {
        [self.delegate basePickerViewDidSelectRow:row inComponent:component viewTag:self.viewTag];
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

- (void)cancelClick {
    [self hideCustomPickerView];
}

- (void)confirmClick {
    if ([self.delegate respondsToSelector:@selector(basePickerViewConfirm:viewTag:)]) {
        [self.delegate basePickerViewConfirm:self.picker viewTag:self.viewTag];
    }
    [self hideCustomPickerView];
}

- (void)showCustomPickerView {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    WEAKSELF
    [UIView animateWithDuration:0.20 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, weakSelf.frame.size.height-weakSelf.viewH, weakSelf.frame.size.width,weakSelf.viewH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideCustomPickerView {
    
    WEAKSELF
    [UIView animateWithDuration:0.20 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, weakSelf.frame.size.height, weakSelf.frame.size.width,weakSelf.viewH);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:Lang(@"str_cancel") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = HomeFont_TitleFont;
        [_cancelButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_cancelButton];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:Lang(@"str_sure") forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = HomeFont_TitleFont;
        [_confirmButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] init];
        _picker.dataSource = self;
        _picker.delegate = self;
        _picker.backgroundColor = [UIColor clearColor];
        [self.bgView addSubview:_picker];
    }
    return _picker;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = HomeFont_TitleFont;
        _unitLabel.textColor = HomeColor_TitleColor;
        _unitLabel.text = @"";
        [self.bgView addSubview:_unitLabel];
    }
    return _unitLabel;
}

@end
