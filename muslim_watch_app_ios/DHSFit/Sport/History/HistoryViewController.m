//
//  HistoryViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "HistoryViewController.h"
#import "HistoryCell.h"
#import "HistoryHeaderCell.h"
#import "SportDetailViewController.h"
#import "SportDetailViewJLController.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 标题数组
@property (nonatomic, strong) NSMutableArray *titleArray;
/// 展开收起数组
@property (nonatomic, strong) NSMutableArray *hiddenArray;
/// 是否删除数据
@property (nonatomic, assign) BOOL isDeleteData;

@end

@implementation HistoryViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
    //监听运动数据变化
    [DHNotificationCenter addObserver:self selector:@selector(sportDataChange) name:BluetoothNotificationSportDataChange object:nil];
    
}

- (void)sportDataChange {
    if (self.isDeleteData) {
        self.isDeleteData = NO;
        return;
    }
    [self.dataArray removeAllObjects];
    [self.titleArray removeAllObjects];
    [self.hiddenArray removeAllObjects];
    [self initData];
    [self.myTableView reloadData];
}

- (void)initData {
    NSArray *array = [DailySportModel queryAllSports];
    if (array.count) {
        DailySportModel *firstModel = array.firstObject;
        NSDate *currentDate = [firstModel.date dateByStringFormat:@"yyyyMMdd"];
        NSMutableArray *rowArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            DailySportModel *model = array[i];
            NSDate *date = [model.date dateByStringFormat:@"yyyyMMdd"];
            if (i == 0) {
                [self.titleArray addObject:[NSString stringWithFormat:@"%04ld/%02ld",(long)currentDate.year,(long)currentDate.month]];
                [self.hiddenArray addObject:@(0)];
                [rowArray addObject:model];
            } else {
                if (date.year == currentDate.year && date.month == currentDate.month) {
                    [rowArray addObject:model];
                } else {
                    [self.dataArray addObject:rowArray];
                    rowArray = [NSMutableArray array];
                    currentDate = date;
                    [self.titleArray addObject:[NSString stringWithFormat:@"%04ld/%02ld",(long)currentDate.year,(long)currentDate.month]];
                    [self.hiddenArray addObject:@(0)];
                    [rowArray addObject:model];
                }
            }
        }
        if (rowArray.count) {
            [self.dataArray addObject:rowArray];
        }
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

- (void)tapClick:(UITapGestureRecognizer *)sender {
    NSInteger isHidden = [self.hiddenArray[sender.view.tag-1000] integerValue];
    NSInteger result = isHidden == 0 ? 1 : 0;
    [self.hiddenArray replaceObjectAtIndex:sender.view.tag-1000 withObject:@(result)];
    
    [self.myTableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL isHidden = [self.hiddenArray[section] integerValue];
    if (isHidden) {
        return 0;
    }
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.dataArray[indexPath.section];
    DailySportModel *model = array[indexPath.row];
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BOOL isHidden = [self.hiddenArray[section] integerValue];
    
    HistoryHeaderCell *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HistoryHeaderCell"];
    headerView.leftTitleLabel.text = self.titleArray[section];
    headerView.leftImageView.transform = isHidden ? CGAffineTransformMakeRotation(M_PI*0.5) : CGAffineTransformMakeRotation(-M_PI*0.5);
    headerView.tag = 1000+section;
    
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [headerView addGestureRecognizer:tap];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    DailySportModel *model = array[indexPath.row];
    
    if (model.isJLRunType){ //杰里
        SportDetailViewJLController *vc = [[SportDetailViewJLController alloc] init];
        vc.navTitle = Lang(@"str_sport_detail");
        vc.navRightImage = @"public_nav_share";
        vc.navLeftImage = @"public_nav_back_sport";
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        SportDetailViewController *vc = [[SportDetailViewController alloc] init];
        vc.navTitle = Lang(@"str_sport_detail");
        vc.navRightImage = @"public_nav_share";
        vc.navLeftImage = @"public_nav_back_sport";
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        [self deleteSportData:indexPath];
    }
}


- (void)deleteSportData:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:array];
    //从数据库删除
    DailySportModel *model = resultArray[indexPath.row];
    if (!model.isUpload) {
        [model deleteObject];
        //从数据源删除
        [resultArray removeObjectAtIndex:indexPath.row];
        if (resultArray.count == 0) {
            [self.dataArray removeObjectAtIndex:indexPath.section];
            [self.titleArray removeObjectAtIndex:indexPath.section];
            [self.hiddenArray removeObjectAtIndex:indexPath.section];
            [self.myTableView reloadData];
        } else {
            [self.dataArray replaceObjectAtIndex:indexPath.section withObject:resultArray];
            [self.myTableView reloadData];
        }
        self.isDeleteData = YES;
        //运动数据更新
        [DHNotificationCenter postNotificationName:BluetoothNotificationSportDataChange object:nil];
        return;
    }
    
    NSInteger timestamp = [model.timestamp integerValue]+DHTimeZoneInterval;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(timestamp) forKey:@"timestamp"];
    
    SHOWINDETERMINATE
    WEAKSELF
    [NetworkManager deleteSportDataWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            HUDDISS
            if (resultCode == 0) {
                [model deleteObject];
                //从数据源删除
                [resultArray removeObjectAtIndex:indexPath.row];
                if (resultArray.count == 0) {
                    [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
                    [weakSelf.titleArray removeObjectAtIndex:indexPath.section];
                    [weakSelf.hiddenArray removeObjectAtIndex:indexPath.section];
                    [weakSelf.myTableView reloadData];
                } else {
                    [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:resultArray];
                    [weakSelf.myTableView reloadData];
                }
                weakSelf.isDeleteData = YES;
                //运动数据更新
                [DHNotificationCenter postNotificationName:BluetoothNotificationSportDataChange object:nil];
            } else if (resultCode == 10000){
                SHOWHUD(Lang(@"str_network_error"))
            } else {
                SHOWHUD(Lang(@"str_delete_failed"))
            }
            
        });
    }];
}

#pragma mark - get and set 属性的set和get方法

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = 140;
        _myTableView.sectionHeaderHeight = 50;
        _myTableView.sectionFooterHeight = 0.01;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[HistoryCell class] forCellReuseIdentifier:@"HistoryCell"];
        [_myTableView registerClass:[HistoryHeaderCell class] forHeaderFooterViewReuseIdentifier:@"HistoryHeaderCell"];
        
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

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)hiddenArray {
    if (!_hiddenArray) {
        _hiddenArray = [NSMutableArray array];
    }
    return _hiddenArray;
}

@end

