//
//  DetailHeaderView.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "DetailHeaderView.h"
#import "ColumnChartView.h"
#import "LineChartView.h"
#import "DoubleLineChartView.h"
#import "SleepChartView.h"
#import "HomeBreathCircleView.h"

@interface DetailHeaderView ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 图表
@property (nonatomic, strong) UIView *chartView;
/// 柱状图
@property (nonatomic, strong) ColumnChartView *columnView;
/// 曲线图
@property (nonatomic, strong) LineChartView *lineView;
/// 双曲线图
@property (nonatomic, strong) DoubleLineChartView *doubleLineView;
/// 睡眠图
@property (nonatomic, strong) SleepChartView *sleepChartView;
/// 呼吸图
@property (nonatomic, strong) HomeBreathCircleView *breathCircleView;
/// 呼吸目标
@property (nonatomic, strong) UILabel *breathGoalLabel;
/// 无数据
@property (nonatomic, strong) UIView *noDataView;
/// 无数据
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation DetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.chartView];
    [self.bgView addSubview:self.noDataView];
    [self.noDataView addSubview:self.noDataLabel];

}

- (void)updateChartView:(ChartViewModel *)chartModel cellType:(HealthDataType)cellType dateType:(HealthDateType)dateType {
    BOOL isHiddenChart = chartModel.dataArray.count == 0;
    self.chartView.hidden = isHiddenChart;
    self.noDataView.hidden = !isHiddenChart;
    if (chartModel.dataArray.count == 0) {
        if (cellType == HealthDataTypeBreath) {
            self.breathCircleView.hidden = YES;
            self.breathGoalLabel.hidden = YES;
        }
        return;
    }
    if (cellType == HealthDataTypeStep) {
        [self updateStepChartView:chartModel cellType:cellType];
    } else if (cellType == HealthDataTypeSleep) {
        [self updateSleepChartView:chartModel cellType:cellType dateType:dateType];
    } else if (cellType == HealthDataTypeBP) {
        [self updateBpChartView:chartModel];
    } else if (cellType == HealthDataTypeBreath) {
        [self updateBreathChartView:chartModel cellType:cellType];
    } else {
        [self updateLineChartView:chartModel cellType:cellType];
    }
}

- (void)updateStepChartView:(ChartViewModel *)chartModel cellType:(HealthDataType)cellType {
    if (!self.columnView) {
        self.columnView = [[ColumnChartView alloc] initWithFrame:self.chartView.bounds];
        self.columnView.mainColor = [HealthDataManager mainColor:cellType];
        self.columnView.cellType = cellType;
        [self.chartView addSubview:self.columnView];
    }
    self.columnView.chartModel = chartModel;
}

- (void)updateSleepChartView:(ChartViewModel *)chartModel cellType:(HealthDataType)cellType dateType:(HealthDateType)dateType {
    if (dateType == HealthDateTypeDay) {
        if (!self.sleepChartView) {
            self.sleepChartView = [[SleepChartView alloc] initWithFrame:self.chartView.bounds];
            [self.chartView addSubview:self.sleepChartView];
        }
        self.sleepChartView.chartModel = chartModel;
        
        self.columnView.hidden = YES;
        self.sleepChartView.hidden = NO;
        
    } else {
        if (!self.columnView) {
            self.columnView = [[ColumnChartView alloc] initWithFrame:self.chartView.bounds];
            self.columnView.mainColor = [HealthDataManager mainColor:cellType];
            self.columnView.cellType = cellType;
            [self.chartView addSubview:self.columnView];
        }
        self.columnView.chartModel = chartModel;
        
        self.columnView.hidden = NO;
        self.sleepChartView.hidden = YES;
    }
}
    
- (void)updateLineChartView:(ChartViewModel *)chartModel cellType:(HealthDataType)cellType {
    if (!self.lineView) {
        self.lineView = [[LineChartView alloc] initWithFrame:self.chartView.bounds];
        self.lineView.mainColor = [HealthDataManager mainColor:cellType];
        self.lineView.unitStr = [HealthDataManager unitOfType:cellType];
        [self.chartView addSubview:self.lineView];
    }
    self.lineView.chartModel = chartModel;
}

- (void)updateBpChartView:(ChartViewModel *)chartModel {
    if (!self.doubleLineView) {
        self.doubleLineView = [[DoubleLineChartView alloc] initWithFrame:self.chartView.bounds];
        [self.chartView addSubview:self.doubleLineView];
    }
    self.doubleLineView.chartModel = chartModel;
}

- (void)updateBreathCircleView:(DailyBreathModel *)model {
    
    if (!self.breathCircleView) {
        CGFloat circleH = self.width/3.0;
        self.breathCircleView = [[HomeBreathCircleView alloc] initWithFrame:CGRectMake(0, 0, circleH, circleH)];
        [self.bgView addSubview:self.breathCircleView];
        self.breathCircleView.center = CGPointMake((self.width-30)/2.0, circleH/2.0+30);
        
        self.breathGoalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.breathCircleView.frame)+25, self.width-30, 20)];
        self.breathGoalLabel.textColor = HomeColor_TitleColor;
        self.breathGoalLabel.font = HomeFont_TitleFont;
        self.breathGoalLabel.text = [NSString stringWithFormat:@"%@:10%@",Lang(@"str_target"),MinuteUnit];
        self.breathGoalLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.breathGoalLabel];
        
    }
    CGFloat progress = model.duration/10.0;
    if (progress > 1.0) {
        progress = 1.0;
    }
    self.breathCircleView.progress = progress;
    self.breathCircleView.breathLabel.text = [NSString stringWithFormat:@"%ld",(long)model.duration];
    
    self.noDataView.hidden = YES;
    self.chartView.hidden = YES;
    self.breathCircleView.hidden = NO;
    self.breathGoalLabel.hidden = NO;
}

- (void)updateBreathChartView:(ChartViewModel *)chartModel cellType:(HealthDataType)cellType {
    
    if (!self.columnView) {
        self.columnView = [[ColumnChartView alloc] initWithFrame:self.chartView.bounds];
        self.columnView.mainColor = [HealthDataManager mainColor:cellType];
        self.columnView.cellType = cellType;
        [self.chartView addSubview:self.columnView];
    }
    self.columnView.chartModel = chartModel;
    
    if (self.breathCircleView) {
        self.breathCircleView.hidden = YES;
        self.breathGoalLabel.hidden = YES;
    }
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.width-30, self.height-10)];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)chartView {
    if (!_chartView) {
        _chartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width-30, self.height-10)];
        _chartView.backgroundColor = HomeColor_BlockColor;
        
    }
    return _chartView;
}

- (UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width-30, self.height-10)];
        _noDataView.backgroundColor = HomeColor_BlockColor;
    }
    return _noDataView;
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width-30, self.height-10)];
        _noDataLabel.textColor = HomeColor_TitleColor;
        _noDataLabel.font = HomeFont_SubTitleFont;
        _noDataLabel.text = Lang(@"str_no_data");
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataLabel;
}

@end
