//
//  AboutViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "AboutViewController.h"
#import "AboutHeaderView.h"
#import "BaseHtmlViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) AboutHeaderView *headerView;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setupUI];
    
}

- (void)initData {
    for (int i = 0; i < self.titles.count; i++) {
        BaseCellModel *cellModel = [[BaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        [self.dataArray addObject:cellModel];
    }
}

- (void)setupUI {
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
}

#pragma mark ----- UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTableViewCell" forIndexPath:indexPath];
    BaseCellModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseCellModel *cellModel = self.dataArray[indexPath.row];
    BaseHtmlViewController *vc = [[BaseHtmlViewController alloc] init];
    vc.navTitle = cellModel.leftTitle;
    vc.isHideNavRightButton = YES;
    vc.urlString = @"https://www.baidu.com";
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = 60;
        _myTableView.tableHeaderView = self.headerView;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"BaseTableViewCell"];
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (AboutHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[AboutHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"用户协议",
                    @"隐私政策"];
    }
    return _titles;
}


@end
