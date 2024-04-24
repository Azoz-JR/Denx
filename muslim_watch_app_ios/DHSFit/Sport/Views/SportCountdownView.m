//
//  SportCountdownView.m
//  DHSFit
//
//  Created by DHS on 2022/7/15.
//

#import "SportCountdownView.h"

@interface SportCountdownView ()
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 定时器
@property (nonatomic, strong) NSTimer *timer;
/// 计数
@property (nonatomic, assign) NSInteger count;
/// 模型
@property (nonatomic, strong) SportGoalSetModel *goalModel;

@end

@implementation SportCountdownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.goalModel = [SportGoalSetModel currentModel];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

- (void)startCount {
    if (self.goalModel.isVibration) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    self.count = 3;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerRun {
    self.count--;
    if (self.count > -1) {
        if (self.goalModel.isVibration) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        if (self.count > 0) {
            self.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
        } else {
            self.titleLabel.text = @"GO";
        }
    } else {
        [self.timer invalidate];
        self.timer = nil;
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(countdownFinished)]) {
            [self.delegate countdownFinished];
        }
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HomeColor_TitleColor;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:120];
        _titleLabel.text = @"";
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
