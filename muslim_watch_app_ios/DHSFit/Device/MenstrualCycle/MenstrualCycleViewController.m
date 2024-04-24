//
//  MenstrualCycleViewController.m
//  DHSFit
//
//  Created by DHS on 2022/11/5.
//

#import "MenstrualCycleViewController.h"
#import "MenstrualRemindViewController.h"
#import "MWPickerViewController.h"

@interface MenstrualCycleViewController ()<UITableViewDelegate,UITableViewDataSource,MenstrualRemindViewControllerDelegate,BasePickerViewDelegate,MWPickerViewControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 选择器
@property (nonatomic, strong) BasePickerView *pickerView;

#pragma mark Data
/// 模型
@property(nonatomic, strong) MenstrualCycleSetModel *model;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// 小标题
@property (nonatomic, strong) NSArray *subTitles;

/// 小时数组
@property (nonatomic, strong) NSMutableArray *hourArray;
/// 分钟数组
@property (nonatomic, strong) NSMutableArray *minuteArray;
/// AMPM
@property (nonatomic, strong) NSArray *splitArray;

/// 频率数组
@property (nonatomic, strong) NSMutableArray *cycleArray;
/// 频率数组
@property (nonatomic, strong) NSMutableArray *menstrualArray;
//经期天数
@property (nonatomic, strong) NSMutableArray *menstrualBeforeDayArray;

/// 是否12小时制
@property (nonatomic, assign) BOOL isHasAMPM;

/// 开关（0.关 1.开）
@property (nonatomic, assign) BOOL isOpen;
/// 经期提醒开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindMenstrualPeriod;
/// 排卵期提醒开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindOvulationPeriod;
/// 排卵高峰开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindOvulationPeak;
/// 排卵期结束开关（0.关 1.开）
@property (nonatomic, assign) BOOL isRemindOvulationEnd;

/// 周期天数（15-60）
@property (nonatomic, assign) NSInteger cycleDays;
/// 经期天数（3-15）
@property (nonatomic, assign) NSInteger menstrualDays;

/// 开始年
@property (nonatomic, assign) NSInteger startYear;
/// 开始月（1-12）
@property (nonatomic, assign) NSInteger startMonth;
/// 开始日（1-31）
@property (nonatomic, assign) NSInteger startDay;

/// 提醒时间小时（0-23）
@property (nonatomic, assign) NSInteger remindHour;
/// 提醒时间分钟（0-59）
@property (nonatomic, assign) NSInteger remindMinute;

@property (nonatomic, assign) NSInteger jlRemindBeforeDay;//经期提醒,提前0~15天
@property (nonatomic, assign) NSInteger jlRemindOvulationBeforeDay;//排卵期提醒,提前0~15天

/// 年数据源
@property (nonatomic, strong) NSMutableArray *birthYears;
/// 月数据源
@property (nonatomic, strong) NSMutableArray *birthMonths;
/// 日数据源
@property (nonatomic, strong) NSMutableArray *birthDays;
/// 当前年
@property (nonatomic, assign) NSInteger currentYear;
/// 当前月
@property (nonatomic, assign) NSInteger currentMonth;
/// 选择器
@property (nonatomic, strong) MWPickerViewController *pickerVC;

@end

@implementation MenstrualCycleViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self getMenstrualCycle];
}

- (void)getMenstrualCycle {
    WEAKSELF
    [DHBleCommand getMenstrualCycle:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf saveModel:data];
        } else {
            weakSelf.model = [MenstrualCycleSetModel currentModel];
        }
        [weakSelf initData];
        [weakSelf setupUI];
        [weakSelf addObservers];
    }];
}

- (void)saveModel:(id)data {
    DHMenstrualCycleSetModel *model = data;
    MenstrualCycleSetModel *menstrualModel = [MenstrualCycleSetModel currentModel];
    
    menstrualModel.type = model.type;
    menstrualModel.isOpen = model.isOpen;
    menstrualModel.isRemindMenstrualPeriod = model.isRemindMenstrualPeriod;
    menstrualModel.isRemindOvulationPeriod = model.isRemindOvulationPeriod;
    menstrualModel.isRemindOvulationPeak = model.isRemindOvulationPeak;
    menstrualModel.isRemindOvulationEnd = model.isRemindOvulationEnd;
    
    menstrualModel.cycleDays = model.cycleDays;
    menstrualModel.menstrualDays = model.menstrualDays;
    
    menstrualModel.timestamp = model.timestamp;
    menstrualModel.remindHour = model.remindHour;
    menstrualModel.remindMinute = model.remindMinute;
    
    menstrualModel.jlRemindBeforeDay = model.jlRemindBeforeDay;
    menstrualModel.jlRemindOvulationBeforeDay = model.jlRemindOvulationBeforeDay;
    
    [menstrualModel saveOrUpdate];
    
    self.model = menstrualModel;
}

- (void)addObservers {
    //程序进入前台
    [DHNotificationCenter addObserver:self selector:@selector(handleWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    //程序进入后台
    [DHNotificationCenter addObserver:self selector:@selector(handleWillEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    
    DHMenstrualCycleSetModel *model = [[DHMenstrualCycleSetModel alloc] init];
    model.type = 1;
    model.isOpen = self.isOpen;
    model.isRemindMenstrualPeriod = self.isRemindMenstrualPeriod;
    model.isRemindOvulationPeriod = self.isRemindOvulationPeriod;
    model.isRemindOvulationPeak = self.isRemindOvulationPeak;
    model.isRemindOvulationEnd = self.isRemindOvulationEnd;
    
    model.cycleDays = self.cycleDays;
    model.menstrualDays = self.menstrualDays;
    
    NSString *date = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)self.startYear,(long)self.startMonth,(long)self.startDay];
    model.timestamp = [[NSDate get1970timeTempWithDateStr:date] integerValue];
    model.remindHour = self.remindHour;
    model.remindMinute = self.remindMinute;
    
    model.jlRemindBeforeDay = self.jlRemindBeforeDay;
    model.jlRemindOvulationBeforeDay = self.jlRemindOvulationBeforeDay;

    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setMenstrualCycle:model block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            SHOWHUD(Lang(@"str_save_success"))
            [weakSelf saveModel];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            SHOWHUD(Lang(@"str_save_fail"))
        }
    }];
}

- (void)saveModel {
    self.model.type = 1;
    self.model.isOpen = self.isOpen;
    self.model.isRemindMenstrualPeriod = self.isRemindMenstrualPeriod;
    self.model.isRemindOvulationPeriod = self.isRemindOvulationPeriod;
    self.model.isRemindOvulationPeak = self.isRemindOvulationPeak;
    self.model.isRemindOvulationEnd = self.isRemindOvulationEnd;
    
    self.model.cycleDays = self.cycleDays;
    self.model.menstrualDays = self.menstrualDays;
    
    NSString *date = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)self.startYear,(long)self.startMonth,(long)self.startDay];
    self.model.timestamp = [[NSDate get1970timeTempWithDateStr:date] integerValue];
    self.model.remindHour = self.remindHour;
    self.model.remindMinute = self.remindMinute;
    
    self.model.jlRemindBeforeDay = self.jlRemindBeforeDay;
    self.model.jlRemindOvulationBeforeDay = self.jlRemindOvulationBeforeDay;
    
    [self.model saveOrUpdate];
}

- (void)initData {
    self.isHasAMPM = [BaseTimeModel isHasAMPM];
    
    self.isOpen = self.model.isOpen;
    self.isRemindMenstrualPeriod = self.model.isRemindMenstrualPeriod;
    self.isRemindOvulationPeriod = self.model.isRemindOvulationPeriod;
    self.isRemindOvulationPeak = self.model.isRemindOvulationPeak;
    self.isRemindOvulationEnd = self.model.isRemindOvulationEnd;
    
    self.cycleDays = self.model.cycleDays;
    self.menstrualDays = self.model.menstrualDays;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.timestamp];
    self.startYear = date.year;
    self.startMonth = date.month;
    self.startDay = date.day;
    self.remindHour = self.model.remindHour;
    self.remindMinute = self.model.remindMinute;
    
    self.jlRemindBeforeDay = self.model.jlRemindBeforeDay;
    self.jlRemindOvulationBeforeDay= self.model.jlRemindOvulationBeforeDay;
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_menstrual_cycle_reminder")]) {
            cellModel.isHideArrow = YES;
            cellModel.isHideSwitch = NO;
            cellModel.isOpen = self.isOpen;
        } else {
            cellModel.subTitle = self.subTitles[i];
        }
        
        [self.dataArray addObject:cellModel];
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
}

- (void)switchViewValueChanged:(UISwitch *)sender {
    self.isOpen = sender.isOn;
    MWBaseCellModel *cellModel = [self.dataArray firstObject];
    cellModel.isOpen = self.isOpen;
    
    [self.myTableView reloadData];
}

- (void)handleWillEnterForeground {
    if ([BaseTimeModel isHasAMPM] != self.isHasAMPM) {
        self.isHasAMPM = [BaseTimeModel isHasAMPM];
        [self updateTimeData];
        
    }
}

- (void)handleWillEnterBackground {
    if (self.pickerView) {
        [self.pickerView hideCustomPickerView];
    }
}

- (void)updateTimeData {
    self.hourArray = [NSMutableArray array];
    int minHour = self.isHasAMPM ? 1 : 0;
    int maxHour = self.isHasAMPM ? 13 : 24;
    for (int i = minHour; i < maxHour; i++) {
        [self.hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_remind_time")]) {
            cellModel.subTitle = [BaseTimeModel transTimeStr:self.remindHour minute:self.remindMinute isHasAMPM:self.isHasAMPM];
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)showPickerView:(NSInteger)viewTag{
    self.pickerView = [[BasePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.pickerView.delegate = self;
    if (viewTag == 100) {
        NSInteger currentIndex = [self indexOfViewTag:viewTag];
        [self.pickerView setupPickerView:@[self.cycleArray] unitStr:@"" viewTag:viewTag];
        [self.pickerView updateSelectRow:currentIndex inComponent:0];
    } else if (viewTag == 101) {
        NSInteger currentIndex = [self indexOfViewTag:viewTag];
        [self.pickerView setupPickerView:@[self.menstrualArray] unitStr:@"" viewTag:viewTag];
        [self.pickerView updateSelectRow:currentIndex inComponent:0];
    }else if (viewTag == 105) { //经期天数
        NSInteger currentIndex = [self indexOfViewTag:viewTag];
        [self.pickerView setupPickerView:@[self.menstrualBeforeDayArray] unitStr:@"" viewTag:viewTag];
        [self.pickerView updateSelectRow:currentIndex inComponent:0];
    }else if (viewTag == 106) {//排卵期提醒
        NSInteger currentIndex = [self indexOfViewTag:viewTag];
        [self.pickerView setupPickerView:@[self.menstrualBeforeDayArray] unitStr:@"" viewTag:viewTag];
        [self.pickerView updateSelectRow:currentIndex inComponent:0];
    } else if (viewTag == 104){
        if (self.isHasAMPM) {
            [self.pickerView setupPickerView:@[self.splitArray, self.hourArray,self.minuteArray] unitStr:@"" viewTag:viewTag];
            
            NSInteger splitIndex = [BaseTimeModel timeSplitIndex:self.remindHour];
            NSInteger hourIndex = [BaseTimeModel timeHourIndex:self.remindHour];
            [self.pickerView updateSelectRow:splitIndex inComponent:0];
            [self.pickerView updateSelectRow:hourIndex inComponent:1];
            [self.pickerView updateSelectRow:self.remindMinute inComponent:2];
        } else {
            [self.pickerView setupPickerView:@[self.hourArray,self.minuteArray] unitStr:@"" viewTag:viewTag];
            [self.pickerView updateSelectRow:self.remindHour inComponent:0];
            [self.pickerView updateSelectRow:self.remindMinute inComponent:1];
        }
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.isOpen) {
        return 1;
    }
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MWBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWBaseTableCell" forIndexPath:indexPath];
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    if (!cellModel.isHideSwitch) {
        [cell.switchView addTarget:self action:@selector(switchViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_menstrual_cycle_reminder")]) {
        return;
    }
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_warn_model")]) {
        //跳转子页面
        MenstrualRemindViewController *vc = [[MenstrualRemindViewController alloc] init];
        vc.isHideNavRightButton = NO;
        vc.navTitle = cellModel.leftTitle;
        vc.delegate = self;
        vc.isRemindMenstrualPeriod = self.isRemindMenstrualPeriod;
        vc.isRemindOvulationPeriod = self.isRemindOvulationPeriod;
        vc.isRemindOvulationPeak = self.isRemindOvulationPeak;
        vc.isRemindOvulationEnd = self.isRemindOvulationEnd;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_menstrual_last_time")]) {
        //跳转子页面
        NSInteger yearIndex = [self.birthYears indexOfObject:[NSString stringWithFormat:@"%ld",(long)self.startYear]];
        NSInteger monthIndex = [self.birthMonths indexOfObject:[NSString stringWithFormat:@"%02ld",(long)self.startMonth]];
        NSInteger dayIndex = [self.birthDays indexOfObject:[NSString stringWithFormat:@"%02ld",(long)self.startDay]];
        self.pickerVC.dataArray = @[self.birthYears,self.birthMonths,self.birthDays];
        self.pickerVC.selectedRows = @[@(yearIndex),@(monthIndex),@(dayIndex)];
        
        self.currentYear = self.startYear;
        self.currentMonth = self.startMonth;
        [self delayPerformBlock:^(id  _Nonnull object) {
            [self resetDateArrayWithComponent:100 andRow:0];
        } WithTime:0.5];
        [self.navigationController pushViewController:self.pickerVC animated:YES];
        return;
    }
    
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_remind_time")]) { //提醒时间
        [self showPickerView:104];
        return;
    }
    
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_remind_menstrual_period")]) {
        [self showPickerView:105];
        return;
    }
    
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_remind_ovulation_period")]) {
        [self showPickerView:106];
        return;
    }
    
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_cycle_days")]) {
        [self showPickerView:100];
        return;
    }
    
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_menstrual_days")]) {
        [self showPickerView:101];
        return;
    }
    
//    [self showPickerView:99+indexPath.row];
}

- (void)resetDateArrayWithComponent:(NSInteger)component andRow:(NSInteger)row {
    NSMutableArray *monthArray = [NSMutableArray array];
    NSMutableArray *dayArray = [NSMutableArray array];
    
    int daynum = 31;
    NSDate *date = [NSDate date];
    
    if (component == 0) {
        self.currentYear = [self.birthYears[row] integerValue];
    } else if (component == 1) {
        self.currentMonth = [self.birthMonths[row] integerValue];
    }
    
    BOOL isLeapYear = (((self.currentYear%4 == 0)&&(self.currentYear%100 != 0))||(self.currentYear%400 == 0));
    
    if (self.currentYear == date.year) {
        for (int i = 1; i <= date.month; i++) {
            [monthArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        if (self.currentMonth > date.month) {
            self.currentMonth = date.month;
        }
    } else {
        for (int i = 1; i <= 12; i++) {
            [monthArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    
    if (self.currentYear == date.year && self.currentMonth == date.month) {
        daynum = (int)date.day;
    }
    else{
        switch (self.currentMonth-1) {
            case 1:
                if (isLeapYear) {
                    daynum = 29;
                }else {
                    daynum = 28;
                }
                break;
            case 3:
            case 5:
            case 8:
            case 10:
                daynum = 30;
                break;
            case 0:
            case 2:
            case 4:
            case 6:
            case 7:
            case 9:
            case 11:
                daynum = 31;
                break;
            default:
                break;
        }
    }
    for (int i = 1; i <= daynum; i++) {
        [dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    self.birthMonths = monthArray;
    self.birthDays = dayArray;
    
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:self.birthYears];
    [dataArray addObject:monthArray];
    [dataArray addObject:dayArray];
    
    [self.pickerVC reloadAllComponents:dataArray];
}

#pragma mark - BasePickerViewControllerDelegate

- (void)customPickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    if (component == 0) {
        self.currentYear = [self.birthYears[row] integerValue];
    } else if (component == 1) {
        self.currentMonth = [self.birthMonths[row] integerValue];
    }
    if (component != 2) {
        [self resetDateArrayWithComponent:component andRow:row];
    }
}

- (void)customPickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    
    NSInteger tViewTagIndex = viewTag - 99;
    if (viewTag == 104){
        tViewTagIndex = self.dataArray.count - 1;
    }
    else if (viewTag == 105){
        tViewTagIndex = 4;
    }
    else if (viewTag == 106){
        tViewTagIndex = 5;
    }
    NSInteger row = [pickerView selectedRowInComponent:0];
    MWBaseCellModel *cellModel = self.dataArray[tViewTagIndex];
     
    NSInteger row1 = [pickerView selectedRowInComponent:1];
    NSInteger row2 = [pickerView selectedRowInComponent:2];
    self.startYear = [self.birthYears[row] integerValue];
    self.startMonth = [self.birthMonths[row1] integerValue];
    self.startDay = [self.birthDays[row2] integerValue];
    cellModel.subTitle = [NSString stringWithFormat:@"%04ld/%02ld/%02ld",(long)self.startYear,(long)self.startMonth,(long)self.startDay];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tViewTagIndex inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - BasePickerViewDelegate

- (void)basePickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}


- (void)basePickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger tViewTagIndex = viewTag - 99;
    if (viewTag == 104){
        tViewTagIndex = self.dataArray.count - 1;
    }
    else if (viewTag == 105){
        tViewTagIndex = 4;
    }
    else if (viewTag == 106){
        tViewTagIndex = 5;
    }
    
    NSInteger row = [pickerView selectedRowInComponent:0];
    MWBaseCellModel *cellModel = self.dataArray[tViewTagIndex];
    if (viewTag == 100) {
       //周期天数
       self.cycleDays = [self.cycleArray[row] integerValue];
       cellModel.subTitle = [NSString stringWithFormat:@"%ld %@",(long)self.cycleDays, Lang(@"str_remind_unit_day")];
   } else if (viewTag == 101) {
        //经期天数
       self.menstrualDays = [self.menstrualArray[row] integerValue];
       cellModel.subTitle = [NSString stringWithFormat:@"%ld %@",(long)self.menstrualDays, Lang(@"str_remind_unit_day")];
   }else if (viewTag == 105) {
       //经期提醒
      self.jlRemindBeforeDay = [self.menstrualBeforeDayArray[row] integerValue];
      cellModel.subTitle = [NSString stringWithFormat:@"%ld %@",(long)self.jlRemindBeforeDay, Lang(@"str_remind_unit_beforeday")];
  }else if (viewTag == 106) {
      //排卵期提醒
     self.jlRemindOvulationBeforeDay = [self.menstrualBeforeDayArray[row] integerValue];
     cellModel.subTitle = [NSString stringWithFormat:@"%ld %@",(long)self.jlRemindOvulationBeforeDay, Lang(@"str_remind_unit_beforeday")];
 } else if (viewTag == 104) {
        //结束时间
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        if (self.isHasAMPM) {
            NSInteger row2 = [pickerView selectedRowInComponent:2];
            self.remindHour = [BaseTimeModel transHour:row1 splitIndex:row];
            self.remindMinute = [self.minuteArray[row2] integerValue];
        } else {
            self.remindHour = [self.hourArray[row] integerValue];
            self.remindMinute = [self.minuteArray[row1] integerValue];
        }
        cellModel.subTitle = [BaseTimeModel transTimeStr:self.remindHour minute:self.remindMinute isHasAMPM:self.isHasAMPM];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tViewTagIndex inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)indexOfViewTag:(NSInteger)viewTag {
    if (viewTag == 100) {
        if ([self.cycleArray indexOfObject:@(self.cycleDays)] == NSNotFound) {
            return 0;
        }
        return [self.cycleArray indexOfObject:@(self.cycleDays)];
    }
    if (viewTag == 105){
        if ([self.menstrualBeforeDayArray indexOfObject:@(self.jlRemindBeforeDay)] == NSNotFound) {
            return 0;
        }
        return [self.menstrualBeforeDayArray indexOfObject:@(self.jlRemindBeforeDay)];
    }
    if (viewTag == 106){
        if ([self.menstrualBeforeDayArray indexOfObject:@(self.jlRemindOvulationBeforeDay)] == NSNotFound) {
            return 0;
        }
        return [self.menstrualBeforeDayArray indexOfObject:@(self.jlRemindOvulationBeforeDay)];
    }
    if ([self.menstrualArray indexOfObject:@(self.menstrualDays)] == NSNotFound) {
        return 0;
    }
    return [self.menstrualArray indexOfObject:@(self.menstrualDays)];
}

#pragma mark - MenstrualRemindViewControllerDelegate

- (void)menstrualRemindChange:(BOOL)isRemindMenstrualPeriod OvulationPeriod:(BOOL)isRemindOvulationPeriod OvulationPeak:(BOOL)isRemindOvulationPeak OvulationEnd:(BOOL)isRemindOvulationEnd {
    self.isRemindMenstrualPeriod = isRemindMenstrualPeriod;
    self.isRemindOvulationPeriod = isRemindOvulationPeriod;
    self.isRemindOvulationPeak = isRemindOvulationPeak;
    self.isRemindOvulationEnd = isRemindOvulationEnd;
    
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = 60;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[MWBaseTableCell class] forCellReuseIdentifier:@"MWBaseTableCell"];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (MWPickerViewController *)pickerVC {
    if (!_pickerVC) {
        _pickerVC = [[MWPickerViewController alloc] init];
        _pickerVC.navTitle = Lang(@"str_menstrual_last_time");
        _pickerVC.isHideNavRightButton = YES;
        _pickerVC.delegate = self;
        _pickerVC.viewTag = 102;
    }
    return _pickerVC;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)titles {
    if (!_titles) {
        if ([DHBleCentralManager isJLProtocol]){
            _titles = @[Lang(@"str_menstrual_cycle_reminder"),
                        Lang(@"str_cycle_days"),
                        Lang(@"str_menstrual_days"),
                        Lang(@"str_menstrual_last_time"),
                        Lang(@"str_remind_menstrual_period"),
                        Lang(@"str_remind_ovulation_period"),
                        Lang(@"str_remind_time")];
        }
        else{
            _titles = @[Lang(@"str_menstrual_cycle_reminder"),
                        Lang(@"str_cycle_days"),
                        Lang(@"str_menstrual_days"),
                        Lang(@"str_menstrual_last_time"),
                        Lang(@"str_warn_model"),
                        Lang(@"str_remind_time")];
        }
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        if ([DHBleCentralManager isJLProtocol]){
            _subTitles = @[@"",
                           [NSString stringWithFormat:@"%ld %@",(long)self.cycleDays, Lang(@"str_remind_unit_day")],
                           [NSString stringWithFormat:@"%ld %@",(long)self.menstrualDays, Lang(@"str_remind_unit_day")],
                           [NSString stringWithFormat:@"%02ld/%02ld/%02ld",(long)self.startYear,(long)self.startMonth,(long)self.startDay],
                           [NSString stringWithFormat:@"%ld %@",(long)self.jlRemindBeforeDay, Lang(@"str_remind_unit_beforeday")],
                           [NSString stringWithFormat:@"%ld %@",(long)self.jlRemindOvulationBeforeDay, Lang(@"str_remind_unit_beforeday")],
                           [BaseTimeModel transTimeStr:self.remindHour minute:self.remindMinute isHasAMPM:self.isHasAMPM],
            ];
        }
        else{
            _subTitles = @[@"",
                           [NSString stringWithFormat:@"%ld %@",(long)self.cycleDays, Lang(@"str_remind_unit_day")],
                           [NSString stringWithFormat:@"%ld %@",(long)self.menstrualDays, Lang(@"str_remind_unit_day")],
                           [NSString stringWithFormat:@"%02ld/%02ld/%02ld",(long)self.startYear,(long)self.startMonth,(long)self.startDay],
                           @"",
                           [BaseTimeModel transTimeStr:self.remindHour minute:self.remindMinute isHasAMPM:self.isHasAMPM],
            ];
        }
        
    }
    return _subTitles;
}

- (NSArray *)splitArray {
    if (!_splitArray) {
        _splitArray = @[@"AM",
                        @"PM"];
    }
    return _splitArray;
}

- (NSMutableArray *)hourArray {
    if (!_hourArray) {
        _hourArray = [NSMutableArray array];
        int minHour = self.isHasAMPM ? 1 : 0;
        int maxHour = self.isHasAMPM ? 13 : 24;
        for (int i = minHour; i < maxHour; i++) {
            [_hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _hourArray;
}

- (NSMutableArray *)minuteArray {
    if (!_minuteArray) {
        _minuteArray = [NSMutableArray array];
        for (int i = 0; i < 60; i++) {
            [_minuteArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _minuteArray;
}

- (NSMutableArray *)cycleArray {
    if (!_cycleArray) {
        _cycleArray = [NSMutableArray array];
        for (int i = 15; i <= 60; i++) {
            [_cycleArray addObject:@(i)];
        }
    }
    return _cycleArray;
}

- (NSMutableArray *)menstrualArray {
    if (!_menstrualArray) {
        _menstrualArray = [NSMutableArray array];
        for (int i = 3; i <= 15; i++) {
            [_menstrualArray addObject:@(i)];
        }
    }
    return _menstrualArray;
}

- (NSMutableArray *)menstrualBeforeDayArray {
    if (!_menstrualBeforeDayArray) {
        _menstrualBeforeDayArray = [NSMutableArray array];
        for (int i = 0; i <= 15; i++) {
            [_menstrualBeforeDayArray addObject:@(i)];
        }
    }
    return _menstrualBeforeDayArray;
}

- (NSMutableArray *)birthYears {
    if (!_birthYears) {
        _birthYears = [NSMutableArray array];
        for (int i = 1900; i <= [NSDate date].year; i++) {
            [_birthYears addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _birthYears;
}

- (NSMutableArray *)birthMonths {
    if (!_birthMonths) {
        _birthMonths = [NSMutableArray array];
        for (int i = 1; i <= 12; i++) {
            [_birthMonths addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _birthMonths;
}

- (NSMutableArray *)birthDays {
    if (!_birthDays) {
        _birthDays = [NSMutableArray array];
        for (int i = 1; i <= 31; i++) {
            [_birthDays addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _birthDays;
}

@end
