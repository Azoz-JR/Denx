//
//  HistoryDataView.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "HistoryDataView.h"
#import "LineChartView.h"

@interface HistoryDataView ()

@property (nonatomic, strong) UIView *dataView;

@property (nonatomic, strong) UIView *paceView;

@property (nonatomic, strong) UIView *stepView;

@property (nonatomic, strong) UIView *heartRateView;

@property (nonatomic, strong) UIView *lineView1;

@property (nonatomic, strong) UIView *lineView2;

@property (nonatomic, strong) UIView *lineView3;

@property (nonatomic, strong) UILabel *paceLabel;

@property (nonatomic, strong) UILabel *stepLabel;

@property (nonatomic, strong) UILabel *heartRateLabel;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *values;

@property (nonatomic, strong) NSArray *paceTitles;

@property (nonatomic, strong) NSArray *paceValues;

@property (nonatomic, strong) NSArray *stepTitles;

@property (nonatomic, strong) NSArray *stepValues;

@property (nonatomic, strong) NSArray *colors;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) LineChartView *heartRateChartView;

@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation HistoryDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(DailySportModel *)model {
    BOOL isShowSteps = (model.type == SportTypeWalk || model.type == SportTypeRunIndoor || model.type == SportTypeRunOutdoor || model.type == SportTypeClimb);
    BOOL isShowHeartRate = model.heartRateItems.length;
    for (int i =0 ; i < self.titles.count; i++) {
        UILabel *valueLabel = [self.dataView viewWithTag:1000+i];
        if (i == 0) {
            valueLabel.text = [RunningManager transformDuration:model.duration];
        } else if (i == 1) {
            valueLabel.text = [NSString stringWithFormat:@"%ld",(long)model.step];
            UILabel *titleLabel = [self.dataView viewWithTag:10000+i];
            titleLabel.hidden = !isShowSteps;
            valueLabel.hidden = !isShowSteps;
        } else if (i == 2) {
            valueLabel.text = [NSString stringWithFormat:@"%.02f%@",DistanceValue(model.distance),DistanceUnit];
        } else {
            valueLabel.text = [NSString stringWithFormat:@"%.01f%@",KcalValue(model.calorie),CalorieUnit];
        }
    }
    
    NSMutableArray *paceArray = [NSMutableArray array];
    if (!ImperialUnit && model.metricPaceItems.length) {
        NSArray *metricPaceItems = [model.metricPaceItems transToObject];
        for (NSDictionary *dict in metricPaceItems) {
            [paceArray addObject:dict[@"value"]];
        }
    } else if (ImperialUnit && model.imperialPaceItems.length) {
        NSArray *imperialPaceItems = [model.imperialPaceItems transToObject];
        for (NSDictionary *dict in imperialPaceItems) {
            [paceArray addObject:dict[@"value"]];
        }
    }
    
    NSInteger avgPace;
    if (ImperialUnit) {
        avgPace = model.distance > 0 ? 1609.0*model.duration/model.distance : 0;
    } else {
        avgPace = model.distance > 0 ? 1000.0*model.duration/model.distance : 0;
    }
    NSInteger maxPace = paceArray.count > 0 ? [[paceArray valueForKeyPath:@"@max.floatValue"] floatValue] : avgPace;
    NSInteger minPace = paceArray.count > 0 ? [[paceArray valueForKeyPath:@"@min.floatValue"] floatValue] : avgPace;
    
    for (int i =0 ; i < self.paceTitles.count; i++) {
        UILabel *valueLabel = [self.paceView viewWithTag:2000+i];
        if (i == 0) {
            valueLabel.text = [NSString stringWithFormat:@"%ld'%02ld\"",(long)avgPace/60,(long)avgPace%60];
        } else if (i == 1) {
            valueLabel.text = [NSString stringWithFormat:@"%ld'%02ld\"",(long)maxPace/60,(long)maxPace%60];
        } else if (i == 2) {
            valueLabel.text = [NSString stringWithFormat:@"%ld'%02ld\"",(long)minPace/60,(long)minPace%60];
        }
    }

    UIView *bottomView = self.paceView;
    if (isShowSteps) {
        [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.right.offset(-HomeViewSpace_Right);
            make.height.offset(1);
            make.top.equalTo(self.paceView.mas_bottom).offset(15);
        }];
        
        [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.top.equalTo(self.lineView2.mas_bottom).offset(15);
        }];
        
        [self.stepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stepLabel.mas_bottom);
            make.left.offset(HomeViewSpace_Left);
            make.right.offset(-HomeViewSpace_Right);
            make.height.offset(66*3);
        }];
        bottomView = self.stepView;
        
        UIView *lastView;
        for (int i = 0; i < self.stepTitles.count; i++) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textColor = self.textColor;
            titleLabel.font = HomeFont_SubTitleFont;
            titleLabel.text = self.stepTitles[i];
            [self.stepView addSubview:titleLabel];
            
            UIView *itemView = [[UIView alloc] init];
            [self.stepView addSubview:itemView];
            
            if (i == 0) {
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.offset(0);
                    make.left.offset(0);
                    make.height.offset(30);
                }];
                
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleLabel.mas_bottom).offset(0);
                    make.left.offset(0);
                    make.width.equalTo(self.paceView).multipliedBy(0.6);
                    make.height.offset(36);
                }];
            } else if (i == 1){
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(0);
                    make.left.offset(0);
                    make.height.offset(30);
                }];
                
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleLabel.mas_bottom).offset(0);
                    make.left.offset(0);
                    make.width.equalTo(self.paceView);
                    make.height.offset(36);
                }];
            } else {
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(0);
                    make.left.offset(0);
                    make.height.offset(30);
                }];
                
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(titleLabel.mas_bottom).offset(0);
                    make.left.offset(0);
                    make.width.equalTo(self.paceView).multipliedBy(0.4);
                    make.height.offset(36);
                }];
            }
            
            CGFloat itemViewWidth;
            if (i == 0) {
                itemViewWidth = (kScreenWidth-60)*0.6;
            } else if (i == 1) {
                itemViewWidth = (kScreenWidth-60)*1;
            } else {
                itemViewWidth = (kScreenWidth-60)*0.4;
            }
            CGRect rect = CGRectMake(0, 0, itemViewWidth, 36);
            
            CAGradientLayer *layer = [CAGradientLayer layer];
            layer.startPoint = CGPointMake(0, 0.5);
            layer.endPoint = CGPointMake(1, 0.5);
            if (i == 0) {
                layer.colors = [NSArray arrayWithObjects:(id)COLOR(@"#FF9C00").CGColor,(id)COLOR(@"#FFEFB9").CGColor, nil];
            } else if (i == 1) {
                layer.colors = [NSArray arrayWithObjects:(id)COLOR(@"#DE0A0A").CGColor,(id)COLOR(@"#FF8181").CGColor, nil];
            } else {
                layer.colors = [NSArray arrayWithObjects:(id)COLOR(@"#05C312").CGColor,(id)COLOR(@"#99FFBD").CGColor, nil];
            }
            layer.frame = rect;
            [itemView.layer insertSublayer:layer atIndex:0];
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(18, 18)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = rect;
            maskLayer.path = maskPath.CGPath;
            itemView.layer.mask = maskLayer;
            
            UILabel *valueLabel = [[UILabel alloc] init];
            valueLabel.textColor = HomeColor_TitleColor;
            valueLabel.font = HomeFont_SubTitleFont;
            valueLabel.text = @"";
            valueLabel.tag = 3000+i;
            [itemView addSubview:valueLabel];
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(5);
                make.centerY.equalTo(itemView);
            }];
            
            lastView = itemView;
        }
        
        NSMutableArray *stepArray = [NSMutableArray array];
        if (model.strideFrequencyItems.length) {
            NSArray *strideFrequencyItems = [model.strideFrequencyItems transToObject];
            for (NSDictionary *dict in strideFrequencyItems) {
                [stepArray addObject:dict[@"value"]];
            }
        }
        NSInteger avgStep = 60.0*model.step/model.duration;
        //NSInteger avgStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@avg.floatValue"] floatValue] : baseAvgStep;
        NSInteger maxStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@max.floatValue"] floatValue] : avgStep;
        NSInteger minStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@min.floatValue"] floatValue] : avgStep;
        
        for (int i =0 ; i < self.stepTitles.count; i++) {
            UILabel *valueLabel = [self.stepView viewWithTag:3000+i];
            if (i == 0) {
                valueLabel.text = [NSString stringWithFormat:@"%ld%@/%@",(long)avgStep,StepUnit,Lang(@"str_mins")];
            } else if (i == 1) {
                valueLabel.text = [NSString stringWithFormat:@"%ld%@/%@",(long)maxStep,StepUnit,Lang(@"str_mins")];
            } else if (i == 2) {
                valueLabel.text = [NSString stringWithFormat:@"%ld%@/%@",(long)minStep,StepUnit,Lang(@"str_mins")];
            }
        }
    }

    if (isShowHeartRate) {
        [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.right.offset(-HomeViewSpace_Right);
            make.height.offset(1);
            make.top.equalTo(bottomView.mas_bottom).offset(15);
        }];
        
        [self.heartRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.top.equalTo(self.lineView3.mas_bottom).offset(15);
        }];
        
        [self.heartRateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.heartRateLabel.mas_bottom).offset(0);
            make.left.offset(HomeViewSpace_Left);
            make.right.offset(-HomeViewSpace_Right);
            make.height.offset(180);
        }];
        
        ChartViewModel *chartModel = [[ChartViewModel alloc] init];
        NSMutableArray *xTitles = [NSMutableArray array];
        NSMutableArray *yTitles = [NSMutableArray array];
        NSMutableArray *xPaths = [NSMutableArray array];
        NSMutableArray *yPaths = [NSMutableArray array];
        NSMutableArray *yPaths1 = [NSMutableArray array];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSInteger maxValue = 0;
        
        NSArray *array = [model.heartRateItems transToObject];
        [dataArray addObjectsFromArray:array];
        NSInteger allTime = model.duration;
        NSInteger beginTimestamp = [model.timestamp integerValue];
        
        NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:beginTimestamp];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:beginTimestamp+model.duration];
        
        [xTitles addObject:[beginDate dateToStringFormat:@"HH:mm"]];
        [xTitles addObject:[endDate dateToStringFormat:@"HH:mm"]];
        
        for (int i = 0; i < array.count; i++) {
            NSDictionary *item = array[i];
            if ([item[@"value"] integerValue] > maxValue) {
                maxValue = [item[@"value"] integerValue];
            }
            NSInteger interval = [item[@"index"] integerValue];
            [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*interval/allTime]];
        }
        
        for (int i = 0; i < array.count; i++) {
            NSDictionary *item = array[i];
            [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
        }
        
        if (maxValue > 0) {
            NSInteger yCount = 3;
            for (int i = 0; i < yCount; i++) {
                if (i == yCount-1) {
                    [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)maxValue]];
                } else {
                    [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)(i+1)*maxValue/yCount]];
                }
            }
        }
        chartModel.xTitles = xTitles;
        chartModel.yTitles = yTitles;
        chartModel.xPaths = xPaths;
        chartModel.yPaths = yPaths;
        chartModel.yPaths1 = yPaths1;
        chartModel.dataArray = dataArray;
        
        [self.heartRateView addSubview:self.heartRateChartView];
        self.heartRateChartView.chartModel = chartModel;
        
    } else {
        //[self.heartRateView addSubview:self.noDataLabel];
    }
}

- (void)setupSubViews {
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(160);
    }];

    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(1);
        make.top.equalTo(self.dataView.mas_bottom).offset(15);
    }];
    
    [self.paceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
    }];
    
    [self.paceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paceLabel.mas_bottom);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(66*3);
    }];
    
    
    
    UIView *lastView;
    for (int i = 0; i < self.titles.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor whiteColor];
        [self.dataView addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.offset(0);
                make.height.offset(80);
                make.width.equalTo(self.dataView).multipliedBy(0.5);
            }];
        } else if (i == 1) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.offset(0);
                make.height.offset(80);
                make.width.equalTo(self.dataView).multipliedBy(0.5);
            }];
        } else if (i == 2) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.left.offset(0);
                make.height.offset(80);
                make.width.equalTo(self.dataView).multipliedBy(0.5);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_top);
                make.right.offset(0);
                make.height.offset(80);
                make.width.equalTo(self.dataView).multipliedBy(0.5);
            }];
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = self.textColor;
        titleLabel.font = HomeFont_ButtonFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.titles[i];
        titleLabel.tag = 10000+i;
        [itemView addSubview:titleLabel];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = self.textColor;
        valueLabel.font = HomeFont_TitleFont;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = self.values[i];
        valueLabel.tag = 1000+i;
        [itemView addSubview:valueLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(30);
            make.centerX.equalTo(itemView);
            make.width.equalTo(itemView);
            
        }];
        
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemView);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
            make.width.equalTo(itemView);
        }];

        lastView = itemView;
    }
    
    for (int i = 0; i < self.paceTitles.count; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = self.textColor;
        titleLabel.font = HomeFont_SubTitleFont;
        titleLabel.text = self.paceTitles[i];
        [self.paceView addSubview:titleLabel];
        
        UIView *itemView = [[UIView alloc] init];
        [self.paceView addSubview:itemView];
        
        if (i == 0) {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.offset(0);
                make.height.offset(30);
            }];
            
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).offset(0);
                make.left.offset(0);
                make.width.equalTo(self.paceView).multipliedBy(0.6);
                make.height.offset(36);
            }];
        } else if (i == 1){
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(0);
                make.left.offset(0);
                make.height.offset(30);
            }];
            
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).offset(0);
                make.left.offset(0);
                make.width.equalTo(self.paceView);
                make.height.offset(36);
            }];
        } else {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(0);
                make.left.offset(0);
                make.height.offset(30);
            }];
            
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).offset(0);
                make.left.offset(0);
                make.width.equalTo(self.paceView).multipliedBy(0.4);
                make.height.offset(36);
            }];
        }
        
        CGFloat itemViewWidth;
        if (i == 0) {
            itemViewWidth = (kScreenWidth-60)*0.6;
        } else if (i == 1) {
            itemViewWidth = (kScreenWidth-60)*1;
        } else {
            itemViewWidth = (kScreenWidth-60)*0.4;
        }
        CGRect rect = CGRectMake(0, 0, itemViewWidth, 36);
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0.5);
        layer.endPoint = CGPointMake(1, 0.5);
        if (i == 0) {
            layer.colors = [NSArray arrayWithObjects:(id)COLOR(@"#FF9C00").CGColor,(id)COLOR(@"#FFEFB9").CGColor, nil];
        } else if (i == 1) {
            layer.colors = [NSArray arrayWithObjects:(id)COLOR(@"#DE0A0A").CGColor,(id)COLOR(@"#FF8181").CGColor, nil];
        } else {
            layer.colors = [NSArray arrayWithObjects:(id)COLOR(@"#05C312").CGColor,(id)COLOR(@"#99FFBD").CGColor, nil];
        }
        layer.frame = rect;
        [itemView.layer insertSublayer:layer atIndex:0];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(18, 18)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = rect;
        maskLayer.path = maskPath.CGPath;
        itemView.layer.mask = maskLayer;
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = HomeColor_TitleColor;
        valueLabel.font = HomeFont_SubTitleFont;
        valueLabel.text = @"";
        valueLabel.tag = 2000+i;
        [itemView addSubview:valueLabel];
        
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.centerY.equalTo(itemView);
        }];
        
        lastView = itemView;
    }
}

- (UIView *)dataView {
    if (!_dataView) {
        _dataView = [[UIView alloc] init];
        _dataView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_dataView];
    }
    return _dataView;
}

- (UIView *)paceView {
    if (!_paceView) {
        _paceView = [[UIView alloc] init];
        _paceView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_paceView];
    }
    return _paceView;
}

- (UIView *)stepView {
    if (!_stepView) {
        _stepView = [[UIView alloc] init];
        _stepView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_stepView];
    }
    return _stepView;
}

- (UIView *)heartRateView {
    if (!_heartRateView) {
        _heartRateView = [[UIView alloc] init];
        _heartRateView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_heartRateView];
    }
    return _heartRateView;
}

- (UILabel *)paceLabel {
    if (!_paceLabel) {
        _paceLabel = [[UILabel alloc]init];
        _paceLabel.textColor = self.textColor;
        _paceLabel.font = HomeFont_ButtonFont;
        _paceLabel.text = Lang(@"str_pace");
        [self addSubview:_paceLabel];
    }
    return _paceLabel;
}

- (UILabel *)stepLabel {
    if (!_stepLabel) {
        _stepLabel = [[UILabel alloc]init];
        _stepLabel.textColor = self.textColor;
        _stepLabel.font = HomeFont_ButtonFont;
        _stepLabel.text =Lang(@"str_step_pace");
        [self addSubview:_stepLabel];
    }
    return _stepLabel;
}

- (UILabel *)heartRateLabel {
    if (!_heartRateLabel) {
        _heartRateLabel = [[UILabel alloc]init];
        _heartRateLabel.textColor = self.textColor;
        _heartRateLabel.font = HomeFont_ButtonFont;
        _heartRateLabel.text =Lang(@"str_hr_title");
        [self addSubview:_heartRateLabel];
    }
    return _heartRateLabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = COLORANDALPHA(@"#131824", 0.3);
        [self addSubview:_lineView1];
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = COLORANDALPHA(@"#131824", 0.3);
        [self addSubview:_lineView2];
    }
    return _lineView2;
}

- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = COLORANDALPHA(@"#131824", 0.3);
        [self addSubview:_lineView3];
    }
    return _lineView3;
}

- (LineChartView *)heartRateChartView {
    if (!_heartRateChartView) {
        _heartRateChartView = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 180)];
        _heartRateChartView.mainColor = [HealthDataManager mainColor:HealthDataTypeHeartRate];
        _heartRateChartView.lineColor = COLORANDALPHA(@"#131824", 0.3);
        _heartRateChartView.labelColor  = [UIColor blackColor];
        _heartRateChartView.gradientColor = COLORANDALPHA(@"#FFFFFF", 0.1);
        _heartRateChartView.isCanClick = NO;
        _heartRateChartView.backgroundColor = [UIColor whiteColor];
    }
    return _heartRateChartView;
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 180)];
        _noDataLabel.textColor = HomeColor_TitleColor;
        _noDataLabel.font = HomeFont_SubTitleFont;
        _noDataLabel.text = Lang(@"str_no_data");
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataLabel;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_total_time"),
                    Lang(@"str_step"),
                    Lang(@"str_distance"),
                    Lang(@"str_cost_cal")];
    }
    return _titles;
}

- (NSArray *)values {
    if (!_values) {
        _values = @[@"",
                    @"",
                    @"",
                    @""];
    }
    return _values;
}

- (NSArray *)paceTitles {
    if (!_paceTitles) {
        _paceTitles = @[Lang(@"str_avg_pace"),
                        Lang(@"str_max_pace"),
                        Lang(@"str_min_pace")];
    }
    return _paceTitles;
}

- (NSArray *)stepTitles {
    if (!_stepTitles) {
        _stepTitles = @[Lang(@"str_avg_step_pace"),
                        Lang(@"str_max_step_pace"),
                        Lang(@"str_min_step_pace")];
    }
    return _stepTitles;
}

- (NSArray *)colors {
    if (!_colors) {
        _colors = @[COLOR(@"#FF9C00"),
                    COLOR(@"#DE0A0A"),
                    COLOR(@"#FF8181")];
    }
    return _colors;
}

@end
