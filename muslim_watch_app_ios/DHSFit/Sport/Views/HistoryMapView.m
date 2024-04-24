//
//  HistoryMapView.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "HistoryMapView.h"

@implementation HistoryMapView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark 创建苹果地图
- (void)setupSubViews{
    self.backgroundColor = HomeColor_BackgroundColor;
    
    self.mkMapView = [[MkMapAppleNewView alloc] init];
    self.mkMapView.type = MapTypeRunDetail;
    [self addSubview:self.mkMapView];
    [self sendSubviewToBack:self.mkMapView];

    [self.mkMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


@end
