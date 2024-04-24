//
//  MoreFuncViewController.m
//  DHSFit
//
//  Created by DHS on 2023/1/5.
//

#import "MoreFuncViewController.h"

@interface MoreFuncViewController ()

/// 标题数组
@property (nonatomic, strong) NSArray *titles;
/// 列表数组
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 准备恢复出厂设置
@property (nonatomic, assign) BOOL isReadyRestore;
/// 正在设备控制
@property (nonatomic, assign) BOOL isDeviceControl;
/// 背景图
@property (nonatomic, strong) UIView *bgView;

@end

@implementation MoreFuncViewController

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setupUI];
    
    //监听数据同步完成
    [DHNotificationCenter addObserver:self selector:@selector(dataSyncingCompleted) name:BluetoothNotificationDataSyncingCompleted object:nil];
    //监听设备连接状态
    [DHNotificationCenter addObserver:self selector:@selector(connectStateChange) name:BluetoothNotificationConnectStateChange object:nil];
}

- (void)dataSyncingCompleted {
    if (self.isReadyRestore) {
        self.isReadyRestore = NO;
        [self onRestore];
    }
}

- (void)connectStateChange {
    if (self.isDeviceControl) {
        HUDDISS
        self.isDeviceControl = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)initData {
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        [self.dataArray addObject:cellModel];
    }
}

- (void)timeViewTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (!DHDeviceConnected) {
            SHOWHUD(Lang(@"str_device_disconnected"))
            return;
        }
        if (sender.view.tag == 1000) {
            [self showRestoreTips];
        } else if (sender.view.tag == 1001) {
            [self showRestartTips];
        } else {
            [self showShutdownTips];
        }
    }
}

- (void)showRestoreTips {
    WEAKSELF
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_device_recovery_tips")
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            if (DHDeviceConnected) {
                weakSelf.isReadyRestore = YES;
                [[DHBluetoothManager shareInstance] startDataSyncing];
            } else {
                SHOWHUD(Lang(@"str_device_disconnected"))
            }
        }
    }];
}

- (void)showRestartTips {
    WEAKSELF
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_device_restart_tips")
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            if (DHDeviceConnected) {
                SHOWINDETERMINATE
                weakSelf.isDeviceControl = YES;
                [DHBleCommand controlDevice:0 block:^(int code, id  _Nonnull data) {
                    
                }];
            } else {
                SHOWHUD(Lang(@"str_device_disconnected"))
            }
        }
    }];
}

- (void)showShutdownTips {
    WEAKSELF
    BaseAlertView *alertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [alertView showWithTitle:@""
                     message:Lang(@"str_device_shutdown_tips")
                      cancel:Lang(@"str_cancel")
                     confirm:Lang(@"str_sure")
         textAlignmentCenter:YES
                       block:^(BaseAlertViewClickType type) {
        if (type == BaseAlertViewClickTypeConfirm) {
            if (DHDeviceConnected) {
                SHOWINDETERMINATE
                weakSelf.isDeviceControl = YES;
                [DHBleCommand controlDevice:1 block:^(int code, id  _Nonnull data) {
                    
                }];
            } else {
                SHOWHUD(Lang(@"str_device_disconnected"))
            }
        }
    }];
}

- (void)onRestore {
    if (!DHDeviceConnected) {
        [self restoreSuccess];
        return;
    }
    WEAKSELF
    [DHBleCommand controlDevice:2 block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf restoreSuccess];
        }
    }];
}

- (void)restoreSuccess {
    if (self.delegate && [self.delegate respondsToSelector:@selector(restoreSuccess)]) {
        [self.delegate restoreSuccess];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupUI {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
    
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
        [self.bgView addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.offset(HomeViewSpace_Left);
                make.right.offset(-HomeViewSpace_Right);
                make.height.offset(50);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom);
                make.left.offset(HomeViewSpace_Left);
                make.right.offset(-HomeViewSpace_Right);
                make.height.offset(50);
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
        lastView = itemView;
    }
}


- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_recover"),
                    Lang(@"str_device_restart"),
                    Lang(@"str_device_shutdown")];
    }
    return _titles;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BackgroundColor;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

@end
