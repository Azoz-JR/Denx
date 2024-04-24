//
//  DateSelectedView.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "DateSelectedView.h"

@implementation DateSelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)yesterdayClick {
    if ([self.delegate respondsToSelector:@selector(onYesterday)]) {
        [self.delegate onYesterday];
    }
}

- (void)tomorrowClick {
    if ([self.delegate respondsToSelector:@selector(onTomorrow)]) {
        [self.delegate onTomorrow];
    }
}

- (void)dateClick {
    if ([self.delegate respondsToSelector:@selector(onDateSelected)]) {
        [self.delegate onDateSelected];
    }
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.height.offset(30);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dateButton.mas_left).offset(-10);
        make.width.height.offset(30);
        make.centerY.equalTo(self);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateButton.mas_right).offset(10);
        make.width.height.offset(30);
        make.centerY.equalTo(self);
    }];
 
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:DHImage(@"home_date_left") forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(yesterdayClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:DHImage(@"home_date_right") forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(tomorrowClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }
    return _rightButton;
}

- (UIButton *)dateButton {
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateButton setTitle:[[NSDate date] dateToStringFormat:@"yyyy/MM/dd"] forState:UIControlStateNormal];
        [_dateButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        _dateButton.titleLabel.font = HomeFont_TitleFont;
        [_dateButton addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dateButton];
    }
    return _dateButton;
}

@end
