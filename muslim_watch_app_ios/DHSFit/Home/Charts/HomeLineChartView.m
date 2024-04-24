//
//  HomeLineChartView.m
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import "HomeLineChartView.h"
#import "UIBezierPath+curved.h"

#define top_padding 0
#define bottom_padding 0
#define left_padding 0
#define right_padding 0

#define  VIEW_WIDTH  self.frame.size.width 
#define  VIEW_HEIGHT self.frame.size.height

#define  TABLE_WIDTH  VIEW_WIDTH 
#define  TABLE_HEIGHT VIEW_HEIGHT 

@interface HomeLineChartView()

@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) BOOL isSmoothed;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *xPaths;
@property (nonatomic, strong) NSArray *yPaths;

@end

@implementation HomeLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HomeColor_BlockColor;
        self.mainColor = [HealthDataManager mainColor:HealthDataTypeHeartRate];
        self.isSmoothed = NO;
        
        self.dataArray = [NSArray array];
    }
    return self;
}

- (void)setChartModel:(ChartViewModel *)chartModel {
    if (self.dataArray.count == chartModel.dataArray.count) {
        return;
    }
    _chartModel = chartModel;
    self.xPaths = chartModel.xPaths;
    self.yPaths = chartModel.yPaths;
    self.dataArray = chartModel.dataArray;
        
    [self updatePoints];
    
    [self drawLineLayerWith:self.path];
    
    [self drawGradient:self.points];
    
    
}

- (void)updatePoints {
    
    [self.points removeAllObjects];
    
    self.path = [UIBezierPath bezierPath];
    
    for (int i= 0; i< self.xPaths.count; i++) {
        CGFloat X = [self.xPaths[i] floatValue] * TABLE_WIDTH + left_padding;
        CGFloat Y = TABLE_HEIGHT - [self.yPaths[i] floatValue] * TABLE_HEIGHT +top_padding;
        CGPoint point = CGPointMake(X, Y);
        if (i == 0) {
            [self.path moveToPoint:point];
        } else{
            [self.path addLineToPoint:point];
        }
        
        [self.points addObject:[NSValue valueWithCGPoint:point]];
    }
}

- (void)drawLineLayerWith:(UIBezierPath *)path{
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
    }
    if (self.isSmoothed) {
        path = [path smoothedPathWithGranularity:10];
    }
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.fillColor = [UIColor clearColor].CGColor;
    self.lineLayer.lineWidth =  1.0f;
    self.lineLayer.strokeEnd = 1;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.strokeColor = [UIColor clearColor].CGColor;
    self.lineLayer.path = path.CGPath;
    [self.layer addSublayer:self.lineLayer];
}

- (void)drawGradient:(NSArray *)pArray {
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
    }
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.layer.bounds;
    self.gradientLayer.colors =@[(__bridge id)self.mainColor.CGColor,
                            (__bridge id)[UIColor clearColor].CGColor];
    
    UIBezierPath *gradientPath = [[UIBezierPath alloc] init];
    
    NSInteger pCount = pArray.count;
    for (int i = 0; i < pCount; i++) {
        if (i == 0) {
            CGPoint firstPoint = [pArray[i] CGPointValue];
            [gradientPath moveToPoint:CGPointMake(firstPoint.x, TABLE_HEIGHT+top_padding)];
            [gradientPath addLineToPoint:firstPoint];
        }
        else{
            if (i == pCount - 1) {
                CGPoint endPoint = [pArray.lastObject CGPointValue];
                [gradientPath addLineToPoint:CGPointMake(endPoint.x+1, endPoint.y)];
                [gradientPath addLineToPoint:CGPointMake(endPoint.x+1, TABLE_HEIGHT+top_padding)];
            }
            else{
                [gradientPath addLineToPoint:[pArray[i] CGPointValue]];
            }
        }
    }
            
    if (self.isSmoothed) {
        gradientPath = [gradientPath smoothedPathWithGranularity:10];
    }
    
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = gradientPath.CGPath;
    self.gradientLayer.mask = arc;
    [self.lineLayer addSublayer:self.gradientLayer];
}

- (NSMutableArray *)points {
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

@end
