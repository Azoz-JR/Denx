//
//  TempReportViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "TempReportViewController.h"

@interface TempReportViewController ()

@end

@implementation TempReportViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - custom action for UI 界面处理有关

- (void)updateDayTableViewCell {
    DailyTempModel *model = [HealthDataManager dayChartDatas:self.currentDate type:self.cellType];
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(model.lastTemp),TempUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(model.avgTemp),TempUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(model.maxTemp),TempUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(model.minTemp),TempUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateWeekTableViewCell {
    NSArray *models = [HealthDataManager weekChartDatas:self.currentWeekDate type:self.cellType];
    
    NSMutableArray *avgTempArray = [NSMutableArray array];
    NSMutableArray *maxTempArray = [NSMutableArray array];
    NSMutableArray *minTempArray = [NSMutableArray array];
    for (DailyTempModel *model in models) {
        if (model.avgTemp > 0) {
            [avgTempArray addObject:@(model.avgTemp)];
            [maxTempArray addObject:@(model.maxTemp)];
            [minTempArray addObject:@(model.minTemp)];
        }
    }
    NSInteger avgTemp = avgTempArray.count > 0 ? [[avgTempArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger maxTemp = maxTempArray.count > 0 ? [[maxTempArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger minTemp = minTempArray.count > 0 ? [[minTempArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(avgTemp),TempUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(maxTemp),TempUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(minTemp),TempUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateMonthTableViewCell {
    NSArray *models = [HealthDataManager monthChartDatas:self.currentMonthDate type:self.cellType];
    
    NSMutableArray *avgTempArray = [NSMutableArray array];
    NSMutableArray *maxTempArray = [NSMutableArray array];
    NSMutableArray *minTempArray = [NSMutableArray array];
    for (DailyTempModel *model in models) {
        if (model.avgTemp > 0) {
            [avgTempArray addObject:@(model.avgTemp)];
            [maxTempArray addObject:@(model.maxTemp)];
            [minTempArray addObject:@(model.minTemp)];
        }
    }
    NSInteger avgTemp = avgTempArray.count > 0 ? [[avgTempArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger maxTemp = maxTempArray.count > 0 ? [[maxTempArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger minTemp = minTempArray.count > 0 ? [[minTempArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(avgTemp),TempUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(maxTemp),TempUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(minTemp),TempUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateYearTableViewCell {
    NSArray *models = [HealthDataManager yearChartDatas:self.currentYearDate type:self.cellType];
    
    NSMutableArray *avgTempArray = [NSMutableArray array];
    NSMutableArray *maxTempArray = [NSMutableArray array];
    NSMutableArray *minTempArray = [NSMutableArray array];
    for (DailyTempModel *model in models) {
        if (model.avgTemp > 0) {
            [avgTempArray addObject:@(model.avgTemp)];
            [maxTempArray addObject:@(model.maxTemp)];
            [minTempArray addObject:@(model.minTemp)];
        }
    }
    NSInteger avgTemp = avgTempArray.count > 0 ? [[avgTempArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger maxTemp = maxTempArray.count > 0 ? [[maxTempArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger minTemp = minTempArray.count > 0 ? [[minTempArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(avgTemp),TempUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(maxTemp),TempUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",TempValue(minTemp),TempUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
 
@end
