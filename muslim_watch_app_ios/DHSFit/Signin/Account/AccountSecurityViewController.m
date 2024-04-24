//
//  AccountSecurityViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "AccountSecurityViewController.h"
#import "AccountBindViewController.h"
#import "PasswordUpdateViewController.h"
#import "AccountLogoutViewController.h"

@interface AccountSecurityViewController ()<UITableViewDelegate,UITableViewDataSource>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 账号内容
@property (nonatomic, strong) UILabel *accountLabel;
/// 确定
@property (nonatomic, strong) UIButton *confirmButton;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// 用户模型
@property (nonatomic, strong) UserModel *model;

@end

@implementation AccountSecurityViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_account_bind")] && self.model.account.length) {
            continue;
        }
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_update_pw")] && (!self.model.account.length || DHAppStatus == 2)) {
            continue;
        }
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_account_cancel")] && (!self.model.account.length || DHAppStatus == 2)) {
            continue;
        }
        
        [self.dataArray addObject:cellModel];
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    if (self.model.account.length) {
        [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationView.mas_bottom);
            make.left.offset(HomeViewSpace_Left);
            make.height.offset(50);
        }];
        
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.right.offset(-HomeViewSpace_Right);
            make.height.offset(50);
            make.bottom.offset(-(kBottomHeight+25));
        }];
        
        [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(self.accountLabel.mas_bottom);
            make.bottom.equalTo(self.confirmButton.mas_top).offset(-20);
        }];
    } else {
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.right.offset(-HomeViewSpace_Right);
            make.height.offset(50);
            make.bottom.offset(-(kBottomHeight+25));
        }];
        
        [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(self.navigationView.mas_bottom);
            make.bottom.equalTo(self.confirmButton.mas_top).offset(-20);
        }];
    }
    
}

- (void)confirmClick:(UIButton *)sender {
    [self showSignoutTips];
}

- (void)showSignoutTips {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WEAKSELF
    [alertView showWithTitle:@""
                     message:Lang(@"str_signout_message")
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            [weakSelf onSignout];
        }
    }];
}

- (void)onSignout {
    if (DHAppStatus == 3) {
        [NetworkManager signoutWithParam:[NSDictionary dictionary] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
            
        }];
    }
    
    [AccountManager userSignout];
    //用户退出登录
    [DHNotificationCenter postNotificationName:AppNotificationUserSignout object:nil];
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
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_account_bind")]) {
        AccountBindViewController *vc = [[AccountBindViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_update_pw")]) {
        PasswordUpdateViewController *vc = [[PasswordUpdateViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.accountStr = self.accountLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_account_cancel")]) {
        AccountLogoutViewController *vc = [[AccountLogoutViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.accountStr = self.model.account;
        [self.navigationController pushViewController:vc animated:YES];
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

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.font = HomeFont_TitleFont;
        _accountLabel.textColor = HomeColor_TitleColor;
        NSString *account = [NSString stringWithFormat:@"%@%@",Lang(@"str_account_current"),self.model.account];
        _accountLabel.text = account;
        [self.view addSubview:_accountLabel];
    }
    return _accountLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 10.0;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.borderColor = HomeColor_MainColor.CGColor;
        _confirmButton.layer.borderWidth = 1.0;
        _confirmButton.backgroundColor = [UIColor clearColor];
        [_confirmButton setTitle:Lang(@"str_login_out") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_account_bind"),
                    Lang(@"str_update_pw"),
                    Lang(@"str_account_cancel")];
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
