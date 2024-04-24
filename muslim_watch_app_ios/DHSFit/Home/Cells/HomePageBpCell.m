//
//  HomePageBpCell.m
//  DHSFit
//
//  Created by DHS on 2022/9/14.
//

#import "HomePageBpCell.h"
#import "HomeDoubleLineChartView.h"

@interface HomePageBpCell ()
/// 血压图表
@property (nonatomic, strong) HomeDoubleLineChartView *bpChartView;

@end

@implementation HomePageBpCell

- (void)updateBpChartView:(ChartViewModel *)chartModel {
    if (!self.bpChartView) {
        self.bpChartView = [[HomeDoubleLineChartView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-45)/2.0-30, 70)];
        [self.chartView addSubview:self.bpChartView];
    }
    self.bpChartView.chartModel = chartModel;
}

@end
