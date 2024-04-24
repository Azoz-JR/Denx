//
//  HomeHeaderView.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "HomeHeaderView.h"
#import "HomeCircleView.h"

@interface HomeHeaderView ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 圆圈
@property (nonatomic, strong) HomeCircleView *circleView;
/// 数据视图
@property (nonatomic, strong) UIView *dataView;
/// 标题
@property (nonatomic, strong) NSArray *titles;
/// 数值
@property (nonatomic, strong) NSArray *values;
/// 进度
@property (nonatomic, assign)CGFloat progress;

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(DailyStepModel *)model {
    _model = model;
    UserModel *userModel = [UserModel currentModel];
    
    self.progress = 1.0*model.step/userModel.stepGoal;
    if (self.progress > 1.0) {
        self.progress = 1.0;
    }
    self.circleView.progress = self.progress;
    self.circleView.stepLabel.text = [NSString stringWithFormat:@"%ld",(long)model.step];
    for (int i = 0; i < self.titles.count; i++) {
        UILabel *valueLabel = [self.dataView viewWithTag:1000+i];
        if (i == 0) {
            valueLabel.text = [NSString stringWithFormat:@"%.01f%@",KcalValue(model.calorie),CalorieUnit];
        } else if (i == 1) {
            valueLabel.text = [NSString stringWithFormat:@"%ld%@",(long)userModel.stepGoal,StepUnit];
        } else {
            valueLabel.text = [NSString stringWithFormat:@"%.02f%@",DistanceValue(model.distance),DistanceUnit];
        }
    }
    
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    CGFloat circleH = self.width/3.0;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(0);
    }];

    self.circleView.center = CGPointMake((self.width-30)/2.0, circleH/2.0+30);
    
    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-15);
        make.height.offset(40);
    }];

    CGFloat multiplied = 1.0/self.titles.count;
    UIView *lastView;
    for (int i = 0; i < self.titles.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_BlockColor;
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

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = HomeColor_SubTitleColor;
        titleLabel.font = HomeFont_SubTitleFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.titles[i];
        [itemView addSubview:titleLabel];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = HomeColor_TitleColor;
        valueLabel.font = HomeFont_SubTitleFont;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = @"";
        valueLabel.tag = 1000+i;
        [itemView addSubview:valueLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(20);
        }];
        
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(20);
        }];

        lastView = itemView;
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}


- (HomeCircleView *)circleView {
    if (!_circleView) {
        CGFloat circleH = self.width/3.0;
        _circleView = [[HomeCircleView alloc] initWithFrame:CGRectMake(0, 0, circleH, circleH)];
        [self.bgView addSubview:_circleView];
    }
    return _circleView;
}

- (UIView *)dataView {
    if (!_dataView) {
        _dataView = [[UIView alloc] init];
        _dataView.backgroundColor = HomeColor_BlockColor;
        [self.bgView addSubview:_dataView];
    }
    return _dataView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_cal"),
                    Lang(@"str_target"),
                    Lang(@"str_distance")];
    }
    return _titles;
}

@end
