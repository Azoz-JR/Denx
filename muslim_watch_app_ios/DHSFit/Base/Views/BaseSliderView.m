//
//  BaseSliderView.m
//  DHSFit
//
//  Created by DHS on 2022/10/7.
//

#import "BaseSliderView.h"

@implementation BaseSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self loadSlider];
        _transformType = NO;
    }
    return self;
}

- (void)Settransform:(BOOL)Type
{
    if (Type == YES)
    {
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.transform =transform;
        _transformType =YES;
    }else
    {
        _transformType =NO;
    }
}

- (void)loadSlider
{
    [self setMinimumTrackImage:DHImage(@"device_slider_lightblue") forState:UIControlStateNormal];
    [self setMaximumTrackImage:DHImage(@"device_slider_gray") forState:UIControlStateNormal];
    [self setThumbImage:DHImage(@"device_slider_button") forState:UIControlStateNormal];
    
    self.maximumValue = 1.0;
    self.minimumValue = 0.0;
    self.value = 0.0;
    [self addTarget:self action:@selector(panSlider:) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(TouchSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(TouchSlider:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(TouchSlider:) forControlEvents:UIControlEventTouchCancel];

    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerIncident:)];
    singleFingerOne.numberOfTouchesRequired = 1;
    singleFingerOne.numberOfTapsRequired = 1;
    singleFingerOne.delegate= self;
    [self addGestureRecognizer:singleFingerOne];
}

- (nullable UIImage *)imageFromColor: (nonnull UIColor *)color withSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)panSlider:(UISlider *)slider
{
    if ([_delegate respondsToSelector:@selector(SliderChangeValue:)])
    {
        [_delegate SliderChangeValue:self];
    }
}

- (void)TouchSlider:(UISlider *)slider
{
    if ([_delegate respondsToSelector:@selector(SliderTouchChangeValue:)])
    {
        [_delegate SliderTouchChangeValue:self];
    }
}

- (void)fingerIncident:(UITapGestureRecognizer *)sender
{
    if (self.state == 1) {
        return;
    }
    if (sender.numberOfTouchesRequired==1) {
        
        if(sender.numberOfTapsRequired == 1) {
            
            CGPoint tapPoint = [sender locationInView:self];
            
            float setValue = 0.0;
            
            if (_transformType) {
                setValue = tapPoint.x/self.frame.size.height;
            }else{
                setValue = tapPoint.x/self.frame.size.width;
            }
            
            self.value = setValue * (self.maxValue-self.minValue) + self.minValue;
            
            if ([_delegate respondsToSelector:@selector(SliderClickChangeValue:)])
            {
                [_delegate SliderClickChangeValue:self];
            }
        }
        
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wformat"

-(void)setMinValue:(NSInteger)minValue{
    _minValue = minValue;
    self.minimumValue = _minValue;
}
-(void)setMaxValue:(NSInteger)maxValue{
    _maxValue = maxValue;
    self.maximumValue = _maxValue;
}

#pragma clang diagnostic pop

@end
