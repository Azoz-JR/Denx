//
//  HomeColumnChartView.m
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import "HomeColumnChartView.h"

#define top_padding 0
#define bottom_padding 0
#define left_padding 0
#define right_padding 0

#define  VIEW_WIDTH  self.frame.size.width 
#define  VIEW_HEIGHT self.frame.size.height

#define  TABLE_WIDTH  VIEW_WIDTH 
#define  TABLE_HEIGHT VIEW_HEIGHT 

@interface HomeColumnChartView ()

@property (nonatomic, strong) NSMutableArray *columns;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HomeColumnChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HomeColor_BlockColor;
        self.dataArray = [NSArray array];
    }
    return self;
}

- (void)setChartModel:(ChartViewModel *)chartModel {
    if (self.dataArray.count == chartModel.dataArray.count) {
        return;
    }
    _chartModel = chartModel;
    self.dataArray = chartModel.dataArray;
    
    [self drawColumnLayer];
}


- (void)drawColumnLayer {
    [self removeSubViews];
    
    NSInteger allTime = 0;
    for (NSDictionary *item in self.dataArray) {
        allTime += [item[@"value"] integerValue];
    }
    
    CGFloat columnH = TABLE_HEIGHT;
    CGFloat columnW = 0;
    CGFloat columnOriginX = left_padding;
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *item = self.dataArray[i];
        NSInteger duration = [item[@"value"] integerValue];
        NSInteger status = [item[@"status"] integerValue];
        columnW = VIEW_WIDTH*duration/allTime;
        
        UIView *column = [[UIView alloc] initWithFrame:CGRectMake(columnOriginX, 0, columnW, columnH)];
        column.backgroundColor = [HealthDataManager sleepMainColor:status];
//        if (status == SleepDataTypeWake) {
//            column.backgroundColor = HomeColor_BlockColor;
//        }
        [self addSubview:column];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = column.bounds;
        gradient.colors = @[(id)column.backgroundColor.CGColor,(id)HomeColor_BlockColor.CGColor];
        gradient.startPoint = CGPointMake(0.5, 0);
        gradient.endPoint = CGPointMake(0.5, 1);
        [column.layer addSublayer:gradient];
        
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

@end

