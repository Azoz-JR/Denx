//
//  AlarmHomeViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "AlarmHomeViewController.h"
#import "AlarmEditViewController.h"

@interface AlarmHomeViewController ()<UITableViewDelegate,UITableViewDataSource,AlarmEditViewControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 添加按钮
@property (nonatomic, strong) UIButton *addButton;

#pragma mark Data

@property(nonatomic, strong) NSMutableArray <AlarmSetModel *>*alarmArray;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 是否12小时制
@property (nonatomic, assign) BOOL isHasAMPM;
/// 编辑下标
@property (nonatomic, assign) NSInteger editIndex;

@end

@implementation AlarmHomeViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    if ([DHBleCentralManager isJLProtocol]){
        self.isHideNavRightButton = YES;
    }
    
    [super viewDidLoad];
    
    [self getAlarms];
}

- (void)getAlarms {
    WEAKSELF
    [DHBleCommand getAlarms:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf saveModel:data];
        } else {
            weakSelf.alarmArray = [NSMutableArray array];
            NSArray *array = [AlarmSetModel queryAllAlarms];
            if (array.count) {
                [weakSelf.alarmArray addObjectsFromArray:array];
            }
        }
        [weakSelf initData];
        [weakSelf setupUI];
        [weakSelf addObservers];
    }];
}

- (void)reflushAlarmData{
    WEAKSELF
    [DHBleCommand getAlarms:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf saveModel:data];
            [weakSelf initData];
            [weakSelf.myTableView reloadData];
        }
    }];
}

- (void)saveModel:(id)data {
    [AlarmSetModel deleteAllAlarms];
    NSArray *alarms = data;
    self.alarmArray = [NSMutableArray array];
    if (alarms.count) {
        for (int i = 0; i < alarms.count; i++) {
            DHAlarmSetModel *model = alarms[i];
            AlarmSetModel *alarmModel = [[AlarmSetModel alloc] init];
            
            alarmModel.alarmIndex = i;
            alarmModel.isOpen = model.isOpen;
            alarmModel.hour = model.hour;
            alarmModel.minute = model.minute;
            alarmModel.repeats = [model.repeats transToJsonString];
            alarmModel.alarmType = model.alarmType;
            alarmModel.jlAlarmId = model.jlAlarmId;
            alarmModel.jlYear = model.jlYear;
            alarmModel.jlMonth = model.jlMonth;
            alarmModel.jlDay = model.jlDay;
            [self.alarmArray addObject:alarmModel];
        }
        [AlarmSetModel saveObjects:self.alarmArray];
    }
    
}

- (void)addObservers {
    //程序进入前台
    [DHNotificationCenter addObserver:self selector:@selector(handleWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    //状态更新
    [DHNotificationCenter addObserver:self selector:@selector(alarmChange) name:BluetoothNotificationAlarmChange object:nil];
}

- (void)alarmChange {
    
    if ([DHBleCentralManager isJLProtocol]){
        [self reflushAlarmData];
    }
    else{
        [self.dataArray removeAllObjects];
        [self.alarmArray removeAllObjects];
        NSArray *array = [AlarmSetModel queryAllAlarms];
        if (array.count) {
            [self.alarmArray addObjectsFromArray:array];
        }
        for (int i = 0; i < self.alarmArray.count; i++) {
            AlarmSetModel *model = self.alarmArray[i];
            MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
            cellModel.isHideArrow = YES;
            cellModel.isHideSwitch = NO;
            cellModel.isOpen = model.isOpen;
            cellModel.switchViewTag = 100+i;
            cellModel.leftTitle = self.isHasAMPM ? @"": [NSString stringWithFormat:@"%02ld:%02ld",(long)model.hour,(long)model.minute];
            NSArray *repeats = [model.repeats transToObject];
            cellModel.contentTitle = [BaseTimeModel repeatsTitle:repeats];
            [self.dataArray addObject:cellModel];
        }
        
        [self.myTableView reloadData];
    }
}

#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    
    NSMutableArray *models = [NSMutableArray array];
    for (int i = 0; i < self.alarmArray.count; i++) {
        AlarmSetModel *model = self.alarmArray[i];
        DHAlarmSetModel *alarmModel = [[DHAlarmSetModel alloc] init];
        
        alarmModel.isOpen = model.isOpen;
        alarmModel.hour = model.hour;
        alarmModel.minute = model.minute;
        alarmModel.repeats = [model.repeats transToObject];
        alarmModel.jlAlarmId = model.jlAlarmId;
        [models addObject:alarmModel];
    }
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setAlarms:models block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            SHOWHUD(Lang(@"str_save_success"))
            [weakSelf saveAlarms];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            SHOWHUD(Lang(@"str_save_fail"))
        }
    }];
}

- (void)initData {
    self.isHasAMPM = [BaseTimeModel isHasAMPM];
    [self.dataArray removeAllObjects];
    
    for (int i = 0; i < self.alarmArray.count; i++) {
        AlarmSetModel *model = self.alarmArray[i];
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.isHideArrow = YES;
        cellModel.isHideSwitch = NO;
        cellModel.isOpen = model.isOpen;
        cellModel.switchViewTag = 100+i;
        cellModel.leftTitle = self.isHasAMPM ? @"": [NSString stringWithFormat:@"%02ld:%02ld",(long)model.hour,(long)model.minute];
        NSArray *repeats = [model.repeats transToObject];
        cellModel.contentTitle = [BaseTimeModel repeatsTitle:repeats];
        [self.dataArray addObject:cellModel];
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.width.offset(50);
        make.bottom.offset(-(kBottomHeight+25));
    }];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.equalTo(self.addButton.mas_top).offset(-10);
    }];
}

- (void)switchViewValueChanged:(UISwitch *)sender {
    MWBaseCellModel *cellModel = self.dataArray[sender.tag-100];
    AlarmSetModel *model = self.alarmArray[sender.tag-100];
    
    cellModel.isOpen = sender.isOn;
    model.isOpen = sender.isOn;
    
    if ([DHBleCentralManager isJLProtocol]){
        DHAlarmSetModel *tBleAlarmMode = [[DHAlarmSetModel alloc] init];
        tBleAlarmMode.isOpen = model.isOpen;
        tBleAlarmMode.hour = model.hour;
        tBleAlarmMode.minute = model.minute;
        tBleAlarmMode.repeats = [model.repeats transToObject];
        tBleAlarmMode.jlAlarmId = model.jlAlarmId;
        
        NSLog(@"updateJLAlarm %d", tBleAlarmMode.jlAlarmId);
        
        [DHBleCommand updateJLAlarm:tBleAlarmMode block:^(int code, id  _Nonnull data) {
            
        }];
    }
}

- (void)addClick {
    if (self.dataArray.count >= 5) {
        SHOWHUD(Lang(@"str_max_alarm_count"))
        return;
    }
    AlarmEditViewController *vc = [[AlarmEditViewController alloc] init];
    vc.navTitle = Lang(@"str_alarm_add");
    vc.isAdd = YES;
    vc.delegate = self;
    vc.model = [[AlarmSetModel alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveAlarms {
    
    NSArray *array = [AlarmSetModel queryAllAlarms];
    if (array.count) {
        [AlarmSetModel deleteObjects:array];
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < self.alarmArray.count; i++) {
        AlarmSetModel *model = self.alarmArray[i];
        model.alarmIndex = i;
        [resultArray addObject:model];
    }
    [AlarmSetModel saveObjects:resultArray];
}

- (void)handleWillEnterForeground {
    if ([BaseTimeModel isHasAMPM] != self.isHasAMPM) {
        self.isHasAMPM = [BaseTimeModel isHasAMPM];
        [self updateTimeData];
        
    }
}

- (void)updateTimeData {
    if (self.alarmArray.count == 0) {
        return;
    }
    
    for (int i = 0; i < self.alarmArray.count; i++) {
        AlarmSetModel *model = self.alarmArray[i];
        MWBaseCellModel *cellModel = self.dataArray[i];
        cellModel.leftTitle = [BaseTimeModel transTimeStr:model.hour minute:model.minute isHasAMPM:self.isHasAMPM];
    }
    [self.myTableView reloadData];
}

- (void)showAlarmDeleteTips {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WEAKSELF
    [alertView showWithTitle:@""
                     message:Lang(@"str_clear_alarm_tips")
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            [weakSelf onDeleteAlarm];
        }
    }];
}

- (void)onDeleteAlarm {

    AlarmSetModel *tDeleteModel = [self.alarmArray objectAtIndex:self.editIndex];
    
    DHAlarmSetModel *tBleAlarmMode = [[DHAlarmSetModel alloc] init];
    tBleAlarmMode.isOpen = tDeleteModel.isOpen;
    tBleAlarmMode.hour = tDeleteModel.hour;
    tBleAlarmMode.minute = tDeleteModel.minute;
    tBleAlarmMode.repeats = [tDeleteModel.repeats transToObject];
    tBleAlarmMode.jlAlarmId = tDeleteModel.jlAlarmId;
    
    NSLog(@"onDeleteAlarm %d", tBleAlarmMode.jlAlarmId);
    
    [DHBleCommand deleteJLAlarm:tBleAlarmMode block:^(int code, id  _Nonnull data) {
        
    }];
    
    [self.alarmArray removeObjectAtIndex:self.editIndex];
    
    [self initData];
    [self.myTableView reloadData];
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
    AlarmSetModel *alarmModel = self.alarmArray[indexPath.row];
    if (self.isHasAMPM) {
        cell.leftTitleLabel.attributedText = [self transTimeStr:alarmModel.hour minute:alarmModel.minute];
    } else {
        cell.leftTitleLabel.font = HomeFont_Bold_25;
    }
    if (!cellModel.isHideSwitch) {
        [cell.switchView addTarget:self action:@selector(switchViewValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.switchView.tag = cellModel.switchViewTag;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.editIndex = indexPath.row;
    AlarmEditViewController *vc = [[AlarmEditViewController alloc] init];
    vc.navTitle = Lang(@"str_alarm");
    vc.isAdd = NO;
    vc.delegate = self;
    vc.model = self.alarmArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 添加删除功能

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Lang(@"str_delete");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.editIndex = indexPath.row;
        [self showAlarmDeleteTips];
    }
}

#pragma mark - AlarmEditViewControllerDelegate

- (void)alarmUpdate:(AlarmSetModel *)model isAdd:(BOOL)isAdd {
    if (isAdd) {
        [self.alarmArray addObject:model];
    } else {
        [self.alarmArray replaceObjectAtIndex:self.editIndex withObject:model];
    }
    
    if ([DHBleCentralManager isJLProtocol]){
        [self saveAlarms];
    }
    
    [self initData];
    [self.myTableView reloadData];
    
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = 90;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[MWBaseTableCell class] forCellReuseIdentifier:@"MWBaseTableCell"];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:DHImage(@"device_alarm_add") forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addButton];
    }
    return _addButton;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSAttributedString *)transTimeStr:(NSInteger)hour minute:(NSInteger)minute {
    NSString *timeStr;
    NSString *unitStr;
    if (hour == 0) {
        timeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour+12, (long)minute];
        unitStr = @"AM";
    } else if (hour == 12) {
        timeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour, (long)minute];
        unitStr = @"PM";
    } else if (hour > 12) {
        timeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour-12, (long)minute];
        unitStr = @"PM";
    } else {
        timeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour, (long)minute];
        unitStr = @"AM";
    }
    NSArray *strArray = @[timeStr,unitStr];
    NSArray *fontArray = @[HomeFont_Bold_25,HomeFont_SubTitleFont];
    NSArray *colorArray = @[HomeColor_TitleColor,HomeColor_SubTitleColor];
    
    return [NSString attributedStrings:strArray fonts:fontArray colors:colorArray];
}

@end
