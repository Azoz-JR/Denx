//
//  HistoryDataView.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "HistoryDataJLView.h"
#import "LineChartView.h"

@interface HistoryDataJLView ()

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

@property (nonatomic, strong) NSArray *heartTitles;

@property (nonatomic, strong) NSArray *heartValues;

@property (nonatomic, strong) NSArray *colors;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation HistoryDataJLView

- (instancetype)initWithFrame:(CGRect)frame model:(DailySportModel *)sportModel {
    self = [super initWithFrame:frame];
    if (self) {
        _model = sportModel;
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(DailySportModel *)model {
    BOOL isShowHeartRate = YES;
    
    
    for (int i =0 ; i < self.titles.count; i++) {
        UILabel *valueLabel = [self.dataView viewWithTag:1000+i];
        if (i == 0) {
            valueLabel.text = [RunningManager transformDuration:model.duration];
        } else if (i == 1) {
            valueLabel.text = [NSString stringWithFormat:@"%ld",(long)model.step];
            
            if (self.model.viewType == 3 || self.model.viewType == 4){ //无步数
                valueLabel.text = @"--";
            }
            
//            UILabel *titleLabel = [self.dataView viewWithTag:10000+i];
//            titleLabel.hidden = !isShowSteps;
//            valueLabel.hidden = !isShowSteps;
        } else if (i == 2) {
            valueLabel.text = [NSString stringWithFormat:@"%.02f%@",DistanceValue(model.distance),DistanceUnit];
            
            if (self.model.viewType == 4){ //无距离
                valueLabel.text = @"--";
            }
        } else {
            valueLabel.text = [NSString stringWithFormat:@"%d%@", (int)model.calorie/1000, CalorieUnit];
        }
    }
    
//    NSMutableArray *paceArray = [NSMutableArray array];
//    if (!ImperialUnit && model.metricPaceItems.length) {
//        NSArray *metricPaceItems = [model.metricPaceItems transToObject];
//        for (NSDictionary *dict in metricPaceItems) {
//            [paceArray addObject:dict[@"value"]];
//        }
//    } else if (ImperialUnit && model.imperialPaceItems.length) {
//        NSArray *imperialPaceItems = [model.imperialPaceItems transToObject];
//        for (NSDictionary *dict in imperialPaceItems) {
//            [paceArray addObject:dict[@"value"]];
//        }
//    }
//    
    
    if (self.model.viewType == 1 || self.model.viewType == 2 || self.model.viewType == 3){
        NSInteger avgPace = self.model.pace;
        if (ImperialUnit){
            avgPace = 1.609*avgPace;
        }
        //    if (ImperialUnit) {
        //        avgPace = model.distance > 0 ? 1609.0*model.duration/model.distance : 0;
        //    } else {
        //        avgPace = model.distance > 0 ? 1000.0*model.duration/model.distance : 0;
        //    }
        NSInteger maxPace = self.model.sportMaxPace;//paceArray.count > 0 ? [[paceArray valueForKeyPath:@"@max.floatValue"] floatValue] : avgPace;
        NSInteger minPace = self.model.sportMinPace; //paceArray.count > 0 ? [[paceArray valueForKeyPath:@"@min.floatValue"] floatValue] : avgPace;
        
        if (ImperialUnit){
            maxPace = 1.609*maxPace;
            minPace = 1.609*minPace;
        }
        
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
    }

    UIView *bottomView = self.paceView;
    if (self.model.viewType == 1) {
//        NSMutableArray *stepArray = [NSMutableArray array];
//        if (model.strideFrequencyItems.length) {
//            NSArray *strideFrequencyItems = [model.strideFrequencyItems transToObject];
//            for (NSDictionary *dict in strideFrequencyItems) {
//                [stepArray addObject:dict[@"value"]];
//            }
//        }
        NSInteger avgStep = self.model.sportStepFreq;//60.0*model.step/model.duration;
        //NSInteger avgStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@avg.floatValue"] floatValue] : baseAvgStep;
        NSInteger maxStep = self.model.maxStepFreq;//stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@max.floatValue"] floatValue] : avgStep;
        NSInteger minStep = self.model.minStepFreq;//stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@min.floatValue"] floatValue] : avgStep;
        
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
//        NSMutableArray *stepArray = [NSMutableArray array];
//        if (model.strideFrequencyItems.length) {
//            NSArray *strideFrequencyItems = [model.strideFrequencyItems transToObject];
//            for (NSDictionary *dict in strideFrequencyItems) {
//                [stepArray addObject:dict[@"value"]];
//            }
//        }
        NSInteger avgHeart = self.model.heartAve;//60.0*model.step/model.duration;
        //NSInteger avgStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@avg.floatValue"] floatValue] : baseAvgStep;
        NSInteger maxHeart = self.model.heartMax;//stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@max.floatValue"] floatValue] : avgStep;
        NSInteger minHeart = self.model.heartMin;//stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@min.floatValue"] floatValue] : avgStep;
        
        for (int i =0 ; i < self.heartTitles.count; i++) {
            UILabel *valueLabel = [self.heartRateView viewWithTag:4000+i];
            if (i == 0) {
                valueLabel.text = [NSString stringWithFormat:@"%ld%@",(long)avgHeart,HrUnit];
            } else if (i == 1) {
                valueLabel.text = [NSString stringWithFormat:@"%ld%@",(long)maxHeart,HrUnit];
            } else if (i == 2) {
                valueLabel.text = [NSString stringWithFormat:@"%ld%@",(long)minHeart,HrUnit];
            }
        }
            
    } else {
        [self.heartRateView addSubview:self.noDataLabel];
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
    
    [self.heartRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
    }];
    
    [self.heartRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heartRateLabel.mas_bottom);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(66*3);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(1);
        make.top.equalTo(self.heartRateView.mas_bottom).offset(15);
    }];
    
    [self.paceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.lineView2.mas_bottom).offset(15);
    }];
    
    [self.paceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paceLabel.mas_bottom);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(66*3);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(1);
        make.top.equalTo(self.paceView.mas_bottom).offset(15);
    }];

    
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
    }];
    
    [self.stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stepLabel.mas_bottom);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(66*3);
    }];
    
    
    //里程与卡路里信息
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
    
    //配速
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
    
    

    //步频
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
    
    
    //心率
    for (int i = 0; i < self.heartTitles.count; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = self.textColor;
        titleLabel.font = HomeFont_SubTitleFont;
        titleLabel.text = self.heartTitles[i];
        [self.heartRateView addSubview:titleLabel];
        
        UIView *itemView = [[UIView alloc] init];
        [self.heartRateView addSubview:itemView];
        
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
        valueLabel.tag = 4000+i;
        [itemView addSubview:valueLabel];
        
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.centerY.equalTo(itemView);
        }];
        
        lastView = itemView;
    }
    
    if (self.model.viewType == 2 || self.model.viewType == 3){ //无步频
        self.lineView3.hidden = YES;
        
        self.stepLabel.hidden = YES;
        
        self.stepView.hidden = YES;
    }
    else if (self.model.viewType == 4){
        self.lineView2.hidden = YES;
        self.lineView3.hidden = YES;
        
        self.paceLabel.hidden = YES;
        self.stepLabel.hidden = YES;
        
        self.paceView.hidden = YES;
        self.stepView.hidden = YES;
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

- (NSArray *)heartTitles {
    if (!_heartTitles) {
        _heartTitles = @[Lang(@"str_avg_hr"),
                        Lang(@"str_max_hr"),
                        Lang(@"str_min_hr")];
    }
    return _heartTitles;
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
