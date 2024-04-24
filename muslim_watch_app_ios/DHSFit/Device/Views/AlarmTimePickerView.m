//
//  AlarmTimePickerView.m
//  DHSFit
//
//  Created by DHS on 2022/6/5.
//

#import "AlarmTimePickerView.h"

@interface AlarmTimePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 单位
@property (nonatomic, strong) UILabel *unitLabel;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 标签
@property (nonatomic, assign) NSInteger viewTag;

@end

@implementation AlarmTimePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = HomeColor_BlockColor;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)loadPickerViewWithArray:(NSArray *)array
                        unitStr:(NSString *)unitStr
                        viewTag:(NSInteger)viewTag {
    
    self.dataArray = [NSMutableArray arrayWithArray:array];
    self.viewTag = viewTag;
    
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    if (unitStr.length) {
        CGFloat centerX = self.frame.size.width/2.0;
        
        [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.picker.mas_centerY);
            make.left.offset(centerX+45);
            make.height.offset(40);
        }];
        self.unitLabel.text = unitStr;
    }
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewDidSelectRow:inComponent:viewTag:)]) {
        [self.delegate pickerViewDidSelectRow:row inComponent:component viewTag:self.viewTag];
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

- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] init];
        _picker.dataSource = self;
        _picker.delegate = self;
        _picker.backgroundColor = [UIColor clearColor];
        [self addSubview:_picker];
    }
    return _picker;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = HomeFont_TitleFont;
        _unitLabel.textColor = HomeColor_TitleColor;
        _unitLabel.text = @"";
        [self addSubview:_unitLabel];
    }
    return _unitLabel;
}

@end

