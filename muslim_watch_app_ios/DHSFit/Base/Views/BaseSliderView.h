//
//  BaseSliderView.h
//  DHSFit
//
//  Created by DHS on 2022/10/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseSliderViewDelegate;

@interface BaseSliderView : UISlider<UIGestureRecognizerDelegate>

@property (nonatomic, assign) id <BaseSliderViewDelegate> delegate;
@property (nonatomic, assign) BOOL transformType;

/**
 设置滑动控件最大值、最小值
 */
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;

/**
 控制水平或垂直，默认水平

 @param Type 控制水平或垂直，默认水平
 */
- (void)Settransform:(BOOL)Type;

@end

@protocol BaseSliderViewDelegate <NSObject>

/**
 滑动改变回调

 @param Slide IDOUISlider对象
 */
- (void)SliderChangeValue:(BaseSliderView *)Slide;

/**
 触摸回调

 @param Slide IDOUISlider对象
 */
- (void)SliderTouchChangeValue:(BaseSliderView *)Slide;

/**
 点击回调

 @param Slide IDOUISlider对象
 */
- (void)SliderClickChangeValue:(BaseSliderView *)Slide;

@end

NS_ASSUME_NONNULL_END
