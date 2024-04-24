//
//  BaseCalendarView.h
//  DHSFit
//
//  Created by DHS on 2022/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseCalendarViewDelegate <NSObject>

@optional

- (void)calendarDidSelectedDate:(NSDate *)date;

@end

@interface BaseCalendarView : UIView

@property (nonatomic, weak) id<BaseCalendarViewDelegate> delegate;

/// 显示日期
/// @param date 日期
/// @param isDateSelected 是否选中
- (void)showCalendar:(NSDate *)date isDateSelected:(BOOL)isDateSelected;

@end

NS_ASSUME_NONNULL_END
