//
//  DrinkingSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "DrinkingSetViewController.h"

@interface DrinkingSetViewController ()<UITableViewDelegate,UITableViewDataSource,BasePickerViewDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 选择器
@property (nonatomic, strong) BasePickerView *pickerView;

#pragma mark Data
/// 模型
@property(nonatomic, strong) DrinkingSetModel *model;
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
@property (nonatomic, strong) NSMutableArray *intervalArray;
/// 是否12小时制
@property (nonatomic, assign) BOOL isHasAMPM;
/// 开关
@property (nonatomic, assign) BOOL isOpen;
/// 开始小时
@property (nonatomic, assign) NSInteger startHour;
/// 开始分钟
@property (nonatomic, assign) NSInteger startMinute;
/// 结束小时
@property (nonatomic, assign) NSInteger endHour;
/// 结束分钟
@property (nonatomic, assign) NSInteger endMinute;
/// 频率
@property (nonatomic, assign) NSInteger interval;

@end

@implementation DrinkingSetViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDrinking];
}

- (void)getDrinking {
    WEAKSELF
    [DHBleCommand getDrinking:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf saveModel:data];
        } else {
            weakSelf.model = [DrinkingSetModel currentModel];
        }
        [weakSelf initData];
        [weakSelf setupUI];
        [weakSelf addObservers];
    }];
}

- (void)saveModel:(id)data {
    DHDrinkingSetModel *model = data;
    DrinkingSetModel *drinkModel = [DrinkingSetModel currentModel];
    
    drinkModel.isOpen = model.isOpen;
    drinkModel.interval = model.interval;
    drinkModel.startHour = model.startHour;
    drinkModel.startMinute = model.startMinute;
    drinkModel.endHour = model.endHour;
    drinkModel.endMinute = model.endMinute;
    [drinkModel saveOrUpdate];
    
    self.model = drinkModel;
}

- (void)addObservers {
    //程序进入前台
    [DHNotificationCenter addObserver:self selector:@selector(handleWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    //程序进入后台
    [DHNotificationCenter addObserver:self selector:@selector(handleWillEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //状态更新
    [DHNotificationCenter addObserver:self selector:@selector(drinkingChange) name:BluetoothNotificationDrinkingChange object:nil];
}

- (void)drinkingChange {
    self.model = [DrinkingSetModel currentModel];
    self.isOpen = self.model.isOpen;
    self.startHour = self.model.startHour;
    self.startMinute = self.model.startMinute;
    self.endHour = self.model.endHour;
    self.endMinute = self.model.endMinute;
    self.interval = self.model.interval;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_drink")]) {
            cellModel.isOpen = self.isOpen;
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_warn_rate")]) {
            cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)self.interval,MinuteUnit];
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_start_time")]) {
            cellModel.subTitle = [BaseTimeModel transTimeStr:self.startHour minute:self.startMinute isHasAMPM:self.isHasAMPM];
        } else {
            cellModel.subTitle = [BaseTimeModel transTimeStr:self.endHour minute:self.endMinute isHasAMPM:self.isHasAMPM];
        }
    }
    [self.myTableView reloadData];
    
}

#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    
    DHDrinkingSetModel *model = [[DHDrinkingSetModel alloc] init];
    model.isOpen = self.isOpen;
    model.startHour = self.startHour;
    model.startMinute = self.startMinute;
    model.endHour = self.endHour;
    model.endMinute = self.endMinute;
    model.interval = self.interval;
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setDrinking:model block:^(int code, id  _Nonnull data) {
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
    
    self.model.isOpen = self.isOpen;
    self.model.startHour = self.startHour;
    self.model.startMinute = self.startMinute;
    self.model.endHour = self.endHour;
    self.model.endMinute = self.endMinute;
    self.model.interval = self.interval;
    [self.model saveOrUpdate];
    
}

- (void)initData {
    self.isHasAMPM = [BaseTimeModel isHasAMPM];
    
    self.isOpen = self.model.isOpen;
    self.startHour = self.model.startHour;
    self.startMinute = self.model.startMinute;
    self.endHour = self.model.endHour;
    self.endMinute = self.model.endMinute;
    self.interval = self.model.interval;
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_drink")]) {
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
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_start_time")]) {
            cellModel.subTitle = [BaseTimeModel transTimeStr:self.startHour minute:self.startMinute isHasAMPM:self.isHasAMPM];
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_end_time")]) {
            cellModel.subTitle = [BaseTimeModel transTimeStr:self.endHour minute:self.endMinute isHasAMPM:self.isHasAMPM];
        }
    }
    [self.myTableView reloadData];
}


- (void)showPickerView:(NSInteger)viewTag{
    self.pickerView = [[BasePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.pickerView.delegate = self;
    if (viewTag == 100) {
        NSInteger currentIndex = [self indexOfViewTag:viewTag];
        [self.pickerView setupPickerView:@[self.intervalArray] unitStr:@"" viewTag:viewTag];
        [self.pickerView updateSelectRow:currentIndex inComponent:0];
    } else if (viewTag == 101) {
        if (self.isHasAMPM) {
            [self.pickerView setupPickerView:@[self.splitArray, self.hourArray,self.minuteArray] unitStr:@"" viewTag:viewTag];
            
            NSInteger splitIndex = [BaseTimeModel timeSplitIndex:self.startHour];
            NSInteger hourIndex = [BaseTimeModel timeHourIndex:self.startHour];
            [self.pickerView updateSelectRow:splitIndex inComponent:0];
            [self.pickerView updateSelectRow:hourIndex inComponent:1];
            [self.pickerView updateSelectRow:self.startMinute inComponent:2];
        } else {
            [self.pickerView setupPickerView:@[self.hourArray,self.minuteArray] unitStr:@"" viewTag:viewTag];
            [self.pickerView updateSelectRow:self.startHour inComponent:0];
            [self.pickerView updateSelectRow:self.startMinute inComponent:1];
        }
    } else if (viewTag == 102){
        if (self.isHasAMPM) {
            [self.pickerView setupPickerView:@[self.splitArray, self.hourArray,self.minuteArray] unitStr:@"" viewTag:viewTag];
            
            NSInteger splitIndex = [BaseTimeModel timeSplitIndex:self.endHour];
            NSInteger hourIndex = [BaseTimeModel timeHourIndex:self.endHour];
            [self.pickerView updateSelectRow:splitIndex inComponent:0];
            [self.pickerView updateSelectRow:hourIndex inComponent:1];
            [self.pickerView updateSelectRow:self.endMinute inComponent:2];
        } else {
            [self.pickerView setupPickerView:@[self.hourArray,self.minuteArray] unitStr:@"" viewTag:viewTag];
            [self.pickerView updateSelectRow:self.endHour inComponent:0];
            [self.pickerView updateSelectRow:self.endMinute inComponent:1];
        }
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_drink")]) {
        return;
    }
    [self showPickerView:99+indexPath.row];
}

#pragma mark - BasePickerViewDelegate

- (void)basePickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}


- (void)basePickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger row = [pickerView selectedRowInComponent:0];
    MWBaseCellModel *cellModel = self.dataArray[viewTag-99];
    if (viewTag == 100) {
       //频率
       self.interval = [self.intervalArray[row] integerValue];
       cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)self.interval,MinuteUnit];
   } else if (viewTag == 101) {
        //开始时间
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        if (self.isHasAMPM) {
            NSInteger row2 = [pickerView selectedRowInComponent:2];
            self.startHour = [BaseTimeModel transHour:row1 splitIndex:row];
            self.startMinute = [self.minuteArray[row2] integerValue];
        } else {
            self.startHour = [self.hourArray[row] integerValue];
            self.startMinute = [self.minuteArray[row1] integerValue];
        }
        cellModel.subTitle = [BaseTimeModel transTimeStr:self.startHour minute:self.startMinute isHasAMPM:self.isHasAMPM];
    } else if (viewTag == 102) {
        //结束时间
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        if (self.isHasAMPM) {
            NSInteger row2 = [pickerView selectedRowInComponent:2];
            self.endHour = [BaseTimeModel transHour:row1 splitIndex:row];
            self.endMinute = [self.minuteArray[row2] integerValue];
        } else {
            self.endHour = [self.hourArray[row] integerValue];
            self.endMinute = [self.minuteArray[row1] integerValue];
        }
        cellModel.subTitle = [BaseTimeModel transTimeStr:self.endHour minute:self.endMinute isHasAMPM:self.isHasAMPM];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewTag-99 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)indexOfViewTag:(NSInteger)viewTag {
    if ([self.intervalArray indexOfObject:@(self.interval)] == NSNotFound) {
        return 0;
    }
    return [self.intervalArray indexOfObject:@(self.interval)];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_drink"),
                    Lang(@"str_warn_rate"),
                    Lang(@"str_start_time"),
                    Lang(@"str_end_time")];
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"",
                       [NSString stringWithFormat:@"%ld%@",(long)self.interval,MinuteUnit],
                       [BaseTimeModel transTimeStr:self.startHour minute:self.startMinute isHasAMPM:self.isHasAMPM],
                       [BaseTimeModel transTimeStr:self.endHour minute:self.endMinute isHasAMPM:self.isHasAMPM],
                       ];
        
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

- (NSMutableArray *)intervalArray {
    if (!_intervalArray) {
        _intervalArray = [NSMutableArray array];
        if ([DHBleCentralManager isJLProtocol]){
            for (int i = 1; i <= 12; i++) {
                [_intervalArray addObject:@(i*15)];
            }
        }
        else{
            for (int i = 1; i <= 12; i++) {
                [_intervalArray addObject:@(i*30)];
            }
        }
    }
    return _intervalArray;
}

@end
