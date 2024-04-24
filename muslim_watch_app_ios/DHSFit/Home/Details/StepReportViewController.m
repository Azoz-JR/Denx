//
//  StepReportViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "StepReportViewController.h"

@interface StepReportViewController ()

@end

@implementation StepReportViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - custom action for UI 界面处理有关

- (void)updateDayTableViewCell {
    UserModel *userModel = [UserModel currentModel];
    DailyStepModel *model = [HealthDataManager dayChartDatas:self.currentDate type:self.cellType];
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)model.step,StepUnit];
        } else if (i == 1) {
            if (model.step >= userModel.stepGoal) {
                cellModel.subTitle = @"1.0";
            } else {
                cellModel.subTitle = [NSString stringWithFormat:@"%.01f",1.0*model.step/userModel.stepGoal];
            }
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",KcalValue(model.calorie),CalorieUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.02f%@",DistanceValue(model.distance),DistanceUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateWeekTableViewCell {
    NSArray *models = [HealthDataManager weekChartDatas:self.currentWeekDate type:self.cellType];
    
    NSMutableArray *stepArray = [NSMutableArray array];
    NSMutableArray *calorieArray = [NSMutableArray array];
    NSMutableArray *distanceArray = [NSMutableArray array];
    for (DailyStepModel *model in models) {
        if (model.step > 0) {
            [stepArray addObject:@(model.step)];
            [calorieArray addObject:@(model.calorie)];
            [distanceArray addObject:@(model.distance)];
        }
    }
    NSInteger sumStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumCalorie = calorieArray.count > 0 ? [[calorieArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumDistance = distanceArray.count > 0 ? [[distanceArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    
    NSInteger avgStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgCalorie = calorieArray.count > 0 ? [[calorieArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgDistance = distanceArray.count > 0 ? [[distanceArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)sumStep,StepUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgStep,StepUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",KcalValue(sumCalorie),CalorieUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",KcalValue(avgCalorie),CalorieUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.02f%@",DistanceValue(sumDistance),DistanceUnit];
        } else if (i == 5) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.02f%@",DistanceValue(avgDistance),DistanceUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateMonthTableViewCell {
    NSArray *models = [HealthDataManager monthChartDatas:self.currentMonthDate type:self.cellType];
    
    NSMutableArray *stepArray = [NSMutableArray array];
    NSMutableArray *calorieArray = [NSMutableArray array];
    NSMutableArray *distanceArray = [NSMutableArray array];
    for (DailyStepModel *model in models) {
        if (model.step > 0) {
            [stepArray addObject:@(model.step)];
            [calorieArray addObject:@(model.calorie)];
            [distanceArray addObject:@(model.distance)];
        }
    }
    NSInteger sumStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumCalorie = calorieArray.count > 0 ? [[calorieArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumDistance = distanceArray.count > 0 ? [[distanceArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    
    NSInteger avgStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgCalorie = calorieArray.count > 0 ? [[calorieArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgDistance = distanceArray.count > 0 ? [[distanceArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)sumStep,StepUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgStep,StepUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",KcalValue(sumCalorie),CalorieUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",KcalValue(avgCalorie),CalorieUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.02f%@",DistanceValue(sumDistance),DistanceUnit];
        } else if (i == 5) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.02f%@",DistanceValue(avgDistance),DistanceUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateYearTableViewCell {
    NSArray *models = [HealthDataManager yearChartDatas:self.currentYearDate type:self.cellType];
    
    NSMutableArray *stepArray = [NSMutableArray array];
    NSMutableArray *calorieArray = [NSMutableArray array];
    NSMutableArray *distanceArray = [NSMutableArray array];
    for (DailyStepModel *model in models) {
        if (model.step > 0) {
            [stepArray addObject:@(model.step)];
            [calorieArray addObject:@(model.calorie)];
            [distanceArray addObject:@(model.distance)];
        }
    }
    NSInteger sumStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumCalorie = calorieArray.count > 0 ? [[calorieArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumDistance = distanceArray.count > 0 ? [[distanceArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    
    NSInteger avgStep = stepArray.count > 0 ? [[stepArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgCalorie = calorieArray.count > 0 ? [[calorieArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgDistance = distanceArray.count > 0 ? [[distanceArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)sumStep,StepUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)avgStep,StepUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",KcalValue(sumCalorie),CalorieUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",KcalValue(avgCalorie),CalorieUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.02f%@",DistanceValue(sumDistance),DistanceUnit];
        } else if (i == 5) {
            cellModel.subTitle = [NSString stringWithFormat:@"%.02f%@",DistanceValue(avgDistance),DistanceUnit];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

@end
