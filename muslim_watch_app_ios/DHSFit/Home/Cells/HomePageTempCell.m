//
//  HomePageTempCell.m
//  DHSFit
//
//  Created by DHS on 2022/9/14.
//

#import "HomePageTempCell.h"
#import "HomeLineChartView.h"

@interface HomePageTempCell ()
/// 体温图表
@property (nonatomic, strong) HomeLineChartView *tempChartView;

@end

@implementation HomePageTempCell

- (void)updateTempChartView:(ChartViewModel *)chartModel {
    if (!self.tempChartView) {
        self.tempChartView = [[HomeLineChartView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-45)/2.0-30, 70)];
        self.tempChartView.mainColor = [HealthDataManager mainColor:HealthDataTypeTemp];
        [self.chartView addSubview:self.tempChartView];
    }
    self.tempChartView.chartModel = chartModel;
}

@end
