//
//  HRReportViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "HRReportViewController.h"

@interface HRReportViewController ()

@end

@implementation HRReportViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - custom action for UI 界面处理有关

- (void)updateDayTableViewCell {
    DailyHeartRateModel *model = [HealthDataManager dayChartDatas:self.currentDate type:self.cellType];
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.lastHr,HrUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.avgHr,HrUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.maxHr,HrUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.minHr,HrUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateWeekTableViewCell {
    NSArray *models = [HealthDataManager weekChartDatas:self.currentWeekDate type:self.cellType];
    
    NSMutableArray *avgHrArray = [NSMutableArray array];
    NSMutableArray *maxHrArray = [NSMutableArray array];
    NSMutableArray *minHrArray = [NSMutableArray array];
    for (DailyHeartRateModel *model in models) {
        if (model.lastHr > 0) {
            [maxHrArray addObject:@(model.maxHr)];
            [minHrArray addObject:@(model.minHr)];
            [avgHrArray addObject:@(model.avgHr)];
        }
    }
    NSInteger avgHr = avgHrArray.count > 0 ? [[avgHrArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger maxHr = maxHrArray.count > 0 ? [[maxHrArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger minHr = minHrArray.count > 0 ? [[minHrArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgHr,HrUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxHr,HrUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minHr,HrUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateMonthTableViewCell {
    NSArray *models = [HealthDataManager monthChartDatas:self.currentMonthDate type:self.cellType];
    
    NSMutableArray *avgHrArray = [NSMutableArray array];
    NSMutableArray *maxHrArray = [NSMutableArray array];
    NSMutableArray *minHrArray = [NSMutableArray array];
    for (DailyHeartRateModel *model in models) {
        if (model.lastHr > 0) {
            [maxHrArray addObject:@(model.maxHr)];
            [minHrArray addObject:@(model.minHr)];
            [avgHrArray addObject:@(model.avgHr)];
        }
    }
    NSInteger avgHr = avgHrArray.count > 0 ? [[avgHrArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger maxHr = maxHrArray.count > 0 ? [[maxHrArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger minHr = minHrArray.count > 0 ? [[minHrArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgHr,HrUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxHr,HrUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minHr,HrUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateYearTableViewCell {
    NSArray *models = [HealthDataManager yearChartDatas:self.currentYearDate type:self.cellType];
    
    NSMutableArray *avgHrArray = [NSMutableArray array];
    NSMutableArray *maxHrArray = [NSMutableArray array];
    NSMutableArray *minHrArray = [NSMutableArray array];
    for (DailyHeartRateModel *model in models) {
        if (model.lastHr > 0) {
            [maxHrArray addObject:@(model.maxHr)];
            [minHrArray addObject:@(model.minHr)];
            [avgHrArray addObject:@(model.avgHr)];
        }
    }
    NSInteger avgHr = avgHrArray.count > 0 ? [[avgHrArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger maxHr = maxHrArray.count > 0 ? [[maxHrArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger minHr = minHrArray.count > 0 ? [[minHrArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgHr,HrUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxHr,HrUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minHr,HrUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
 
@end
