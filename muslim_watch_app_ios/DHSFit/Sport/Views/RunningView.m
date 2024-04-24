//
//  RunningView.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "RunningView.h"
#import "RunningDataView.h"

@interface RunningView ()
/// 顶部视图
@property (nonatomic, strong) UIView *topView;
/// 数据视图
@property (nonatomic, strong) RunningDataView *dataView;
/// 底部视图
@property (nonatomic, strong) UIView *bottomView;
/// 开始
@property (nonatomic, strong) UIButton *startButton;
/// 暂停、继续
@property (nonatomic, strong) UIButton *pauseButton;
/// 停止
@property (nonatomic, strong) UIButton *stopButton;

/// 长按暂停
@property(nonatomic, strong) CAShapeLayer *stopLayer;
/// 是否长按
@property (nonatomic, assign) BOOL isLongPressing;
/// 圆角
@property (nonatomic, assign) CGFloat radius;
/// 开始角度
@property (nonatomic, assign) CGFloat startAngle;
/// 结束角度
@property (nonatomic, assign) CGFloat endAngle;
/// 结束文案
@property (nonatomic, strong) UILabel *stopLabel;
/// 继续文案
@property (nonatomic, strong) UILabel *continueLabel;

/// 加锁
@property (nonatomic, strong) UIButton *lockButton;
/// 解锁
@property (nonatomic, strong) UIButton *unlockButton;
/// 解锁
@property(nonatomic, strong) CAShapeLayer *unlockLayer;
/// 解锁
@property (nonatomic, strong) UILabel *unlockLabel;
///是否运动中
@property (nonatomic, assign) BOOL isRunning;

@end

@implementation RunningView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(DailySportModel *)model {
    self.dataView.model = model;
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(kNavAndStatusHeight);
    }];
    
    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(HomeViewSpace_Vertical);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.equalTo(self).multipliedBy(0.3);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dataView.mas_bottom).offset(HomeViewSpace_Vertical);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.equalTo(self).multipliedBy(0.3);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.width.offset(44);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(0);
        make.height.width.offset(44);
    }];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftButton.mas_right);
        make.bottom.offset(0);
        make.height.offset(44);
    }];
    
    
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(80);
        make.centerX.equalTo(self.bottomView);
        make.centerY.equalTo(self.bottomView).offset(-15);
    }];
    
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(80);
        make.centerX.equalTo(self.bottomView).offset(-60);
        make.centerY.equalTo(self.bottomView).offset(-15);
    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(80);
        make.centerX.equalTo(self.bottomView).offset(60);
        make.centerY.equalTo(self.bottomView).offset(-15);
    }];
    
    [self.mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-30);
    }];
    
    self.startButton.hidden = YES;
    self.stopButton.hidden = YES;
    self.continueLabel.hidden = YES;
    self.stopLabel.hidden = YES;
    self.pauseButton.hidden = NO;
    
    
    [self.stopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stopButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.stopButton);
        make.width.offset(100);
//        make.height.offset(20);
    }];
    
    [self.continueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.startButton);
        make.width.offset(100);
        //make.height.offset(20);
    }];
    
    [self.lockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.bottom.offset(-30);
    }];
    
    [self.unlockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(80);
        make.centerX.equalTo(self.bottomView);
        make.centerY.equalTo(self.bottomView).offset(-15);
    }];
    
    [self.unlockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.unlockButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.unlockButton);
        make.height.offset(20);
    }];
    
    self.radius = 40.0;
    [self.stopButton.layer addSublayer:self.stopLayer];
    [self.unlockButton.layer addSublayer:self.unlockLayer];
}

- (void)stopLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.isLongPressing = YES;
        if (self.stopLayer.animationKeys.count) {
            [self.stopLayer removeAllAnimations];
        }
        self.startAngle = 0.5*M_PI;
        self.endAngle = self.startAngle+2*M_PI;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
        self.stopLayer.path = [path CGPath];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0f);
        animation.toValue = @(1.0f);
        animation.duration = 2.0f;
        [self.stopLayer addAnimation:animation forKey:@"animationStrokeEnd"];
        [self performSelector:@selector(delayEndA) withObject:nil afterDelay:2.0];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.stopLayer.animationKeys.count) {
            [self.stopLayer removeAllAnimations];
        }
        if (self.isLongPressing) {
            self.isLongPressing = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self restoreAnimationA];
        }
    }
}

- (void)restoreAnimationA {
    self.startAngle = 0.5*M_PI;
    self.endAngle = 0.5*M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    self.stopLayer.path = [path CGPath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.duration = 0.25f;
    [self.stopLayer addAnimation:animation forKey:@"animationStrokeEnd"];
}

- (void)delayEndA {
    self.isLongPressing = NO;
    [self endClick];
    [self restoreAnimationA];
}

- (void)unlockLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.isLongPressing = YES;
        if (self.unlockLayer.animationKeys.count) {
            [self.unlockLayer removeAllAnimations];
        }
        self.startAngle = 0.5*M_PI;
        self.endAngle = self.startAngle+2*M_PI;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
        self.unlockLayer.path = [path CGPath];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0f);
        animation.toValue = @(1.0f);
        animation.duration = 2.0f;
        [self.unlockLayer addAnimation:animation forKey:@"animationStrokeEnd"];
        [self performSelector:@selector(delayEndB) withObject:nil afterDelay:2.0];
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.unlockLayer.animationKeys.count) {
            [self.unlockLayer removeAllAnimations];
        }
        if (self.isLongPressing) {
            self.isLongPressing = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self restoreAnimationB];
        }
    }
}

- (void)restoreAnimationB {
    self.startAngle = 0.5*M_PI;
    self.endAngle = 0.5*M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.radius, self.radius) radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    self.unlockLayer.path = [path CGPath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.duration = 0.25f;
    [self.unlockLayer addAnimation:animation forKey:@"animationStrokeEnd"];
}

- (void)delayEndB {
    self.isLongPressing = NO;
    [self unlockClick];
    [self restoreAnimationB];
}


- (void)settingsClick {
    if ([self.delegate respondsToSelector:@selector(onSettings)]) {
        [self.delegate onSettings];
    }
}

- (void)continueClick {
    if ([self.delegate respondsToSelector:@selector(onContinue)]) {
        [self.delegate onContinue];
    }
    self.startButton.hidden = YES;
    self.stopButton.hidden = YES;
    self.continueLabel.hidden = YES;
    self.stopLabel.hidden = YES;
    self.pauseButton.hidden = NO;
}

- (void)autoContinueClick {
    if (!self.unlockButton.hidden) {
        self.isRunning = YES;
        return;
    }
    self.startButton.hidden = YES;
    self.stopButton.hidden = YES;
    self.continueLabel.hidden = YES;
    self.stopLabel.hidden = YES;
    self.pauseButton.hidden = NO;
}

- (void)pauseClick {
    if ([self.delegate respondsToSelector:@selector(onPause)]) {
        [self.delegate onPause];
    }
    self.pauseButton.hidden = YES;
    self.startButton.hidden = NO;
    self.stopButton.hidden = NO;
    self.continueLabel.hidden = NO;
    self.stopLabel.hidden = NO;
}

- (void)autoPauseClick {
    if (!self.unlockButton.hidden) {
        self.isRunning = NO;
        return;
    }
    self.pauseButton.hidden = YES;
    self.startButton.hidden = NO;
    self.stopButton.hidden = NO;
    self.continueLabel.hidden = NO;
    self.stopLabel.hidden = NO;
}

- (void)endClick {
    if ([self.delegate respondsToSelector:@selector(onEnd)]) {
        [self.delegate onEnd];
    }
}

- (void)lockClick {
    self.isRunning = !self.pauseButton.hidden;
    
    self.lockButton.enabled = NO;
    self.mapButton.enabled = NO;
    
    self.unlockButton.hidden = NO;
    self.unlockLabel.hidden = NO;
    
    self.pauseButton.hidden = YES;
    self.startButton.hidden = YES;
    self.stopButton.hidden = YES;
    self.continueLabel.hidden = YES;
    self.stopLabel.hidden = YES;
}

- (void)unlockClick {
    self.lockButton.enabled = YES;
    self.mapButton.enabled = YES;
    
    self.unlockButton.hidden = YES;
    self.unlockLabel.hidden = YES;
    
    if (!self.isRunning) {
        self.startButton.hidden = NO;
        self.stopButton.hidden = NO;
        self.continueLabel.hidden = NO;
        self.stopLabel.hidden = NO;
    } else {
        self.pauseButton.hidden = NO;
    }
}

- (void)mapClick {
    if ([self.delegate respondsToSelector:@selector(onMap)]) {
        [self.delegate onMap];
    }
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = HomeColor_BackgroundColor;
        [self addSubview:_topView];
    }
    return _topView;
}

- (RunningDataView *)dataView {
    if (!_dataView) {
        _dataView = [[RunningDataView alloc] init];
        _dataView.backgroundColor = HomeColor_BlockColor;
        _dataView.layer.cornerRadius = 10.0;
        _dataView.layer.masksToBounds = YES;
        [self addSubview:_dataView];
    }
    return _dataView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HomeColor_BlockColor;
        _bottomView.layer.cornerRadius = 10.0;
        _bottomView.layer.masksToBounds = YES;
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:DHImage(@"mine_main_settings") forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(settingsClick) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.hidden = YES;
        [self.topView addSubview:_rightButton];
    }
    return _rightButton;
}


- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:DHImage(@"public_type_run") forState:UIControlStateNormal];
        [self.topView addSubview:_leftButton];
    }
    return _leftButton;
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = HomeColor_TitleColor;
        _leftTitleLabel.font = HomeFont_TitleFont;
        _leftTitleLabel.text = @"";
        [self.topView addSubview:_leftTitleLabel];
    }
    return _leftTitleLabel;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton addTarget:self action:@selector(continueClick) forControlEvents:UIControlEventTouchUpInside];
        [_startButton setImage:DHImage(@"sport_main_continue") forState:UIControlStateNormal];
        [self.bottomView addSubview:_startButton];
    }
    return _startButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton addTarget:self action:@selector(pauseClick) forControlEvents:UIControlEventTouchUpInside];
        [_pauseButton setImage:DHImage(@"sport_main_pause") forState:UIControlStateNormal];
        [self.bottomView addSubview:_pauseButton];
    }
    return _pauseButton;
}

- (UIButton *)stopButton {
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setImage:DHImage(@"sport_main_end") forState:UIControlStateHighlighted];
        [_stopButton setImage:DHImage(@"sport_main_end") forState:UIControlStateNormal];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(stopLongPress:)];
        longPress.minimumPressDuration = 0.2;
        [_stopButton addGestureRecognizer:longPress];
        [self.bottomView addSubview:_stopButton];
    }
    return _stopButton;
}

- (CAShapeLayer *)stopLayer {
    if (!_stopLayer) {
        _stopLayer = [[CAShapeLayer alloc] init];
        _stopLayer.lineWidth = 4;
        _stopLayer.strokeColor = HomeColor_TitleColor.CGColor;
        _stopLayer.fillColor = [UIColor clearColor].CGColor;
        _stopLayer.lineCap = kCALineCapRound;
    }
    return _stopLayer;
}

- (UILabel *)stopLabel {
    if (!_stopLabel) {
        _stopLabel = [[UILabel alloc]init];
        _stopLabel.textAlignment = NSTextAlignmentCenter;
        _stopLabel.textColor = HomeColor_TitleColor;
        _stopLabel.font = HomeFont_SubTitleFont;
        _stopLabel.text = Lang(@"str_longpress_end");
        _stopLabel.numberOfLines = 0;
        _stopLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.bottomView addSubview:_stopLabel];
    }
    return _stopLabel;
}

- (UILabel *)continueLabel {
    if (!_continueLabel) {
        _continueLabel = [[UILabel alloc]init];
        _continueLabel.textAlignment = NSTextAlignmentCenter;
        _continueLabel.textColor = HomeColor_TitleColor;
        _continueLabel.font = HomeFont_SubTitleFont;
        _continueLabel.text = Lang(@"str_click_continue");
        _continueLabel.numberOfLines = 0;
        _continueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.bottomView addSubview:_continueLabel];
    }
    return _continueLabel;
}

- (UIButton *)lockButton {
    if (!_lockButton) {
        _lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockButton addTarget:self action:@selector(lockClick) forControlEvents:UIControlEventTouchUpInside];
        [_lockButton setImage:DHImage(@"sport_main_lock") forState:UIControlStateNormal];
        [self addSubview:_lockButton];
    }
    return _lockButton;
}

- (UIButton *)unlockButton {
    if (!_unlockButton) {
        _unlockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unlockButton setImage:DHImage(@"sport_main_unlock") forState:UIControlStateHighlighted];
        [_unlockButton setImage:DHImage(@"sport_main_unlock") forState:UIControlStateNormal];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(unlockLongPress:)];
        longPress.minimumPressDuration = 0.2;
        [_unlockButton addGestureRecognizer:longPress];
        _unlockButton.hidden = YES;
        [self.bottomView addSubview:_unlockButton];
    }
    return _unlockButton;
}

- (UILabel *)unlockLabel {
    if (!_unlockLabel) {
        _unlockLabel = [[UILabel alloc]init];
        _unlockLabel.textAlignment = NSTextAlignmentCenter;
        _unlockLabel.textColor = HomeColor_TitleColor;
        _unlockLabel.font = HomeFont_SubTitleFont;
        _unlockLabel.text = Lang(@"str_longpress_unlock");
        _unlockLabel.hidden = YES;
        [self.bottomView addSubview:_unlockLabel];
    }
    return _unlockLabel;
}

- (CAShapeLayer *)unlockLayer {
    if (!_unlockLayer) {
        _unlockLayer = [[CAShapeLayer alloc] init];
        _unlockLayer.lineWidth = 4;
        _unlockLayer.strokeColor = HomeColor_TitleColor.CGColor;
        _unlockLayer.fillColor = [UIColor clearColor].CGColor;
        _unlockLayer.lineCap = kCALineCapRound;
    }
    return _unlockLayer;
}

- (UIButton *)mapButton {
    if (!_mapButton) {
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapButton addTarget:self action:@selector(mapClick) forControlEvents:UIControlEventTouchUpInside];
        [_mapButton setImage:DHImage(@"sport_main_map") forState:UIControlStateNormal];
        [self addSubview:_mapButton];
    }
    return _mapButton;
}

@end
