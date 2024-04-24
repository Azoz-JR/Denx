//
//  LineChartView.h
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineChartView : UIView

@property (nonatomic, strong) UIColor *mainColor;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) UIColor *labelColor;

@property (nonatomic, strong) UIColor *gradientColor;

@property (nonatomic, copy) NSString *unitStr;

@property (nonatomic, assign) BOOL isCanClick;

@property (nonatomic, strong) ChartViewModel *chartModel;

@end

NS_ASSUME_NONNULL_END
