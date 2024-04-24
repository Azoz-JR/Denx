//
//  DetailHeaderView.h
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailHeaderView : UIView

- (void)updateChartView:(ChartViewModel *)chartModel cellType:(HealthDataType)cellType dateType:(HealthDateType)dateType;

- (void)updateBreathCircleView:(DailyBreathModel *)model;

@end

NS_ASSUME_NONNULL_END
