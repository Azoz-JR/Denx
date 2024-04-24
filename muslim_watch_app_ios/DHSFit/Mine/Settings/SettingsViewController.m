//
//  SettingsViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "SettingsViewController.h"
#import "AccountSecurityViewController.h"
#import "PrivacySecurityViewController.h"
#import "MWPickerViewController.h"

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource,MWPickerViewControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// 小标题
@property (nonatomic, strong) NSArray *subTitles;
/// 距离单位数据源
@property (nonatomic, strong) NSArray *distanceUnits;
/// 温度单位数据源
@property (nonatomic, strong) NSArray *tempUnits;
/// 距离单位
@property (nonatomic, assign) NSInteger distanceUnit;
/// 温度单位
@property (nonatomic, assign) NSInteger tempUnit;

@end

@implementation SettingsViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    self.distanceUnit = [ConfigureModel shareInstance].distanceUnit;
    self.tempUnit = [ConfigureModel shareInstance].tempUnit;
    
    for (int i = 0; i < self.titles.count; i++) {
        NSString *titleStr = self.titles[i];
        if ([titleStr isEqualToString:Lang(@"str_privacy_safe")] && DHAppStatus == 2) {
            continue;
        }
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

- (void)showDeleteAlertView {
    WEAKSELF
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_clear_cache_tips")
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            [weakSelf clearCacheWithFilePath:[DHFile cachesPath]];
            //[weakSelf performSelector:@selector(showClearCacheSuccesed) withObject:nil afterDelay:0.5];
            [weakSelf reloadLastCell];
        }
    }];
}

- (void)reloadLastCell {
    MWBaseCellModel *cellModel = [self.dataArray lastObject];
    cellModel.subTitle = @"";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

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
    if (totleSize > 1024 * 1024) {
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1024.00f /1024.00f];
    } else if (totleSize > 1024) {
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
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_account_safe")]) {
        AccountSecurityViewController *vc = [[AccountSecurityViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_unit")]) {
        MWPickerViewController *vc = [[MWPickerViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.viewTag = indexPath.row+99;
        vc.dataArray = @[self.distanceUnits];
        vc.selectedRows = @[@(self.distanceUnit)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_temp")]) {
        MWPickerViewController *vc = [[MWPickerViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.viewTag = indexPath.row + 99;
        vc.dataArray = @[self.tempUnits];
        vc.selectedRows = @[@(self.tempUnit)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_privacy_safe")]) {
        PrivacySecurityViewController *vc = [[PrivacySecurityViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        //vc.isHideNavRightButton = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_clear_cache")]) {
        if (cellModel.subTitle.length) {
            [self showDeleteAlertView];
        } else {
            //SHOWHUD(Lang(@"str_clear_cache_none"))
        }
    }
    
}

#pragma mark - BasePickerViewControllerDelegate

- (void)customPickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}

- (void)customPickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger row = [pickerView selectedRowInComponent:0];
    MWBaseCellModel *cellModel = self.dataArray[viewTag-99];
    NSString *notificationName = @"";
    if (viewTag == 100) {
        self.distanceUnit = row;
        cellModel.subTitle = self.distanceUnits[row];
        [ConfigureModel shareInstance].distanceUnit = row;
        notificationName = AppNotificationDistanceUnitChange;
    } else if (viewTag == 101) {
        self.tempUnit = row;
        cellModel.subTitle = self.tempUnits[row];
        [ConfigureModel shareInstance].tempUnit = row;
        notificationName = AppNotificationTempUnitChange;
    }
    [ConfigureModel archiveraModel];
    if (DHDeviceConnected) {
        if ([DHBleCentralManager isJLProtocol]){
            [[DHBluetoothManager shareInstance] setJLUnit];
        }
        else{
            DHUnitSetModel *unitModel = [[DHUnitSetModel alloc] init];
            unitModel.language = [LanguageManager shareInstance].languageType;
            unitModel.distanceUnit = self.distanceUnit;
            unitModel.tempUnit = self.tempUnit;
            unitModel.timeformat = [BaseTimeModel isHasAMPM];
            [DHBleCommand setUnit:unitModel block:^(int code, id  _Nonnull data) {
                
            }];
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewTag-99 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //单位变化
    [DHNotificationCenter postNotificationName:notificationName object:nil];
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
        _titles = @[Lang(@"str_account_safe"),
                    Lang(@"str_unit"),
                    Lang(@"str_temp"),
                    Lang(@"str_privacy_safe"),
                    Lang(@"str_clear_cache")];
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
        _distanceUnits = @[Lang(@"str_unit_metric"),
                           Lang(@"str_unit_imperial")];
    }
    return _distanceUnits;
}

- (NSArray *)tempUnits {
    if (!_tempUnits) {
        _tempUnits = @[Lang(@"str_temp_centigrade"),
                       Lang(@"str_temp_fahrenheit")];
    }
    return _tempUnits;
}

@end
