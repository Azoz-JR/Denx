//
//  DataSyncingView.m
//  DHSFit
//
//  Created by DHS on 2022/7/6.
//

#import "DataSyncingView.h"

@interface DataSyncingView ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 菊花
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DataSyncingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLORANDALPHA(@"#000000", 0.4);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(120);  //120
        make.left.offset(52.5); //52.5
        make.right.offset(-52.5);
        make.centerY.equalTo(self);
    }];
    
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.centerX.equalTo(self.bgView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activityIndicator.mas_bottom).offset(20);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    [self.activityIndicator startAnimating];
}

- (void)showSyncingView {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",Lang(@"str_syncing")];
    
    UIWindow *tWindow = nil;
    if(@available(iOS 13.0, *)) {
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *windowScene = (UIWindowScene*)array[0];
        UIWindow *mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
        if (mainWindow){
            tWindow = mainWindow;
        }
        else{
            tWindow = [UIApplication sharedApplication].windows.lastObject;
        }
    }
    else{
        tWindow = [UIApplication sharedApplication].windows.lastObject;
    }
    
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [tWindow addSubview:self];
    self.bgView.transform = CGAffineTransformMakeScale(0.70, 0.70);
    WEAKSELF
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)setProgress:(NSInteger)progress {
    _progress = progress;
    if (progress == -1) {
        self.titleLabel.text = Lang(@"str_syncing_fail");
        [self delayPerformBlock:^(id  _Nonnull object) {
            [self hiddenSyncingView];
        } WithTime:1.0];
    } else if (progress == 100) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",Lang(@"str_syncing")];
        [self delayPerformBlock:^(id  _Nonnull object) {
            [self syncSucceed];
        } WithTime:0.3];
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",Lang(@"str_syncing")];
    }
    
}

- (void)syncSucceed {
    self.titleLabel.text = Lang(@"str_syncing_success");
    [self delayPerformBlock:^(id  _Nonnull object) {
        [self hiddenSyncingView];
    } WithTime:1.0];
}

- (void)hiddenSyncingView {
    self.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    WEAKSELF
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.bgView.alpha = 0.0;
        weakSelf.alpha = 0.0;
        weakSelf.bgView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [weakSelf.activityIndicator stopAnimating];
        [weakSelf removeFromSuperview];
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [BaseView titleLabel];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicator.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        [self.bgView addSubview:_activityIndicator];
    }
    return _activityIndicator;
}

@end
