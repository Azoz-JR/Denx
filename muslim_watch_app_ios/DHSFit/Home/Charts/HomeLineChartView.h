//
//  HomeLineChartView.h
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeLineChartView : UIView

@property (nonatomic, strong) UIColor *mainColor;

@property (nonatomic, strong) ChartViewModel *chartModel;

@end

NS_ASSUME_NONNULL_END
