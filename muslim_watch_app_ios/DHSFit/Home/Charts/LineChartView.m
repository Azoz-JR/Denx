//
//  LineChartView.m
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import "LineChartView.h"
#import "UIBezierPath+curved.h"

#define top_padding 40.0
#define bottom_padding 30.0
#define left_padding 30.0
#define right_padding 20.0

#define  VIEW_WIDTH  self.frame.size.width
#define  VIEW_HEIGHT self.frame.size.height

#define  TABLE_WIDTH  (VIEW_WIDTH-50)
#define  TABLE_HEIGHT (VIEW_HEIGHT-70)

@interface LineChartView()

@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) BOOL isSmoothed;


@property (nonatomic, strong) UIFont *labelFont;

@property (nonatomic, strong) UIView *xLine;
@property (nonatomic, strong) UIView *yLine;

@property (nonatomic, strong) NSMutableArray *xAxisLines;
@property (nonatomic, strong) NSMutableArray *yAxisLines;
@property (nonatomic, strong) NSMutableArray *xLabels;
@property (nonatomic, strong) NSMutableArray *yLabels;
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *xTitles;
@property (nonatomic, strong) NSArray *yTitles;
@property (nonatomic, strong) NSArray *xPaths;
@property (nonatomic, strong) NSArray *yPaths;

@property (nonatomic, strong) UIView *touchXLine;
@property (nonatomic, strong) UIView *touchYLine;
@property (nonatomic, strong) UILabel *touchLabel;
@property (nonatomic, strong) NSMutableArray <UIButton *>*buttonArray;

@end

@implementation LineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HomeColor_BlockColor;
        self.isSmoothed = NO;
        self.isCanClick = YES;
        self.unitStr = @"";
        
        self.mainColor = COLOR(@"#DD2A44");
        self.lineColor = HomeColor_LineColor;
        self.labelColor = HomeColor_TitleColor;
        self.labelFont = HomeFont_Regular_8;
        self.gradientColor = [UIColor clearColor];
        
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
}

- (void)setChartModel:(ChartViewModel *)chartModel {
    _chartModel = chartModel;
    self.xPaths = chartModel.xPaths;
    self.yPaths = chartModel.yPaths;
    self.xTitles = chartModel.xTitles;
    self.yTitles = chartModel.yTitles;
    self.dataArray = chartModel.dataArray;
        
    [self updatePoints];
    
    [self drawLineLayerWith:self.path];
    
    [self drawGradient:self.points];
    
    if (self.isCanClick) {
        [self addTouchSubViews];
        self.touchXLine.hidden = YES;
        self.touchYLine.hidden = YES;
        self.touchLabel.hidden = YES;
        
        UIPanGestureRecognizer *panSelfView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSelfView:)];
        [self addGestureRecognizer:panSelfView];
    }
}

- (void)setXTitles:(NSArray *)xTitles {
    _xTitles = xTitles;
    [self removeXLabels];
    
    CGFloat labelW = 60;
    CGFloat labelH = 20;
    CGFloat spaceX = TABLE_WIDTH/xTitles.count;
    NSInteger inteval = xTitles.count == 24 ? 6 : 5;
    if (xTitles.count >= 24) {
        for (int i = 0; i < xTitles.count; i++) {
            if (i == 0) {
                UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(left_padding-labelW/2, VIEW_HEIGHT-bottom_padding+5, labelW, labelH)];
                xLabel.text = xTitles[i];
                xLabel.textColor = self.labelColor;
                xLabel.font = self.labelFont;
                xLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:xLabel];
                [self.xLabels addObject:xLabel];
            } else if (i == xTitles.count-1) {
                UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_WIDTH-right_padding-labelW/2, VIEW_HEIGHT-bottom_padding+5, labelW, labelH)];
                xLabel.textColor = self.labelColor;
                xLabel.font = self.labelFont;
                xLabel.text = xTitles[i];
                xLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:xLabel];
                [self.xLabels addObject:xLabel];
            } else if (i%inteval == 0) {
                UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-bottom_padding+5, labelW, labelH)];
                xLabel.text = xTitles[i];
                xLabel.textColor = self.labelColor;
                xLabel.font = self.labelFont;
                xLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:xLabel];
                xLabel.center = CGPointMake(left_padding+spaceX*i, VIEW_HEIGHT-bottom_padding+5+labelH/2);
                [self.xLabels addObject:xLabel];
            }
        }
    } else {
        labelW = TABLE_WIDTH/(xTitles.count-1);
        labelH = 20;
        for (int i = 0; i < xTitles.count; i++) {
            UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(left_padding+i*labelW-labelW/2, VIEW_HEIGHT-bottom_padding+5, labelW, labelH)];
            xLabel.text = xTitles[i];
            xLabel.textColor = self.labelColor;
            xLabel.font = self.labelFont;
            xLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:xLabel];
            [self.xLabels addObject:xLabel];
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

- (void)updatePoints {
    
    [self.points removeAllObjects];
    [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.buttonArray = [NSMutableArray array];
    
    self.path = [UIBezierPath bezierPath];
    for (int i= 0; i< self.xPaths.count; i++) {
        CGFloat X = [self.xPaths[i] floatValue] * TABLE_WIDTH + left_padding;
        CGFloat Y = TABLE_HEIGHT - [self.yPaths[i] floatValue] * TABLE_HEIGHT +top_padding;
        CGPoint point = CGPointMake(X, Y);
        if (i == 0) {
            [self.path moveToPoint:point];//起点
        } else{
            [self.path addLineToPoint:point];
        }
        if (self.isCanClick) {
            [self addTouchButtonWith:i point:point];
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
    self.lineLayer.strokeColor = self.mainColor.CGColor;
    self.lineLayer.path = path.CGPath;
    [self.layer insertSublayer:self.lineLayer atIndex:0];
}

- (void)drawGradient:(NSArray *)pArray {
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
    }
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.layer.bounds;
    self.gradientLayer.colors =@[(__bridge id)self.mainColor.CGColor,
                            (__bridge id)self.gradientColor.CGColor];
    
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
                [gradientPath addLineToPoint:CGPointMake(endPoint.x+0, endPoint.y)];
                [gradientPath addLineToPoint:CGPointMake(endPoint.x+0, TABLE_HEIGHT+top_padding)];
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

- (void)addTouchSubViews{
    if (!self.touchXLine.superview) {
        self.touchXLine = [[UIView alloc] init];
        self.touchXLine.frame = CGRectMake(left_padding,TABLE_HEIGHT + top_padding, TABLE_WIDTH, 1);
        self.touchXLine.backgroundColor = [UIColor clearColor];
        [self addSubview:self.touchXLine];
        
        self.touchYLine = [[UIView alloc] init];
        self.touchYLine.frame = CGRectMake(left_padding,top_padding, 1, TABLE_HEIGHT);
        self.touchYLine.backgroundColor = self.lineColor;
        [self addSubview:self.touchYLine];
        
        self.touchLabel = [[UILabel alloc] init];
        self.touchLabel.backgroundColor = HomeColor_BackgroundColor;
        self.touchLabel.textColor = self.labelColor;
        self.touchLabel.font = self.labelFont;
        [self addSubview:self.touchLabel];
        [self.touchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(18);
            make.center.equalTo(self);
        }];
    }
}

- (void)addTouchButtonWith:(NSInteger)i point:(CGPoint)p{
        UIButton *v = [[UIButton alloc]initWithFrame:CGRectMake(p.x, p.y, 2, 2)];
        v.frame = CGRectMake(p.x-1, top_padding, 2, TABLE_HEIGHT);
        v.tag = 10000 + i;
        [v addTarget:self action:@selector(pointClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:v];
        [self.buttonArray addObject:v];
}

- (void)pointClick:(UIButton *)btn{
    
    NSValue *point = self.points[btn.tag - 10000];
    CGPoint po = [point CGPointValue];
    
    CGRect x = self.touchXLine.frame;
    x.origin.y = po.y;
    self.touchXLine.frame = x;
    
    CGRect y = self.touchYLine.frame;
    y.origin.x = po.x;
    self.touchYLine.frame = y;
    
    NSDictionary *dict = self.dataArray[btn.tag - 10000];
    if ([self.unitStr isEqualToString:TempUnit]) {
        if ([dict[@"value"] integerValue] > 0) {
            self.touchLabel.text = [NSString stringWithFormat:@" %.01f%@ ",TempValue([dict[@"value"] integerValue]),self.unitStr];
        } else {
            self.touchLabel.text = [NSString stringWithFormat:@" 0.0%@ ",self.unitStr];
        }
        
    } else {
        self.touchLabel.text = [NSString stringWithFormat:@" %@%@ ",dict[@"value"],self.unitStr];
    }
    
    [self.touchLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(po.x-self.width/2);
        make.centerY.equalTo(self).offset(po.y-9-self.height/2);
    }];
    
    [self bringSubviewToFront:self.touchXLine];
    [self bringSubviewToFront:self.touchYLine];
    [self bringSubviewToFront:self.touchLabel];
    self.touchXLine.hidden = NO;
    self.touchYLine.hidden = NO;
    self.touchLabel.hidden = NO;
}

- (void)panSelfView:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    for (UIButton *subView in self.subviews) {
        if ([subView.layer.presentationLayer hitTest:touchPoint]) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [self pointClick:subView];
            }
        }
    }
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

- (NSMutableArray *)points {
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}

@end

