//
//  UserInfoSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "UserInfoSetViewController.h"
#import "MWPickerViewController.h"
#import "NickNameSetViewController.h"
#import "YYImageClipViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface UserInfoSetViewController ()<UITableViewDelegate,UITableViewDataSource,MWPickerViewControllerDelegate,NickNameSetViewControllerDelegate,UIImagePickerControllerDelegate,YYImageClipDelegate,UINavigationControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;
/// 相机、相册视图
@property (nonatomic, strong) UIImagePickerController *pickerController;

#pragma mark Data
/// 模型
@property (nonatomic, strong) UserModel *model;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// 小标题
@property (nonatomic, strong) NSArray *subTitles;
/// 性别数据源
@property (nonatomic, strong) NSArray *genders;
/// 年数据源
@property (nonatomic, strong) NSMutableArray *birthYears;
/// 月数据源
@property (nonatomic, strong) NSMutableArray *birthMonths;
/// 日数据源
@property (nonatomic, strong) NSMutableArray *birthDays;
/// 身高数据源
@property (nonatomic, strong) NSMutableArray *heights;
/// 体重数据源
@property (nonatomic, strong) NSMutableArray *weights;
/// 小数数据源
@property (nonatomic, strong) NSMutableArray *decimals;
/// 步数数据源
@property (nonatomic, strong) NSMutableArray *steps;
/// 当前年
@property (nonatomic, assign) NSInteger currentYear;
/// 当前月
@property (nonatomic, assign) NSInteger currentMonth;
/// 头像
@property (nonatomic, strong) UIImage *avatarImage;
/// 头像URL
@property (nonatomic, copy) NSString *avatar;
/// 用户昵称
@property (nonatomic, copy) NSString *nickName;
/// 性别（0女 1男）
@property (nonatomic, assign) NSInteger gender;
/// 身高（cm）
@property (nonatomic, assign) CGFloat height;
/// 身高（inch）
@property (nonatomic, assign) CGFloat height_imperial;
/// 体重（kg）
@property (nonatomic, assign) CGFloat weight;
/// 体重（lbs）
@property (nonatomic, assign) CGFloat weight_imperial;
/// 体重
@property (nonatomic, assign) NSInteger weightInt;
/// 最大体重
@property (nonatomic, assign) NSInteger maxWeight;

/// 步数目标（step）
@property (nonatomic, assign) NSInteger stepGoal;
/// 年
@property (nonatomic, assign) NSInteger birthYear;
/// 月
@property (nonatomic, assign) NSInteger birthMonth;
/// 日
@property (nonatomic, assign) NSInteger birthDay;

/// 选择器
@property (nonatomic, strong) MWPickerViewController *pickerVC;

@end

@implementation UserInfoSetViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
}
#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    self.avatar = self.model.avatar;
    self.nickName = self.model.name;
    self.gender = self.model.gender;
    self.height = self.model.height;
    self.weight = self.model.weight;
    self.stepGoal = self.model.stepGoal;
    
    if (self.height > 280.0) {
        self.height = 280.0;
    } else if (self.height < 60.0) {
        self.height = 60.0;
    }
    if (self.weight > 200.0) {
        self.weight = 200.0;
    } else if (self.weight < 20.0) {
        self.weight = 20.0;
    }
    
    if (self.stepGoal < 1000 || self.stepGoal > 30000) {
        self.stepGoal = 5000;
    }
    
    self.maxWeight = ImperialUnit ? 441 : 200;
    
    if (ImperialUnit) {
        self.height_imperial = HeightValue(self.height);
        if (self.height_imperial > 110.0) {
            self.height_imperial = 110.0;
        } else if (self.height_imperial < 24.0) {
            self.height_imperial = 24.0;
        }
        
        self.weight_imperial = [RunningManager formatOneDecimalValue:self.weight*2.205];
        if (self.weight_imperial > 441.0) {
            self.weight_imperial = 441.0;
        } else if (self.weight_imperial < 44.0) {
            self.weight_imperial = 44.0;
        }
    }
    
    if (self.model.birthday.length) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.model.birthday integerValue]];
        self.birthYear = date.year;
        self.birthMonth = date.month;
        self.birthDay = date.day;
    } else {
        self.birthYear = [NSDate date].year-25;
        self.birthMonth = [NSDate date].month;
        self.birthDay = [NSDate date].day;
    }
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        cellModel.subTitle = self.subTitles[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_user_avatar")]) {
            cellModel.isHideAvatar = NO;
        }
        [self.dataArray addObject:cellModel];
    }
    
    NSString *documentPath  = [DHFile documentPath];
    NSString *directoryPath = [documentPath stringByAppendingPathComponent:DHAvatarFolder];
    [DHFile createDirectoryWithPath:directoryPath error:nil];
}

- (void)navRightButtonClick:(UIButton *)sender {
    if (DHAppStatus == 2 || !self.model.isSyncUserData) {
        [self saveAvatar];
        [self saveUserInfo];
        SHOWHUD(Lang(@"str_save_success"))
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        SHOWINDETERMINATE
        [self uploadAvatar];
    }
}

- (void)uploadAvatar {
    if (!self.avatarImage) {
        [self uploadUserInfo];
        return;
    }
    NSData *avatarData = UIImagePNGRepresentation(self.avatarImage);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"file" forKey:@"name"];
    [dict setObject:@"img.png" forKey:@"fileName"];
    [dict setObject:@"image/png" forKey:@"mimeType"];
    
    WEAKSELF
    [NetworkManager uploadFile:avatarData andParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (resultCode == 0) {
                NSDictionary *result = data;
                if (result[@"url"]) {
                    [weakSelf saveAvatar];
                    [weakSelf saveAvatarUrl:result[@"url"]];
                    [weakSelf uploadUserInfo];
                }
            } else if (resultCode == 10000){
                SHOWHUD(Lang(@"str_network_error"))
            } else {
                SHOWHUD(Lang(@"str_save_fail"))
            }
        });
    }];
}

- (void)uploadUserInfo {
    
    NSString *timestamp = [NSDate get1970timeTempWithYear:self.birthYear andMonth:self.birthMonth andDay:self.birthDay];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.nickName forKey:@"name"];
    [dict setObject:timestamp forKey:@"birthday"];
    [dict setObject:@(self.height) forKey:@"height"];
    [dict setObject:@(self.weight) forKey:@"weight"];
    [dict setObject:self.avatar forKey:@"portraitUrl"];
    [dict setObject:@(self.stepGoal) forKey:@"sportTarget"];
    
    NSInteger gender = self.gender == 0 ? 2 : 1;
    [dict setObject:@(gender) forKey:@"sex"];
    
    WEAKSELF
    [NetworkManager updateUserInformWithParameter:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            HUDDISS
            if (resultCode == 0) {
                [weakSelf saveUserInfo];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else if (resultCode == 10000){
                SHOWHUD(Lang(@"str_network_error"))
            } else {
                NSString *errorStr = [NetworkManager transformErrorCode:resultCode];
                if (errorStr.length) {
                    SHOWHUD(errorStr)
                } else {
                    SHOWHUD(Lang(@"str_update_user_info_fail"))
                }
            }
        });
    }];
}

- (void)saveAvatarUrl:(NSString *)url {
    self.avatar = url;
    self.model.avatar = url;
    [self.model saveOrUpdate];
}

- (void)saveAvatar {
    if (!self.avatarImage) {
        return;
    }
    [DHFile saveLocalImageWithImage:self.avatarImage folderName:DHAvatarFolder fileName:[NSString stringWithFormat:@"%@.png",DHUserId]];
    
    if ([self.delegate respondsToSelector:@selector(avatarUpdate:)]) {
        [self.delegate avatarUpdate:self.avatarImage];
    }
}

- (void)saveUserInfo {
    self.model.name = self.nickName;
    self.model.gender = self.gender;
    self.model.height = self.height;
    self.model.weight = self.weight;
    self.model.stepGoal = self.stepGoal;
    
    NSString *timestamp = [NSDate get1970timeTempWithYear:self.birthYear andMonth:self.birthMonth andDay:self.birthDay];
    self.model.birthday = timestamp;
    [self.model saveOrUpdate];
    
    if (DHAppStatus == 2) {
        VisitorModel *visitorModel = [VisitorModel currentModel];
        visitorModel.name = self.nickName;
        visitorModel.gender = self.gender;
        visitorModel.height = self.height;
        visitorModel.weight = self.weight;
        visitorModel.stepGoal = self.stepGoal;
        visitorModel.birthday = timestamp;
        [visitorModel saveOrUpdate];
    }
    
    
    NSDate *startDate = [[NSString stringWithFormat:@"%@000000",[[NSDate date] dateToStringFormat:@"yyyyMMdd"]] dateByStringFormat:@"yyyyMMddHHmmss"];
    NSDate *endDate = [[NSString stringWithFormat:@"%@235959",[[NSDate date] dateToStringFormat:@"yyyyMMdd"]] dateByStringFormat:@"yyyyMMddHHmmss"];
    [[HealthKitManager shareInstance] saveOrReplace:HealthTypeHeight value:[NSString stringWithFormat:@"%.02f",(long)self.height/100.0] startDate:startDate endDate:endDate];
    [[HealthKitManager shareInstance] saveOrReplace:HealthTypeWeight value:[NSString stringWithFormat:@"%ld",(long)self.weight] startDate:startDate endDate:endDate];
    if (DHDeviceConnected) {
        DHUserInfoSetModel *userInfoModel = [[DHUserInfoSetModel alloc] init];
        userInfoModel.gender = self.gender;
        userInfoModel.height = self.height;
        userInfoModel.weight = self.weight*10;
        userInfoModel.stepGoal = self.stepGoal;
        userInfoModel.age = [NSDate date].year-self.birthYear;
        [DHBleCommand setUserInfo:userInfoModel block:^(int code, id  _Nonnull data) {
            
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(nickNameUpdate:)]) {
        [self.delegate nickNameUpdate:self.nickName];
    }
    //目标变化
    [DHNotificationCenter postNotificationName:AppNotificationStepGoalChange object:nil];
}


#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
}

- (void)avatarClick {
    NSArray *titleArray = @[Lang(@"str_take_photo"),Lang(@"str_album"),Lang(@"str_cancel")];
    WEAKSELF
    BaseActionSheet *actionSheet = [[BaseActionSheet alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [actionSheet showWithTitles:titleArray block:^(NSInteger tag) {
        switch (tag) {
            case 100:
                [weakSelf takePhotoClick];
                break;
            case 101:
                [weakSelf albumClick];
                break;
            default:
                break;
        }
    }];
}

- (void)takePhotoClick {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [BaseView showCameraUnauthorized];
        return;
    }
    self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }
    [self.navigationController presentViewController:self.pickerController animated:YES completion:nil];
}

- (void)albumClick {
    self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }
    [self.navigationController presentViewController:self.pickerController animated:YES completion:nil];
}

- (UIImage *)imageScaleToSize:(CGSize)size withImage:(UIImage *)image {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    }
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MWBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWBaseTableCell" forIndexPath:indexPath];
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    if (!cellModel.isHideAvatar) {
        if (self.avatarImage) {
            cell.avatarView.image = self.avatarImage;
        } else {
            NSData *avatar = [DHFile queryLocalImageWithFolderName:DHAvatarFolder fileName:[NSString stringWithFormat:@"%@.png",DHUserId]];
            if (self.avatar.length) {
                [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:DHImage(@"mine_main_avatar")];
            } else if (avatar) {
                cell.avatarView.image = [UIImage imageWithData:avatar];
            } else {
                cell.avatarView.image = DHImage(@"mine_main_avatar");
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWBaseCellModel *cellModel = self.dataArray[indexPath.row];
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_user_avatar")]) {
        [self avatarClick];
        return;
    }
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_nick")]) {
        NickNameSetViewController *vc = [[NickNameSetViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.nickName = self.nickName;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    self.pickerVC = [[MWPickerViewController alloc] init];
    self.pickerVC.navTitle = cellModel.leftTitle;
    self.pickerVC.isHideNavRightButton = YES;
    self.pickerVC.delegate = self;
    self.pickerVC.viewTag = indexPath.row+98;
    if ([cellModel.leftTitle isEqualToString:Lang(@"str_sex")]) {
        self.pickerVC.dataArray = @[self.genders];
        
        NSInteger genderIndex = [self selectedGenderIndex:self.gender];
        self.pickerVC.selectedRows = @[@(genderIndex)];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_birthday")]) {
        
        NSInteger yearIndex = [self.birthYears indexOfObject:[NSString stringWithFormat:@"%ld",(long)self.birthYear]];
        NSInteger monthIndex = [self.birthMonths indexOfObject:[NSString stringWithFormat:@"%02ld",(long)self.birthMonth]];
        NSInteger dayIndex = [self.birthDays indexOfObject:[NSString stringWithFormat:@"%02ld",(long)self.birthDay]];
        self.pickerVC.dataArray = @[self.birthYears,self.birthMonths,self.birthDays];
        self.pickerVC.selectedRows = @[@(yearIndex),@(monthIndex),@(dayIndex)];
        
        self.currentYear = self.birthYear;
        self.currentMonth = self.birthMonth;
        [self delayPerformBlock:^(id  _Nonnull object) {
            [self resetDateArrayWithComponent:100 andRow:0];
        } WithTime:0.5];
        
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_height")]) {
        NSInteger height = HeightValue(self.height);
        NSInteger currentIndex = [self.heights indexOfObject:@(height)];
        self.pickerVC.dataArray = @[self.heights];
        self.pickerVC.selectedRows = @[@(currentIndex)];
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_weight")]) {
        NSString *weightStr = ImperialUnit ? [NSString stringWithFormat:@"%.01f",self.weight_imperial] : [NSString stringWithFormat:@"%.01f",self.weight];
        NSArray *array = [weightStr componentsSeparatedByString:@"."];
        NSInteger intValue = [array.firstObject integerValue];
        NSInteger floatValue = [array.lastObject integerValue];
        NSInteger intIndex = [self.weights indexOfObject:@(intValue)];
        
        self.pickerVC.dataArray = @[self.weights,self.decimals];
        self.pickerVC.selectedRows = @[@(intIndex),@(floatValue)];
        
        self.weightInt = intValue;
        [self delayPerformBlock:^(id  _Nonnull object) {
            [self resetWeightArrayWithComponent:0 andRow:intIndex];
        } WithTime:0.5];
        
        
    } else if ([cellModel.leftTitle isEqualToString:Lang(@"str_target")]) {
        NSInteger currentIndex = [self.steps indexOfObject:@(self.stepGoal)];
        self.pickerVC.dataArray = @[self.steps];
        self.pickerVC.selectedRows = @[@(currentIndex)];
    }
    [self.navigationController pushViewController:self.pickerVC animated:YES];
}

#pragma mark - MWPickerViewControllerDelegate

- (void)customPickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    if (viewTag == 101) {
        if (component == 0) {
            self.currentYear = [self.birthYears[row] integerValue];
        } else if (component == 1) {
            self.currentMonth = [self.birthMonths[row] integerValue];
        }
        if (component != 2) {
            [self resetDateArrayWithComponent:component andRow:row];
        }
    } else if (viewTag == 103) {
        if (component == 0) {
            self.weightInt = [self.weights[row] integerValue];
            [self resetWeightArrayWithComponent:component andRow:row];
        }
    }
}


- (void)customPickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger row = [pickerView selectedRowInComponent:0];
    MWBaseCellModel *cellModel = self.dataArray[viewTag-98];
    if (viewTag == 100) {
        self.gender = [self selectedGenderIndex:row];
        cellModel.subTitle = self.genders[row];
        [[DHBluetoothManager shareInstance] setJLMuslimArgs:self.gender];
    } else if (viewTag == 101) {
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        NSInteger row2 = [pickerView selectedRowInComponent:2];
        self.birthYear = [self.birthYears[row] integerValue];
        self.birthMonth = [self.birthMonths[row1] integerValue];
        self.birthDay = [self.birthDays[row2] integerValue];
        cellModel.subTitle = [NSString stringWithFormat:@"%04ld/%02ld/%02ld",(long)self.birthYear,(long)self.birthMonth,(long)self.birthDay];
    } else if (viewTag == 102) {
        if (ImperialUnit) {
            self.height_imperial = [self.heights[row] integerValue];
            self.height = self.height_imperial*2.54;
            cellModel.subTitle = [NSString stringWithFormat:@"%.0f%@", self.height_imperial,HeightUnit];
            
            if (self.height > 280.0) {
                self.height = 280.0;
            } else if (self.height < 60.0) {
                self.height = 60.0;
            }
        } else {
            self.height = [self.heights[row] integerValue];
            cellModel.subTitle = [NSString stringWithFormat:@"%.0f%@", self.height,HeightUnit];
        }
        
        
    } else if (viewTag == 103) {
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        NSInteger intValue = [self.weights[row] integerValue];
        NSInteger floatValue = row1;
        if (ImperialUnit) {
            self.weight_imperial = intValue+floatValue/10.0;
            self.weight = self.weight_imperial/2.205;
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",self.weight_imperial,WeightUnit];
            
            if (self.weight > 200.0) {
                self.weight = 200.0;
            } else if (self.weight < 20.0) {
                self.weight = 20.0;
            }
        } else {
            self.weight = intValue+floatValue/10.0;
            cellModel.subTitle = [NSString stringWithFormat:@"%.01f%@",self.weight,WeightUnit];
        }
    } else if (viewTag == 104) {
        self.stepGoal = [self.steps[row] integerValue];
        cellModel.subTitle = [NSString stringWithFormat:@"%ld%@",(long)self.stepGoal,StepUnit];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewTag-98 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)resetDateArrayWithComponent:(NSInteger)component andRow:(NSInteger)row {
    NSMutableArray *monthArray = [NSMutableArray array];
    NSMutableArray *dayArray = [NSMutableArray array];
    
    int daynum = 31;
    NSDate *date = [NSDate date];
    
    if (component == 0) {
        self.currentYear = [self.birthYears[row] integerValue];
    } else if (component == 1) {
        self.currentMonth = [self.birthMonths[row] integerValue];
    }
    
    BOOL isLeapYear = (((self.currentYear%4 == 0)&&(self.currentYear%100 != 0))||(self.currentYear%400 == 0));
    
    if (self.currentYear == date.year) {
        for (int i = 1; i <= date.month; i++) {
            [monthArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        if (self.currentMonth > date.month) {
            self.currentMonth = date.month;
        }
    } else {
        for (int i = 1; i <= 12; i++) {
            [monthArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    
    if (self.currentYear == date.year && self.currentMonth == date.month) {
        daynum = (int)date.day;
    }
    else{
        switch (self.currentMonth-1) {
            case 1:
                if (isLeapYear) {
                    daynum = 29;
                }else {
                    daynum = 28;
                }
                break;
            case 3:
            case 5:
            case 8:
            case 10:
                daynum = 30;
                break;
            case 0:
            case 2:
            case 4:
            case 6:
            case 7:
            case 9:
            case 11:
                daynum = 31;
                break;
            default:
                break;
        }
    }
    for (int i = 1; i <= daynum; i++) {
        [dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    self.birthMonths = monthArray;
    self.birthDays = dayArray;
    
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:self.birthYears];
    [dataArray addObject:monthArray];
    [dataArray addObject:dayArray];
    
    [self.pickerVC reloadAllComponents:dataArray];
}

- (void)resetWeightArrayWithComponent:(NSInteger)component andRow:(NSInteger)row {
    NSMutableArray *floatArray = [NSMutableArray array];
    if (component == 0) {
        self.weightInt = [self.weights[row] integerValue];
    }
    if (self.weightInt >= self.maxWeight) {
        [floatArray addObject:@".0"];
    } else {
        for (int i = 0; i < 10; i++) {
            [floatArray addObject:[NSString stringWithFormat:@".%d",i]];
        }
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:self.weights];
    [dataArray addObject:floatArray];
    [self.pickerVC reloadAllComponents:dataArray];
}

#pragma mark --- NickNameSetViewControllerDelegate

- (void)nickNameUpdate:(NSString *)nickName {
    self.nickName = nickName;
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        if ([cellModel.leftTitle isEqualToString:Lang(@"str_nick")]) {
            cellModel.subTitle = nickName;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

#pragma mark --- UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        
        
    }
}

#pragma mark --- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:image cropFrame:CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [picker pushViewController:imgCropperVC animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}

#pragma mark - YYImageCropperDelegate
- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    WEAKSELF
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
        [weakSelf tempSaveAvatar:editedImage];
    }];
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}

- (void)tempSaveAvatar:(UIImage *)image {
    UIImage *scaleImage = [self imageScaleToSize:CGSizeMake(200.0, 200.0) withImage:image];
    self.avatarImage = scaleImage;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - get and set 属性的set和get方法

- (UIImagePickerController *)pickerController {
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _pickerController.delegate = self;
    }
    return _pickerController;
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = HomeColor_BackgroundColor;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (UserModel *)model {
    if (!_model) {
        _model = [UserModel currentModel];
    }
    return _model;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_user_avatar"),
                    Lang(@"str_nick"),
                    Lang(@"str_sex"),
                    Lang(@"str_birthday"),
                    Lang(@"str_height"),
                    Lang(@"str_weight"),
                    Lang(@"str_target")];
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        CGFloat weight = ImperialUnit ? self.weight_imperial : self.weight;
        _subTitles = @[@"",
                       self.nickName,
                       [self selectedGenderName:self.gender],
                       [NSString stringWithFormat:@"%04ld/%02ld/%02ld",(long)self.birthYear,(long)self.birthMonth,(long)self.birthDay],
                       [NSString stringWithFormat:@"%.0f%@",HeightValue(self.height),HeightUnit],
                       [NSString stringWithFormat:@"%.1f%@",weight,WeightUnit],
                       [NSString stringWithFormat:@"%ld%@",(long)self.stepGoal,StepUnit]];
    }
    return _subTitles;
}

- (NSInteger)selectedGenderIndex:(NSInteger)gender {
    if (gender == 0) {
        return 1;
    }
    return 0;
}



- (NSString *)selectedGenderName:(NSInteger)gender {
    if (gender == 0) {
        return Lang(@"str_woman");
    }
    return Lang(@"str_man");
}

- (NSArray *)genders {
    if (!_genders) {
        _genders = @[Lang(@"str_man"),
                     Lang(@"str_woman")];
    }
    return _genders;
}

- (NSMutableArray *)birthYears {
    if (!_birthYears) {
        _birthYears = [NSMutableArray array];
        for (int i = 1900; i <= [NSDate date].year; i++) {
            [_birthYears addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _birthYears;
}

- (NSMutableArray *)birthMonths {
    if (!_birthMonths) {
        _birthMonths = [NSMutableArray array];
        for (int i = 1; i <= 12; i++) {
            [_birthMonths addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _birthMonths;
}

- (NSMutableArray *)birthDays {
    if (!_birthDays) {
        _birthDays = [NSMutableArray array];
        for (int i = 1; i <= 31; i++) {
            [_birthDays addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _birthDays;
}

- (NSMutableArray *)heights {
    if (!_heights) {
        _heights = [NSMutableArray array];
        if (ImperialUnit) {
            for (int i = 24; i <= 110; i++) {
                [_heights addObject:@(i)];
            }
        } else {
            for (int i = 60; i <= 280; i++) {
                [_heights addObject:@(i)];
            }
        }
        
    }
    return _heights;
}

- (NSMutableArray *)weights {
    if (!_weights) {
        _weights = [NSMutableArray array];
        if (ImperialUnit) {
            for (int i = 44; i <= 441; i++) {
                [_weights addObject:@(i)];
            }
        } else {
            for (int i = 20; i <= 200; i++) {
                [_weights addObject:@(i)];
            }
        }
    }
    return _weights;
}

- (NSMutableArray *)decimals {
    if (!_decimals) {
        _decimals = [NSMutableArray array];
        for (int i = 0; i <= 9; i++) {
            [_decimals addObject:[NSString stringWithFormat:@".%d",i]];
        }
    }
    return _decimals;
}

- (NSMutableArray *)steps {
    if (!_steps) {
        _steps = [NSMutableArray array];
        for (int i = 1; i <= 30; i++) {
            [_steps addObject:@(i*1000)];
        }
    }
    return _steps;
}

@end
