//
//  BaseProgressView.m
//  DHSFit
//
//  Created by DHS on 2022/6/17.
//

#import "BaseProgressView.h"

@interface BaseProgressView ()
/// 背景
@property (nonatomic, strong) UIView *baseView;
/// 当前视图
@property (nonatomic, strong) UIView *currentView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

/// 进度
@property (nonatomic, assign) CGFloat progress;
/// 进度
@property (nonatomic, strong) NSString *fileProgress;


@end

@implementation BaseProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)updateDialSyncingProgress:(CGFloat)progress {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        if (progress > self.progress) {
            self.progress = progress;
            self.titleLabel.text = [NSString stringWithFormat:@"%@:%.0f%%",Lang(@"str_installing"),progress*100];
            CGFloat width = (kScreenWidth-30)*progress;
            [self.currentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(width);
            }];
        } else if (progress == 0) {
            self.progress = 0;
            self.titleLabel.text = [NSString stringWithFormat:@"%@:0%%",Lang(@"str_installing")];
            [self.currentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(0);
            }];
        }
    });
}

- (void)updateFileSyncingProgress:(CGFloat)progress {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        if (progress > self.progress) {
            self.progress = progress;
            self.titleLabel.text = [NSString stringWithFormat:@"%@:%.0f%%",Lang(@"str_upgrading"),progress*100];
            CGFloat width = (kScreenWidth-30)*progress;
            [self.currentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(width);
            }];
        } else if (progress == 0) {
            self.progress = 0;
            self.titleLabel.text = [NSString stringWithFormat:@"%@:0%%",Lang(@"str_upgrading")];
            [self.currentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(0);
            }];
        }
    });
}

- (void)setupSubViews {
    self.progress = 0;
    self.backgroundColor = HomeColor_BlockColor;
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = HomeColor_BlockColor;
        [self addSubview:_baseView];
    }
    return _baseView;
}

- (UIView *)currentView {
    if (!_currentView) {
        _currentView = [[UIView alloc] init];
        _currentView.backgroundColor = HomeColor_MainColor;
        _currentView.layer.cornerRadius = 10.0;
        _currentView.layer.masksToBounds = YES;
        [self addSubview:_currentView];
    }
    return _currentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = HomeColor_TitleColor;
        _titleLabel.font = HomeFont_ButtonFont;
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
