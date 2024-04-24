//
//  HomePageBaseCell.m
//  DHSFit
//
//  Created by DHS on 2022/9/14.
//

#import "HomePageBaseCell.h"

@interface HomePageBaseCell ()
/// 背景
@property (nonatomic, strong) UIView *bgView;

@end

@implementation HomePageBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(HomeCellModel *)model {
    self.leftImageView.image = DHImage(model.leftImage);
    self.leftTitleLabel.text = model.leftTitle;
    
    NSArray *strArray;
    NSArray *fontArray;
    NSArray *colorArray;
    if (model.cellType == HealthDataTypeSleep) {
        DailySleepModel *sleepModel = model.dataModel;
        ChartViewModel *chartModel = model.chartModel;
        
        NSInteger total = sleepModel.deep+sleepModel.light;
        NSString *hour = total > 0 ? [NSString stringWithFormat:@"%02ld", (long)total/60] : @"--";
        NSString *minute = total > 0 ? [NSString stringWithFormat:@"%02ld", (long)total%60] : @"--";
        strArray = @[hour,HourUnit,minute,MinuteUnit];
        fontArray = @[HomeFont_Bold_25,HomeFont_SubTitleFont,HomeFont_Bold_25,HomeFont_SubTitleFont];
        colorArray = @[[HealthDataManager mainColor:model.cellType], HomeColor_SubTitleColor, [HealthDataManager mainColor:model.cellType],HomeColor_SubTitleColor];
        
        BOOL isHiddenChart = chartModel.dataArray.count < 1;
        self.chartView.hidden = isHiddenChart;
        self.noDataView.hidden = !isHiddenChart;
        if (!isHiddenChart) {
            [self updateSleepChartView:chartModel];
        }
        
    } else if (model.cellType == HealthDataTypeHeartRate) {
        DailyHeartRateModel *hrModel = model.dataModel;
        ChartViewModel *chartModel = model.chartModel;
        
        NSString *hr = hrModel.lastHr > 0 ? [NSString stringWithFormat:@"%ld",(long)hrModel.lastHr] : @"--";
        strArray = @[hr,HrUnit];
        fontArray = @[HomeFont_Bold_25,HomeFont_SubTitleFont];
        colorArray = @[[HealthDataManager mainColor:model.cellType],HomeColor_SubTitleColor];
        
        BOOL isHiddenChart = chartModel.dataArray.count < 1;
        self.chartView.hidden = isHiddenChart;
        self.noDataView.hidden = !isHiddenChart;
        if (!isHiddenChart) {
            [self updateHrChartView:chartModel];
        }
        
    } else if (model.cellType == HealthDataTypeBP) {
        DailyBpModel *bpModel = model.dataModel;
        ChartViewModel *chartModel = model.chartModel;
        
        NSString *systolic = bpModel.lastSystolic > 0 ? [NSString stringWithFormat:@"%ld",(long)bpModel.lastSystolic] : @"--";
        NSString *diastolic = bpModel.lastDiastolic > 0 ? [NSString stringWithFormat:@"%ld",(long)bpModel.lastDiastolic] : @"--";
        strArray = @[systolic,@"/",diastolic,BpUnit];
        fontArray = @[HomeFont_Bold_25,HomeFont_SubTitleFont,HomeFont_Bold_25,HomeFont_SubTitleFont];
        colorArray = @[COLOR(@"#FF53FD"),HomeColor_SubTitleColor,COLOR(@"#17FFF1"),HomeColor_SubTitleColor];
        
        BOOL isHiddenChart = chartModel.dataArray.count < 1;
        self.chartView.hidden = isHiddenChart;
        self.noDataView.hidden = !isHiddenChart;
        if (!isHiddenChart) {
            [self updateBpChartView:chartModel];
        }
    } else if (model.cellType == HealthDataTypeBO) {
        DailyBoModel *boModel = model.dataModel;
        ChartViewModel *chartModel = model.chartModel;
        
        NSString *bo = boModel.lastBo > 0 ? [NSString stringWithFormat:@"%ld",(long)boModel.lastBo] : @"--";
        strArray = @[bo,BoUnit];
        fontArray = @[HomeFont_Bold_25,HomeFont_SubTitleFont];
        colorArray = @[[HealthDataManager mainColor:model.cellType],HomeColor_SubTitleColor];
        
        BOOL isHiddenChart = chartModel.dataArray.count < 1;
        self.chartView.hidden = isHiddenChart;
        self.noDataView.hidden = !isHiddenChart;
        if (!isHiddenChart) {
            [self updateBoChartView:chartModel];
        }
    } else if (model.cellType == HealthDataTypeTemp) {
        DailyTempModel *tempModel = model.dataModel;
        ChartViewModel *chartModel = model.chartModel;
        
        NSString *temp = tempModel.lastTemp > 0 ? [NSString stringWithFormat:@"%.01f",TempValue(tempModel.lastTemp)] : @"--";
        strArray = @[temp,TempUnit];
        fontArray = @[HomeFont_Bold_25,HomeFont_SubTitleFont];
        colorArray = @[[HealthDataManager mainColor:model.cellType],HomeColor_SubTitleColor];
        
        BOOL isHiddenChart = chartModel.dataArray.count < 1;
        self.chartView.hidden = isHiddenChart;
        self.noDataView.hidden = !isHiddenChart;
        if (!isHiddenChart) {
            [self updateTempChartView:chartModel];
        }
    } else if (model.cellType == HealthDataTypeBreath) {
        DailyBreathModel *breathModel = model.dataModel;
        
        NSString *breath = breathModel.duration > 0 ? [NSString stringWithFormat:@"%ld",(long)breathModel.duration] : @"--";
        strArray = @[breath,MinuteUnit];
        fontArray = @[HomeFont_Bold_25,HomeFont_SubTitleFont];
        colorArray = @[[HealthDataManager mainColor:model.cellType],HomeColor_SubTitleColor];
        
        BOOL isHiddenChart = NO;
        self.chartView.hidden = isHiddenChart;
        self.noDataView.hidden = !isHiddenChart;
        if (!isHiddenChart) {
            [self updateBreathChartView:breathModel];
        }
    }
    if (strArray) {
        self.valueLabel.attributedText = [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
    }
    
}

- (void)updateSleepChartView:(ChartViewModel *)chartModel {
    
}

- (void)updateHrChartView:(ChartViewModel *)chartModel {
    
}

- (void)updateBpChartView:(ChartViewModel *)chartModel {
    
}

- (void)updateBoChartView:(ChartViewModel *)chartModel {
    
}

- (void)updateTempChartView:(ChartViewModel *)chartModel {
    
}

- (void)updateBreathChartView:(DailyBreathModel *)dataModel {
    
}

- (void)setupSubViews {
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.height.width.offset(22);
    }];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.right.offset(-10);
        make.centerY.equalTo(self.leftImageView);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.leftImageView.mas_bottom).offset(10);
    }];
        
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
        make.height.offset(70);
    }];
    
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
        make.height.offset(70);
    }];
    
    CGRect rect = CGRectMake(0, 0, (kScreenWidth-45)/2.0-30, 70);
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = rect;
    gradient.colors = @[(id)[UIColor colorNamed:@"D_#FEFEFE"].CGColor, (id)[UIColor clearColor].CGColor];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.noDataView.layer addSublayer:gradient];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeCenter;
        [self.bgView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = HomeColor_TitleColor;
        _leftTitleLabel.font = HomeFont_ButtonFont;
        _leftTitleLabel.numberOfLines = 0;
        _leftTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _leftTitleLabel.text = @"";
        [self.bgView addSubview:_leftTitleLabel];
    }
    return _leftTitleLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc]init];
        _valueLabel.text = @"";
        [self.bgView addSubview:_valueLabel];
    }
    return _valueLabel;
}

- (UIView *)chartView {
    if (!_chartView) {
        _chartView = [[UIView alloc] init];
        _chartView.backgroundColor = HomeColor_BlockColor;
        [self.bgView addSubview:_chartView];
    }
    return _chartView;
}

- (UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
        _noDataView.backgroundColor = HomeColor_BlockColor;
        [self.bgView addSubview:_noDataView];
    }
    return _noDataView;
}
@end
