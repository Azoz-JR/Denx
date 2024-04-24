//
//  MenstrualRemindViewController.m
//  DHSFit
//
//  Created by DHS on 2022/11/7.
//

#import "MenstrualRemindViewController.h"

@interface MenstrualRemindViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

#pragma mark Data

/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;

@end

@implementation MenstrualRemindViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(menstrualRemindChange:OvulationPeriod:OvulationPeak:OvulationEnd:)]) {
        [self.delegate menstrualRemindChange:self.isRemindMenstrualPeriod OvulationPeriod:self.isRemindOvulationPeriod OvulationPeak:self.isRemindOvulationPeak OvulationEnd:self.isRemindOvulationEnd];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {

    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        cellModel.isHideArrow = YES;
        cellModel.isHideSwitch = NO;
        cellModel.switchViewTag = 100+i;
        if (i == 0) {
            cellModel.isOpen = self.isRemindMenstrualPeriod;
        } else if (i == 1) {
            cellModel.isOpen = self.isRemindOvulationPeriod;
        } else if (i == 2) {
            cellModel.isOpen = self.isRemindOvulationPeak;
        } else if (i == 3) {
            cellModel.isOpen = self.isRemindOvulationEnd;
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
    if (sender.tag == 100) {
        self.isRemindMenstrualPeriod = sender.isOn;
    } else if (sender.tag == 101) {
        self.isRemindOvulationPeriod = sender.isOn;
    } else if (sender.tag == 102) {
        self.isRemindOvulationPeak = sender.isOn;
    } else if (sender.tag == 103) {
        self.isRemindOvulationEnd = sender.isOn;
    }
    MWBaseCellModel *cellModel = self.dataArray[sender.tag-100];
    cellModel.isOpen = sender.isOn;
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
        _titles = @[Lang(@"str_remind_menstrual_period"),
                    Lang(@"str_remind_ovulation_period"),
                    Lang(@"str_remind_ovulation_peak"),
                    Lang(@"str_remind_ovulation_end")];
    }
    return _titles;
}

@end
