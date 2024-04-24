//
//  SleepChartView.m
//  DHSFit
//
//  Created by DHS on 2022/6/13.
//

#import "SleepChartView.h"

#define top_padding 80.0
#define bottom_padding 30.0
#define left_padding 20.0
#define right_padding 20.0

#define  VIEW_WIDTH  self.frame.size.width 
#define  VIEW_HEIGHT self.frame.size.height

#define  TABLE_WIDTH  (VIEW_WIDTH-40) 
#define  TABLE_HEIGHT (VIEW_HEIGHT-110)

@interface SleepChartView ()

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIFont *labelFont;

@property (nonatomic, strong) UIView *xLine;
@property (nonatomic, strong) UIView *yLine;

@property (nonatomic, strong) NSMutableArray *xAxisLines;
@property (nonatomic, strong) NSMutableArray *yAxisLines;
@property (nonatomic, strong) NSMutableArray *xLabels;
@property (nonatomic, strong) NSMutableArray *yLabels;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *columns;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *xTitles;
@property (nonatomic, strong) NSArray *yTitles;
@property (nonatomic, strong) NSArray *yPaths;

@end

@implementation SleepChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HomeColor_BlockColor;
        self.dataArray = [NSArray array];
        
        self.lineColor = HomeColor_LineColor;
        self.labelColor = HomeColor_TitleColor;
        self.labelFont = HomeFont_Regular_8;
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.yLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(top_padding-10);
        make.bottom.offset(-bottom_padding);
        make.left.offset(left_padding);
        make.width.offset(1);
    }];
    
    [self.xLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yLine.mas_right);
        make.right.offset(-right_padding);
        make.bottom.offset(-bottom_padding);
        make.height.offset(1);
    }];
    
    NSArray *titles = @[Lang(@"str_deep_sleep"),Lang(@"str_light_sleep"),Lang(@"str_wake_up")];
    UIView *lastView;
    for (int i = 0; i < titles.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_BlockColor;
        [self addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(10);
                make.left.right.offset(0);
                make.height.offset(20);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.left.right.offset(0);
                make.height.offset(20);
            }];
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = HomeColor_TitleColor;
        titleLabel.font = HomeFont_SubTitleFont;
        titleLabel.text = titles[i];
        [itemView addSubview:titleLabel];
        
        UIView *circle = [[UIView alloc] init];
        if (i == 0) {
            circle.backgroundColor = [HealthDataManager sleepMainColor:2];
        } else if (i == 2) {
            circle.backgroundColor = [HealthDataManager sleepMainColor:0];
        } else {
            circle.backgroundColor = [HealthDataManager sleepMainColor:1];
        }
        
        circle.layer.cornerRadius = 5.0;
        circle.layer.masksToBounds = YES;
        [itemView addSubview:circle];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.top.bottom.offset(0);
            //make.width.offset(60);
        }];
        
        [circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(titleLabel.mas_left).offset(-10);
            make.width.height.offset(10);
            make.centerY.equalTo(itemView);
        }];
        
        lastView = itemView;
    }
}

- (void)setChartModel:(ChartViewModel *)chartModel {
    _chartModel = chartModel;
    self.xTitles = chartModel.xTitles;
    self.yTitles = chartModel.yTitles;
    self.yPaths = chartModel.yPaths;
    self.dataArray = chartModel.dataArray;
    
    [self drawColumnLayer];
}

- (void)setXTitles:(NSArray *)xTitles {
    _xTitles = xTitles;
    [self removeXLabels];
    if (xTitles.count == 2) {
        CGFloat labelW = 60;
        CGFloat labelH = 20;
        for (int i = 0; i < xTitles.count; i++) {
            if (i == 0) {
                UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(left_padding, VIEW_HEIGHT-bottom_padding+5, labelW, labelH)];
                xLabel.text = xTitles[i];
                xLabel.textColor = self.labelColor;
                xLabel.font = self.labelFont;
                xLabel.textAlignment = NSTextAlignmentLeft;
                [self addSubview:xLabel];
                [self.xLabels addObject:xLabel];
            } else {
                UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_WIDTH-right_padding-labelW, VIEW_HEIGHT-bottom_padding+5, labelW, labelH)];
                xLabel.textColor = self.labelColor;
                xLabel.font = self.labelFont;
                xLabel.text = xTitles[i];
                xLabel.textAlignment = NSTextAlignmentRight;
                [self addSubview:xLabel];
                [self.xLabels addObject:xLabel];
            }
            
        }
    }
}

- (void)setYTitles:(NSArray *)yTitles {
    _yTitles = yTitles;
    
    if (self.yLabels.count) {
        for (int i = 0; i < self.yLabels.count; i++) {
            UILabel *yLabel = self.yLabels[i];
            yLabel.text = yTitles[i];
        }
        return;
    }
    
    CGFloat yLineSpace = TABLE_HEIGHT/yTitles.count;
    CGFloat labelW = left_padding-5;
    CGFloat labelH = 20;
    
    for (int i = 0; i < yTitles.count; i++) {
        UIView *yLine = [[UIView alloc] initWithFrame:CGRectMake(left_padding, VIEW_HEIGHT-bottom_padding-(i+1)*yLineSpace, TABLE_WIDTH, 1)];
        yLine.backgroundColor = self.lineColor;
        [self addSubview:yLine];
        
        UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-bottom_padding-(i+1)*yLineSpace-labelH/2, labelW, labelH)];
        yLabel.text = yTitles[i];
        yLabel.textColor = self.labelColor;
        yLabel.font = self.labelFont;
        yLabel.textAlignment = NSTextAlignmentRight;
        yLabel.hidden = YES;
        [self addSubview:yLabel];
        
        [self.yLabels addObject:yLabel];
        [self.yAxisLines addObject:yLine];
    }
}

- (void)removeXLabels {
    for (UILabel *label in self.xLabels) {
        [label removeFromSuperview];
    }
    [self.xLabels removeAllObjects];
}

- (void)drawColumnLayer {
    [self removeSubViews];
    
    NSInteger allTime = 0;
    for (NSDictionary *item in self.dataArray) {
        allTime += [item[@"value"] integerValue];
    }
    
    CGFloat columnH = TABLE_HEIGHT/3-1;
    CGFloat columnW = 0;
    CGFloat columnOriginX = left_padding;
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *item = self.dataArray[i];
        NSInteger duration = [item[@"value"] integerValue];
        NSInteger status = [item[@"status"] integerValue];
        columnW = TABLE_WIDTH*duration/allTime;
        
        UIView *column = [[UIView alloc] initWithFrame:CGRectMake(columnOriginX, top_padding+[self.yPaths[i] floatValue]*TABLE_HEIGHT+1, columnW, columnH)];
        column.backgroundColor = [HealthDataManager sleepMainColor:status];
        [self addSubview:column];
        
        columnOriginX += columnW;
        [self.columns addObject:column];
    }
}

- (void)removeSubViews {
    for (UIView *column in self.columns) {
        [column removeFromSuperview];
    }
    [self.columns removeAllObjects];
}

- (NSMutableArray *)columns {
    if (!_columns) {
        _columns = [NSMutableArray array];
    }
    return _columns;
}

- (UIView *)xLine {
    if (!_xLine) {
        _xLine = [[UIView alloc] init];
        _xLine.backgroundColor = self.lineColor;
        [self addSubview:_xLine];
    }
    return _xLine;
}

- (UIView *)yLine {
    if (!_yLine) {
        _yLine = [[UIView alloc] init];
        _yLine.backgroundColor = self.lineColor;
        _yLine.hidden = YES;
        [self addSubview:_yLine];
    }
    return _yLine;
}

- (NSMutableArray *)xLabels {
    if (!_xLabels) {
        _xLabels = [NSMutableArray array];
    }
    return _xLabels;
}

- (NSMutableArray *)yLabels {
    if (!_yLabels) {
        _yLabels = [NSMutableArray array];
    }
    return _yLabels;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)xAxisLines {
    if (!_xAxisLines) {
        _xAxisLines = [NSMutableArray array];
    }
    return _xAxisLines;
}

- (NSMutableArray *)yAxisLines {
    if (!_yAxisLines) {
        _yAxisLines = [NSMutableArray array];
    }
    return _yAxisLines;
}

@end
