//
//  PrivacySecurityViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "PrivacySecurityViewController.h"
#import "DataUploadManager.h"

@interface PrivacySecurityViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;

/// 是否同步个人信息
@property (nonatomic, assign) BOOL isSyncUserData;
/// 是否同步运动数据
@property (nonatomic, assign) BOOL isSyncSportData;
/// 是否同步健康数据
@property (nonatomic, assign) BOOL isSyncHealthData;
/// 用户模型
@property (nonatomic, strong) UserModel *model;

@end

@implementation PrivacySecurityViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
}

- (void)navRightButtonClick:(UIButton *)sender {
    NSDictionary *dict1 = @{@"paraName":@"isPerson",@"paraValue":[NSString stringWithFormat:@"%ld",(long)self.isSyncUserData]};
    NSDictionary *dict2 = @{@"paraName":@"isSport",@"paraValue":[NSString stringWithFormat:@"%ld",(long)self.isSyncSportData]};
    NSDictionary *dict3 = @{@"paraName":@"isHealth",@"paraValue":[NSString stringWithFormat:@"%ld",(long)self.isSyncHealthData]};
    
    SHOWINDETERMINATE
    WEAKSELF
    [NetworkManager saveSwitchWithParam:@[dict1,dict2,dict3] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            HUDDISS
            if (resultCode == 0) {
                [weakSelf saveSwitchSuccess];
                
            } else if (resultCode == 10000){
                SHOWHUD(Lang(@"str_network_error"))
            } else {
                SHOWHUD(Lang(@"str_save_fail"))
            }
        });
    }];
}

- (void)saveSwitchSuccess {
    SHOWHUD(Lang(@"str_save_success"))
    self.model.isSyncUserData = self.isSyncUserData;
    self.model.isSyncSportData = self.isSyncSportData;
    self.model.isSyncHealthData = self.isSyncHealthData;
    [self.model saveOrUpdate];
    if (self.isSyncSportData || self.isSyncHealthData) {
        [DataUploadManager uploadAllHealthData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showClearDataTips {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WEAKSELF
    [alertView showWithTitle:@""
                     message:Lang(@"str_cloud_data_clear")
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            [weakSelf clearCloudData];
        }
    }];
}

- (void)clearCloudData {
    SHOWINDETERMINATE
    [NetworkManager clearDataWithParam:[NSDictionary dictionary] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            HUDDISS
            if (resultCode == 0) {
                SHOWHUD(Lang(@"str_clear_data_success"))
            } else if (resultCode == 10000){
                SHOWHUD(Lang(@"str_network_error"))
            } else {
                SHOWHUD(Lang(@"str_clear_data_failed"))
            }
        });
    }];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    self.isSyncUserData = self.model.isSyncUserData;
    self.isSyncHealthData = self.model.isSyncHealthData;
    self.isSyncSportData = self.model.isSyncSportData;
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_sync_person")]) {
            cellModel.isHideSwitch = NO;
            cellModel.isHideArrow = YES;
            cellModel.isOpen = self.isSyncUserData;
            cellModel.switchViewTag = 1000;
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_sync_sport")]) {
            cellModel.isHideSwitch = NO;
            cellModel.isHideArrow = YES;
            cellModel.isOpen = self.isSyncSportData;
            cellModel.switchViewTag = 2000;
        } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_sync_health")]) {
            cellModel.isHideSwitch = NO;
            cellModel.isHideArrow = YES;
            cellModel.isOpen = self.isSyncHealthData;
            cellModel.switchViewTag = 3000;
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
    if (sender.tag == 1000) {
        self.isSyncUserData = sender.isOn;
    } else if (sender.tag == 2000) {
        self.isSyncSportData = sender.isOn;
    } else {
        self.isSyncHealthData = sender.isOn;
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
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_clear_data")]) {
        [self showClearDataTips];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_sync_person"),
                    Lang(@"str_sync_sport"),
                    Lang(@"str_sync_health"),
                    Lang(@"str_clear_data")];
    }
    return _titles;
}

- (UserModel *)model {
    if (!_model) {
        _model = [UserModel currentModel];
    }
    return _model;
}

@end
