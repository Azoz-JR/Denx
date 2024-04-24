//
//  BaseLongPressView.m
//  DHSFit
//
//  Created by DHS on 2022/8/26.
//

#import "BaseLongPressView.h"

@interface BaseLongPressView ()

@property(nonatomic, strong) CAShapeLayer *currentLayer;

@property (nonatomic, assign) CGFloat startAngle;

@property (nonatomic, assign) CGFloat endAngle;

@end

@implementation BaseLongPressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    self.startAngle = M_PI;
    self.endAngle = self.startAngle+2*M_PI;
    
    [self.mainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.centerX.equalTo(self);
        make.height.offset(20);
    }];
    
    [self.layer addSublayer:self.currentLayer];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 2;
    [self addGestureRecognizer:longPress];
    
}

- (void)longPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.currentLayer removeAllAnimations];
        
        self.startAngle = M_PI;
        self.endAngle = self.startAngle+2*M_PI;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
        self.currentLayer.path = [path CGPath];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0f);
        animation.toValue = @(1.0f);
        animation.duration = 2.0f;
        [self.currentLayer addAnimation:animation forKey:@"animationStrokeEnd"];
        
    } else if (sender.state == UIGestureRecognizerStateCancelled) {
        self.startAngle = M_PI;
        self.endAngle = M_PI;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
        self.currentLayer.path = [path CGPath];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0f);
        animation.toValue = @(1.0f);
        animation.duration = 0.25f;
        [self.currentLayer addAnimation:animation forKey:@"animationStrokeEnd"];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.delegate) {
            
        }
    }
}

- (void)stopAnimation {
    self.startAngle = M_PI;
    self.endAngle = M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    self.currentLayer.path = [path CGPath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.duration = 0.25f;
    [self.currentLayer addAnimation:animation forKey:@"animationStrokeEnd"];
}

- (CAShapeLayer *)currentLayer {
    if (!_currentLayer) {
        _currentLayer = [[CAShapeLayer alloc] init];
        _currentLayer.lineWidth = 4;
        _currentLayer.strokeColor = COLOR(@"#29B7CB").CGColor;
        _currentLayer.fillColor = [UIColor clearColor].CGColor;
        _currentLayer.lineCap = kCALineCapRound;
    }
    return _currentLayer;
}

- (UIButton *)mainButton {
    if (!_mainButton) {
        _mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mainButton setImage:DHImage(@"sport_main_end") forState:UIControlStateNormal];
        [self addSubview:_mainButton];
    }
    return _mainButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HomeColor_TitleColor;
        _titleLabel.font = HomeFont_SubTitleFont;
        _titleLabel.text = Lang(@"str_longpress_end");
        _titleLabel.hidden = YES;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
