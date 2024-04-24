//
//  OTAViewController.m
//  DHSFit
//
//  Created by DHS on 2022/7/19.
//

#import "OTAViewController.h"

@interface OTAViewController ()

#pragma mark UI

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) BaseProgressView *progressView;

@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UILabel *currentVersionLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *descTitleLabel;

@property (nonatomic, strong) UILabel *descLabel;

#pragma mark Data

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, assign) BOOL isSyncing;

@property (nonatomic, copy) NSString *filePath;

@end

@implementation OTAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    
}

- (void)initData {
    self.isSyncing = NO;
}

- (void)navLeftButtonClick:(UIButton *)sender {
    if (self.isSyncing) {
        SHOWHUD(Lang(@"str_upgrading"))
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupUI {
    CGFloat topViewH = 150+30*5+15+30;
    CGFloat bottomViewH = [UILabel getLabelheight:self.descLabel.text width:kScreenWidth-30 font:HomeFont_TitleFont]+50;
        
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(topViewH);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(HomeViewSpace_Vertical);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(bottomViewH);
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
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.width.height.offset(80);
        make.top.offset(15);
        make.centerX.equalTo(self.topView);
    }];
    
    [self.currentVersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.topView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentVersionLabel.mas_bottom).offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(1);
    }];
    
    UIView *lastView;
    for (int i = 0; i < self.titles.count; i++) {
        UILabel *itemLabel = [[UILabel alloc] init];
        itemLabel.textColor = HomeColor_TitleColor;
        itemLabel.font = i == 0 ? HomeFont_TitleFont : HomeFont_ContentFont;
        itemLabel.tag = 100+i;
        itemLabel.numberOfLines = 0;
        itemLabel.text = self.titles[i];
        [self.topView addSubview:itemLabel];
        
        if (i == 0) {
            [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lineView.mas_bottom).offset(10);
                make.left.offset(HomeViewSpace_Left);
                make.right.offset(-HomeViewSpace_Right);
            }];
        } else {
            [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(5);
                make.left.offset(HomeViewSpace_Left);
                make.right.offset(-HomeViewSpace_Right);
            }];
        }
        lastView = itemLabel;
    }
    
    [self.descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descTitleLabel.mas_bottom).offset(5);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
    }];
}


- (void)confirmClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"));
        return;
    }
    [self dowloadDialFile];
}

- (void)dowloadDialFile {
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    self.isSyncing = YES;
    self.confirmButton.hidden = YES;
    self.progressView.hidden = NO;
    [self.progressView updateFileSyncingProgress:0];
    
    NSString *documentPath  = [DHFile documentPath];
    NSString *directoryPath = [documentPath stringByAppendingPathComponent:DHOTAFolder];
    [DHFile createDirectoryWithPath:directoryPath error:nil];
    
    self.filePath = [directoryPath stringByAppendingString:[NSString stringWithFormat:@"/%@_ota.img", self.onlieModel.onlineVersion]];
    [DHFile removeLocalImageWithFolderName:DHOTAFolder fileName:[NSString stringWithFormat:@"/%@_ota.img", self.onlieModel.onlineVersion]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.onlieModel.filePath forKey:@"url"];
    [dict setObject:self.filePath forKey:@"path"];
    WEAKSELF
    [NetworkManager downloadFileWithParameter:dict progress:^(NSProgress * _Nonnull progress) {
        
    } andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
        if (resultCode == 0) {
            [weakSelf fileSyncingStart];
        } else {
            [weakSelf fileSyncingFailed];
        }
        });
    }];
}

- (void)fileSyncingStart {
    NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];
    if (!fileData) {
        [self fileSyncingFailed];
        return;
    }
    
    WEAKSELF
    if ([DHBleCentralManager isJLProtocol]){
        [DHBleCommand startUIFileSyncing:fileData bleKey:BLE_KEY_ALL_BIN_DATA block:^(int code, CGFloat progress, id  _Nonnull data) {
            if (code == 0) {
                [weakSelf.progressView updateFileSyncingProgress:progress];
                if ([data isEqualToString:@"Finished"]) {
                    [weakSelf fileSyncingSuccess];
                }
            } else {
                [weakSelf fileSyncingFailed];
            }
        }];
    }
    else{
        
        DHFileSyncingModel *model = [[DHFileSyncingModel alloc] init];
        model.fileType = 1;
        model.fileSize = fileData.length;
        model.fileData = fileData;
        [DHBleCommand fileSyncingStart:model block:^(int code, id  _Nonnull data) {
            
        }];
        [self performSelector:@selector(startFileSyncing) withObject:nil afterDelay:1.3];
    }
}



- (void)startFileSyncing {
    NSData *fileData = [NSData dataWithContentsOfFile:self.filePath];

    WEAKSELF
    [DHBleCommand startFileSyncing:fileData block:^(int code, CGFloat progress, id  _Nonnull data) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (code == 0) {
                [weakSelf.progressView updateFileSyncingProgress:progress];
                if ([data isEqualToString:@"Finished"]) {
                    [weakSelf fileSyncingSuccess];
                }
            } else {
                [weakSelf fileSyncingFailed];
            }
        });
    }];
}

- (void)fileSyncingSuccess {
    SHOWHUD(Lang(@"str_upgrade_success"));
    self.onlieModel.onlineVersion = @"";
    [self.onlieModel saveOrUpdate];
    if ([self.delegate respondsToSelector:@selector(deviceOtaSucceed:)]) {
        [self.delegate deviceOtaSucceed:self.onlieModel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fileSyncingFailed {
    SHOWHUD(Lang(@"str_upgrade_fail"));
    [self.confirmButton setTitle:Lang(@"str_ota_restart") forState:UIControlStateNormal];
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    self.isSyncing = NO;
    self.confirmButton.hidden = NO;
    self.progressView.hidden = YES;
    [self.progressView updateFileSyncingProgress:0];
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HomeColor_BlockColor;
        _bottomView.layer.cornerRadius = 10.0;
        _bottomView.layer.masksToBounds = YES;
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 10.0;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton setTitle:Lang(@"str_ota_start") forState:UIControlStateNormal];
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

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.contentMode = UIViewContentModeCenter;
        _topImageView.image = DHImage(@"device_ota_logo");
        [self.topView addSubview:_topImageView];
    }
    return _topImageView;
}

- (UILabel *)currentVersionLabel {
    if (!_currentVersionLabel) {
        _currentVersionLabel = [[UILabel alloc]init];
        _currentVersionLabel.textColor = HomeColor_TitleColor;
        _currentVersionLabel.font = HomeFont_ContentFont;
        _currentVersionLabel.textAlignment = NSTextAlignmentCenter;
        _currentVersionLabel.text = [NSString stringWithFormat:@"%@V%@",Lang(@"str_ota_current_version"),self.onlieModel.currentVersion];
        [self.topView addSubview:_currentVersionLabel];
    }
    return _currentVersionLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HomeColor_LineColor;
        [self.topView addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)descTitleLabel {
    if (!_descTitleLabel) {
        _descTitleLabel = [[UILabel alloc]init];
        _descTitleLabel.textColor = HomeColor_TitleColor;
        _descTitleLabel.font = HomeFont_TitleFont;
        _descTitleLabel.numberOfLines = 0;
        _descTitleLabel.text = Lang(@"str_notes");
        [self.bottomView addSubview:_descTitleLabel];
    }
    return _descTitleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.textColor = HomeColor_TitleColor;
        _descLabel.font = HomeFont_ContentFont;
        _descLabel.numberOfLines = 0;
        _descLabel.text = Lang(@"str_notes_ota");
        [self.bottomView addSubview:_descLabel];
    }
    return _descLabel;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        NSArray *array = @[Lang(@"str_ota_info"),
                           [NSString stringWithFormat:@"%@V%@",Lang(@"str_ota_version"),self.onlieModel.onlineVersion],
                           [NSString stringWithFormat:@"%@%.0fKB",Lang(@"str_ota_filesize"),self.onlieModel.fileSize/1024.0],
                           [NSString stringWithFormat:@"%@",Lang(@"str_ota_update_message")],
                           self.onlieModel.desc];
        _titles = [NSMutableArray array];
        [_titles addObjectsFromArray:array];
    }
    return _titles;
}


@end
