//
//  HomeCircleView.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "HomeCircleView.h"

@interface HomeCircleView ()
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
/// 步数
@property (nonatomic, strong) UIImageView *stepView;

@end

@implementation HomeCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorNamed:@"D_#FFD000"];
        self.radius = kScreenWidth/6.0;
        self.startAngle = 0.5*M_PI;
        self.endAngle = self.startAngle+2*M_PI;
        
        [self.layer addSublayer:self.baseLayer];
        [self.layer addSublayer:self.currentLayer];
        [self addSubview:self.pointView];
        [self addSubview:self.stepView];
        [self addSubview:self.stepLabel];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.startAngle+2*M_PI clockwise:YES];
        self.baseLayer.path = [path CGPath];
       
        self.pointView.center = CGPointMake(kScreenWidth/6.0, kScreenWidth/3.0);
        self.stepLabel.center = CGPointMake(kScreenWidth/6.0, kScreenWidth/3.0/2.0+kScreenWidth/3.0/4.0-10);
        self.stepView.center = CGPointMake(kScreenWidth/6.0, kScreenWidth/3.0/4.0+10);
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
        _currentLayer.strokeColor = [HealthDataManager mainColor:HealthDataTypeStep].CGColor;
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

- (UIImageView *)stepView {
    if (!_stepView) {
        _stepView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60.0, 60.0)];
        _stepView.contentMode = UIViewContentModeScaleAspectFit;
        _stepView.image = DHImage(@"home_main_step");
    }
    return _stepView;
}

- (UILabel *)stepLabel {
    if (!_stepLabel) {
        _stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/3.0-20, 30.0)];
        _stepLabel.font = HomeFont_Bold_25;
        _stepLabel.textColor = [UIColor whiteColor];
        _stepLabel.textAlignment = NSTextAlignmentCenter;
        _stepLabel.text = @"0";
    }
    return _stepLabel;
}

@end
