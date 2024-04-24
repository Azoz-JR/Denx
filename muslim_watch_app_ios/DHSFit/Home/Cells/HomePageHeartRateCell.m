//
//  HomePageHeartRateCell.m
//  DHSFit
//
//  Created by DHS on 2022/9/14.
//

#import "HomePageHeartRateCell.h"
#import "HomeLineChartView.h"

@interface HomePageHeartRateCell ()
/// 心率图表
@property (nonatomic, strong) HomeLineChartView *hrChartView;

@end

@implementation HomePageHeartRateCell

- (void)updateHrChartView:(ChartViewModel *)chartModel {
    if (!self.hrChartView) {
        self.hrChartView = [[HomeLineChartView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-45)/2.0-30, 70)];
        self.hrChartView.mainColor = [HealthDataManager mainColor:HealthDataTypeHeartRate];
        [self.chartView addSubview:self.hrChartView];
    }
    self.hrChartView.chartModel = chartModel;
}

@end
