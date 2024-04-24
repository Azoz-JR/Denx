//
//  UserInfoSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "UserInfoSetViewController.h"
#import "BasePickerViewController.h"
#import "NickNameSetViewController.h"
#import "YYImageClipViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface UserInfoSetViewController ()<UITableViewDelegate,UITableViewDataSource,BasePickerViewControllerDelegate,NickNameSetViewControllerDelegate,UIImagePickerControllerDelegate,YYImageClipDelegate,UINavigationControllerDelegate>

#pragma mark UI
/// 列表视图
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) UIImagePickerController *pickerController;

#pragma mark Data
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *subTitles;

@property (nonatomic, strong) NSArray *genders;

@property (nonatomic, strong) NSMutableArray *birthYears;

@property (nonatomic, strong) NSMutableArray *birthMonths;

@property (nonatomic, strong) NSMutableArray *birthDays;

@property (nonatomic, strong) NSMutableArray *heights;

@property (nonatomic, strong) NSMutableArray *weights;

@property (nonatomic, strong) NSMutableArray *steps;


/// 头像URL
@property (nonatomic, copy) NSString *avatar;
/// 用户昵称
@property (nonatomic, copy) NSString *nickName;
/// 性别（0其他 1男 2女）
@property (nonatomic, assign) NSInteger gender;
/// 身高（cm）
@property (nonatomic, assign) NSInteger height;
/// 体重（kg）
@property (nonatomic, assign) NSInteger weight;
/// 步数目标（step）
@property (nonatomic, assign) NSInteger stepGoal;

@property (nonatomic, assign) NSInteger birthYear;

@property (nonatomic, assign) NSInteger birthMonth;

@property (nonatomic, assign) NSInteger birthDay;

@end

@implementation UserInfoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self setupUI];
    
}

- (void)navRightButtonTouchUpInside:(UIButton *)sender {
    if ([ConfigureModel shareInstance].appStatus == 2) {
        //游客
        self.model.nickName = self.nickName;
        self.model.gender = self.gender;
        self.model.height = self.height;
        self.model.weight = self.weight;
        self.model.stepGoal = self.stepGoal;
        self.model.birthday = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)self.birthYear,(long)self.birthMonth,(long)self.birthDay];
        [self.model saveOrUpdate];
        if ([self.delegate respondsToSelector:@selector(userModelChange)]) {
            [self.delegate userModelChange];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //普通用户
    }
}

- (void)initData {
    self.avatar = self.model.avatar;
    self.nickName = self.model.nickName;
    self.gender = self.model.gender;
    self.height = self.model.height;
    self.weight = self.model.weight;
    self.stepGoal = self.model.stepGoal;
    
    NSArray *birthDayArray = [self.model.birthday componentsSeparatedByString:@"-"];
    if (birthDayArray.count == 3) {
        self.birthYear = [birthDayArray[0] integerValue];
        self.birthMonth = [birthDayArray[1] integerValue];
        self.birthDay = [birthDayArray[2] integerValue];
    } else {
        self.birthYear = [NSDate date].year-25;
        self.birthMonth = [NSDate date].month;
        self.birthDay = [NSDate date].day;
    }
    
    
    for (int i = 0; i < self.titles.count; i++) {
        BaseCellModel *cellModel = [[BaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        cellModel.subTitle = self.subTitles[i];
        if ([cellModel.leftTitle isEqualToString:@"头像"]) {
            cellModel.isHideAvatar = NO;
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

#pragma mark ----- UITableViewDelegate,UITableViewDataSource

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
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTableViewCell" forIndexPath:indexPath];
    BaseCellModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    //头像
    if (!cellModel.isHideAvatar) {
        NSData *avatar = [DHFile getLocalImageWithFolderName:@"Avatar" fileName:@"avatar.png"];
        if (avatar) {
            cell.avatarView.image = [UIImage imageWithData:[DHFile getLocalImageWithFolderName:@"Avatar" fileName:@"avatar.png"]];
        } else if (self.avatar.length) {
            [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:self.avatar]];
        } else {
            cell.avatarView.image = [[UIImage alloc] init];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseCellModel *cellModel = self.dataArray[indexPath.row];
    if ([cellModel.leftTitle isEqualToString:@"头像"]) {
        [self avatarTouchUpInside];
    } else if ([cellModel.leftTitle isEqualToString:@"昵称"]) {
        
        NickNameSetViewController *vc = [[NickNameSetViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.nickName = self.nickName;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([cellModel.leftTitle isEqualToString:@"性别"]) {
        BasePickerViewController *vc = [[BasePickerViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.viewTag = indexPath.row+98;
        vc.dataArray = @[self.genders];
        vc.selectedRows = @[@(self.gender-1)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:@"生日"]) {
        BasePickerViewController *vc = [[BasePickerViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.viewTag = indexPath.row+98;
        vc.dataArray = @[self.birthYears,self.birthMonths,self.birthDays];
        NSInteger yearIndex = [self.birthYears indexOfObject:@(self.birthYear)];
        NSInteger monthIndex = [self.birthMonths indexOfObject:@(self.birthMonth)];
        NSInteger dayIndex = [self.birthDays indexOfObject:@(self.birthDay)];
        vc.selectedRows = @[@(yearIndex),@(monthIndex),@(dayIndex)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:@"身高"]) {
        BasePickerViewController *vc = [[BasePickerViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.viewTag = indexPath.row+98;
        NSInteger currentIndex = [self.heights indexOfObject:@(self.height)];
        vc.dataArray = @[self.heights];
        vc.selectedRows = @[@(currentIndex)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:@"体重"]) {
        BasePickerViewController *vc = [[BasePickerViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.viewTag = indexPath.row+98;
        vc.dataArray = @[self.weights];
        NSInteger currentIndex = [self.weights indexOfObject:@(self.weight)];
        vc.selectedRows = @[@(currentIndex)];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cellModel.leftTitle isEqualToString:@"目标"]) {
        BasePickerViewController *vc = [[BasePickerViewController alloc] init];
        vc.navTitle = cellModel.leftTitle;
        vc.isHideNavRightButton = YES;
        vc.delegate = self;
        vc.viewTag = indexPath.row+98;
        vc.dataArray = @[self.steps];
        NSInteger currentIndex = [self.steps indexOfObject:@(self.stepGoal)];
        vc.selectedRows = @[@(currentIndex)];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark ----- BasePickerViewControllerDelegate

- (void)customPickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}


- (void)customPickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger row = [pickerView selectedRowInComponent:0];
    BaseCellModel *cellModel = self.dataArray[viewTag-98];
    if (viewTag == 100) {
        //性别
        self.gender = row+1;
        cellModel.subTitle = self.genders[row];
    } else if (viewTag == 101) {
        //年龄
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        NSInteger row2 = [pickerView selectedRowInComponent:2];
        self.birthYear = [self.birthYears[row] integerValue];
        self.birthMonth = [self.birthMonths[row1] integerValue];
        self.birthDay = [self.birthDays[row2] integerValue];
        cellModel.subTitle = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)self.birthYear,(long)self.birthMonth,(long)self.birthDay];
    } else if (viewTag == 102) {
        //身高
        self.height = [self.heights[row] integerValue];
        cellModel.subTitle = [NSString stringWithFormat:@"%ldcm",(long)self.height];
    } else if (viewTag == 103) {
        //体重
        self.weight = [self.weights[row] integerValue];
        cellModel.subTitle = [NSString stringWithFormat:@"%ldkg",(long)self.weight];
    } else if (viewTag == 104) {
        //目标
        self.stepGoal = [self.steps[row] integerValue];
        cellModel.subTitle = [NSString stringWithFormat:@"%ld步",(long)self.stepGoal];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:viewTag-98 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark --- NickNameSetViewControllerDelegate

- (void)nickNameDidChange:(NSString *)nickName {
    self.nickName = nickName;
    for (int i = 0; i < self.dataArray.count; i++) {
        BaseCellModel *cellModel = self.dataArray[i];
        if ([cellModel.leftTitle isEqualToString:@"昵称"]) {
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
    // bug fixes: UIImagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        
        
    }
}

#pragma mark --- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"didFinishPickingMediaWithInfo");
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
        [weakSelf updateAvatar:editedImage];
    }];
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}

- (void)avatarTouchUpInside {
    NSArray *titleArray = @[@"拍照",@"相册",@"取消"];
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

- (void)updateAvatar:(UIImage *)image {
    UIImage *scaleImage = [self imageScaleToSize:CGSizeMake(200.0, 200.0) withImage:image];
    if ([ConfigureModel shareInstance].appStatus == 2) {
        //游客
        [DHFile setLocalImageWithImage:scaleImage folderName:@"Avatar" fileName:@"avatar.png"];
        [self performSelector:@selector(reloadAvatarView) withObject:nil afterDelay:0.2];
    } else {
        //普通用户
        [self sendAvatarRequest:scaleImage];
    }
    
}

- (void)reloadAvatarView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)sendAvatarRequest:(UIImage *)image {
    
}


//裁剪图片
- (UIImage *)imageScaleToSize:(CGSize)size withImage:(UIImage *)image {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
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
        _titles = @[@"头像",
                    @"昵称",
                    @"性别",
                    @"生日",
                    @"身高",
                    @"体重",
                    @"目标"];
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"",
                       self.nickName,
                       self.genders[self.gender-1],
                       [NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)self.birthYear,(long)self.birthMonth,(long)self.birthDay],
                       [NSString stringWithFormat:@"%ldcm",(long)self.height],
                       [NSString stringWithFormat:@"%ldkg",(long)self.weight],
                       [NSString stringWithFormat:@"%ld步",(long)self.stepGoal]];
    }
    return _subTitles;
}

- (NSArray *)genders {
    if (!_genders) {
        _genders = @[@"男",
                     @"女"];
    }
    return _genders;
}

- (NSMutableArray *)birthYears {
    if (!_birthYears) {
        _birthYears = [NSMutableArray array];
        for (int i = 1922; i <= 2022; i++) {
            [_birthYears addObject:@(i)];
        }
    }
    return _birthYears;
}

- (NSMutableArray *)birthMonths {
    if (!_birthMonths) {
        _birthMonths = [NSMutableArray array];
        for (int i = 1; i <= 12; i++) {
            [_birthMonths addObject:@(i)];
        }
    }
    return _birthMonths;
}

- (NSMutableArray *)birthDays {
    if (!_birthDays) {
        _birthDays = [NSMutableArray array];
        for (int i = 1; i <= 31; i++) {
            [_birthDays addObject:@(i)];
        }
    }
    return _birthDays;
}

- (NSMutableArray *)heights {
    if (!_heights) {
        _heights = [NSMutableArray array];
        for (int i = 60; i <= 220; i++) {
            [_heights addObject:@(i)];
        }
    }
    return _heights;
}

- (NSMutableArray *)weights {
    if (!_weights) {
        _weights = [NSMutableArray array];
        for (int i = 20; i <= 200; i++) {
            [_weights addObject:@(i)];
        }
    }
    return _weights;
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
