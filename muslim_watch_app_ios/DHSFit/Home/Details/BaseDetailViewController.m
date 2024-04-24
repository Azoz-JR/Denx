//
//  BaseDetailViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/8.
//

#import "BaseDetailViewController.h"
#import "BaseSelectedView.h"
#import "DateSelectedView.h"
#import "DetailHeaderView.h"
#import "DetailDescCell.h"
#import "BaseCalendarView.h"

@interface BaseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BaseSelectedViewDelegate,DateSelectedViewDelegate,BaseCalendarViewDelegate>

/// 顶部视图
@property (nonatomic, strong) BaseSelectedView *topView;
/// 日期视图
@property (nonatomic, strong) DateSelectedView *dateView;
/// 头部视图
@property (nonatomic, strong) DetailHeaderView *headerView;
/// 日历
@property (nonatomic, strong) BaseCalendarView *calendarView;
/// 头部视图高度
@property (nonatomic, assign) CGFloat headerViewH;
/// 呼吸模型
@property (nonatomic, strong) DailyBreathModel *breathModel;
/// 呼吸无数据
@property (nonatomic, strong) UILabel *breathNodataLabel;

@end

@implementation BaseDetailViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
    self.currentDate = [NSDate date];
    //监听健康数据变化
    [DHNotificationCenter addObserver:self selector:@selector(healthDataChange:) name:BluetoothNotificationHealthDataChange object:nil];
}

- (void)healthDataChange:(NSNotification *)sender {
    NSDictionary *dict = sender.userInfo;
    NSInteger type = [dict[@"type"] integerValue];

    if (self.dateType != HealthDateTypeDay || ![self.currentDate isToday]) {
        if (self.cellType == HealthDataTypeBreath) {
            self.breathModel = [HealthDataManager dayChartDatas:[NSDate date] type:self.cellType];
        }
        return;
    }
    if (type > 0) {
        type += 1;
    }
    if (self.cellType != type) {
        return;
    }
    if (self.cellType == HealthDataTypeBreath) {
        self.breathModel = [HealthDataManager dayChartDatas:[NSDate date] type:self.cellType];
    }
    
    [self updateDayChartView];
    [self updateDayCellModels];
    [self updateDayTableViewCell];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    self.headerViewH = 240;
    self.dateType = HealthDateTypeDay;
    
    if (self.cellType == HealthDataTypeStep) {
        NSArray *titles1 = [HealthDataManager detailDataCellDayTitles:self.cellType];
        NSMutableArray *sectionArray1 = [NSMutableArray array];
        for (int i = 0; i < titles1.count; i++) {
            MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
            cellModel.leftTitle = titles1[i];
            [sectionArray1 addObject:cellModel];
        }
        NSInteger cellH1 = 44*titles1.count+10;
        [self.dataArray addObject:sectionArray1];
        [self.cellHArray addObject:@(cellH1)];
        
    } else if (self.cellType == HealthDataTypeBreath) {
        
        self.breathModel = [HealthDataManager dayChartDatas:[NSDate date] type:self.cellType];
        NSMutableArray *rowArray = [NSMutableArray array];
        if (self.breathModel.items.length) {
            NSArray *array = [self.breathModel.items transToObject];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *item = array[i];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item[@"timestamp"] integerValue]];
                MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
                cellModel.leftTitle = [date dateToStringFormat:@"yyyy/MM/dd HH:mm:ss"];
                cellModel.subTitle = [NSString stringWithFormat:@"%@%@",item[@"value"],MinuteUnit];
                [rowArray addObject:cellModel];
            }
        }
        NSInteger cellH1 = 44*rowArray.count+10;
        [self.dataArray addObject:rowArray];
        [self.cellHArray addObject:@(cellH1)];
        
    } else {
        
        NSArray *titles1 = [HealthDataManager detailDataCellDayTitles:self.cellType];
        NSArray *titles2 = [HealthDataManager detailDescCellTitles:self.cellType];
        NSArray *subTitles2 = [HealthDataManager detailDescCellSubTitles:self.cellType];
        
        NSMutableArray *sectionArray1 = [NSMutableArray array];
        for (int i = 0; i < titles1.count; i++) {
            MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
            cellModel.leftTitle = titles1[i];
            [sectionArray1 addObject:cellModel];
        }
        
        
        NSMutableArray *sectionArray2 = [NSMutableArray array];
        for (int i = 0; i < titles2.count; i++) {
            MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
            cellModel.leftTitle = titles2[i];
            cellModel.subTitle = subTitles2[i];
            [sectionArray2 addObject:cellModel];
        }
        
        
        NSInteger labelH = [[titles2 lastObject] heightWithFont:HomeFont_SubTitleFont width:kScreenWidth-60];
        NSInteger cellH1 = 44*titles1.count+10;
        NSInteger cellH2 = 44*(titles2.count-1) + labelH+10+30;
        
        [self.dataArray addObject:sectionArray1];
        [self.cellHArray addObject:@(cellH1)];
        
        if (DHDeviceBinded) {
            [self.dataArray addObject:sectionArray2];
            [self.cellHArray addObject:@(cellH2)];
        }
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.offset(44);
    }];
    [self.topView setupSubViews];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.top.equalTo(self.topView.mas_bottom).offset(HomeViewSpace_Vertical);
        make.height.offset(44);
    }];
    
    if (self.cellType == HealthDataTypeBreath) {
        [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(self.dateView.mas_bottom).offset(-44+8);
            make.bottom.offset(-kBottomHeight);
        }];
    } else {
        [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(self.dateView.mas_bottom).offset(10);
            make.bottom.offset(-kBottomHeight);
        }];
    }
    
    if (self.cellType == HealthDataTypeBreath) {
        [self.myTableView addSubview:self.breathNodataLabel];
        self.breathNodataLabel.frame = CGRectMake(15, self.headerViewH, kScreenWidth-30, 44);
        NSArray *array = self.dataArray.firstObject;
        self.breathNodataLabel.hidden = array.count;
    }
}

- (void)updateTableViewTopConstraints {
    if (self.cellType == HealthDataTypeBreath) {
        if (self.dateType == HealthDateTypeDay) {
            [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.dateView.mas_bottom).offset(-44+8);
            }];
        } else {
            [self.myTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.dateView.mas_bottom).offset(10);
            }];
            
        }
    }
}

- (void)updateDayChartView {
    if (self.cellType == HealthDataTypeBreath) {
        [self.headerView updateBreathCircleView:self.breathModel];
        return;
    }
    ChartViewModel *chartModel = [HealthDataManager dayChartModel:self.currentDate type:self.cellType];
    [self.headerView updateChartView:chartModel cellType:self.cellType dateType:HealthDateTypeDay];
}

- (void)updateWeekChartView {
    ChartViewModel *chartModel = [HealthDataManager weekChartModel:self.currentWeekDate type:self.cellType];
    [self.headerView updateChartView:chartModel cellType:self.cellType dateType:HealthDateTypeWeek];
}

- (void)updateMonthChartView {
    ChartViewModel *chartModel = [HealthDataManager monthChartModel:self.currentMonthDate type:self.cellType];
    [self.headerView updateChartView:chartModel cellType:self.cellType dateType:HealthDateTypeMonth];
}

- (void)updateYearChartView {
    ChartViewModel *chartModel = [HealthDataManager yearChartModel:self.currentYearDate type:self.cellType];
    [self.headerView updateChartView:chartModel cellType:self.cellType dateType:HealthDateTypeYear];
}

- (void)updateDayCellModels {
    NSInteger count = 0;
    if (self.cellType == HealthDataTypeStep) {
        count = 5;
        NSArray *rowArray = [self.dataArray firstObject];
        if (rowArray.count != count) {
            NSArray *titles1 = [HealthDataManager detailDataCellDayTitles:self.cellType];
            NSMutableArray *sectionArray1 = [NSMutableArray array];
            for (int i = 0; i < titles1.count; i++) {
                MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
                cellModel.leftTitle = titles1[i];
                [sectionArray1 addObject:cellModel];
            }
            NSInteger cellH1 = 44*titles1.count+10;
            [self.dataArray replaceObjectAtIndex:0 withObject:sectionArray1];
            [self.cellHArray replaceObjectAtIndex:0 withObject:@(cellH1)];
            [self.myTableView reloadData];
        }
        return;
    }
    if (self.cellType == HealthDataTypeSleep) {
        count = 6;
    } else if (self.cellType == HealthDataTypeHeartRate) {
        count = 4;
    } else if (self.cellType == HealthDataTypeBP) {
        count = 6;
    } else if (self.cellType == HealthDataTypeBO) {
        count = 4;
    } else if (self.cellType == HealthDataTypeTemp) {
        count = 4;
    } else if (self.cellType == HealthDataTypeBreath) {
        if (self.breathModel.items.length) {
            NSArray *array = [self.breathModel.items transToObject];
            count = array.count;
        } else {
            count = 0;
        }
    }
    
    if (self.cellType == HealthDataTypeBreath) {
        NSMutableArray *rowArray = [NSMutableArray array];
        if (self.breathModel.items.length) {
            NSArray *array = [self.breathModel.items transToObject];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *item = array[i];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[item[@"timestamp"] integerValue]];
                MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
                cellModel.leftTitle = [date dateToStringFormat:@"yyyy/MM/dd HH:mm:ss"];
                cellModel.subTitle = [NSString stringWithFormat:@"%@%@",item[@"value"],MinuteUnit];
                [rowArray addObject:cellModel];
            }
        }
        NSInteger cellH1 = 44*rowArray.count+10;
        [self.dataArray replaceObjectAtIndex:0 withObject:rowArray];
        [self.cellHArray replaceObjectAtIndex:0 withObject:@(cellH1)];
        [self.myTableView reloadData];
        
        self.breathNodataLabel.hidden = rowArray.count;
        
    } else {
        NSArray *rowArray = [self.dataArray firstObject];
        if (rowArray.count != count) {
            NSArray *titles1 = [HealthDataManager detailDataCellDayTitles:self.cellType];
            NSMutableArray *sectionArray1 = [NSMutableArray array];
            for (int i = 0; i < titles1.count; i++) {
                MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
                cellModel.leftTitle = titles1[i];
                [sectionArray1 addObject:cellModel];
            }
            NSInteger cellH1 = 44*titles1.count+10;
            [self.dataArray replaceObjectAtIndex:0 withObject:sectionArray1];
            [self.cellHArray replaceObjectAtIndex:0 withObject:@(cellH1)];
            [self.myTableView reloadData];
        }
    }
    
}

- (void)updateWeekCellModels {
    NSInteger count = 0;
    if (self.cellType == HealthDataTypeStep) {
        count = 6;
        NSArray *rowArray = [self.dataArray firstObject];
        if (rowArray.count != count) {
            NSArray *titles1 = [HealthDataManager detailDataCellWeekTitles:self.cellType];
            NSMutableArray *sectionArray1 = [NSMutableArray array];
            for (int i = 0; i < titles1.count; i++) {
                MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
                cellModel.leftTitle = titles1[i];
                [sectionArray1 addObject:cellModel];
            }
            NSInteger cellH1 = 44*titles1.count+10;
            [self.dataArray replaceObjectAtIndex:0 withObject:sectionArray1];
            [self.cellHArray replaceObjectAtIndex:0 withObject:@(cellH1)];
            [self.myTableView reloadData];
        }
        return;
    }
    if (self.cellType == HealthDataTypeSleep) {
        count = 8;
    } else if (self.cellType == HealthDataTypeHeartRate) {
        count = 3;
    } else if (self.cellType == HealthDataTypeBP) {
        count = 5;
    } else if (self.cellType == HealthDataTypeBO) {
        count = 3;
    } else if (self.cellType == HealthDataTypeTemp) {
        count = 3;
    } else if (self.cellType == HealthDataTypeBreath) {
        count = 2;
    }
    if (self.cellType == HealthDataTypeBreath) {
        NSArray *titles1 = [HealthDataManager detailDataCellWeekTitles:self.cellType];
        NSMutableArray *sectionArray1 = [NSMutableArray array];
        for (int i = 0; i < titles1.count; i++) {
            MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
            cellModel.leftTitle = titles1[i];
            [sectionArray1 addObject:cellModel];
        }
        NSInteger cellH1 = 44*titles1.count+10;
        if (self.dataArray.count) {
            [self.dataArray replaceObjectAtIndex:0 withObject:sectionArray1];
            [self.cellHArray replaceObjectAtIndex:0 withObject:@(cellH1)];
        } else {
            [self.dataArray addObject:sectionArray1];
            [self.cellHArray addObject:@(cellH1)];
        }
        self.breathNodataLabel.hidden = YES;
        [self.myTableView reloadData];
        
    } else {
        NSArray *rowArray = [self.dataArray firstObject];
        if (rowArray.count != count) {
            NSArray *titles1 = [HealthDataManager detailDataCellWeekTitles:self.cellType];
            NSMutableArray *sectionArray1 = [NSMutableArray array];
            for (int i = 0; i < titles1.count; i++) {
                MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
                cellModel.leftTitle = titles1[i];
                [sectionArray1 addObject:cellModel];
            }
            NSInteger cellH1 = 44*titles1.count+10;
            [self.dataArray replaceObjectAtIndex:0 withObject:sectionArray1];
            [self.cellHArray replaceObjectAtIndex:0 withObject:@(cellH1)];
            [self.myTableView reloadData];
        }
    }
    
}

- (void)updateDayTableViewCell {
    
}

- (void)updateWeekTableViewCell {
    
}

- (void)updateMonthTableViewCell {
    
}

- (void)updateYearTableViewCell {
    
}

- (void)updateDateLabel {
    NSString *dateStr = @"";
    BOOL isHiddenRightButton = NO;
    if (self.dateType == HealthDateTypeDay) {
        dateStr = [self.currentDate dateToStringFormat:@"yyyy/MM/dd"];
        isHiddenRightButton = [self.currentDate isToday];
    } else if (self.dateType == HealthDateTypeWeek) {
        NSArray *dates = [self.currentWeekDate getweekBeginAndEndWithFirstDay:1];
        NSDate *beginDate = dates.firstObject;
        NSDate *endDate = dates.lastObject;
        dateStr = [NSString stringWithFormat:@"%@ - %@",[beginDate dateToStringFormat:@"yyyy/MM/dd"],[endDate dateToStringFormat:@"yyyy/MM/dd"]];
        isHiddenRightButton = [self.currentWeekDate dateIsThisWeek];
    } else if (self.dateType == HealthDateTypeMonth) {
        dateStr = [self.currentMonthDate dateToStringFormat:@"yyyy/MM"];
        isHiddenRightButton = [self.currentMonthDate dateIsThisMonth];
    } else {
        dateStr = [self.currentYearDate dateToStringFormat:@"yyyy"];
        isHiddenRightButton = self.currentYearDate.year == [NSDate date].year;
    }
    [self.dateView.dateButton setTitle:dateStr forState:UIControlStateNormal];
    self.dateView.rightButton.hidden = isHiddenRightButton;
}

#pragma mark - BaseSelectedViewDelegate

- (void)onTypeSelected:(NSInteger)index {
    if (self.dateType == index) {
        return;
    }
    self.dateType = index;
    [self updateDateLabel];
    switch (index) {
        case 0:
        {
            [self updateTableViewTopConstraints];
            [self updateDayChartView];
            [self updateDayCellModels];
            [self updateDayTableViewCell];
        }
            break;
        case 1:
        {
            if (!self.currentWeekDate) {
                self.currentWeekDate = [NSDate date];
            } else {
                [self updateTableViewTopConstraints];
                [self updateWeekChartView];
                [self updateWeekCellModels];
                [self updateWeekTableViewCell];
            }
            
        }
            break;
        case 2:
        {
            if (!self.currentMonthDate) {
                self.currentMonthDate = [NSDate date];
            } else {
                [self updateTableViewTopConstraints];
                [self updateMonthChartView];
                [self updateWeekCellModels];
                [self updateMonthTableViewCell];
            }
            
        }
            break;
        case 3:
        {
            if (!self.currentYearDate) {
                self.currentYearDate = [NSDate date];
            } else {
                [self updateTableViewTopConstraints];
                [self updateYearChartView];
                [self updateWeekCellModels];
                [self updateYearTableViewCell];
            }
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - DateSelectedViewDelegate

- (void)onYesterday {
    if (self.dateType == HealthDateTypeDay) {
        self.currentDate = [self.currentDate dateAfterDay:-1];
    } else if (self.dateType == HealthDateTypeWeek) {
        NSDate *date = [self.currentWeekDate dateAfterDay:-7];
        NSArray *dates = [date getweekBeginAndEndWithFirstDay:1];
        self.currentWeekDate = dates.firstObject;
    } else if (self.dateType == HealthDateTypeMonth) {
        NSDate *date = [self.currentMonthDate dateAfterMonth:-1];
        NSArray *dates = [date getMonthBeginAndEnd];
        self.currentMonthDate = dates.firstObject;
    } else {
        NSString *dateStr = [NSString stringWithFormat:@"%04ld0101",(long)self.currentYearDate.year-1];
        self.currentYearDate = [dateStr dateByStringFormat:@"yyyyMMdd"];
    }
    
}

- (void)onTomorrow {
    if (self.dateType == HealthDateTypeDay) {
        self.currentDate = [self.currentDate dateAfterDay:1];
    } else if (self.dateType == HealthDateTypeWeek) {
        NSDate *date = [self.currentWeekDate dateAfterDay:7];
        NSArray *dates = [date getweekBeginAndEndWithFirstDay:1];
        self.currentWeekDate = dates.firstObject;
    } else if (self.dateType == HealthDateTypeMonth) {
        NSDate *date = [self.currentMonthDate dateAfterMonth:1];
        NSArray *dates = [date getMonthBeginAndEnd];
        self.currentMonthDate = dates.firstObject;
    } else {
        NSString *dateStr = [NSString stringWithFormat:@"%04ld0101",(long)self.currentYearDate.year+1];
        self.currentYearDate = [dateStr dateByStringFormat:@"yyyyMMdd"];
    }
}

- (void)onDateSelected {
    if (self.dateType == HealthDateTypeYear) {
        return;
    }
    BaseCalendarView *calendarView = [[BaseCalendarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    calendarView.delegate = self;
    if (self.dateType == HealthDateTypeDay) {
        [calendarView showCalendar:self.currentDate isDateSelected:YES];
    } else if (self.dateType == HealthDateTypeWeek) {
        [calendarView showCalendar:self.currentWeekDate isDateSelected:YES];
    } else if (self.dateType == HealthDateTypeMonth) {
        [calendarView showCalendar:self.currentMonthDate isDateSelected:YES];
    } else {
        [calendarView showCalendar:self.currentYearDate isDateSelected:YES];
    }
    
}

#pragma mark - BaseCalendarViewDelegate

- (void)calendarDidSelectedDate:(NSDate *)date {
    if (self.dateType == HealthDateTypeDay) {
        self.currentDate = date;
    } else if (self.dateType == HealthDateTypeWeek) {
        self.currentWeekDate = date;
    } else if (self.dateType == HealthDateTypeMonth) {
        self.currentMonthDate = date;
    } else {
        self.currentYearDate = date;
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerViewH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellH = [self.cellHArray[indexPath.row] floatValue];
    return cellH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.cellType == HealthDataTypeStep && self.dateType == HealthDateTypeDay) {
            DetailStepDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailStepDayCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *rowArray = self.dataArray[indexPath.row];
            cell.models = rowArray;
            return cell;
            
        }
        if (self.cellType == HealthDataTypeStep && self.dateType != HealthDateTypeDay) {
            DetailStepWeekCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailStepWeekCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *rowArray = self.dataArray[indexPath.row];
            cell.models = rowArray;
            return cell;
            
        }
        if (self.dateType == HealthDateTypeDay) {
            DetailSleepDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSleepDayCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *rowArray = self.dataArray[indexPath.row];
            cell.models = rowArray;
            return cell;
            
        }
        DetailSleepWeekCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSleepWeekCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *rowArray = self.dataArray[indexPath.row];
        cell.models = rowArray;
        return cell;
    }
    DetailDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailDescCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *rowArray = self.dataArray[indexPath.row];
    cell.models = rowArray;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - get and set 属性的set和get方法

- (void)setCurrentDate:(NSDate *)currentDate {
    BOOL isReloadData = YES;
    if ([[currentDate dateToStringFormat:@"yyyyMMdd"] isEqualToString:[_currentDate dateToStringFormat:@"yyyyMMdd"]]) {
        isReloadData = NO;
    }
    
    _currentDate = currentDate;
    [self updateDateLabel];
    if (isReloadData) {
        [self updateDayChartView];
        [self updateDayCellModels];
        [self updateDayTableViewCell];
    }
    
}

- (void)setCurrentWeekDate:(NSDate *)currentWeekDate {
    BOOL isReloadData = YES;
    if ([currentWeekDate weekOfYear] == [_currentWeekDate weekOfYear]) {
        isReloadData = NO;
    }
    
    _currentWeekDate = currentWeekDate;
    [self updateDateLabel];
    if (isReloadData) {
        [self updateTableViewTopConstraints];
        [self updateWeekChartView];
        [self updateWeekCellModels];
        [self updateWeekTableViewCell];
    }
}

- (void)setCurrentMonthDate:(NSDate *)currentMonthDate {
    BOOL isReloadData = YES;
    if (currentMonthDate.month == _currentMonthDate.month) {
        isReloadData = NO;
    }
    
    _currentMonthDate = currentMonthDate;
    [self updateDateLabel];
    if (isReloadData) {
        [self updateTableViewTopConstraints];
        [self updateMonthChartView];
        [self updateWeekCellModels];
        [self updateMonthTableViewCell];
    }
}

- (void)setCurrentYearDate:(NSDate *)currentYearDate {
    BOOL isReloadData = YES;
    if (currentYearDate.year == _currentYearDate.year) {
        isReloadData = NO;
    }
    
    _currentYearDate = currentYearDate;
    [self updateDateLabel];
    if (isReloadData) {
        [self updateTableViewTopConstraints];
        [self updateYearChartView];
        [self updateWeekCellModels];
        [self updateYearTableViewCell];
    }
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[DetailDescCell class] forCellReuseIdentifier:@"DetailDescCell"];
        [_myTableView registerClass:[DetailStepDayCell class] forCellReuseIdentifier:@"DetailStepDayCell"];
        [_myTableView registerClass:[DetailStepWeekCell class] forCellReuseIdentifier:@"DetailStepWeekCell"];
        [_myTableView registerClass:[DetailSleepDayCell class] forCellReuseIdentifier:@"DetailSleepDayCell"];
        [_myTableView registerClass:[DetailSleepWeekCell class] forCellReuseIdentifier:@"DetailSleepWeekCell"];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (DetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.headerViewH)];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)cellHArray {
    if (!_cellHArray) {
        _cellHArray = [NSMutableArray array];
    }
    return _cellHArray;
}

- (BaseSelectedView *)topView {
    if (!_topView) {
        _topView = [[BaseSelectedView alloc] init];
        _topView.titles = @[Lang(@"str_tab_day"),
                            Lang(@"str_tab_week"),
                            Lang(@"str_tab_month"),
                            Lang(@"str_tab_year")];
        _topView.delegate = self;
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (DateSelectedView *)dateView {
    if (!_dateView) {
        _dateView = [[DateSelectedView alloc] init];
        _dateView.delegate = self;
        [self.view addSubview:_dateView];
    }
    return _dateView;
}

- (UILabel *)breathNodataLabel {
    if (!_breathNodataLabel) {
        _breathNodataLabel = [[UILabel alloc] init];
        _breathNodataLabel.backgroundColor = HomeColor_BlockColor;
        _breathNodataLabel.textColor = HomeColor_TitleColor;
        _breathNodataLabel.font = HomeFont_SubTitleFont;
        _breathNodataLabel.textAlignment = NSTextAlignmentCenter;
        _breathNodataLabel.layer.cornerRadius = 10.0;
        _breathNodataLabel.layer.masksToBounds = YES;
        _breathNodataLabel.text = Lang(@"str_no_data");
    }
    return _breathNodataLabel;
}

@end
