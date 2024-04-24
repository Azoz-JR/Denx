//
//  HomeBreathProgressView.m
//  DHSFit
//
//  Created by DHS on 2022/8/12.
//

#import "HomeBreathProgressView.h"

@interface HomeBreathProgressView ()
/// 背景
@property (nonatomic, strong) UIView *baseView;
/// 当前
@property (nonatomic, strong) UIView *currentView;

@end

@implementation HomeBreathProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)updateProgress:(CGFloat)progress {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        CGFloat width = (self.frame.size.width-2)*progress;
        [self.currentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(width);
        }];
    });
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BlockColor;
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(1);
        make.top.offset(1);
        make.bottom.offset(-1);
        make.width.offset(0);
    }];

    CGRect rect = CGRectMake(0, 0, self.frame.size.width-3, 34);
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = rect;
    gradient.colors = @[(id)COLOR(@"#73EAFB").CGColor,(id)COLOR(@"#53ABB7").CGColor];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.currentView.layer addSublayer:gradient];
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor clearColor];
        [self addSubview:_baseView];
    }
    return _baseView;
}

- (UIView *)currentView {
    if (!_currentView) {
        _currentView = [[UIView alloc] init];
        _currentView.backgroundColor = [HealthDataManager mainColor:HealthDataTypeBreath];
        _currentView.layer.cornerRadius = 17.0;
        _currentView.layer.masksToBounds = YES;
        [self addSubview:_currentView];
    }
    return _currentView;
}

@end

