//
//  DisturbModeSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "DisturbModeSetViewController.h"

@interface DisturbModeSetViewController ()<UITableViewDelegate,UITableViewDataSource,BasePickerViewDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 选择器
@property (nonatomic, strong) BasePickerView *pickerView;
/// 底部视图
@property (nonatomic, strong) UIView *footerView;
/// 底部高度
@property (nonatomic, assign) CGFloat footerViewH;


#pragma mark Data
/// 模型
@property(nonatomic, strong) DisturbModeSetModel *model;
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
/// 是否12小时制
@property (nonatomic, assign) BOOL isHasAMPM;
/// 开关
@property (nonatomic, assign) BOOL isOpen;
/// 全天开关
@property (nonatomic, assign) BOOL isAllday;
/// 开始小时
@property (nonatomic, assign) NSInteger startHour;
/// 开始分钟
@property (nonatomic, assign) NSInteger startMinute;
/// 结束小时
@property (nonatomic, assign) NSInteger endHour;
/// 结束分钟
@property (nonatomic, assign) NSInteger endMinute;

@end

@implementation DisturbModeSetViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDisturbMode];
}

- (void)getDisturbMode {
    WEAKSELF
    [DHBleCommand getDisturbMode:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf saveModel:data];
        } else {
            weakSelf.model = [DisturbModeSetModel currentModel];
        }
        [weakSelf initData];
        [weakSelf setupUI];
        [weakSelf addObservers];
    }];
}

- (void)saveModel:(id)data {
    DHDisturbModeSetModel *model = data;
    DisturbModeSetModel *disturbModel = [DisturbModeSetModel currentModel];
    
    disturbModel.isOpen = model.isOpen;
    disturbModel.isAllday = model.isAllday;
    disturbModel.startHour = model.startHour;
    disturbModel.startMinute = model.startMinute;
    disturbModel.endHour = model.endHour;
    disturbModel.endMinute = model.endMinute;
    [disturbModel saveOrUpdate];
    
    self.model = disturbModel;
}


- (void)addObservers {
    //程序进入前台
    [DHNotificationCenter addObserver:self selector:@selector(handleWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    //程序进入后台
    [DHNotificationCenter addObserver:self selector:@selector(handleWillEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //状态更新
    [DHNotificationCenter addObserver:self selector:@selector(disturbModeChange) name:BluetoothNotificationDisturbModeChange object:nil];
}

- (void)disturbModeChange {
    self.model = [DisturbModeSetModel currentModel];
    self.isOpen = self.model.isOpen;
    self.isAllday = self.model.isAllday;
    self.startHour = self.model.startHour;
    self.startMinute = self.model.startMinute;
    self.endHour = self.model.endHour;
    self.endMinute = self.model.endMinute;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_do_not_disturb_allday")]) {
            cellModel.isOpen = self.isAllday;
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_do_not_disturb_timing")]) {
            cellModel.isOpen = self.isOpen;
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
    
    DHDisturbModeSetModel *model = [[DHDisturbModeSetModel alloc] init];
    model.isOpen = self.isOpen;
    model.isAllday = self.isAllday;
    model.startHour = self.startHour;
    model.startMinute = self.startMinute;
    model.endHour = self.endHour;
    model.endMinute = self.endMinute;
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setDisturbMode:model block:^(int code, id  _Nonnull data) {
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
    self.model.isAllday = self.isAllday;
    self.model.startHour = self.startHour;
    self.model.startMinute = self.startMinute;
    self.model.endHour = self.endHour;
    self.model.endMinute = self.endMinute;
    [self.model saveOrUpdate];
}

- (void)initData {
    
    self.footerViewH = round([UILabel getLabelheight:Lang(@"str_no_disturb_tips") width:kScreenWidth-30 font:HomeFont_ContentFont])+5;
    
    self.isHasAMPM = [BaseTimeModel isHasAMPM];
    
    self.isOpen = self.model.isOpen;
    self.isAllday = self.model.isAllday;
    self.startHour = self.model.startHour;
    self.startMinute = self.model.startMinute;
    self.endHour = self.model.endHour;
    self.endMinute = self.model.endMinute;
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_do_not_disturb_allday")]) {
            cellModel.isHideArrow = YES;
            cellModel.isHideSwitch = NO;
            cellModel.isOpen = self.isAllday;
            cellModel.switchViewTag = 1000;
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_do_not_disturb_timing")]) {
            cellModel.isHideArrow = YES;
            cellModel.isHideSwitch = NO;
            cellModel.isOpen = self.isOpen;
            cellModel.switchViewTag = 2000;
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
    if (sender.tag == 1000) { //全天勿扰
        self.isAllday = sender.isOn;
        if (self.isAllday && self.isOpen) {
            self.isOpen = NO;
        }
    } else {
        self.isOpen = sender.isOn;
        if (self.isOpen && self.isAllday) {
            self.isAllday = NO;
        }
    }
    
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_do_not_disturb_allday")]) {
            cellModel.isOpen = self.isAllday;
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_do_not_disturb_timing")]) {
            cellModel.isOpen = self.isOpen;
        }
    }
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
    } else if (viewTag == 101){
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
    if (self.isOpen) {
        return self.dataArray.count;
    }
    if ([DHBleCentralManager isJLProtocol]){
        return 1;
    }
    else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MWBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWBaseTableCell" forIndexPath:indexPath];
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    if (!cellModel.isHideSwitch) {
        cell.switchView.tag = cellModel.switchViewTag;
        [cell.switchView addTarget:self action:@selector(switchViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_do_not_disturb_allday")] || [cellModel.leftTitle isEqualToString:Lang(@"str_do_not_disturb_timing")]) {
        return;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [self showPickerView:99+indexPath.row];
    }
    else{
        [self showPickerView:98+indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.footerViewH;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

#pragma mark - BasePickerViewDelegate

- (void)basePickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}


- (void)basePickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger row = [pickerView selectedRowInComponent:0];
    int tTag = 98;
    if ([DHBleCentralManager isJLProtocol]){
        tTag = 99;
    }
    MWBaseCellModel *cellModel = self.dataArray[viewTag-tTag];
    if (viewTag == 100) {
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
    } else if (viewTag == 101) {
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewTag-tTag inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.footerViewH)];
        _footerView.backgroundColor = HomeColor_BackgroundColor;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, self.footerViewH)];
        titleLabel.textColor = HomeColor_TitleColor;
        titleLabel.font = HomeFont_ContentFont;
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.text = Lang(@"str_no_disturb_tips");
        [_footerView addSubview:titleLabel];
    }
    return _footerView;
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
            _titles = @[Lang(@"str_do_not_disturb_timing"),
                        Lang(@"str_start_time"),
                        Lang(@"str_end_time")];
        }
        else{
            _titles = @[Lang(@"str_do_not_disturb_allday"),
                        Lang(@"str_do_not_disturb_timing"),
                        Lang(@"str_start_time"),
                        Lang(@"str_end_time")];
        }
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        if ([DHBleCentralManager isJLProtocol]){
            _subTitles = @[@"",
                           [BaseTimeModel transTimeStr:self.startHour minute:self.startMinute isHasAMPM:self.isHasAMPM],
                           [BaseTimeModel transTimeStr:self.endHour minute:self.endMinute isHasAMPM:self.isHasAMPM]];
        }
        else{
            _subTitles = @[@"",
                           @"",
                           [BaseTimeModel transTimeStr:self.startHour minute:self.startMinute isHasAMPM:self.isHasAMPM],
                           [BaseTimeModel transTimeStr:self.endHour minute:self.endMinute isHasAMPM:self.isHasAMPM]];
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

@end
