//
//  BrightTimeSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "BrightTimeSetViewController.h"

@interface BrightTimeSetViewController ()<UITableViewDelegate,UITableViewDataSource,BasePickerViewDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 选择器
@property (nonatomic, strong) BasePickerView *pickerView;

#pragma mark Data
/// 模型
@property(nonatomic, strong) BrightTimeSetModel *model;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// 小标题
@property (nonatomic, strong) NSArray *subTitles;
/// 频率数组
@property (nonatomic, strong) NSMutableArray *intervalArray;
/// 频率
@property (nonatomic, assign) NSInteger interval;

@end

@implementation BrightTimeSetViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getBrightTime];
}

- (void)getBrightTime {
    WEAKSELF
    [DHBleCommand getBrightTime:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf saveModel:data];
        } else {
            weakSelf.model = [BrightTimeSetModel currentModel];
        }
        [weakSelf initData];
        [weakSelf setupUI];
        [weakSelf addObservers];
    }];
}

- (void)addObservers {
    [DHNotificationCenter addObserver:self selector:@selector(brightTimeChange) name:BluetoothNotificationBrightTimeChange object:nil];
}

- (void)brightTimeChange {
    self.model = [BrightTimeSetModel currentModel];
    self.interval = self.model.duration;
    MWBaseCellModel *cellModel = self.dataArray.firstObject;
    if (self.interval == 0) {
        cellModel.subTitle = Lang(@"str_always_bright");
    } else {
        cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)self.interval,Lang(@"str_second")];
    }
    [self.myTableView reloadData];
}

- (void)saveModel:(id)data {
    DHBrightTimeSetModel *model = data;
    BrightTimeSetModel *brightTimeModel = [BrightTimeSetModel currentModel];
    brightTimeModel.duration = model.duration;
    brightTimeModel.durationNums = model.durationNums;
    [brightTimeModel saveOrUpdate];
    
    self.model = brightTimeModel;
}

#pragma mark - custom action for DATA 数据处理有关
- (void)navRightButtonClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    
    DHBrightTimeSetModel *model = [[DHBrightTimeSetModel alloc] init];
    model.duration = self.interval;
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setBrightTime:model block:^(int code, id  _Nonnull data) {
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
    
    self.model.duration = self.interval;
    [self.model saveOrUpdate];
}

- (void)initData {
    
    self.interval = self.model.duration;
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        cellModel.subTitle = self.subTitles[i];
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
    [self.pickerView setupPickerView:@[self.intervalArray] unitStr:@"" viewTag:viewTag];
    [self.pickerView updateSelectRow:currentIndex inComponent:0];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showPickerView:100+indexPath.row];
}

#pragma mark - BasePickerViewDelegate

- (void)basePickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}


- (void)basePickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger row = [pickerView selectedRowInComponent:0];
    MWBaseCellModel *cellModel = self.dataArray[viewTag-100];
    if (viewTag == 100) {
        //频率
        if ([DHBleCentralManager isJLProtocol]){
            self.interval = [self.intervalArray[row] integerValue];
            if (self.interval == 0) {
                cellModel.subTitle = Lang(@"str_always_bright");
            }
            else{
                cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)self.interval,Lang(@"str_second")];
            }
        }
        else{
            self.interval = row == 0 ? 0 : [self.intervalArray[row] integerValue];
            if (self.interval == 0) {
                cellModel.subTitle = Lang(@"str_always_bright");
            } else {
                cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)self.interval,Lang(@"str_second")];
            }
        }
        
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewTag-100 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)indexOfViewTag:(NSInteger)viewTag {
    
    if (self.interval == 0) {
        return 0;
    }
    
    if ([self.intervalArray indexOfObject:[NSString stringWithFormat:@"%ld", self.interval]] == NSNotFound) {
        return 0;
    }
    
    return [self.intervalArray indexOfObject:[NSString stringWithFormat:@"%ld", self.interval]];
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
        _titles = @[Lang(@"str_screen_long")];
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        if (self.interval == 0) {
            _subTitles = @[Lang(@"str_always_bright")];
        } else {
            _subTitles = @[[NSString stringWithFormat:@"%ld%@",(long)self.interval,Lang(@"str_second")]];
        }
        
        
    }
    return _subTitles;
}

- (NSMutableArray *)intervalArray {
    if ([DHBleCentralManager isJLProtocol]){
        if (_model.durationNums.length > 0){
            _intervalArray = [NSMutableArray arrayWithCapacity:0];
            NSArray *durationNumArr = [_model.durationNums componentsSeparatedByString:@"_"];
            if ([_model.durationNums containsString:@"_0"]){ //包含常亮
                [_intervalArray addObject:Lang(@"str_always_bright")];
            }
            for (NSString *tDurationNum in durationNumArr){
                if (NO == [tDurationNum isEqualToString:@"0"]){
                    [_intervalArray addObject:tDurationNum];
                }
            }
        }
        else{
            _intervalArray = [NSMutableArray arrayWithArray:@[@"5",
                                                              @"10",
                                                              @"15",
                                                              @"20", @"25", @"30"]];
        }
    }
    else{
        _intervalArray = [NSMutableArray arrayWithArray:@[Lang(@"str_always_bright"),
                                                          @"5",
                                                          @"15",
                                                          @"30",
                                                          @"45"]];
    }
    
    return _intervalArray;
}

@end
