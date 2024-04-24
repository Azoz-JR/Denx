//
//  BaseDetailViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "MWBaseController.h"
#import "DetailStepDayCell.h"
#import "DetailStepWeekCell.h"
#import "DetailSleepDayCell.h"
#import "DetailSleepWeekCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseDetailViewController : MWBaseController

/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

/// 日期类型
@property (nonatomic, assign) HealthDataType cellType;
/// 当前天
@property (nonatomic, strong) NSDate *currentDate;
/// 当前周
@property (nonatomic, strong) NSDate *currentWeekDate;
/// 当前月
@property (nonatomic, strong) NSDate *currentMonthDate;
/// 当前年
@property (nonatomic, strong) NSDate *currentYearDate;
/// 数据类型
@property (nonatomic, assign) HealthDateType dateType;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 高度数组
@property (nonatomic, strong) NSMutableArray *cellHArray;
/// 更新日列表
- (void)updateDayTableViewCell;
/// 更新周列表
- (void)updateWeekTableViewCell;
/// 更新月列表
- (void)updateMonthTableViewCell;
/// 更新年列表
- (void)updateYearTableViewCell;

@end

NS_ASSUME_NONNULL_END
