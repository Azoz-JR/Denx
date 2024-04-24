//
//  DeviceInfoCell.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "DeviceInfoCell.h"
#import "DeviceBatteryView.h"

@interface DeviceInfoCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *deviceImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UILabel *macLabel;

@property (nonatomic, strong) DeviceBatteryView *batteryView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIView *redPointView;

@end

@implementation DeviceInfoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)updateDeviceImageView:(NSString *)imageUrl
{
    [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:DHImage(@"device_main_watch")];
}

- (void)updateCell {
    self.batteryView.model = [DHBluetoothManager shareInstance].batteryModel;
    
    self.nameLabel.text = [DHBluetoothManager shareInstance].deviceName;
    self.macLabel.text = [NSString stringWithFormat:@"MAC:%@", DHMacAddr];
    self.versionLabel.text = [DHBluetoothManager shareInstance].firmwareVersion.length ? [NSString stringWithFormat:@"%@V%@",Lang(@"str_ota_version"),[DHBluetoothManager shareInstance].firmwareVersion] : [NSString stringWithFormat:@"%@--",Lang(@"str_ota_version")];
}

- (void)updateRedPoint:(NSString *)onlineVersion {
    self.redPointView.hidden = onlineVersion.length ? NO : YES;
}

- (void)confirmClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onConfirmOTA:)]) {
        [self.delegate onConfirmOTA:self.redPointView.isHidden];
    }
}

- (void)setupSubViews {
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.height.offset(120);
        make.width.offset(72);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deviceImageView);
        make.left.equalTo(self.deviceImageView.mas_right).offset(20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deviceImageView.mas_right).offset(20);
        make.bottom.equalTo(self.versionLabel.mas_top).offset(-8);
        make.height.offset(20);
    }];
    
    [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deviceImageView.mas_right).offset(20);
        make.top.equalTo(self.versionLabel.mas_bottom).offset(6);
        make.height.offset(20);
    }];
    
    [self.batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScreenWidth-30-20-60);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-5);
        make.height.offset(20);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize fitSize = [self.confirmButton sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        make.top.equalTo(self.macLabel.mas_bottom).offset(5);
        make.height.offset(40);
        CGFloat tConfirmWidth = fitSize.width/2.0 + 10;
        if (tConfirmWidth < 120){
            tConfirmWidth = 120;
        }
        make.width.offset(tConfirmWidth);
        make.right.offset(-20);
    }];
    
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(8);
        make.left.equalTo(self.versionLabel.mas_right).offset(5);
        make.centerY.equalTo(self.versionLabel);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)deviceImageView {
    if (!_deviceImageView) {
        _deviceImageView = [[UIImageView alloc] init];
        _deviceImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _deviceImageView.image = DHImage(@"device_main_watch");
        [self.bgView addSubview:_deviceImageView];
    }
    return _deviceImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = HomeColor_TitleColor;
        _nameLabel.font = HomeFont_Bold_20;
        _nameLabel.text = @"";
        [self.bgView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc]init];
        _macLabel.textColor = HomeColor_TitleColor;
        _macLabel.font = HomeFont_SubTitleFont;
        _macLabel.text = @"";
        [self.bgView addSubview:_macLabel];
    }
    return _macLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc]init];
        _versionLabel.textColor = HomeColor_TitleColor;
        _versionLabel.font = HomeFont_SubTitleFont;
        _versionLabel.text = @"";
        [self.bgView addSubview:_versionLabel];
    }
    return _versionLabel;
}

- (DeviceBatteryView *)batteryView {
    if (!_batteryView) {
        _batteryView = [[DeviceBatteryView alloc] init];
        [self.bgView addSubview:_batteryView];
    }
    return _batteryView;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 10.0;
        _confirmButton.layer.masksToBounds = YES;
//        _confirmButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_confirmButton setTitle:Lang(@"str_ota") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        _confirmButton.backgroundColor = HomeColor_MainColor;
        _confirmButton.titleLabel.font = HomeFont_ContentFont;
        _confirmButton.titleLabel.numberOfLines = 2;
        _confirmButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (UIView *)redPointView {
    if (!_redPointView) {
        _redPointView = [[UIView alloc] init];
        _redPointView.backgroundColor = [UIColor redColor];
        _redPointView.layer.cornerRadius = 4.0;
        _redPointView.layer.masksToBounds = YES;
        [self.bgView addSubview:_redPointView];
    }
    return _redPointView;
}

@end
