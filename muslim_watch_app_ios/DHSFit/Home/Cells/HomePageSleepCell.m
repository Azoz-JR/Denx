//
//  HomePageSleepCell.m
//  DHSFit
//
//  Created by DHS on 2022/9/14.
//

#import "HomePageSleepCell.h"
#import "HomeColumnChartView.h"

@interface HomePageSleepCell ()
/// 睡眠图表
@property (nonatomic, strong) HomeColumnChartView *sleepChartView;

@end

@implementation HomePageSleepCell

- (void)updateSleepChartView:(ChartViewModel *)chartModel {
    if (!self.sleepChartView) {
        self.sleepChartView = [[HomeColumnChartView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-45)/2.0-30, 70)];
        [self.chartView addSubview:self.sleepChartView];
    }
    self.sleepChartView.chartModel = chartModel;
}

@end
