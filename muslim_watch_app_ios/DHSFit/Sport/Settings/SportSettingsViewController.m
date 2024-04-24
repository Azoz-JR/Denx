//
//  SportSettingsViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "SportSettingsViewController.h"

@interface SportSettingsViewController ()<UITableViewDelegate,UITableViewDataSource,BasePickerViewDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 选择器
@property (nonatomic, strong) BasePickerView *pickerView;

#pragma mark Data

@property(nonatomic, strong) SportGoalSetModel *model;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// 小标题
@property (nonatomic, strong) NSArray *subTitles;
/// 时长数组
@property (nonatomic, strong) NSMutableArray *durationArray;
/// 消耗数组
@property (nonatomic, strong) NSMutableArray *calorieArray;
/// 距离数组
@property (nonatomic, strong) NSMutableArray *distanceArray;
/// 时长
@property (nonatomic, assign) NSInteger duration;
/// 消耗
@property (nonatomic, assign) NSInteger calorie;
/// 距离
@property (nonatomic, assign) NSInteger distance;

/// 振动开关
@property (nonatomic, assign) BOOL isVibration;
/// 屏幕常亮
@property (nonatomic, assign) BOOL isAlwaysBright;
/// 自动暂停
@property (nonatomic, assign) BOOL isAutoPause;

@end

@implementation SportSettingsViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    
    DHSportGoalSetModel *model = [[DHSportGoalSetModel alloc] init];
    model.duration = self.duration;
    model.calorie = self.calorie;
    model.distance = self.distance;
    
    if (![DHBleCentralManager isJLProtocol]){ //当前只瑞昱支持
        [DHBleCommand setSportGoal:model block:^(int code, id  _Nonnull data) {
            
        }];
    }
    
    [self saveModel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveModel {
    self.model.isVibration = self.isVibration;
    self.model.isAlwaysBright = self.isAlwaysBright;
    self.model.isAutoPause = self.isAutoPause;
    
    self.model.duration = self.duration;
    self.model.calorie = self.calorie;
    self.model.distance = self.distance;
    [self.model saveOrUpdate];
    
}

- (void)initData {
    self.model = [SportGoalSetModel currentModel];
    
    self.isVibration = self.model.isVibration;
    self.isAlwaysBright = self.model.isAlwaysBright;
    self.isAutoPause = self.model.isAutoPause;
    
    self.duration = self.model.duration;
    self.calorie = self.model.calorie;
    self.distance = self.model.distance;
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_vibration_settings")]) {
            cellModel.isHideArrow = YES;
            cellModel.isHideSwitch = NO;
            cellModel.isOpen = self.isVibration;
            cellModel.switchViewTag = 1000;
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_screen_always_on")]) {
            cellModel.isHideArrow = YES;
            cellModel.isHideSwitch = NO;
            cellModel.isOpen = self.isAlwaysBright;
            cellModel.switchViewTag = 2000;
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_auto_pause")]) {
            cellModel.isHideArrow = YES;
            cellModel.isHideSwitch = NO;
            cellModel.isOpen = self.isAutoPause;
            cellModel.switchViewTag = 3000;
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

- (void)showPickerView:(NSInteger)viewTag{
    self.pickerView = [[BasePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.pickerView.delegate = self;
    NSInteger currentIndex = [self indexOfViewTag:viewTag];
    NSArray *array = [self dataOfViewTag:viewTag];
    [self.pickerView setupPickerView:@[array] unitStr:@"" viewTag:viewTag];
    [self.pickerView updateSelectRow:currentIndex inComponent:0];
    
}

- (void)switchViewValueChanged:(UISwitch *)sender {
    if (sender.tag == 1000) {
        self.isVibration = sender.isOn;
    } else if (sender.tag == 2000) {
        self.isAlwaysBright = sender.isOn;
    } else if (sender.tag == 3000) {
        self.isAutoPause = sender.isOn;
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
        cell.switchView.tag = cellModel.switchViewTag;
        [cell.switchView addTarget:self action:@selector(switchViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_vibration_settings")] ||
        [cellModel.leftTitle isEqualToString:Lang(@"str_screen_always_on")] ||
        [cellModel.leftTitle isEqualToString:Lang(@"str_auto_pause")]) {
        return;
    }
    [self showPickerView:97+indexPath.row];
}

#pragma mark - BasePickerViewDelegate

- (void)basePickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}

- (void)basePickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger row = [pickerView selectedRowInComponent:0];
    MWBaseCellModel *cellModel = self.dataArray[viewTag-97];
    if (viewTag == 100) {
        //时长
        self.duration = [self.durationArray[row] integerValue];
        cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)self.duration,MinuteUnit];
    } else if (viewTag == 101) {
        //卡路里
        self.calorie = [self.calorieArray[row] integerValue];
        cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)self.calorie,CalorieUnit];
    } else if (viewTag == 102) {
        //里程
        self.distance = [self.distanceArray[row] integerValue];
        cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)self.distance,DistanceUnit];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewTag-97 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)indexOfViewTag:(NSInteger)viewTag {
    if (viewTag == 100) {
        if ([self.durationArray indexOfObject:@(self.duration)] == NSNotFound) {
            return 0;
        }
        return [self.durationArray indexOfObject:@(self.duration)];
    }
    if (viewTag == 101) {
        if ([self.calorieArray indexOfObject:@(self.calorie)] == NSNotFound) {
            return 0;
        }
        return [self.calorieArray indexOfObject:@(self.calorie)];
    }
    if ([self.distanceArray indexOfObject:@(self.distance)] == NSNotFound) {
        return 0;
    }
    return [self.distanceArray indexOfObject:@(self.distance)];
}

- (NSArray *)dataOfViewTag:(NSInteger)viewTag {
    if (viewTag == 100) {
        return self.durationArray;
    }
    if (viewTag == 101) {
        return self.calorieArray;
    }
    return self.distanceArray;
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
        _titles = @[Lang(@"str_vibration_settings"),
                    Lang(@"str_screen_always_on"),
                    Lang(@"str_auto_pause"),
                    Lang(@"str_time_goal"),
                    Lang(@"str_calorie_goal"),
                    Lang(@"str_distance_goal")];
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"",
                       @"",
                       @"",
                       [NSString stringWithFormat:@"%ld%@",(long)self.duration,MinuteUnit],
                       [NSString stringWithFormat:@"%ld%@",(long)self.calorie,CalorieUnit],
                       [NSString stringWithFormat:@"%ld%@",(long)self.distance,DistanceUnit]];
        
    }
    return _subTitles;
}

- (NSMutableArray *)durationArray {
    if (!_durationArray) {
        _durationArray = [NSMutableArray array];
        for (int i = 1; i <= 18; i++) {
            [_durationArray addObject:@(i*10)];
        }
    }
    return _durationArray;
}

- (NSMutableArray *)calorieArray {
    if (!_calorieArray) {
        _calorieArray = [NSMutableArray array];
        for (int i = 1; i <= 10; i++) {
            [_calorieArray addObject:@(i*100)];
        }
    }
    return _calorieArray;
}

- (NSMutableArray *)distanceArray {
    if (!_distanceArray) {
        _distanceArray = [NSMutableArray array];
        for (int i = 1; i <= 10; i++) {
            [_distanceArray addObject:@(i)];
        }
    }
    return _distanceArray;
}


@end
