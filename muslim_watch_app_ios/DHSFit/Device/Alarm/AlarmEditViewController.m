//
//  AlarmEditViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "AlarmEditViewController.h"
#import "AlarmTimePickerView.h"
#import "MWWeekViewController.h"
#import "AlarmTypeEditViewController.h"

@interface AlarmEditViewController ()<UITableViewDelegate,UITableViewDataSource,AlarmTimePickerViewDelegate,MWWeekViewControllerDelegate,AlarmTypeEditViewControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) AlarmTimePickerView *pickerView;

#pragma mark Data
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
/// 标签
@property (nonatomic, copy) NSString *alarmType;
/// 重复
@property (nonatomic, strong) NSArray <NSNumber *>*repeats;
/// AMPM
@property (nonatomic, assign) NSInteger split;
/// 小时
@property (nonatomic, assign) NSInteger hour;
/// 分钟
@property (nonatomic, assign) NSInteger minute;

@end

@implementation AlarmEditViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
    //程序进入后台
    [DHNotificationCenter addObserver:self selector:@selector(handleWillEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    NSInteger row = [self.pickerView.picker selectedRowInComponent:0];
    //开始时间
    NSInteger row1 = [self.pickerView.picker selectedRowInComponent:1];
    if (self.isHasAMPM) {
        NSInteger row2 = [self.pickerView.picker selectedRowInComponent:2];
        self.hour = [BaseTimeModel transHour:row1 splitIndex:row];
        self.minute = [self.minuteArray[row2] integerValue];
    } else {
        self.hour = [self.hourArray[row] integerValue];
        self.minute = [self.minuteArray[row1] integerValue];
    }
    
    AlarmSetModel *model = [[AlarmSetModel alloc] init];
    model.isOpen = self.model.isOpen;
    model.alarmType = self.alarmType;
    model.hour = self.hour;
    model.minute = self.minute;
    model.repeats = [self.repeats transToJsonString];
    if ([self.delegate respondsToSelector:@selector(alarmUpdate:isAdd:)]) {
        [self.delegate alarmUpdate:model isAdd:self.isAdd];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {
    self.isHasAMPM = [BaseTimeModel isHasAMPM];
    self.alarmType = self.model.alarmType;
    self.repeats = [self.model.repeats transToObject];
    self.hour = self.model.hour;
    self.minute = self.model.minute;
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        cellModel.subTitle = self.subTitles[i];
        [self.dataArray addObject:cellModel];
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(216);
    }];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.pickerView.mas_bottom).offset(10);
        make.bottom.offset(-kBottomHeight);
    }];
    
    if (self.isHasAMPM) {
        
        NSInteger splitIndex = [BaseTimeModel timeSplitIndex:self.hour];
        NSInteger hourIndex = [BaseTimeModel timeHourIndex:self.hour];
        [self.pickerView loadPickerViewWithArray:@[self.splitArray,self.hourArray, self.minuteArray] unitStr:@"" viewTag:0];
        [self.pickerView updateSelectRow:splitIndex inComponent:0];
        [self.pickerView updateSelectRow:hourIndex inComponent:1];
        [self.pickerView updateSelectRow:self.minute inComponent:2];
    } else {
        [self.pickerView loadPickerViewWithArray:@[self.hourArray, self.minuteArray] unitStr:@"" viewTag:0];
        [self.pickerView updateSelectRow:self.hour inComponent:0];
        [self.pickerView updateSelectRow:self.minute inComponent:1];
    }
}

- (void)handleWillEnterBackground {
    [self.navigationController popViewControllerAnimated:YES];
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_repeat")]) {
        MWWeekViewController *vc = [[MWWeekViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.delegate = self;
        vc.selectIndexs = [NSMutableArray arrayWithArray:self.repeats];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_tag")]) {
        AlarmTypeEditViewController *vc = [[AlarmTypeEditViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.delegate = self;
        vc.alarmType = self.alarmType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark UserInformSetPickerViewDelegate

- (void)pickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}

- (void)repeatsUpdate:(NSArray *)repeats {
    self.repeats = repeats;
    MWBaseCellModel *cellModel = [self.dataArray firstObject];
    cellModel.subTitle = [BaseTimeModel repeatsTitle:repeats];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark AlarmTypeEditViewControllerDelegate

- (void)alarmTypeUpdate:(NSString *)alarmType {
    self.alarmType = alarmType;
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_tag")]) {
            cellModel.subTitle = alarmType;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
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

- (AlarmTimePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AlarmTimePickerView alloc] init];
        _pickerView.delegate = self;
        [self.view addSubview:_pickerView];
    }
    return _pickerView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_repeat")];
        //Lang(@"str_tag")
    }
    return _titles;
    
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[[BaseTimeModel repeatsTitle:self.repeats]];
        //self.alarmType
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
