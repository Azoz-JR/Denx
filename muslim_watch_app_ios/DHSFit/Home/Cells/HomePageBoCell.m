//
//  HomePageBoCell.m
//  DHSFit
//
//  Created by DHS on 2022/9/14.
//

#import "HomePageBoCell.h"
#import "HomeLineChartView.h"

@interface HomePageBoCell ()
/// 血氧图表
@property (nonatomic, strong) HomeLineChartView *boChartView;

@end

@implementation HomePageBoCell

- (void)updateBoChartView:(ChartViewModel *)chartModel {
    if (!self.boChartView) {
        self.boChartView = [[HomeLineChartView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-45)/2.0-30, 70)];
        self.boChartView.mainColor = [HealthDataManager mainColor:HealthDataTypeBO];
        [self.chartView addSubview:self.boChartView];
    }
    self.boChartView.chartModel = chartModel;
}

@end
