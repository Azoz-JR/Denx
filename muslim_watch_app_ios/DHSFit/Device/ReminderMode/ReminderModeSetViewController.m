//
//  ReminderModeSetViewController.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "ReminderModeSetViewController.h"

@interface ReminderModeSetViewController ()

#pragma mark UI
/// 背景图
@property (nonatomic, strong) UIView *bgView;

#pragma mark Data
/// 模型
@property(nonatomic, strong) ReminderModeSetModel *model;
/// 列表数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 大标题
@property (nonatomic, strong) NSArray *titles;
/// 提醒模式
@property (nonatomic, assign) NSInteger reminderMode;

@end

@implementation ReminderModeSetViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getReminderMode];
}

- (void)getReminderMode {
    WEAKSELF
    [DHBleCommand getReminderMode:^(int code, id  _Nonnull data) {
        if (code == 0) {
            [weakSelf saveModel:data];
        } else {
            weakSelf.model = [ReminderModeSetModel currentModel];
        }
        [weakSelf initData];
        [weakSelf setupUI];
        [weakSelf addObservers];
    }];
    
}

- (void)addObservers {
    //状态更新
    [DHNotificationCenter addObserver:self selector:@selector(reminderModeChange) name:BluetoothNotificationReminderModeChange object:nil];
}

- (void)reminderModeChange {
    self.model = [ReminderModeSetModel currentModel];
    self.reminderMode = self.model.reminderMode;
    
    for (int i = 0; i < self.dataArray.count; i++) {
            MWBaseCellModel *cellModel = self.dataArray[i];
            UIImageView *rightImageView = [self.bgView viewWithTag:1000+i];
            if (self.reminderMode == i ) {
                cellModel.rightImage = @"public_cell_selected";
                rightImageView.image = DHImage(@"public_cell_selected");
            } else {
                cellModel.rightImage = @"";
                rightImageView.image = [[UIImage alloc] init];
            }
        }
}


- (void)saveModel:(id)data {
    DHReminderModeSetModel *model = data;
    ReminderModeSetModel *reminderModel = [ReminderModeSetModel currentModel];
    
    reminderModel.reminderMode = model.reminderMode;
    [reminderModel saveOrUpdate];
    
    self.model = reminderModel;
}

#pragma mark - custom action for DATA 数据处理有关

- (void)navRightButtonClick:(UIButton *)sender {
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    
    DHReminderModeSetModel *model = [[DHReminderModeSetModel alloc] init];
    model.reminderMode = self.reminderMode;
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setReminderMode:model block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            SHOWHUD(Lang(@"str_save_success"))
            [weakSelf saveModel];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            SHOWHUD(Lang(@"str_save_fail"))
        }
    }];
    
}

- (void)saveModel {
    
    self.model.reminderMode = self.reminderMode;
    [self.model saveOrUpdate];
}

- (void)initData {
    
    self.reminderMode = self.model.reminderMode;
    
    for (int i = 0; i < self.titles.count; i++) {
        MWBaseCellModel *cellModel = [[MWBaseCellModel alloc] init];
        cellModel.leftTitle = self.titles[i];
        cellModel.rightImage = self.reminderMode == i ? @"public_cell_selected" : @"";
        [self.dataArray addObject:cellModel];
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(150);
    }];
    
    UIView *lastView;
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_BlockColor;
        itemView.tag = 100+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [itemView addGestureRecognizer:tap];
        [self.bgView addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
                make.left.right.offset(0);
                make.height.offset(50);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(0);
                make.left.right.offset(0);
                make.height.offset(50);
            }];
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = HomeColor_TitleColor;
        titleLabel.font = HomeFont_TitleFont;
        titleLabel.text = cellModel.leftTitle;
        titleLabel.numberOfLines = 2;
        [itemView addSubview:titleLabel];

        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.contentMode = UIViewContentModeRight;
        rightImageView.tag = 1000+i;
        if (cellModel.rightImage.length) {
            rightImageView.image = DHImage(cellModel.rightImage);
        } else {
            rightImageView.image = [[UIImage alloc] init];
        }
        [itemView addSubview:rightImageView];
        
        UIView *lineView  = [[UIView alloc] init];
        lineView.backgroundColor = HomeColor_LineColor;
        lineView.hidden = (i == self.dataArray.count-1);
        [itemView addSubview:lineView];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(12);
            make.right.offset(-10);
            make.centerY.equalTo(itemView);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(itemView);
            make.left.offset(HomeViewSpace_Left);
            make.right.equalTo(rightImageView.mas_left).offset(-5);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.right.offset(-10);
            make.height.offset(0.5);
            make.bottom.offset(0);
        }];
        
        lastView = itemView;
        
    }
}

- (void)tapClick:(UITapGestureRecognizer *)sender {
    for (int i = 0; i < self.dataArray.count; i++) {
        MWBaseCellModel *cellModel = self.dataArray[i];
        UIImageView *rightImageView = [self.bgView viewWithTag:1000+i];
        if (sender.view.tag - 100 == i ) {
            self.reminderMode = sender.view.tag - 100;
            cellModel.rightImage = @"public_cell_selected";
            rightImageView.image = DHImage(@"public_cell_selected");
        } else {
            cellModel.rightImage = @"";
            rightImageView.image = [[UIImage alloc] init];
        }
    }
}

#pragma mark - get and set 属性的set和get方法

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[Lang(@"str_vibration"),
                    Lang(@"str_bright"),
                    [NSString stringWithFormat:@"%@+%@",Lang(@"str_vibration"),Lang(@"str_bright")]];
    }
    return _titles;
}

@end
