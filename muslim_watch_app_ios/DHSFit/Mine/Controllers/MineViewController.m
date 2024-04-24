//
//  MineViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "MineViewController.h"
#import "MineHeaderView.h"
#import "MWHtmlViewController.h"
#import "UserInfoSetViewController.h"
#import "SettingsViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "AppQRCodeViewController.h"
#import <StoreKit/StoreKit.h>
#import "UIQuranViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,MineHeaderViewDelegate,UserInfoSetViewControllerDelegate,SKStoreProductViewControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 头部视图
@property (nonatomic, strong) MineHeaderView *headerView;
/// 头部高度
@property (nonatomic, assign) CGFloat headerViewH;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// icon
@property (nonatomic, strong) NSArray *images;

/// 用户模型
@property (nonatomic, strong) UserModel *model;
/// 当前版本
@property (nonatomic, copy) NSString *currentVersion;
/// 线上版本
@property (nonatomic, copy) NSString *onlineVersion;

@end

@implementation MineViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
//    [self delayPerformBlock:^(id  _Nonnull object) {
//        [self checkVersionUpdate];
//    } WithTime:0.5];
    //用户信息更新
    [DHNotificationCenter addObserver:self selector:@selector(userInfoChange) name:AppNotificationUserInfoChange object:nil];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    self.currentVersion = [DHDevice appShotVersion];
    self.onlineVersion = [DHDevice appShotVersion];
    self.headerViewH = 200;
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftImage = self.images[i];
        cellModel.leftTitle = self.titles[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_check_app_version")] ||
            [cellModel.leftTitle isEqualToString:Lang(@"str_help")]) {
            continue;
        }

        [self.dataArray addObject:cellModel];
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(kStatusHeight+10);
    }];
}

- (void)userInfoChange {
    self.model = [UserModel currentModel];
    self.headerView.model = self.model;
}

- (void)checkVersionUpdate {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(1) forKey:@"type"];
    [dict setObject:self.currentVersion forKey:@"version"];
    WEAKSELF
    [NetworkManager queryAppVersionWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        if (resultCode == 0) {
            NSDictionary *result = data;
            if (DHIsNotEmpty(result, @"version")) {
                weakSelf.onlineVersion = [NSString stringWithFormat:@"%@",[result objectForKey:@"version"]];
            }
            [weakSelf updateAppVersionCell];
        }
        });
    }];
}

- (void)updateAppVersionCell {
    BOOL isHideRedPoint = YES;
    if (![self.currentVersion isEqualToString:self.onlineVersion]) {
        NSString *currentNumber = [self.currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *onlineNumber = [self.onlineVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([onlineNumber integerValue] > [currentNumber integerValue]) {
            isHideRedPoint = NO;
        }
    }

    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_check_app_version")]) {
            cellModel.isHideRedPoint = isHideRedPoint;
            cellModel.subTitle = isHideRedPoint ? Lang(@"str_is_latest_version") : [NSString stringWithFormat:@"V%@",self.onlineVersion];
        }
    }
    [self.myTableView reloadData];
}

- (void)checkVersionUpdateAgain {
    NSDictionary *dict = @{@"type":@(1)};
    WEAKSELF
    [NetworkManager queryAppVersionWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        if (resultCode == 0) {
            NSDictionary *result = data;
            if (DHIsNotEmpty(result, @"version")) {
                weakSelf.onlineVersion = [NSString stringWithFormat:@"%@",[result objectForKey:@"version"]];
            } else {
                weakSelf.onlineVersion = weakSelf.currentVersion;
            }
            [weakSelf updateAppVersionCell];
        }
        });
    }];
}

- (void)showAppUpdateTips {
    WEAKSELF
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_new_version_found")
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            [weakSelf jumpAppStore];
        }
    }];
}

- (void)jumpAppStore {
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1644023195" forKey:SKStoreProductParameterITunesItemIdentifier];
    SKStoreProductViewController *vc = [[SKStoreProductViewController alloc] init];
    vc.delegate = self;
    WEAKSELF
    [vc loadProductWithParameters:dict completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (error == nil) {
            [weakSelf presentViewController:vc animated:YES completion:nil];
        }
    }];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    WEAKSELF
    [viewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf checkVersionUpdateAgain];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MWBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWBaseTableCell" forIndexPath:indexPath];
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_qrcode")]) {
        AppQRCodeViewController *vc = [[AppQRCodeViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.navRightImage = @"public_nav_share";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_personal_data")]) {
        [self onAvatar];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_setting")]) {
        SettingsViewController *vc = [[SettingsViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_suggest")]) {
        FeedbackViewController *vc = [[FeedbackViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_help")]) {
        MWHtmlViewController *vc = [[MWHtmlViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.urlString = @"https://www.baidu.com";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_check_app_version")]) {
        if (!cellModel.isHideRedPoint) {
            [self showAppUpdateTips];
        }
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_about")]) {
        AboutViewController *vc = [[AboutViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - MineHeaderViewDelegate

- (void)onAvatar {
    UserInfoSetViewController *vc = [[UserInfoSetViewController alloc] init];
    vc.navTitle = Lang(@"str_personal_data");
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UserInfoSetViewController

- (void)nickNameUpdate:(NSString *)nickName {
    self.model = [UserModel currentModel];
    self.headerView.nickName = nickName;
}

- (void)avatarUpdate:(UIImage *)avatarImage {
    self.model = [UserModel currentModel];
    self.headerView.avatarImage = avatarImage;
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

- (MineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.headerViewH)];
        _headerView.delegate = self;
        _headerView.model = self.model;
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
        _titles = @[Lang(@"str_qrcode"),
                    Lang(@"str_personal_data"),
                    Lang(@"str_setting"),
                    Lang(@"str_suggest"),
                    Lang(@"str_help"),
                    Lang(@"str_check_app_version"),
                    Lang(@"str_about")];
    }
    return _titles;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"mine_main_qrcode",
                    @"mine_main_userinfo",
                    @"mine_main_settings",
                    @"mine_main_feedback",
                    @"mine_main_help",
                    @"mine_main_version",
                    @"mine_main_about"];
    }
    return _images;
}

- (UserModel *)model {
    if (!_model) {
        _model = [UserModel currentModel];
    }
    return _model;
}

@end
