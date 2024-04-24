//
//  CustomDialViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "CustomDialViewController.h"
#import "BaseSliderView.h"
#import "YYImageClipViewController.h"
#import "TZImagePickerController.h"
#import "CustomDialCell.h"


@interface CustomDialViewController ()<BaseSliderViewDelegate,BasePickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YYImageClipDelegate, TZImagePickerControllerDelegate>

#pragma mark UI
/// 背景
@property (nonatomic, strong) UIScrollView *myScrollView;
/// 顶部视图
@property (nonatomic, strong) UIView *topView;
/// 顶部背景图
@property (nonatomic, strong) UIImageView *topImageView;
/// 手表背景图
@property (nonatomic, strong) UIImageView *dialBgImageView;
/// 表盘图
@property (nonatomic, strong) UIImageView *dialImageView;
/// 表盘蒙板
@property (nonatomic, strong) UIView *dialMaskView;
/// 选择图片
@property (nonatomic, strong) UIButton *changeButton;
/// 恢复默认
@property (nonatomic, strong) UIButton *restoreButton;
/// 中间视图
@property (nonatomic, strong) UIView *middleView;
/// 颜色视图
@property (nonatomic, strong) UIView *colorsView;
/// 亮度视图
@property (nonatomic, strong) UIView *lightView;
/// 亮度滑块
@property (nonatomic, strong) BaseSliderView *sliderView;
/// 安装
@property (nonatomic, strong) UIButton *confirmButton;
/// 安装进度
@property (nonatomic, strong) BaseProgressView *progressView;
/// 选择器
@property (nonatomic, strong) BasePickerView *pickerView;
/// 时间文字
@property (nonatomic, strong) UILabel *timeLabel;
/// 时间上方文字
@property (nonatomic, strong) UILabel *timeUpLabel;
/// 时间下方文字
@property (nonatomic, strong) UILabel *timeDownLabel;
/// 时间上方图标
@property (nonatomic, strong) UIImageView *timeUpImageView;
/// 时间下方图标
@property (nonatomic, strong) UIImageView *timeDownImageView;
/// 相册
@property (nonatomic, strong) UIImagePickerController *pickerController;


#pragma mark Data

/// 相册照片
@property (nonatomic, strong, nullable) UIImage *dialImage;
/// 正在安装
@property (nonatomic, assign) BOOL isSyncing;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 标题数据源
@property (nonatomic, strong) NSArray *titles;
/// 小标题数据源
@property (nonatomic, strong) NSArray *subTitles;

/// 颜色值数据源
@property (nonatomic, strong) NSArray *colors;
/// 时间位置数据源
@property (nonatomic, strong) NSArray *timePositions;
/// 时间元素数据源
@property (nonatomic, strong) NSArray *timeElements;

/// 时间文字数据源
@property (nonatomic, strong) NSArray *timeElementTitles;
/// 时间图标数据源
@property (nonatomic, strong) NSArray *timeElementImages;


/// 时间位置（0.上方 1.下方）
@property (nonatomic, assign) NSInteger timePos;
/// 时间上方元素（0. 无 1.日期 2.睡眠 3.心率 4.计步）
@property (nonatomic, assign) NSInteger timeUp;
/// 时间上方元素（0. 无 1.日期 2.睡眠 3.心率 4.计步）
@property (nonatomic, assign) NSInteger timeDown;
/// 颜色下标
@property (nonatomic, assign) NSInteger colorIndex;
/// 表盘宽度
@property (nonatomic, assign) NSInteger imageWidth;
/// 表盘高度
@property (nonatomic, assign) NSInteger imageHeight;
/// 表盘图片路径
@property (nonatomic, copy) NSString *imagePath;
/// 蒙板透明度
@property (nonatomic, assign) CGFloat maskAlpha;
/// 保存的图片路径
@property (nonatomic, copy) NSString *filePath;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

@property (nonatomic, strong) NSData *fileData;

@property (nonatomic, strong) NSData *thumbnailData;

@end

@implementation CustomDialViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    [self setupTopView];
    [self setupMiddleView];
    [self setupTimeView];
}

#pragma mark - custom action for UI 界面处理有关

- (void)initData {
    
    
    NSString *documentPath  = [DHFile documentPath];
    NSString *directoryPath = [documentPath stringByAppendingPathComponent:DHDialFolder];
    [DHFile createDirectoryWithPath:directoryPath error:nil];
    
    self.macAddr = [DHMacAddr stringByReplacingOccurrencesOfString:@":" withString:@""];
    self.filePath = [directoryPath stringByAppendingFormat:@"/%@.png",self.macAddr];
    
    
    self.imageHeight = DHDialHeight;
    self.imageWidth = DHDialWidth;
    
    self.timePos = self.model.timePos;
    self.timeUp = self.model.timeUp;
    self.timeDown = self.model.timeDown;
    self.colorIndex = [self.colors indexOfObject:@(self.model.textColor)];
    self.imagePath = self.model.imagePath;
    self.maskAlpha = 0.0;
    
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        cellModel.subTitle = self.subTitles[i];
        [self.dataArray addObject:cellModel];
    }
}

- (void)setupUI {
    
    self.myScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.myScrollView];
    
    CGFloat topViewH = 300;
    CGFloat middleViewH = 50*5+80;
    CGFloat scrollViewH = kScreenHeight-kNavAndStatusHeight-kBottomHeight-25-50-10;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myScrollView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.offset(topViewH);
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.height.offset(middleViewH);
    }];
    
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(kNavAndStatusHeight);
        make.height.offset(scrollViewH);
        make.bottom.equalTo(self.middleView.mas_bottom);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.bottom.offset(-(kBottomHeight+25));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.bottom.offset(-(kBottomHeight+25));
    }];
}

- (void)setupTopView {
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
    }];
    
    [self.dialBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.centerX.equalTo(self.topView);
        make.width.offset(122);
        make.height.offset(192);
    }];
    self.dialBgImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *tBgImageUrl = [DHBluetoothManager shareInstance].dialServiceInfoModel.customizeDialShowUrl;
    [self.dialBgImageView sd_setImageWithURL:[NSURL URLWithString:tBgImageUrl] placeholderImage:DHImage(@"device_dial_wallpaper_bg")];

    if ([DHBluetoothManager shareInstance].dialInfoModel.screenType == 0){ //方屏
        [self.dialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(96);
            make.height.offset(116);
            make.centerX.equalTo(self.dialBgImageView).offset(0);
            make.centerY.equalTo(self.dialBgImageView).offset(1);
        }];
    }
    else{
        [self.dialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(102);
            make.height.offset(102);
            make.centerX.equalTo(self.dialBgImageView).offset(0);
            make.centerY.equalTo(self.dialBgImageView).offset(1);
        }];
        self.dialImageView.layer.cornerRadius = 102/2.0;
    }
    
    [self.dialMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        CGSize fitSize = [self.changeButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        make.bottom.offset(-20);
        make.width.offset(120);
        make.height.offset(36);
        make.centerX.equalTo(self.topView).offset(-kScreenWidth/8.0-30);
    }];
    
    [self.restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-20);
        make.width.offset(120);
        make.height.offset(36);
        make.centerX.equalTo(self.topView).offset(kScreenWidth/8.0+30);
    }];
}

- (void)setupTimeView {
    CGFloat timeOffset = self.timePos == 0 ? -30 : 30;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.dialBgImageView);
        make.centerY.equalTo(self.dialBgImageView).offset(timeOffset);
    }];
    
    [self.timeUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.mas_top).offset(5);
        make.centerX.equalTo(self.timeLabel);
    }];
    
    [self.timeDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(-5);
        make.centerX.equalTo(self.timeLabel);
    }];
    
    [self.timeUpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeUpLabel.mas_left);
        make.centerY.equalTo(self.timeUpLabel);
        make.width.height.offset(6);
    }];
    
    [self.timeDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeDownLabel.mas_left);
        make.centerY.equalTo(self.timeDownLabel);
        make.width.height.offset(6);
    }];
    
    self.timeUpLabel.text = self.timeElementTitles[self.timeUp];
    self.timeDownLabel.text = self.timeElementTitles[self.timeDown];
    self.timeUpImageView.hidden = self.timeUpLabel.text.length == 0;
    self.timeDownImageView.hidden = self.timeDownLabel.text.length == 0;
    
    NSInteger color = [self.colors[self.colorIndex] integerValue];
    NSInteger red = (color >> 16 & 0xFF);
    NSInteger green = (color >> 8 & 0xFF);
    NSInteger blue = (color >> 0 & 0xFF);
    UIColor *currentColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    
    self.timeLabel.textColor = currentColor;
    self.timeUpLabel.textColor = currentColor;
    self.timeDownLabel.textColor = currentColor;
    
    
    NSString *timeUpImage = self.timeElementImages[self.timeUp];
    NSString *timeDownImage = self.timeElementImages[self.timeDown];
    self.timeUpImageView.image = timeUpImage.length ? DHImage(timeUpImage) : [[UIImage alloc] init];
    self.timeDownImageView.image = timeDownImage.length ? DHImage(timeDownImage) : [[UIImage alloc] init];
}

- (void)setupMiddleView {
    UIView *lastView;
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_BackgroundColor;
        itemView.tag = 1000+i;
        itemView.userInteractionEnabled = YES;
        if (i < 3) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeViewTap:)];
            [itemView addGestureRecognizer:tap];
        }
        [self.middleView addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.offset(HomeViewSpace_Left);
                make.right.offset(-HomeViewSpace_Right);
                make.height.offset(50);
            }];
        } else if (i < 3) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.left.offset(HomeViewSpace_Left);
                make.right.offset(-HomeViewSpace_Right);
                make.height.offset(50);
            }];
            
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.left.offset(HomeViewSpace_Left);
                make.right.offset(-HomeViewSpace_Right);
                make.height.offset(90);
            }];
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = HomeColor_TitleColor;
        titleLabel.font = HomeFont_TitleFont;
        titleLabel.text = cellModel.leftTitle;
        [itemView addSubview:titleLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.textColor = HomeColor_SubTitleColor;
        subTitleLabel.font = HomeFont_SubTitleFont;
        subTitleLabel.text = cellModel.subTitle;
        subTitleLabel.textAlignment = NSTextAlignmentRight;
        subTitleLabel.tag = 3000+i;
        [itemView addSubview:subTitleLabel];
        
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.contentMode = UIViewContentModeRight;
        rightImageView.image = DHImage(@"public_cell_arrow");
        [itemView addSubview:rightImageView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = HomeColor_BlockColor;
        lineView.layer.cornerRadius = 1.5;
        lineView.layer.masksToBounds = YES;
        [itemView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.offset(3);
            make.top.offset(47);
        }];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(12);
            make.right.offset(-10);
            make.bottom.equalTo(lineView.mas_top).offset(-12);
        }];
        
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rightImageView);
            make.right.equalTo(rightImageView.mas_left).offset(-10);
            make.width.offset(80);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rightImageView);
            make.left.offset(10);
            make.right.equalTo(subTitleLabel.mas_left).offset(-5);
        }];
        
        if (i >= 3) {
            lineView.hidden = YES;
            rightImageView.hidden = YES;
            subTitleLabel.hidden = YES;
            if (i == 3) {
                [itemView addSubview:self.colorsView];
                [self.colorsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.offset(0);
                    make.left.offset(20);
                    make.right.offset(-20);
                    make.height.offset(40);
                }];
                [self setupColorsView];
            } else {
                [itemView addSubview:self.lightView];
                [self.lightView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.offset(-10);
                    make.left.offset(20);
                    make.right.offset(-20);
                    make.height.offset(40);
                }];
                [self setupSliderView];
            }
        }
        
        lastView = itemView;
    }
}

- (void)setupColorsView {
    UIScrollView *colorsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-70, 40)];
    colorsScrollView.contentSize = CGSizeMake((36+10)*self.colors.count-10, 40);
    colorsScrollView.showsVerticalScrollIndicator = NO;
    colorsScrollView.showsHorizontalScrollIndicator = NO;
    [self.colorsView addSubview:colorsScrollView];
    
    UIView *lastView;
    for (int i = 0; i < self.colors.count; i++) {
        NSInteger color = [self.colors[i] integerValue];
        NSInteger red = (color >> 16 & 0xFF);
        NSInteger green = (color >> 8 & 0xFF);
        NSInteger blue = (color >> 0 & 0xFF);
        UIView *colorBgView = [[UIView alloc] init];
        colorBgView.backgroundColor = HomeColor_BackgroundColor;
        colorBgView.layer.cornerRadius = 18.0;
        colorBgView.layer.masksToBounds = YES;
        colorBgView.layer.borderColor = i == self.colorIndex ? [UIColor whiteColor].CGColor : HomeColor_BackgroundColor.CGColor;
        colorBgView.layer.borderWidth = 1.0;
        colorBgView.tag = 2000+i;
        colorBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorViewTap:)];
        [colorBgView addGestureRecognizer:tap];
        [colorsScrollView addSubview:colorBgView];
        
        if (i == 0) {
            [colorBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.width.height.offset(36);
                make.centerY.equalTo(colorsScrollView);
            }];
        } else {
            [colorBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(10);
                make.width.height.offset(36);
                make.centerY.equalTo(colorsScrollView);
            }];
        }
        
        UIView *colorView = [[UIView alloc] init];
        colorView.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        colorView.layer.cornerRadius = 13.0;
        colorView.layer.masksToBounds = YES;
        [colorBgView addSubview:colorView];
        
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(26);
            make.centerX.equalTo(colorBgView);
            make.centerY.equalTo(colorBgView);
        }];
        
        lastView = colorBgView;
    }
    
}

- (void)setupSliderView {
    self.sliderView = [[BaseSliderView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth-70, 30)];
    self.sliderView.delegate = self;
    self.sliderView.minValue = 0;
    self.sliderView.maxValue = 100;
    self.sliderView.value = 100;
    [self.lightView addSubview:self.sliderView];
}


- (void)navLeftButtonClick:(UIButton *)sender {
    if (self.isSyncing) {
        SHOWHUD(Lang(@"str_installing"))
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeClick:(UIButton *)sender {
    if (self.isSyncing) {
        return;
    }
    
//    self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    if (@available(iOS 11.0, *)){
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
//    }
//    [self.navigationController presentViewController:self.pickerController animated:YES completion:nil];
        
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerVc.allowCrop = true;
    imagePickerVc.allowTakeVideo = false;
    imagePickerVc.allowPickingVideo = false;
    imagePickerVc.allowPickingGif = false;
    
    if ([DHBluetoothManager shareInstance].dialInfoModel.screenType == 0){
        imagePickerVc.needCircleCrop = false;
    }
    else{
        imagePickerVc.needCircleCrop = true;
    }

    __weak CustomDialViewController *weakSelf = self;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *tSelectPhoto = photos.firstObject;
        if (tSelectPhoto != nil){
            [weakSelf tempSaveAvatar:tSelectPhoto];
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)restoreClick:(UIButton *)sender {
    if (self.isSyncing) {
        return;
    }
    [self showRestoreTips];
}

- (void)showRestoreTips {
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WEAKSELF
    [alertView showWithTitle:@""
                     message:Lang(@"str_dial_restore_tips")
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            [weakSelf onRestore];
        }
    }];
}

- (void)onRestore {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    self.imagePath = @"";
    self.dialImage = nil;
    self.dialImageView.image = [CustomDialCell imageFromColor:[UIColor blackColor] size:self.dialImageView.frame.size];
    
    self.maskAlpha = 0.0;
    self.timePos = 0;
    self.timeUp = 1;
    self.timeDown = 4;
    self.colorIndex = self.colors.count-1;
    self.sliderView.value = 100;
    self.dialMaskView.backgroundColor = COLORANDALPHA(@"#000000", self.maskAlpha);
    
    [self updateTimePosition];
    [self updateTimeUpLabel];
    [self updateTimeDownLabel];
    
    [self setTimePositionOnly];
}

- (void)confirmClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    if (self.dialImage == nil) {
        [self setTimePositionOnly];
    } else {
//        [self thumbnailSyncingStart];
        [self fileSyncingStart];
    }
}

- (NSData *)transformFileData {
    
    NSLog(@"transformFileData imageWidth %d imageHeight %d", self.imageWidth, self.imageHeight);
    UIView *wallpaperView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, self.imageWidth, self.imageHeight)];
    [self.view addSubview:wallpaperView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:wallpaperView.bounds];
    imageView.image = self.dialImage;
    imageView.contentMode = UIViewContentModeCenter;
    [wallpaperView addSubview:imageView];
    
    wallpaperView.alpha = 1 - self.maskAlpha;
    
//    UIView *maskView = [[UIView alloc] initWithFrame:wallpaperView.bounds];
//    maskView.backgroundColor = COLORANDALPHA(@"#000000", self.maskAlpha);
//    [wallpaperView addSubview:maskView];
    
    UIImage *image = [self getmakeImageWithView:wallpaperView andWithSize:wallpaperView.bounds.size];
    NSData *fileData = UIImagePNGRepresentation(image);
    [wallpaperView removeFromSuperview];
    
    return fileData;
}

- (NSData *)transformThumbnailData {
    
    UIView *wallpaperView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, 0.625*self.imageWidth, 0.625*self.imageHeight)];
    wallpaperView.layer.cornerRadius = 16.5;
    wallpaperView.layer.masksToBounds = YES;
    [self.view addSubview:wallpaperView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:wallpaperView.bounds];
    imageView.image = self.dialImage;
    imageView.contentMode = UIViewContentModeCenter;
    [wallpaperView addSubview:imageView];

    UIImage *image = [self getmakeImageWithView:wallpaperView andWithSize:wallpaperView.bounds.size];
    NSData *fileData = UIImagePNGRepresentation(image);
    [wallpaperView removeFromSuperview];
    
    return fileData;
}

- (UIImage *)getmakeImageWithView:(UIView *)view andWithSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 1.0);
//    BOOL success = [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    return image;
}

- (void)thumbnailSyncingStart {
    self.thumbnailData = [self transformThumbnailData];
    if (!self.thumbnailData) {
        return;
    }
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    self.isSyncing = YES;
    self.confirmButton.hidden = YES;
    self.progressView.hidden = NO;
    self.sliderView.userInteractionEnabled = NO;
    [self.progressView updateDialSyncingProgress:0];
    
    DHFileSyncingModel *model = [[DHFileSyncingModel alloc] init];
    model.fileType = 4;
    model.fileSize = self.thumbnailData.length;
    model.fileData = self.thumbnailData;
    [DHBleCommand fileSyncingStart:model block:^(int code, id  _Nonnull data) {

    }];
    
    [self performSelector:@selector(startThumbnailSyncing) withObject:nil afterDelay:1.3];
}

- (void)startThumbnailSyncing {
    WEAKSELF
    [DHBleCommand startThumbnailSyncing:self.thumbnailData customDial:YES block:^(int code, CGFloat progress, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (code == 0) {
                [weakSelf.progressView updateDialSyncingProgress:0.3*progress];
                if ([data isEqualToString:@"Finished"]) {
                    [weakSelf performSelector:@selector(fileSyncingStart) withObject:nil afterDelay:0.3];
                }
            } else {
                [weakSelf dialInstalledFailed];
            }
        });
    }];
}

- (void)fileSyncingStart {
    self.fileData = [self transformFileData];
    if (!self.fileData) {
        return;
    }
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    self.isSyncing = YES;
    self.confirmButton.hidden = YES;
    self.progressView.hidden = NO;
    self.sliderView.userInteractionEnabled = NO;

    [self.progressView updateDialSyncingProgress:0];
    DHFileSyncingModel *model = [[DHFileSyncingModel alloc] init];
    model.fileType = 3;
    model.fileSize = self.fileData.length;
    model.fileData = self.fileData;
    [DHBleCommand fileSyncingStart:model block:^(int code, id  _Nonnull data) {
        
    }];
    [self performSelector:@selector(installDial) withObject:nil afterDelay:1.3];
}

- (void)installDial {
    
    DHCustomDialSyncingModel *model = [[DHCustomDialSyncingModel alloc] init];
    model.fileData = self.fileData;
    model.timePos = self.timePos;
    model.timeUp = self.timeUp;
    model.timeDown = self.timeDown;
    model.textColor = [self.colors[self.colorIndex] integerValue];
    model.imageType = 2;
    model.imageWidth = self.imageWidth;
    model.imageHeight = self.imageHeight;
    WEAKSELF
    [DHBleCommand startCustomDialSyncing:model block:^(int code, CGFloat progress, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (code == 0) {
                [weakSelf.progressView updateDialSyncingProgress:progress];
                if ([data isEqualToString:@"Finished"]) {
                    [weakSelf dialInstalledSuccess];
                }
            } else {
                [weakSelf dialInstalledFailed];
            }
        });
    }];
}
 
- (void)setTimePositionOnly {
    DHCustomDialSyncingModel *model = [[DHCustomDialSyncingModel alloc] init];
    model.timePos = self.timePos;
    model.timeUp = self.timeUp;
    model.timeDown = self.timeDown;
    model.textColor = [self.colors[self.colorIndex] integerValue];
    model.imageType = self.imagePath.length ? 0 : 1;
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand startCustomDialSyncing:model block:^(int code, CGFloat progress, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (code == 0) {
                [weakSelf dialSyncingSuccess];
            } else {
                [weakSelf dialSyncingFailed];
            }
        });
    }];
}

- (void)dialSyncingSuccess {
    
    if (self.imagePath.length == 0) {
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:self.filePath];
        if (isExist) {
            [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
        }
    }

    self.model.timePos = self.timePos;
    self.model.timeUp = self.timeUp;
    self.model.timeDown = self.timeDown;
    self.model.textColor = [self.colors[self.colorIndex] integerValue];
    self.model.imagePath = self.imagePath;
    [self.model saveOrUpdate];
    
    if ([self.delegate respondsToSelector:@selector(customDialInstallSuccess:)]) {
        [self.delegate customDialInstallSuccess:self.model];
    }
    SHOWHUD(Lang(@"str_save_success"));
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dialSyncingFailed {
    SHOWHUD(Lang(@"str_save_fail"));
    [self.confirmButton setTitle:Lang(@"str_reinstall") forState:UIControlStateNormal];
}

- (void)dialInstalledSuccess {
    
    [DHFile saveLocalImageWithImage:self.dialImage folderName:DHDialFolder fileName:[NSString stringWithFormat:@"%@.png",self.macAddr]];
    
    self.model.timePos = self.timePos;
    self.model.timeUp = self.timeUp;
    self.model.timeDown = self.timeDown;
    self.model.textColor = [self.colors[self.colorIndex] integerValue];
    self.model.imagePath = self.filePath;
    [self.model saveOrUpdate];
    
    if ([self.delegate respondsToSelector:@selector(customDialInstallSuccess:)]) {
        [self.delegate customDialInstallSuccess:self.model];
    }
    
    SHOWHUD(Lang(@"str_save_success"));
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dialInstalledFailed {
    SHOWHUD(Lang(@"str_save_fail"));
    [self.confirmButton setTitle:Lang(@"str_reinstall") forState:UIControlStateNormal];
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    self.isSyncing = NO;
    self.confirmButton.hidden = NO;
    self.progressView.hidden = YES;
    self.sliderView.userInteractionEnabled = YES;
    [self.progressView updateDialSyncingProgress:0];
}

- (void)timeViewTap:(UITapGestureRecognizer *)sender {
    if (self.isSyncing) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self showPickerView:sender.view.tag];
    }
}

- (void)colorViewTap:(UITapGestureRecognizer *)sender {
    if (self.isSyncing) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.colorIndex = sender.view.tag-2000;
        for (int i = 0; i < self.colors.count; i++) {
            UIView *colorView = [self.colorsView viewWithTag:2000+i];
            colorView.layer.borderColor = self.colorIndex == i ? [UIColor whiteColor].CGColor : HomeColor_BackgroundColor.CGColor;
        }
        
        NSInteger color = [self.colors[self.colorIndex] integerValue];
        NSInteger red = (color >> 16 & 0xFF);
        NSInteger green = (color >> 8 & 0xFF);
        NSInteger blue = (color >> 0 & 0xFF);
        UIColor *currentColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        
        self.timeLabel.textColor = currentColor;
        self.timeUpLabel.textColor = currentColor;
        self.timeDownLabel.textColor = currentColor;
    }
}

- (void)showPickerView:(NSInteger)viewTag{
    self.pickerView = [[BasePickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.pickerView.delegate = self;
    NSInteger currentIndex = [self indexOfViewTag:viewTag];
    NSArray *array = [self dataArrayOfViewTag:viewTag];
    [self.pickerView setupPickerView:@[array] unitStr:@"" viewTag:viewTag];
    [self.pickerView updateSelectRow:currentIndex inComponent:0];
    
}

- (NSInteger)indexOfViewTag:(NSInteger)viewTag {
    if (viewTag == 1000) {
        return self.timePos;
    }
    if (viewTag == 1001) {
        return self.timeUp;
    }
    return self.timeDown;
}

- (NSArray *)dataArrayOfViewTag:(NSInteger)viewTag {
    if (viewTag == 1000) {
        return self.timePositions;
    }
    return self.timeElements;
}

- (void)updateTimePosition {
    CGFloat timeOffset = self.timePos == 0 ? -30 : 30;
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.dialBgImageView);
        make.centerY.equalTo(self.dialBgImageView).offset(timeOffset);
    }];
}

- (void)updateTimeUpLabel {
    self.timeUpLabel.text = self.timeElementTitles[self.timeUp];
    self.timeUpImageView.hidden = self.timeUpLabel.text.length == 0;

    NSString *timeUpImage = self.timeElementImages[self.timeUp];
    self.timeUpImageView.image = timeUpImage.length ? DHImage(timeUpImage) : [[UIImage alloc] init];
}

- (void)updateTimeDownLabel {
    self.timeDownLabel.text = self.timeElementTitles[self.timeDown];
    self.timeDownImageView.hidden = self.timeDownLabel.text.length == 0;
    
    NSString *timeDownImage = self.timeElementImages[self.timeDown];
    self.timeDownImageView.image = timeDownImage.length ? DHImage(timeDownImage) : [[UIImage alloc] init];
}

#pragma mark - BasePickerViewDelegate

- (void)basePickerViewDidSelectRow:(NSInteger)row inComponent:(NSInteger)component viewTag:(NSInteger)viewTag {
    
}

- (void)basePickerViewConfirm:(UIPickerView *)pickerView viewTag:(NSInteger)viewTag {
    NSInteger row = [pickerView selectedRowInComponent:0];
    MWBaseCellModel *cellModel = self.dataArray[viewTag-1000];
    if (viewTag == 1000) {
        if (self.timePos == row) {
            return;
        }
        self.timePos = row;
        cellModel.subTitle = self.timePositions[row];
        [self updateTimePosition];
    } else if (viewTag == 1001) {
        if (self.timeUp == row) {
            return;
        }
        if (self.timeDown > 0 && self.timeDown == row) {
            SHOWHUD(Lang(@"str_up_and_down_same_tips"))
            return;
        }
        self.timeUp = row;
        cellModel.subTitle = self.timeElements[row];
        [self updateTimeUpLabel];
    } else {
        if (self.timeDown == row) {
            return;
        }
        if (self.timeUp > 0 && self.timeUp == row) {
            SHOWHUD(Lang(@"str_up_and_down_same_tips"))
            return;
        }
        self.timeDown = row;
        cellModel.subTitle = self.timeElements[row];
        [self updateTimeDownLabel];
    }
    
    UILabel *subTitleLabel = [self.middleView viewWithTag:2000+viewTag];
    if (subTitleLabel) {
        subTitleLabel.text = cellModel.subTitle;
    }
}

#pragma mark - 滑板代理方法

- (void)SliderChangeValue:(BaseSliderView *)Slide{
    self.maskAlpha = 1.0-Slide.value/100.0;
    self.dialMaskView.backgroundColor = COLORANDALPHA(@"#000000", self.maskAlpha);
}

- (void)SliderClickChangeValue:(BaseSliderView *)Slide{
    self.maskAlpha = 1.0-Slide.value/100.0;
    self.dialMaskView.backgroundColor = COLORANDALPHA(@"#000000", self.maskAlpha);
}

- (void)SliderTouchChangeValue:(BaseSliderView *)Slide{
    self.maskAlpha = 1.0-Slide.value/100.0;
    self.dialMaskView.backgroundColor = COLORANDALPHA(@"#000000", self.maskAlpha);
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
    YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:image cropFrame:CGRectMake((kScreenWidth-self.imageWidth)/2, (kScreenHeight-self.imageHeight)/2, self.imageWidth, self.imageHeight) limitScaleRatio:3.0];
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
    UIImage *scaleImage = [self imageScaleToSize:CGSizeMake(self.imageWidth, self.imageHeight) withImage:image];
    self.dialImage = scaleImage;
    self.dialImageView.image = self.dialImage;
}

//裁剪图片
- (UIImage *)imageScaleToSize:(CGSize)size withImage:(UIImage *)image {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark- TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    NSLog(@"imagePickerController didFinishPickingPhotos %d", photos.count);
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

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = HomeColor_BackgroundColor;
        [self.myScrollView addSubview:_topView];
    }
    return _topView;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = DHImage(@"device_dial_wallpaper_top");
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.topView addSubview:_topImageView];
    }
    return _topImageView;
}

- (UIImageView *)dialBgImageView {
    if (!_dialBgImageView) {
        _dialBgImageView = [[UIImageView alloc] init];
        _dialBgImageView.image = DHImage(@"device_dial_wallpaper_bg");
        _dialBgImageView.contentMode = UIViewContentModeCenter;
        [self.topView addSubview:_dialBgImageView];
    }
    return _dialBgImageView;
}

- (UIImageView *)dialImageView {
    if (!_dialImageView) {
        _dialImageView = [[UIImageView alloc] init];
        _dialImageView.layer.cornerRadius = 16.0;
        _dialImageView.layer.masksToBounds = YES;
        
        if (self.imagePath.length) {
            NSData *imageData = [DHFile queryLocalImageWithFolderName:DHDialFolder fileName:[NSString stringWithFormat:@"%@.png",self.macAddr]];
            if (imageData) {
                _dialImageView.image = [UIImage imageWithData:imageData];
            } else {
                _dialImageView.image = [CustomDialCell imageFromColor:[UIColor blackColor] size:self.dialImageView.frame.size];
            }
        } else {
            _dialImageView.image = [CustomDialCell imageFromColor:[UIColor blackColor] size:self.dialImageView.frame.size];
        }
        
        [self.dialBgImageView addSubview:_dialImageView];
    }
    return _dialImageView;
}

- (UIView *)dialMaskView {
    if (!_dialMaskView) {
        _dialMaskView = [[UIView alloc] init];
        _dialMaskView.backgroundColor = COLORANDALPHA(@"#000000", self.maskAlpha);
        [self.dialImageView addSubview:_dialMaskView];
    }
    return _dialMaskView;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeButton.layer.cornerRadius = 5.0;
        _changeButton.layer.masksToBounds = YES;
        _changeButton.titleLabel.font = HomeFont_ContentFont;
        _changeButton.titleLabel.numberOfLines = 0;
        _changeButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_changeButton setTitle:Lang(@"str_select_picture") forState:UIControlStateNormal];
        [_changeButton setTitleColor:HomeColor_ButtonNormal forState:UIControlStateNormal];
        _changeButton.backgroundColor = HomeColor_MainColor;
        [_changeButton addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_changeButton];
    }
    return _changeButton;
}

- (UIButton *)restoreButton {
    if (!_restoreButton) {
        _restoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _restoreButton.layer.cornerRadius = 5.0;
        _restoreButton.layer.masksToBounds = YES;
        _restoreButton.titleLabel.font = HomeFont_ContentFont;
        _restoreButton.titleLabel.numberOfLines = 0;
        _restoreButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_restoreButton setTitle:Lang(@"str_restore_default") forState:UIControlStateNormal];
        [_restoreButton setTitleColor:HomeColor_ButtonNormal forState:UIControlStateNormal];
        _restoreButton.backgroundColor = COLOR(@"#B3B3B3");
        [_restoreButton addTarget:self action:@selector(restoreClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_restoreButton];
    }
    return _restoreButton;
}

- (UIView *)middleView {
    if (!_middleView) {
        _middleView = [[UIView alloc] init];
        _middleView.backgroundColor = HomeColor_BackgroundColor;
        [self.myScrollView addSubview:_middleView];
    }
    return _middleView;
}

- (UIView *)colorsView {
    if (!_colorsView) {
        _colorsView = [[UIView alloc] init];
        _colorsView.backgroundColor = HomeColor_BackgroundColor;
    }
    return _colorsView;
}

- (UIView *)lightView {
    if (!_lightView) {
        _lightView = [[UIView alloc] init];
        _lightView.backgroundColor = HomeColor_BackgroundColor;
    }
    return _lightView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"10:00";
        _timeLabel.textColor = HomeColor_TitleColor;
        _timeLabel.font = HomeFont_Regular_22;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.dialBgImageView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)timeUpLabel {
    if (!_timeUpLabel) {
        _timeUpLabel = [[UILabel alloc] init];
        _timeUpLabel.textColor = HomeColor_TitleColor;
        _timeUpLabel.font = HomeFont_Regular_10;
        _timeUpLabel.textAlignment = NSTextAlignmentCenter;
        [self.dialBgImageView addSubview:_timeUpLabel];
    }
    return _timeUpLabel;
}

- (UILabel *)timeDownLabel {
    if (!_timeDownLabel) {
        _timeDownLabel = [[UILabel alloc] init];
        _timeDownLabel.textColor = HomeColor_TitleColor;
        _timeDownLabel.font = HomeFont_Regular_10;
        _timeDownLabel.textAlignment = NSTextAlignmentCenter;
        [self.dialBgImageView addSubview:_timeDownLabel];
    }
    return _timeDownLabel;
}

- (UIImageView *)timeUpImageView {
    if (!_timeUpImageView) {
        _timeUpImageView = [[UIImageView alloc] init];
        _timeUpImageView.contentMode = UIViewContentModeCenter;
        [self.dialBgImageView addSubview:_timeUpImageView];
    }
    return _timeUpImageView;
}

- (UIImageView *)timeDownImageView {
    if (!_timeDownImageView) {
        _timeDownImageView = [[UIImageView alloc] init];
        _timeDownImageView.contentMode = UIViewContentModeCenter;
        [self.dialBgImageView addSubview:_timeDownImageView];
    }
    return _timeDownImageView;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 10.0;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.titleLabel.font = HomeFont_ButtonFont;
        [_confirmButton setTitle:Lang(@"str_install") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        _confirmButton.backgroundColor = HomeColor_MainColor;
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (BaseProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[BaseProgressView alloc] init];
        _progressView.layer.cornerRadius = 10.0;
        _progressView.layer.masksToBounds = YES;
        _progressView.hidden = YES;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (NSArray *)colors {
    if (!_colors) {
        _colors = @[@(0xDE4371),
                    @(0xDE4343),
                    @(0xDE7143),
                    @(0xDBA85C),
                    @(0xDBCF60),
                    
                    @(0xB7C96B),
                    @(0xA8E36D),
                    @(0x85E36D),
                    @(0x6DE379),
                    @(0x6DE39C),
                    
                    @(0x6DE3C0),
                    @(0x6DE3E3),
                    @(0x6DC0E3),
                    @(0x6DC0E3),
                    @(0x6d79e3),
                    
                    @(0x856DE3),
                    @(0xA86DE3),
                    @(0xCB6DE3),
                    @(0xE36DD7),
                    @(0xE36DB4),
                    
                    @(0xFFFFFF),
                    @(0x000000)];
    }
    return _colors;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_time_position"),
                    Lang(@"str_time_up"),
                    Lang(@"str_time_down"),
                    Lang(@"str_text_color"),
                    Lang(@"str_picture_brightness")];
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[self.timePositions[self.model.timePos],
                       self.timeElements[self.model.timeUp],
                       self.timeElements[self.model.timeDown],
                       @"",
                       @""];
    }
    return _subTitles;
}

- (NSArray *)timePositions {
    if (!_timePositions) {
        _timePositions = @[Lang(@"str_upper"),
                           Lang(@"str_below")];
    }
    return _timePositions;
}

- (NSArray *)timeElements {
    if (!_timeElements) {
        _timeElements = @[Lang(@"str_nothing"),
                          Lang(@"str_date"),
                          Lang(@"str_sleep_title"),
                          Lang(@"str_hr_title"),
                          Lang(@"str_step_title")];
    }
    return _timeElements;
}

- (NSArray *)timeElementTitles {
    if (!_timeElementTitles) {
        _timeElementTitles = @[@"",
                               @"THU 06",
                               @"00h00m",
                               @"080",
                               @"0"];
    }
    return _timeElementTitles;
}

- (NSArray *)timeElementImages {
    if (!_timeElementImages) {
        _timeElementImages = @[@"",
                               @"",
                               @"device_time_sleep",
                               @"device_time_hr",
                               @"device_time_step"];
    }
    return _timeElementImages;
}

@end
