//
//  DialDetailViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "DialDetailViewController.h"

@interface DialDetailViewController ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIImageView *dialImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *downloadLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *fileSizeLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) BaseProgressView *progressView;

@property (nonatomic, assign) BOOL isSyncing;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) NSString *thumbnailPath;

/// 表盘宽度
@property (nonatomic, assign) NSInteger imageWidth;
/// 表盘高度
@property (nonatomic, assign) NSInteger imageHeight;

@property (nonatomic, strong) NSData *thumbnailData;

@end

@implementation DialDetailViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageHeight = DHDialHeight;
    self.imageWidth = DHDialWidth;
    
    [self setupUI];
}

#pragma mark - custom action for UI 界面处理有关

- (void)navLeftButtonClick:(UIButton *)sender {
    if (self.isSyncing) {
        SHOWHUD(Lang(@"str_installing"))
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)confirmClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"));
        return;
    }
    if (self.model.filePath.length == 0 || self.model.thumbnailPath.length == 0) {
        return;
    }
    if ([DHBleCentralManager isJLProtocol]){
        [self jlDowloadDialFile];
    }
    else{
        [self downloadThumbnailFile];
    }
}

- (NSData *)transformThumbnailData {
    
    CGFloat thumbImageWidth = [DHBluetoothManager shareInstance].dialServiceInfoModel.thumbWidth;
    CGFloat thumbImageHeight = [DHBluetoothManager shareInstance].dialServiceInfoModel.thumbHeight;
    
    thumbImageWidth = (thumbImageWidth < 10 ? 0.625*self.imageWidth : thumbImageWidth);
    thumbImageHeight = (thumbImageHeight < 10 ? 0.625*self.imageHeight : thumbImageHeight);
    
    NSLog(@"transformThumbnailData %lf thumbImageHeight %lf", thumbImageWidth, thumbImageHeight);
    
    UIView *wallpaperView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, thumbImageWidth, thumbImageHeight)];
    //wallpaperView.layer.cornerRadius = 16.5;
    //wallpaperView.layer.masksToBounds = YES;
    wallpaperView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:wallpaperView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:wallpaperView.bounds];
    imageView.image = [UIImage imageWithContentsOfFile:self.thumbnailPath];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
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
    return image;
}

- (void)uploadDialRecord {
    self.model.downlaod = self.model.downlaod+1;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:DHMacAddr forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)self.model.dialId] forKey:@"dials"];
    [NetworkManager saveDialWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {

    }];
}

- (void)downloadThumbnailFile {
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    self.isSyncing = YES;
    self.confirmButton.hidden = YES;
    self.progressView.hidden = NO;
    [self.progressView updateDialSyncingProgress:0];
    
    NSString *documentPath  = [DHFile documentPath];
    NSString *directoryPath = [documentPath stringByAppendingPathComponent:DHDialFolder];
    [DHFile createDirectoryWithPath:directoryPath error:nil];
    
    self.thumbnailPath = [directoryPath stringByAppendingFormat:@"/%ld.png",(long)self.model.dialId];
    [DHFile removeLocalImageWithFolderName:DHDialFolder fileName:[NSString stringWithFormat:@"%ld.png",(long)self.model.dialId]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.model.thumbnailPath forKey:@"url"];
    [dict setObject:self.thumbnailPath forKey:@"path"];
    WEAKSELF
    [NetworkManager downloadFileWithParameter:dict progress:^(NSProgress * _Nonnull progress) {
        
    } andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        if (resultCode == 0) {
            [weakSelf thumbnailSyncingStart];
        } else {
            [weakSelf dialInstalledFailed];
        }
        });
    }];
}

- (void)thumbnailSyncingStart {
    self.thumbnailData = [self transformThumbnailData];//[NSData dataWithContentsOfFile:self.thumbnailPath];
    if (!self.thumbnailData) {
        return;
    }

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
    [DHBleCommand startThumbnailSyncing:self.thumbnailData customDial:NO block:^(int code, CGFloat progress, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (code == 0) {
                [weakSelf.progressView updateDialSyncingProgress:0.3*progress];
                if ([data isEqualToString:@"Finished"]) {
                    [weakSelf dowloadDialFile];
                }
            } else {
                [weakSelf dialInstalledFailed];
            }
        });
    }];
}


- (void)dowloadDialFile {
    NSString *documentPath  = [DHFile documentPath];
    NSString *directoryPath = [documentPath stringByAppendingPathComponent:DHDialFolder];
    
    self.filePath = [directoryPath stringByAppendingFormat:@"/%ld.bin",(long)self.model.dialId];
    [DHFile removeLocalImageWithFolderName:DHDialFolder fileName:[NSString stringWithFormat:@"%ld.bin",(long)self.model.dialId]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.model.filePath forKey:@"url"];
    [dict setObject:self.filePath forKey:@"path"];
    WEAKSELF
    [NetworkManager downloadFileWithParameter:dict progress:^(NSProgress * _Nonnull progress) {
        
    } andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        if (resultCode == 0) {
            [weakSelf uploadDialRecord];
            [weakSelf fileSyncingStart];
        } else {
            [weakSelf dialInstalledFailed];
        }
        });
    }];
}

- (void)fileSyncingStart {
    NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
    if (!fileData) {
        [self dialInstalledFailed];
        return;
    }
    
    DHFileSyncingModel *model = [[DHFileSyncingModel alloc] init];
    model.fileType = 0;
    model.fileSize = fileData.length;
    model.fileData = fileData;
    [DHBleCommand fileSyncingStart:model block:^(int code, id  _Nonnull data) {
        
    }];
    [self performSelector:@selector(startDialSyncing) withObject:nil afterDelay:1.3];
}

- (void)startDialSyncing {
    NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
    WEAKSELF
    [DHBleCommand startDialSyncing:fileData block:^(int code, CGFloat progress, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (code == 0) {
                [weakSelf.progressView updateDialSyncingProgress:0.3+0.7*progress];
                if ([data isEqualToString:@"Finished"]) {
                    [weakSelf dialInstalledSuccess];
                }
            } else {
                [weakSelf dialInstalledFailed];
            }
        });
    }];
}

- (void)dialInstalledSuccess {
    
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
    [self.progressView updateDialSyncingProgress:0];
}


- (void)setupUI {
    CGFloat screenHeight = DHDialHeight;
    CGFloat screenWidth = DHDialWidth;
    NSInteger imageWidth = kScreenWidth/3.0;
    NSInteger imageHeight = 1.0*imageWidth*screenHeight/screenWidth;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(imageHeight+40);
    }];
    
    [self.dialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(imageWidth);
        make.height.offset(imageHeight);
        make.centerX.equalTo(self.topView);
        make.centerY.equalTo(self.topView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.topView.mas_bottom).offset(35);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.width.offset(0.5);
        make.height.offset(10);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [self.fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.downloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-HomeViewSpace_Right);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(20);
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

#pragma mark - 杰里相关操作
- (void)jlDowloadDialFile {
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    self.isSyncing = YES;
    self.confirmButton.hidden = YES;
    self.progressView.hidden = NO;
    [self.progressView updateDialSyncingProgress:0];
    
    
    NSString *documentPath  = [DHFile documentPath];
    NSString *directoryPath = [documentPath stringByAppendingPathComponent:DHDialFolder];
    [DHFile createDirectoryWithPath:directoryPath error:nil];
    
    self.filePath = [directoryPath stringByAppendingFormat:@"/%ld.bin",(long)self.model.dialId];
    [DHFile removeLocalImageWithFolderName:DHDialFolder fileName:[NSString stringWithFormat:@"%ld.bin",(long)self.model.dialId]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.model.filePath forKey:@"url"];
    [dict setObject:self.filePath forKey:@"path"];
    
    NSLog(@"dict %@", dict);
    WEAKSELF
    [NetworkManager downloadFileWithParameter:dict progress:^(NSProgress * _Nonnull progress) {
        
    } andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        NSLog(@"message %@ data %@", message, data);
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        if (resultCode == 0) {
            [weakSelf uploadDialRecord];
            [weakSelf jlFileSyncingStart];
        } else {
            [weakSelf dialInstalledFailed];
        }
        });
    }];
}

- (void)jlFileSyncingStart {
    NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
    if (!fileData) {
        [self dialInstalledFailed];
        return;
    }
    
    WEAKSELF
    [DHBleCommand startDialSyncing:fileData block:^(int code, CGFloat progress, id  _Nonnull data) {
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

#pragma mark - get and set 属性的set和get方法

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = HomeColor_BlockColor;
        _topView.layer.cornerRadius = 10.0;
        _topView.layer.masksToBounds = YES;
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (UIImageView *)dialImageView {
    if (!_dialImageView) {
        _dialImageView = [[UIImageView alloc] init];
        _dialImageView.layer.cornerRadius = 10.0;
        _dialImageView.layer.masksToBounds = YES;
        [_dialImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imagePath]];
        [self.topView addSubview:_dialImageView];
    }
    return _dialImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = HomeColor_TitleColor;
        _nameLabel.font = HomeFont_ButtonFont;
        _nameLabel.text = self.model.name;
        [self.view addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)downloadLabel {
    if (!_downloadLabel) {
        _downloadLabel = [[UILabel alloc]init];
        _downloadLabel.textColor = HomeColor_TitleColor;
        _downloadLabel.font = HomeFont_ContentFont;
        _downloadLabel.text = [NSString stringWithFormat:Lang(@"str_installed_count"),(long)self.model.downlaod];
        _downloadLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_downloadLabel];
    }
    return _downloadLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textColor = COLOR(@"#FFFE83");
        _priceLabel.font = HomeFont_ContentFont;
        _priceLabel.text = Lang(@"str_dial_free");
        [self.view addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = COLORANDALPHA(@"#FFFFFF", 0.5);
        [self.view addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)fileSizeLabel {
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc]init];
        _fileSizeLabel.textColor = COLOR(@"#8FFFA4");
        _fileSizeLabel.font = HomeFont_ContentFont;
        _fileSizeLabel.text = [NSString stringWithFormat:@"%.0fKB",round(self.model.fileSize/1024.0)];
        [self.view addSubview:_fileSizeLabel];
    }
    return _fileSizeLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.textColor = HomeColor_TitleColor;
        _descLabel.font = HomeFont_ContentFont;
        _descLabel.text = [NSString stringWithFormat:@"%@\n\n%@",Lang(@"str_notes"),Lang(@"str_notes_dial")];
        _descLabel.numberOfLines = 0;
        [self.view addSubview:_descLabel];
    }
    return _descLabel;
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

@end
