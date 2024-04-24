//
//  HomeDoubleLineChartView.m
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import "HomeDoubleLineChartView.h"
#import "UIBezierPath+curved.h"

#define top_padding 0
#define bottom_padding 0
#define left_padding 0
#define right_padding 0

#define  VIEW_WIDTH  self.frame.size.width 
#define  VIEW_HEIGHT self.frame.size.height

#define  TABLE_WIDTH  VIEW_WIDTH 
#define  TABLE_HEIGHT VIEW_HEIGHT 

@interface HomeDoubleLineChartView()

@property (nonatomic, strong) NSMutableArray *pointsA;
@property (nonatomic, strong) NSMutableArray *pointsB;
@property (nonatomic, strong) CAShapeLayer *lineLayerA;
@property (nonatomic, strong) CAShapeLayer *lineLayerB;
@property (nonatomic, strong) CAGradientLayer *gradientLayerA;
@property (nonatomic, strong) CAGradientLayer *gradientLayerB;
@property (nonatomic, strong) UIBezierPath *pathA;
@property (nonatomic, strong) UIBezierPath *pathB;
@property (nonatomic, assign) BOOL isSmoothed;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *xPaths;
@property (nonatomic, strong) NSArray *yPaths;
@property (nonatomic, strong) NSArray *yPaths1;

@end

@implementation HomeDoubleLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HomeColor_BlockColor;
        self.mainColorA = COLOR(@"#FF53FD");
        self.mainColorB = COLOR(@"#17FFF1");
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
    self.yPaths1 = chartModel.yPaths1;
    self.dataArray = chartModel.dataArray;
        
    [self updatePoints];
    
    [self drawLineLayerAWith:self.pathA];
    
    [self drawLineLayerBWith:self.pathB];
    
}

- (void)updatePoints {
    [self.pointsA removeAllObjects];
    [self.pointsB removeAllObjects];
    
    self.pathA = [UIBezierPath bezierPath];
    self.pathB = [UIBezierPath bezierPath];
    
    for (int i= 0; i< self.xPaths.count; i++) {
        CGFloat X = [self.xPaths[i] floatValue] * TABLE_WIDTH + left_padding;
        CGFloat YA = TABLE_HEIGHT - [self.yPaths[i] floatValue] * TABLE_HEIGHT +top_padding;
        CGFloat YB = TABLE_HEIGHT - [self.yPaths1[i] floatValue] * TABLE_HEIGHT +top_padding;
        CGPoint pointA = CGPointMake(X, YA);
        CGPoint pointB = CGPointMake(X, YB);
        if (i == 0) {
            [self.pathA moveToPoint:pointA];
            [self.pathB moveToPoint:pointB];
        } else{
            [self.pathA addLineToPoint:pointA];
            [self.pathB addLineToPoint:pointB];
        }
        
        [self.pointsA addObject:[NSValue valueWithCGPoint:pointA]];
        [self.pointsB addObject:[NSValue valueWithCGPoint:pointB]];
    }
}

- (void)drawLineLayerAWith:(UIBezierPath *)path{
    if (self.lineLayerA) {
        [self.lineLayerA removeFromSuperlayer];
    }
    if (self.isSmoothed) {
        path = [path smoothedPathWithGranularity:10];
    }
    self.lineLayerA = [CAShapeLayer layer];
    self.lineLayerA.fillColor = [UIColor clearColor].CGColor;
    self.lineLayerA.lineWidth =  1.0f;
    self.lineLayerA.strokeEnd = 1;
    self.lineLayerA.lineCap = kCALineCapRound;
    self.lineLayerA.lineJoin = kCALineJoinRound;
    self.lineLayerA.strokeColor = self.mainColorA.CGColor;
    self.lineLayerA.path = path.CGPath;
    [self.layer addSublayer:self.lineLayerA];
}

- (void)drawLineLayerBWith:(UIBezierPath *)path{
    if (self.lineLayerB) {
        [self.lineLayerB removeFromSuperlayer];
    }
    if (self.isSmoothed) {
        path = [path smoothedPathWithGranularity:10];
    }
    self.lineLayerB = [CAShapeLayer layer];
    self.lineLayerB.fillColor = [UIColor clearColor].CGColor;
    self.lineLayerB.lineWidth =  1.0f;
    self.lineLayerB.strokeEnd = 1;
    self.lineLayerB.lineCap = kCALineCapRound;
    self.lineLayerB.lineJoin = kCALineJoinRound;
    self.lineLayerB.strokeColor = self.mainColorB.CGColor;
    self.lineLayerB.path = path.CGPath;
    [self.layer addSublayer:self.lineLayerB];
}

- (void)drawGradientA:(NSArray *)pArray {
    if (self.gradientLayerA) {
        [self.gradientLayerA removeFromSuperlayer];
    }
    self.gradientLayerA = [CAGradientLayer layer];
    self.gradientLayerA.frame = self.layer.bounds;
    self.gradientLayerA.colors =@[(__bridge id)self.mainColorA.CGColor,
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
    self.gradientLayerA.mask = arc;
    [self.lineLayerA addSublayer:self.gradientLayerA];
}

- (void)drawGradientB:(NSArray *)pArray {
    if (self.gradientLayerB) {
        [self.gradientLayerB removeFromSuperlayer];
    }
    self.gradientLayerB = [CAGradientLayer layer];
    self.gradientLayerB.frame = self.layer.bounds;
    self.gradientLayerB.colors =@[(__bridge id)self.mainColorB.CGColor,
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
    self.gradientLayerB.mask = arc;
    [self.lineLayerB addSublayer:self.gradientLayerB];
}


- (NSMutableArray *)pointsA {
    if (!_pointsA) {
        _pointsA = [NSMutableArray array];
    }
    return _pointsA;
}

- (NSMutableArray *)pointsB {
    if (!_pointsB) {
        _pointsB = [NSMutableArray array];
    }
    return _pointsB;
}

@end
