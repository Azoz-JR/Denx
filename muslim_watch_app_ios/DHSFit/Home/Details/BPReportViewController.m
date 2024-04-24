//
//  BPReportViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "BPReportViewController.h"

@interface BPReportViewController ()

@end

@implementation BPReportViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - custom action for UI 界面处理有关

- (void)updateDayTableViewCell {
    DailyBpModel *model = [HealthDataManager dayChartDatas:self.currentDate type:self.cellType];
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld/%ld%@",(long)model.lastSystolic,(long)model.lastDiastolic,BpUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld/%ld%@",(long)model.avgSystolic,(long)model.avgDiastolic,BpUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.maxSystolic,BpUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.minSystolic,BpUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.maxDiastolic,BpUnit];
        } else if (i == 5) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.minDiastolic,BpUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateWeekTableViewCell {
    NSArray *models = [HealthDataManager weekChartDatas:self.currentWeekDate type:self.cellType];
    
    NSMutableArray *avgSystolicArray = [NSMutableArray array];
    NSMutableArray *avgDiastolicArray = [NSMutableArray array];
    NSMutableArray *maxSystolicArray = [NSMutableArray array];
    NSMutableArray *maxDiastolicArray = [NSMutableArray array];
    NSMutableArray *minSystolicArray = [NSMutableArray array];
    NSMutableArray *minDiastolicArray = [NSMutableArray array];
    for (DailyBpModel *model in models) {
        if (model.avgSystolic > 0) {
            [avgSystolicArray addObject:@(model.avgSystolic)];
            [avgDiastolicArray addObject:@(model.avgDiastolic)];
            [maxSystolicArray addObject:@(model.maxSystolic)];
            [maxDiastolicArray addObject:@(model.maxDiastolic)];
            [minSystolicArray addObject:@(model.minSystolic)];
            [minDiastolicArray addObject:@(model.minDiastolic)];
        }
    }
    NSInteger avgSystolic = avgSystolicArray.count > 0 ? [[avgSystolicArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgDiastolic = avgDiastolicArray.count > 0 ? [[avgDiastolicArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSInteger maxSystolic = maxSystolicArray.count > 0 ? [[maxSystolicArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger maxDiastolic = maxDiastolicArray.count > 0 ? [[maxDiastolicArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    
    NSInteger minSystolic = minSystolicArray.count > 0 ? [[minSystolicArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    NSInteger minDiastolic = minDiastolicArray.count > 0 ? [[minDiastolicArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld/%ld%@",(long)avgSystolic,(long)avgDiastolic,BpUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxSystolic,BpUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minSystolic,BpUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxDiastolic,BpUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minDiastolic,BpUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateMonthTableViewCell {
    NSArray *models = [HealthDataManager monthChartDatas:self.currentMonthDate type:self.cellType];
    
    NSMutableArray *avgSystolicArray = [NSMutableArray array];
    NSMutableArray *avgDiastolicArray = [NSMutableArray array];
    NSMutableArray *maxSystolicArray = [NSMutableArray array];
    NSMutableArray *maxDiastolicArray = [NSMutableArray array];
    NSMutableArray *minSystolicArray = [NSMutableArray array];
    NSMutableArray *minDiastolicArray = [NSMutableArray array];
    for (DailyBpModel *model in models) {
        if (model.avgSystolic > 0) {
            [avgSystolicArray addObject:@(model.avgSystolic)];
            [avgDiastolicArray addObject:@(model.avgDiastolic)];
            [maxSystolicArray addObject:@(model.maxSystolic)];
            [maxDiastolicArray addObject:@(model.maxDiastolic)];
            [minSystolicArray addObject:@(model.minSystolic)];
            [minDiastolicArray addObject:@(model.minDiastolic)];
        }
    }
    NSInteger avgSystolic = avgSystolicArray.count > 0 ? [[avgSystolicArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgDiastolic = avgDiastolicArray.count > 0 ? [[avgDiastolicArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSInteger maxSystolic = maxSystolicArray.count > 0 ? [[maxSystolicArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger maxDiastolic = maxDiastolicArray.count > 0 ? [[maxDiastolicArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    
    NSInteger minSystolic = minSystolicArray.count > 0 ? [[minSystolicArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    NSInteger minDiastolic = minDiastolicArray.count > 0 ? [[minDiastolicArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld/%ld%@",(long)avgSystolic,(long)avgDiastolic,BpUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxSystolic,BpUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minSystolic,BpUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxDiastolic,BpUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minDiastolic,BpUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateYearTableViewCell {
    NSArray *models = [HealthDataManager yearChartDatas:self.currentYearDate type:self.cellType];
    
    NSMutableArray *avgSystolicArray = [NSMutableArray array];
    NSMutableArray *avgDiastolicArray = [NSMutableArray array];
    NSMutableArray *maxSystolicArray = [NSMutableArray array];
    NSMutableArray *maxDiastolicArray = [NSMutableArray array];
    NSMutableArray *minSystolicArray = [NSMutableArray array];
    NSMutableArray *minDiastolicArray = [NSMutableArray array];
    for (DailyBpModel *model in models) {
        if (model.avgSystolic > 0) {
            [avgSystolicArray addObject:@(model.avgSystolic)];
            [avgDiastolicArray addObject:@(model.avgDiastolic)];
            [maxSystolicArray addObject:@(model.maxSystolic)];
            [maxDiastolicArray addObject:@(model.maxDiastolic)];
            [minSystolicArray addObject:@(model.minSystolic)];
            [minDiastolicArray addObject:@(model.minDiastolic)];
        }
    }
    NSInteger avgSystolic = avgSystolicArray.count > 0 ? [[avgSystolicArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgDiastolic = avgDiastolicArray.count > 0 ? [[avgDiastolicArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSInteger maxSystolic = maxSystolicArray.count > 0 ? [[maxSystolicArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger maxDiastolic = maxDiastolicArray.count > 0 ? [[maxDiastolicArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    
    NSInteger minSystolic = minSystolicArray.count > 0 ? [[minSystolicArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    NSInteger minDiastolic = minDiastolicArray.count > 0 ? [[minDiastolicArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld/%ld%@",(long)avgSystolic,(long)avgDiastolic,BpUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxSystolic,BpUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minSystolic,BpUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxDiastolic,BpUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minDiastolic,BpUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
