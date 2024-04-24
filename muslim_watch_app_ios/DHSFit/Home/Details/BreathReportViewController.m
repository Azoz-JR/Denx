//
//  BreathReportViewController.m
//  DHSFit
//
//  Created by DHS on 2022/8/12.
//

#import "BreathReportViewController.h"

@interface BreathReportViewController ()

@end

@implementation BreathReportViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - custom action for UI 界面处理有关

- (void)updateDayTableViewCell {
    
}

- (void)updateWeekTableViewCell {
    NSArray *models = [HealthDataManager weekChartDatas:self.currentWeekDate type:self.cellType];
    
    NSMutableArray *breathArray = [NSMutableArray array];
    for (DailyBreathModel *model in models) {
        if (model.duration > 0) {
            [breathArray addObject:@(model.duration)];
        }
    }
    NSInteger sumBreath = breathArray.count > 0 ? [[breathArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger avgBreath = breathArray.count > 0 ? [[breathArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)sumBreath,MinuteUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgBreath,MinuteUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateMonthTableViewCell {
    NSArray *models = [HealthDataManager monthChartDatas:self.currentMonthDate type:self.cellType];
    
    NSMutableArray *breathArray = [NSMutableArray array];
    for (DailyBreathModel *model in models) {
        if (model.duration > 0) {
            [breathArray addObject:@(model.duration)];
        }
    }
    NSInteger sumBreath = breathArray.count > 0 ? [[breathArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger avgBreath = breathArray.count > 0 ? [[breathArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)sumBreath,MinuteUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgBreath,MinuteUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateYearTableViewCell {
    NSArray *models = [HealthDataManager yearChartDatas:self.currentYearDate type:self.cellType];
    
    NSMutableArray *breathArray = [NSMutableArray array];
    for (DailyBreathModel *model in models) {
        if (model.duration > 0) {
            [breathArray addObject:@(model.duration)];
        }
    }
    NSInteger sumBreath = breathArray.count > 0 ? [[breathArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger avgBreath = breathArray.count > 0 ? [[breathArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)sumBreath,MinuteUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgBreath,MinuteUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

@end
