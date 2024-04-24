//
//  HomePageBreathCell.m
//  DHSFit
//
//  Created by DHS on 2022/9/14.
//

#import "HomePageBreathCell.h"
#import "HomeBreathProgressView.h"

@interface HomePageBreathCell ()
/// 呼吸图表
@property (nonatomic, strong) HomeBreathProgressView *progressView;

@end

@implementation HomePageBreathCell

- (void)updateBreathChartView:(DailyBreathModel *)dataModel {
    if (!self.progressView) {
        self.progressView = [[HomeBreathProgressView alloc] initWithFrame:CGRectMake(0, 22, (kScreenWidth-45)/2.0-30, 36)];
        self.progressView.layer.cornerRadius = 18.0;
        self.progressView.layer.masksToBounds = YES;
        self.progressView.layer.borderWidth = 1.5;
        self.progressView.layer.borderColor = COLOR(@"#B3B3B3").CGColor;
        [self.chartView addSubview:self.progressView];
    }
    CGFloat progress = dataModel.duration/10.0;
    if (progress > 1.0) {
        progress = 1.0;
    }
    [self.progressView updateProgress:progress];
}

@end
