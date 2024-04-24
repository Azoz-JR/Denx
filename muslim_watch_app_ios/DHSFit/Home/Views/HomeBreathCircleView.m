//
//  HomeBreathCircleView.m
//  DHSFit
//
//  Created by DHS on 2022/8/12.
//

#import "HomeBreathCircleView.h"

@interface HomeBreathCircleView ()
/// 背景
@property(nonatomic, strong) CAShapeLayer *baseLayer;
/// 当前
@property(nonatomic, strong) CAShapeLayer *currentLayer;
/// 圆角
@property (nonatomic, assign) CGFloat radius;
/// 开始角度
@property (nonatomic, assign) CGFloat startAngle;
/// 结束角度
@property (nonatomic, assign) CGFloat endAngle;
/// 当前角度
@property (nonatomic, assign) CGFloat currentAngle;
/// 圆点
@property (nonatomic, strong) UIImageView *pointView;

@end

@implementation HomeBreathCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = HomeColor_BlockColor;
        self.radius = kScreenWidth/6.0;
        self.startAngle = 0.5*M_PI;
        self.endAngle = self.startAngle+2*M_PI;
        
        [self.layer addSublayer:self.baseLayer];
        [self.layer addSublayer:self.currentLayer];
        [self addSubview:self.pointView];
        [self addSubview:self.breathLabel];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.startAngle+2*M_PI clockwise:YES];
        self.baseLayer.path = [path CGPath];
       
        self.pointView.center = CGPointMake(kScreenWidth/6.0, kScreenWidth/3.0);
        self.breathLabel.center = CGPointMake(kScreenWidth/6.0, kScreenWidth/6.0);
    }
    return self;
}


- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.endAngle = self.startAngle+2*M_PI*progress;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    self.currentLayer.path = [path CGPath];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 0.01;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.path = path.CGPath;
    [self.pointView.layer addAnimation:animation forKey:nil];
    
}

- (CAShapeLayer *)currentLayer {
    if (!_currentLayer) {
        _currentLayer = [[CAShapeLayer alloc] init];
        _currentLayer.lineWidth = 10;
        _currentLayer.strokeColor = [HealthDataManager mainColor:HealthDataTypeBreath].CGColor;
        _currentLayer.fillColor = [UIColor clearColor].CGColor;
        _currentLayer.lineCap = kCALineCapRound;
    }
    return _currentLayer;
}

- (CAShapeLayer *)baseLayer {
    if (!_baseLayer) {
        _baseLayer = [[CAShapeLayer alloc] init];
        _baseLayer.lineWidth = 10;
        _baseLayer.strokeColor = HomeColor_BackgroundColor.CGColor;
        _baseLayer.fillColor = [UIColor clearColor].CGColor;
        _baseLayer.lineCap = kCALineCapRound;
    }
    return _baseLayer;
}

- (UIImageView *)pointView {
    if (!_pointView) {
        _pointView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17.0, 17.0)];
        _pointView.contentMode = UIViewContentModeCenter;
        _pointView.image = DHImage(@"home_main_circle");
    }
    return _pointView;
}

- (UILabel *)breathLabel {
    if (!_breathLabel) {
        _breathLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/3.0-20, 30.0)];
        _breathLabel.font = HomeFont_Bold_30;
        _breathLabel.textColor = HomeColor_TitleColor;
        _breathLabel.textAlignment = NSTextAlignmentCenter;
        _breathLabel.text = @"0";
    }
    return _breathLabel;
}

@end
