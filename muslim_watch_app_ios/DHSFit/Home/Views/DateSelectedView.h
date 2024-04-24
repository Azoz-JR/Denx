//
//  DateSelectedView.h
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DateSelectedViewDelegate <NSObject>

@optional

- (void)onYesterday;
- (void)onTomorrow;
- (void)onDateSelected;

@end

@interface DateSelectedView : UIView
/// 代理
@property (nonatomic, weak) id<DateSelectedViewDelegate> delegate;
/// 日期
@property (nonatomic, strong) UIButton *dateButton;
/// 右按钮
@property (nonatomic, strong) UIButton *rightButton;
/// 左按钮
@property (nonatomic, strong) UIButton *leftButton;

@end

NS_ASSUME_NONNULL_END
