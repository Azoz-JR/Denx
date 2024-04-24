//
//  AboutViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "AboutViewController.h"
#import "AboutHeaderView.h"
#import "MWHtmlViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 头部视图
@property (nonatomic, strong) AboutHeaderView *headerView;
/// 头部高度
@property (nonatomic, assign) CGFloat headerViewH;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSString *helpUrl;
@property (nonatomic, strong) NSString *privacyPolicyUrl;
@property (nonatomic, strong) NSString *userProtocolUrl;

@end

@implementation AboutViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {

    self.helpUrl = UserHelpUrl;
    self.privacyPolicyUrl = PrivacyPolicyUrl;
    self.userProtocolUrl = UserProtocolUrl;
    
    self.headerViewH = 220;
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        [self.dataArray addObject:cellModel];
    }
    NSString *tLang = [[LanguageManager shareInstance] getHttpLanguageType];
    WEAKSELF
    [NetworkManager getDocUrl:@{@"language":tLang} andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        NSLog(@"message %@ data %@",  message, data);
        NSDictionary *tDocDic = data;
        if (tDocDic){
            weakSelf.helpUrl = tDocDic[@"helpUrl"];
            weakSelf.privacyPolicyUrl = tDocDic[@"privacyPolicyUrl"];
            weakSelf.userProtocolUrl = tDocDic[@"userProtocolUrl"];
        }
    }];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerViewH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MWBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWBaseTableCell" forIndexPath:indexPath];
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    MWHtmlViewController *vc = [[MWHtmlViewController alloc] init];
    vc.navTitle = cellModel.leftTitle;
    vc.isHideNavRightButton = YES;
    vc.urlString = [cellModel.leftTitle isEqualToString:Lang(@"str_user_protocol")] ? self.userProtocolUrl : self.privacyPolicyUrl;
    if (indexPath.row == 2){
        vc.urlString = self.helpUrl;
    }
    [self.navigationController pushViewController:vc animated:YES];
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

- (AboutHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[AboutHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.headerViewH)];
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
        _titles = @[Lang(@"str_user_protocol"),
                    Lang(@"str_privacy_policy"), Lang(@"str_about_help")];
    }
    return _titles;
}


@end
