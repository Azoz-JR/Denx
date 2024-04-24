//
//  RunningmapView.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "RunningGPSView.h"
#import "RunningMapView.h"

@interface RunningGPSView ()
/// 返回
@property (nonatomic, strong) UIButton *backButton;
/// 定位
@property (nonatomic, strong) UIButton *locationButton;

@end

@implementation RunningGPSView

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
 
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kStatusHeight);
        make.left.right.bottom.offset(0);
    }];
    
    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kStatusHeight+20);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.equalTo(self).multipliedBy(0.3);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-30);
    }];
    
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.equalTo(self.backButton.mas_top).offset(-20);
    }];
    
}

- (void)backClick {
    if ([self.delegate respondsToSelector:@selector(onBack)]) {
        [self.delegate onBack];
    }
}

- (void)locationClick {
    if ([self.delegate respondsToSelector:@selector(onLocation)]) {
        [self.delegate onLocation];
    }
}

- (RunningMapView *)mapView {
    if (!_mapView) {
        _mapView = [[RunningMapView alloc] init];
        [self addSubview:_mapView];
    }
    return _mapView;
}

- (RunningDataView *)dataView {
    if (!_dataView) {
        _dataView = [[RunningDataView alloc] init];
        _dataView.alpha = 0.85;
        _dataView.backgroundColor = HomeColor_BlockColor;
        _dataView.layer.cornerRadius = 10.0;
        _dataView.layer.masksToBounds = YES;
        [_dataView updateTitleLabelFrame];
        [self addSubview:_dataView];
    }
    return _dataView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:DHImage(@"sport_main_back") forState:UIControlStateNormal];
        [self addSubview:_backButton];
    }
    return _backButton;
}

- (UIButton *)locationButton {
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
        [_locationButton setImage:DHImage(@"sport_main_location") forState:UIControlStateNormal];
        [self addSubview:_locationButton];
    }
    return _locationButton;
}

@end
