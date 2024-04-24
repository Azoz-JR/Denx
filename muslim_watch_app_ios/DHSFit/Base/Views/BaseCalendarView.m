//
//  BaseCalendarView.m
//  DHSFit
//
//  Created by DHS on 2022/6/14.
//

#import "BaseCalendarView.h"
#import "FSCalendar.h"

@interface BaseCalendarView()<FSCalendarDataSource,FSCalendarDelegate>

/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 取消
@property (nonatomic, strong) UIButton *cancelButton;
/// 确认
@property (nonatomic, strong) UIButton *confirmButton;
/// 日历
@property (nonatomic, strong) FSCalendar *calendarView;
/// 当前日期
@property (nonatomic, strong) NSDate *currentDate;
/// 视图高度
@property (nonatomic, assign) CGFloat viewH;
/// 选中日期
@property (nonatomic, assign) BOOL isDateSelected;

@end

@implementation BaseCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLORANDALPHA(@"#000000", 0.4);
        
    }
    return self;
}

- (void)showCalendar:(NSDate *)date isDateSelected:(BOOL)isDateSelected {
    self.isDateSelected = isDateSelected;
    self.currentDate = date;
    [self setupSubviews];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    WEAKSELF
    [UIView animateWithDuration:0.20 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, weakSelf.frame.size.height-weakSelf.viewH, weakSelf.frame.size.width,weakSelf.viewH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideCalendar {
    WEAKSELF
    [UIView animateWithDuration:0.20 animations:^{
        weakSelf.bgView.frame = CGRectMake(0, weakSelf.frame.size.height, weakSelf.frame.size.width,weakSelf.viewH);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)cancelClick {
    [self hideCalendar];
}

- (void)confirmClick {
    if ([self.delegate respondsToSelector:@selector(calendarDidSelectedDate:)]) {
        [self.delegate calendarDidSelectedDate:self.currentDate];
    }
    [self hideCalendar];
}

- (void)setupSubviews {
    
    self.viewH = kBottomHeight+330;
    CGFloat buttonW = self.frame.size.width/3.0;
    
    self.bgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width,self.viewH);

    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(buttonW);
        make.height.offset(50);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.offset(0);
        make.width.offset(buttonW);
        make.height.offset(50);
    }];
    
    [self.bgView addSubview:self.calendarView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
    
}

#pragma mark - FSCalendarDataSource,FSCalendarDelegate

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    return [NSDate date];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    self.currentDate = date;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (FSCalendar *)calendarView {
    if (!_calendarView) {
        _calendarView = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 280)];
        _calendarView.scrollDirection = FSCalendarScrollDirectionHorizontal;
        _calendarView.appearance.headerTitleAlignment = NSTextAlignmentCenter;
        _calendarView.appearance.headerDateFormat = @"yyyy-MM";
        _calendarView.appearance.headerTitleColor = HomeColor_TitleColor;
        _calendarView.appearance.headerTitleFont = HomeFont_TitleFont;
        _calendarView.appearance.weekdayTextColor = HomeColor_SubTitleColor;
        _calendarView.appearance.titleDefaultColor = HomeColor_TitleColor;
        _calendarView.appearance.headerMinimumDissolvedAlpha = 0;
        _calendarView.appearance.selectionColor = self.isDateSelected ? HomeColor_MainColor : [UIColor clearColor];
        _calendarView.appearance.todayColor = COLORANDALPHA(@"#69D4E3", 0.2);
        
        NSString *languageName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject];
        if ([languageName hasPrefix:@"zh"]) {
            _calendarView.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
            _calendarView.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        } else {
            _calendarView.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesDefaultCase;
            _calendarView.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
        }
        _calendarView.backgroundColor = [UIColor clearColor];
        _calendarView.dataSource = self;
        _calendarView.delegate = self;
        _calendarView.scrollEnabled = YES;
        [_calendarView selectDate:self.currentDate];
    }
    
    return _calendarView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:Lang(@"str_cancel") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = HomeFont_TitleFont;
        [_cancelButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_cancelButton];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:Lang(@"str_sure") forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = HomeFont_TitleFont;
        [_confirmButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_confirmButton];
    }
    return _confirmButton;
}

@end

