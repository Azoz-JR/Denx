//
//  SettingsViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "SettingsViewController.h"
#import "AccountSecurityViewController.h"
#import "PrivacySecurityViewController.h"
#import "BasePickerViewController.h"

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource,BasePickerViewControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *subTitles;

@property (nonatomic, strong) NSArray *distanceUnits;

@property (nonatomic, strong) NSArray *tempUnits;

@property (nonatomic, assign) NSInteger distanceUnit;

@property (nonatomic, assign) NSInteger tempUnit;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setupUI];
    
}

- (void)initData {
    self.distanceUnit = [ConfigureModel shareInstance].distanceUnit;
    self.tempUnit = [ConfigureModel shareInstance].tempUnit;
    
    for (int i = 0; i < self.titles.count; i++) {
        BaseCellModel *cellModel = [[BaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        cellModel.subTitle = self.subTitles[i];
        if ([cellModel.leftTitle isEqualToString:@"隐私安全"] && [ConfigureModel shareInstance].appStatus == 2) {
            continue;
        }
        [self.dataArray addObject:cellModel];
    }
}

- (void)setupUI {
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
}

/// 清除缓存提示
- (void)showCacheDataDeleteAlertView {
    WEAKSELF
    BaseAlertView *alertView =  [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@"confirm_clear_cache"
                     message:@""
                      cancel:@"str_cancel"
                     confirm:@"determine"
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            [weakSelf clearCacheWithFilePath:[DHFile cachesPath]];
            [weakSelf performSelector:@selector(showClearCacheSuccesed) withObject:nil afterDelay:0.5];
            [weakSelf reloadLastCell];
        }
    }];
}

- (void)reloadLastCell {
    BaseCellModel *cellModel = [self.dataArray lastObject];
    cellModel.subTitle = @"";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

/// 清除缓存成功
- (void)showClearCacheSuccesed {
    //SHOWHUD(Lang(@"str_clear_cache_success"))
}

#pragma mark - 获取path路径下文件夹大小

- (NSString *)getCacheSizeWithFilePath:(NSString *)path {
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath = nil; NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr) {
        filePath =[path stringByAppendingPathComponent:subPath];
        BOOL isDirectory = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist || isDirectory || [filePath containsString:@".DS"]) {
            continue;
        }
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        totleSize += size;
    }
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    } else if (totleSize > 1000) {
        totleStr = @"";
    } else {
        totleStr = @"";
    }
    return totleStr;
}

#pragma mark - 清除path文件夹下缓存大小

- (BOOL)clearCacheWithFilePath:(NSString *)path {
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]; NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingPathComponent:subPath];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
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
    if ([cellModel.leftTitle isEqualToString:@"帐号与安全"]) {
        AccountSecurityViewController *vc = [[AccountSecurityViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:@"单位"]) {
        BasePickerViewController *vc = [[BasePickerViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.viewTag = indexPath.row+99;
        vc.dataArray = @[self.distanceUnits];
        vc.selectedRows = @[@(self.distanceUnit)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:@"温度"]) {
        BasePickerViewController *vc = [[BasePickerViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.viewTag = indexPath.row+99;
        vc.dataArray = @[self.tempUnits];
        vc.selectedRows = @[@(self.tempUnit)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:@"隐私安全"]) {
        PrivacySecurityViewController *vc = [[PrivacySecurityViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:@"清理缓存"]) {
        if (cellModel.subTitle.length) {
            [self showCacheDataDeleteAlertView];
        } else {
            //SHOWHUD(Lang(@"str_clear_cache_none"))
        }
    }
    
}

#pragma mark ----- BasePickerViewControllerDelegate

- (void)customPickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}


- (void)customPickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger row = [pickerView selectedRowInComponent:0];
    BaseCellModel *cellModel = self.dataArray[viewTag-99];
    if (viewTag == 100) {
        //单位
        self.distanceUnit = row;
        cellModel.subTitle = self.distanceUnits[row];
        [ConfigureModel shareInstance].distanceUnit = row;
    } else if (viewTag == 101) {
        //单位
        self.tempUnit = row;
        cellModel.subTitle = self.tempUnits[row];
        [ConfigureModel shareInstance].tempUnit = row;
    }
    [ConfigureModel archiveraModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewTag-99 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

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
        [_myTableView registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"BaseTableViewCell"];
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
        _titles = @[@"帐号与安全",
                    @"单位",
                    @"温度",
                    @"隐私安全",
                    @"清理缓存"];
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"",
                       self.distanceUnits[self.distanceUnit],
                       self.tempUnits[self.tempUnit],
                       @"",
                       [self getCacheSizeWithFilePath:[DHFile cachesPath]]];
    }
    return _subTitles;
}

- (NSArray *)distanceUnits {
    if (!_distanceUnits) {
        _distanceUnits = @[@"公制",
                           @"英制"];
    }
    return _distanceUnits;
}

- (NSArray *)tempUnits {
    if (!_tempUnits) {
        _tempUnits = @[@"℃",
                       @"℉"];
    }
    return _tempUnits;
}

@end
