//
//  BOReportViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "BOReportViewController.h"

@interface BOReportViewController ()

@end

@implementation BOReportViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - custom action for UI 界面处理有关

- (void)updateDayTableViewCell {
    DailyBoModel *model = [HealthDataManager dayChartDatas:self.currentDate type:self.cellType];
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.lastBo,BoUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.avgBo,BoUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.maxBo,BoUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.minBo,BoUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateWeekTableViewCell {
    NSArray *models = [HealthDataManager weekChartDatas:self.currentWeekDate type:self.cellType];
    
    NSMutableArray *avgBoArray = [NSMutableArray array];
    NSMutableArray *maxBoArray = [NSMutableArray array];
    NSMutableArray *minBoArray = [NSMutableArray array];
    for (DailyBoModel *model in models) {
        if (model.avgBo > 0) {
            [avgBoArray addObject:@(model.avgBo)];
            [maxBoArray addObject:@(model.maxBo)];
            [minBoArray addObject:@(model.minBo)];
        }
    }
    NSInteger avgBo = avgBoArray.count > 0 ? [[avgBoArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger maxBo = maxBoArray.count > 0 ? [[maxBoArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger minBo = minBoArray.count > 0 ? [[minBoArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgBo,BoUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxBo,BoUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minBo,BoUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateMonthTableViewCell {
    NSArray *models = [HealthDataManager monthChartDatas:self.currentMonthDate type:self.cellType];
    
    NSMutableArray *avgBoArray = [NSMutableArray array];
    NSMutableArray *maxBoArray = [NSMutableArray array];
    NSMutableArray *minBoArray = [NSMutableArray array];
    for (DailyBoModel *model in models) {
        if (model.avgBo > 0) {
            [avgBoArray addObject:@(model.avgBo)];
            [maxBoArray addObject:@(model.maxBo)];
            [minBoArray addObject:@(model.minBo)];
        }
    }
    NSInteger avgBo = avgBoArray.count > 0 ? [[avgBoArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger maxBo = maxBoArray.count > 0 ? [[maxBoArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger minBo = minBoArray.count > 0 ? [[minBoArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgBo,BoUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxBo,BoUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minBo,BoUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateYearTableViewCell {
    NSArray *models = [HealthDataManager yearChartDatas:self.currentYearDate type:self.cellType];
    
    NSMutableArray *avgBoArray = [NSMutableArray array];
    NSMutableArray *maxBoArray = [NSMutableArray array];
    NSMutableArray *minBoArray = [NSMutableArray array];
    for (DailyBoModel *model in models) {
        if (model.avgBo > 0) {
            [avgBoArray addObject:@(model.avgBo)];
            [maxBoArray addObject:@(model.maxBo)];
            [minBoArray addObject:@(model.minBo)];
        }
    }
    NSInteger avgBo = avgBoArray.count > 0 ? [[avgBoArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger maxBo = maxBoArray.count > 0 ? [[maxBoArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
    NSInteger minBo = minBoArray.count > 0 ? [[minBoArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgBo,BoUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)maxBo,BoUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)minBo,BoUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
 

@end
