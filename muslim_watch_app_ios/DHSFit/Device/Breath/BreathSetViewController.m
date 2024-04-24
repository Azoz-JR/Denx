//
//  BreathSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/8/10.
//

#import "BreathSetViewController.h"

@interface BreathSetViewController ()<UITableViewDelegate,UITableViewDataSource,BasePickerViewDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 选择器
@property (nonatomic, strong) BasePickerView *pickerView;
/// 底部视图
@property (nonatomic, strong) UIView *footerView;

#pragma mark Data
/// 模型
@property(nonatomic, strong) BreathSetModel *model;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// 小标题
@property (nonatomic, strong) NSArray *subTitles;
/// 底部高度
@property (nonatomic, assign) CGFloat footerViewH;

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
/// 小时
@property (nonatomic, strong) NSMutableArray *hourItems;
/// 分钟
@property (nonatomic, strong) NSMutableArray *minuteItems;

@end

@implementation BreathSetViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getBreath];
}

- (void)getBreath {
    WEAKSELF
    [DHBleCommand getBreath:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf saveModel:data];
        } else {
            weakSelf.model = [BreathSetModel currentModel];
        }
        [weakSelf initData];
        [weakSelf setupUI];
        [weakSelf addObservers];
        
    }];
}

- (void)saveModel:(id)data {
    DHBreathSetModel *model = data;
    BreathSetModel *breathModel = [BreathSetModel currentModel];
    
    breathModel.isOpen = model.isOpen;
    breathModel.hourItems = [model.hourArray transToJsonString];
    breathModel.minuteItems = [model.minuteArray transToJsonString];
    [breathModel saveOrUpdate];
    
    self.model = breathModel;
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
    DHBreathSetModel *model = [[DHBreathSetModel alloc] init];
    model.isOpen = self.isOpen;
    model.hourArray = self.hourItems;
    model.minuteArray = self.minuteItems;
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setBreath:model block:^(int code, id  _Nonnull data) {
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
    self.model.hourItems = [self.hourItems transToJsonString];
    self.model.minuteItems = [self.minuteItems transToJsonString];
    [self.model saveOrUpdate];
}

- (void)initData {
    self.footerViewH = round([UILabel getLabelheight:Lang(@"str_breath_tips") width:kScreenWidth-30 font:HomeFont_ContentFont])+5;
    self.isHasAMPM = [BaseTimeModel isHasAMPM];
    
    self.isOpen = self.model.isOpen;
    if (self.model.hourItems.length) {
        NSArray *hourArray = [self.model.hourItems transToObject];
        if (hourArray.count) {
            self.hourItems = [NSMutableArray arrayWithArray:hourArray];
        }
    }
    
    if (self.model.minuteItems.length) {
        NSArray *minuteArray = [self.model.minuteItems transToObject];
        if (minuteArray.count) {
            self.minuteItems = [NSMutableArray arrayWithArray:minuteArray];
        }
    }
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_breath_training")]) {
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
    
    for (int i = 1; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        cellModel.subTitle = [BaseTimeModel transTimeStr:[self.hourItems[i-1] integerValue] minute:[self.minuteItems[i-1] integerValue] isHasAMPM:self.isHasAMPM];
    }
    [self.myTableView reloadData];

}

- (void)showPickerView:(NSInteger)viewTag{
    self.pickerView = [[BasePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.pickerView.delegate = self;
    NSInteger index = viewTag-100;
    if (self.isHasAMPM) {
        [self.pickerView setupPickerView:@[self.splitArray, self.hourArray,self.minuteArray] unitStr:@"" viewTag:viewTag];
        NSInteger splitIndex = [BaseTimeModel timeSplitIndex:[self.hourItems[index] integerValue]];
        NSInteger hourIndex = [BaseTimeModel timeHourIndex:[self.hourItems[index] integerValue]];
        [self.pickerView updateSelectRow:splitIndex inComponent:0];
        [self.pickerView updateSelectRow:hourIndex inComponent:1];
        [self.pickerView updateSelectRow:[self.minuteItems[index] integerValue] inComponent:2];
    } else {
        [self.pickerView setupPickerView:@[self.hourArray,self.minuteArray] unitStr:@"" viewTag:viewTag];
        [self.pickerView updateSelectRow:[self.hourItems[index] integerValue] inComponent:0];
        [self.pickerView updateSelectRow:[self.minuteItems[index] integerValue] inComponent:1];
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
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_breath_training")]) {
        return;
    }
    [self showPickerView:99+indexPath.row];
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
    MWBaseCellModel *cellModel = self.dataArray[viewTag-99];
    
    NSInteger row1 = [pickerView selectedRowInComponent:1];
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger index = viewTag-100;
    if (self.isHasAMPM) {
        NSInteger row2 = [pickerView selectedRowInComponent:2];
        hour = [BaseTimeModel transHour:row1 splitIndex:row];
        minute = [self.minuteArray[row2] integerValue];
    } else {
        hour = [self.hourArray[row] integerValue];
        minute = [self.minuteArray[row1] integerValue];
    }
    [self.hourItems replaceObjectAtIndex:index withObject:@(hour)];
    [self.minuteItems replaceObjectAtIndex:index withObject:@(minute)];
    cellModel.subTitle = [BaseTimeModel transTimeStr:hour minute:minute isHasAMPM:self.isHasAMPM];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewTag-99 inSection:0];
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
        titleLabel.text = Lang(@"str_breath_tips");
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
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
        _titles = @[Lang(@"str_breath_training"),
                    Lang(@"str_first_time"),
                    Lang(@"str_second_time"),
                    Lang(@"str_third_time"),
                    Lang(@"str_fourth_time"),
                    Lang(@"str_fifth_time")];
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"",
                       [BaseTimeModel transTimeStr:[self.hourItems[0] integerValue] minute:[self.minuteItems[0] integerValue] isHasAMPM:self.isHasAMPM],
                       [BaseTimeModel transTimeStr:[self.hourItems[1] integerValue] minute:[self.minuteItems[1] integerValue] isHasAMPM:self.isHasAMPM],
                       [BaseTimeModel transTimeStr:[self.hourItems[2] integerValue] minute:[self.minuteItems[2] integerValue] isHasAMPM:self.isHasAMPM],
                       [BaseTimeModel transTimeStr:[self.hourItems[3] integerValue] minute:[self.minuteItems[3] integerValue] isHasAMPM:self.isHasAMPM],
                       [BaseTimeModel transTimeStr:[self.hourItems[4] integerValue] minute:[self.minuteItems[4] integerValue] isHasAMPM:self.isHasAMPM]];
        
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

- (NSMutableArray *)hourItems {
    if (!_hourItems) {
        _hourItems = [NSMutableArray array];
        for (int i = 10; i < 20; i+=2) {
            [_hourItems addObject:@(i)];
        }
    }
    return _hourItems;
}

- (NSMutableArray *)minuteItems {
    if (!_minuteItems) {
        _minuteItems = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            [_minuteItems addObject:@(0)];
        }
    }
    return _minuteItems;
}

@end
