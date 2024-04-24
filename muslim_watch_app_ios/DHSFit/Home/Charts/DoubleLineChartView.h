//
//  DoubleLineChartView.h
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoubleLineChartView : UIView

@property (nonatomic, strong) UIColor *mainColorA;

@property (nonatomic, strong) UIColor *mainColorB;

@property (nonatomic, assign) BOOL isCanClick;

@property (nonatomic, strong) ChartViewModel *chartModel;

@end

NS_ASSUME_NONNULL_END
