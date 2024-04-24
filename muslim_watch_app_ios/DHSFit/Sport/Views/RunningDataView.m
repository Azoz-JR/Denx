//
//  RunningDataView.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "RunningDataView.h"

@interface RunningDataView ()

/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 数据视图
@property (nonatomic, strong) UIView *dataView;
/// GPS信号
@property (nonatomic, strong) UIImageView *rssiView;
/// 标题
@property (nonatomic, strong) NSArray *titles;
/// 图标
@property (nonatomic, strong) NSArray *images;
/// 文字颜色
@property (nonatomic, strong) UIColor *textColor;

@end

@implementation RunningDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(DailySportModel *)model {
    _model = model;
    NSArray *strArray = @[[NSString stringWithFormat:@"%.02f",DistanceValue(model.distance)],DistanceUnit];
    NSArray *fontArray = @[HomeFont_Bold_30,HomeFont_SubTitleFont];
    NSArray *colorArray = @[self.textColor,self.textColor];
    self.titleLabel.attributedText = [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
    
    for (int i =0 ; i < self.titles.count; i++) {
        UILabel *valueLabel = [self.dataView viewWithTag:2000+i];
        if (i == 0) {
            valueLabel.text = [NSString stringWithFormat:@"%.01f",KcalValue(model.calorie)];
        } else if (i ==1) {
            valueLabel.text = [RunningManager transformDuration:model.duration];
        } else {
            if (ImperialUnit) {
                NSInteger avg_pace = model.distance > 0 ? 1609.0*model.duration/model.distance : 0;
                valueLabel.text =  [NSString stringWithFormat:@"%ld'%02ld\"",(long)avg_pace/60,(long)avg_pace%60];
            } else {
                NSInteger avg_pace = model.distance > 0 ? 1000.0*model.duration/model.distance : 0;
                valueLabel.text =  [NSString stringWithFormat:@"%ld'%02ld\"",(long)avg_pace/60,(long)avg_pace%60];
            }
        }
    }
    
}

- (void)updateTitleLabelFrame {
    self.rssiView.hidden = NO;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(30);
    }];
}

- (void)updateGpsRssi:(NSInteger)rssi {
    NSString *imageStr;
    if (rssi <= 0 || rssi > 65) {
        imageStr = @"sport_gps_0";
    } else if (rssi <= 25) {
        imageStr = @"sport_gps_4";
    } else if (rssi <= 45) {
        imageStr = @"sport_gps_3";
    } else {
        imageStr = @"sport_gps_2";
    }
    self.rssiView.image = DHImage(imageStr);
}

- (void)setupSubViews {
    self.textColor = HomeColor_TitleColor;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.centerX.equalTo(self);
    }];
    
    [self.rssiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.offset(-30);
    }];

    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-30);
        make.left.right.offset(0);
        make.height.offset(80);
    }];
    
    CGFloat multiplied = 1.0/self.titles.count;
    UIView *lastView;
    for (int i = 0; i < self.titles.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.dataView addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.offset(0);
                make.width.equalTo(self.dataView).multipliedBy(multiplied);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right);
                make.top.bottom.offset(0);
                make.width.equalTo(self.dataView).multipliedBy(multiplied);
            }];
        }
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = self.textColor;
        valueLabel.font = HomeFont_Bold_25;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = @"";
        valueLabel.tag = 2000+i;
        [itemView addSubview:valueLabel];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = self.textColor;
        titleLabel.font = HomeFont_TitleFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.titles[i];
        titleLabel.tag = 1000+i;
        [itemView addSubview:titleLabel];
        
        UIImageView *itemImageView = [[UIImageView alloc] init];
        itemImageView.image = DHImage(self.images[i]);
        [itemView addSubview:itemImageView];
        
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemView);
            make.centerY.equalTo(itemView);
            make.width.equalTo(itemView);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemView);
            make.top.equalTo(valueLabel.mas_bottom).offset(5);
            make.width.equalTo(itemView);
        }];
        
        [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(itemView);
            make.bottom.equalTo(valueLabel.mas_top).offset(-5);
        }];
        
        lastView = itemView;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        NSArray *strArray = @[@"0.00",DistanceUnit];
        NSArray *fontArray = @[HomeFont_Bold_30,HomeFont_SubTitleFont];
        NSArray *colorArray = @[self.textColor,self.textColor];
        _titleLabel.attributedText = [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)dataView {
    if (!_dataView) {
        _dataView = [[UIView alloc] init];
        _dataView.backgroundColor = [UIColor clearColor];
        [self addSubview:_dataView];
    }
    return _dataView;
}

- (UIImageView *)rssiView {
    if (!_rssiView) {
        _rssiView = [[UIImageView alloc] init];
        _rssiView.contentMode = UIViewContentModeScaleAspectFit;
        _rssiView.image = DHImage(@"sport_gps_2");
        _rssiView.hidden = YES;
        [self addSubview:_rssiView];
    }
    return _rssiView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_cal"),
                    Lang(@"str_total_time"),
                    Lang(@"str_pace")];
    }
    return _titles;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"sport_main_calories",
                    @"sport_main_duration",
                    @"sport_main_pace"];
    }
    return _images;
}

@end
