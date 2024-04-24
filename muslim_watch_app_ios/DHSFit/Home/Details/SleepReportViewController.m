//
//  SleepReportViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "SleepReportViewController.h"

@interface SleepReportViewController ()


@end

@implementation SleepReportViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - custom action for UI 界面处理有关

- (void)updateDayTableViewCell {
    DailySleepModel *model = [HealthDataManager dayChartDatas:self.currentDate type:self.cellType];
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            NSInteger total = model.deep+model.light;
            if (model.isJLType){
                total += model.wake;
            }
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)total/60,HourUnit,(long)total%60,MinuteUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)model.deep/60,HourUnit,(long)model.deep%60,MinuteUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)model.light/60,HourUnit,(long)model.light%60,MinuteUnit];
        } else if (i == 3) {
            if (model.total) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.beginTime integerValue]];
                cellModel.subTitle = [date dateToStringFormat:@"HH:mm"];
            } else {
                cellModel.subTitle = @"00:00";
            }
        } else if (i == 4) {
            if (model.total) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.endTime integerValue]];
                cellModel.subTitle = [date dateToStringFormat:@"HH:mm"];
            } else {
                cellModel.subTitle = @"00:00";
            }
        } else if (i == 5) {
            if ([DHBleCentralManager isJLProtocol]){ //清醒时长
                cellModel.leftTitle = Lang(@"str_wake_timelong");
                cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)model.wake/60,HourUnit,(long)model.wake%60,MinuteUnit];
            }
            else{
                cellModel.leftTitle = Lang(@"str_wake_times");
                cellModel.subTitle = [NSString stringWithFormat:@"%ld",(long)model.wakeCount];
            }
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateWeekTableViewCell {
    NSArray *models = [HealthDataManager weekChartDatas:self.currentWeekDate type:self.cellType];
    
    NSMutableArray *totalArray = [NSMutableArray array];
    NSMutableArray *deepArray = [NSMutableArray array];
    NSMutableArray *lightArray = [NSMutableArray array];
    NSMutableArray *wakeArray = [NSMutableArray array];
    for (DailySleepModel *model in models) {
        if (model.total > 0) {
            NSInteger total = model.deep+model.light;
            [totalArray addObject:@(total)];
            [deepArray addObject:@(model.deep)];
            [lightArray addObject:@(model.light)];
            [wakeArray addObject:@(model.wakeCount)];
        }
    }
    NSInteger sumTotal = totalArray.count > 0 ? [[totalArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumDeep = deepArray.count > 0 ? [[deepArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumLight = lightArray.count > 0 ? [[lightArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumWake = wakeArray.count > 0 ? [[wakeArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    
    NSInteger avgTotal = totalArray.count > 0 ? [[totalArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgDeep = deepArray.count > 0 ? [[deepArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgLight = lightArray.count > 0 ? [[lightArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgWake = wakeArray.count > 0 ? [[wakeArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)sumTotal/60,HourUnit,(long)sumTotal%60,MinuteUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)avgTotal/60,HourUnit,(long)avgTotal%60,MinuteUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)sumDeep/60,HourUnit,(long)sumDeep%60,MinuteUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)avgDeep/60,HourUnit,(long)avgDeep%60,MinuteUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)sumLight/60,HourUnit,(long)sumLight%60,MinuteUnit];
        } else if (i == 5) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)avgLight/60,HourUnit,(long)avgLight%60,MinuteUnit];
        } else if (i == 6) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld",(long)sumWake];
        } else if (i == 7) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld",(long)avgWake];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateMonthTableViewCell {
    NSArray *models = [HealthDataManager monthChartDatas:self.currentMonthDate type:self.cellType];
    
    NSMutableArray *totalArray = [NSMutableArray array];
    NSMutableArray *deepArray = [NSMutableArray array];
    NSMutableArray *lightArray = [NSMutableArray array];
    NSMutableArray *wakeArray = [NSMutableArray array];
    for (DailySleepModel *model in models) {
        if (model.total > 0) {
            NSInteger total = model.deep+model.light;
            [totalArray addObject:@(total)];
            [deepArray addObject:@(model.deep)];
            [lightArray addObject:@(model.light)];
            [wakeArray addObject:@(model.wakeCount)];
        }
    }
    NSInteger sumTotal = totalArray.count > 0 ? [[totalArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumDeep = deepArray.count > 0 ? [[deepArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumLight = lightArray.count > 0 ? [[lightArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumWake = wakeArray.count > 0 ? [[wakeArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    
    NSInteger avgTotal = totalArray.count > 0 ? [[totalArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgDeep = deepArray.count > 0 ? [[deepArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgLight = lightArray.count > 0 ? [[lightArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgWake = wakeArray.count > 0 ? [[wakeArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)sumTotal/60,HourUnit,(long)sumTotal%60,MinuteUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)avgTotal/60,HourUnit,(long)avgTotal%60,MinuteUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)sumDeep/60,HourUnit,(long)sumDeep%60,MinuteUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)avgDeep/60,HourUnit,(long)avgDeep%60,MinuteUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)sumLight/60,HourUnit,(long)sumLight%60,MinuteUnit];
        } else if (i == 5) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)avgLight/60,HourUnit,(long)avgLight%60,MinuteUnit];
        } else if (i == 6) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld",(long)sumWake];
        } else if (i == 7) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld",(long)avgWake];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateYearTableViewCell {
    NSArray *models = [HealthDataManager yearChartDatas:self.currentYearDate type:self.cellType];
    
    NSMutableArray *totalArray = [NSMutableArray array];
    NSMutableArray *deepArray = [NSMutableArray array];
    NSMutableArray *lightArray = [NSMutableArray array];
    NSMutableArray *wakeArray = [NSMutableArray array];
    for (DailySleepModel *model in models) {
        if (model.total > 0) {
            NSInteger total = model.deep+model.light;
            [totalArray addObject:@(total)];
            [deepArray addObject:@(model.deep)];
            [lightArray addObject:@(model.light)];
            [wakeArray addObject:@(model.wakeCount)];
        }
    }
    NSInteger sumTotal = totalArray.count > 0 ? [[totalArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumDeep = deepArray.count > 0 ? [[deepArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumLight = lightArray.count > 0 ? [[lightArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    NSInteger sumWake = wakeArray.count > 0 ? [[wakeArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
    
    NSInteger avgTotal = totalArray.count > 0 ? [[totalArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgDeep = deepArray.count > 0 ? [[deepArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgLight = lightArray.count > 0 ? [[lightArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    NSInteger avgWake = wakeArray.count > 0 ? [[wakeArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
    
    NSArray *rowArray = [self.dataArray firstObject];
    for (int i = 0; i < rowArray.count; i++) {
        MWBaseCellModel *cellModel = rowArray[i];
        if (i == 0) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)sumTotal/60,HourUnit,(long)sumTotal%60,MinuteUnit];
        } else if (i == 1) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)avgTotal/60,HourUnit,(long)avgTotal%60,MinuteUnit];
        } else if (i == 2) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)sumDeep/60,HourUnit,(long)sumDeep%60,MinuteUnit];
        } else if (i == 3) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)avgDeep/60,HourUnit,(long)avgDeep%60,MinuteUnit];
        } else if (i == 4) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)sumLight/60,HourUnit,(long)sumLight%60,MinuteUnit];
        } else if (i == 5) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@%ld%@",(long)avgLight/60,HourUnit,(long)avgLight%60,MinuteUnit];
        } else if (i == 6) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld",(long)sumWake];
        } else if (i == 7) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld",(long)avgWake];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

@end
