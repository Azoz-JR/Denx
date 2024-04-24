//
//  ScanDeviceCell.m
//  DHSFit
//
//  Created by DHS on 2022/6/16.
//

#import "ScanDeviceCell.h"
#import "DeviceRssiView.h"

@interface ScanDeviceCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *leftTitleLabel;

@property (nonatomic, strong) DeviceRssiView *rssiView;

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ScanDeviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(MWBaseCellModel *)model {
    
    self.leftTitleLabel.text = model.leftTitle;
    self.contentLabel.text = model.contentTitle;
    self.rssiView.status = [model.subTitle integerValue];
}

- (void)setupSubViews {
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.rssiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-HomeViewSpace_Right);
        make.width.offset(14);
        make.height.offset(16);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.leftTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.equalTo(self.rssiView.mas_left).offset(-5);
        make.centerY.equalTo(self.bgView).offset(-15);
    }];
        
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.leftTitleLabel.mas_bottom).offset(10);
        make.width.equalTo(self.leftTitleLabel);
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

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = HomeColor_TitleColor;
        _leftTitleLabel.font = HomeFont_TitleFont;
        _leftTitleLabel.numberOfLines = 2;
        [self.bgView addSubview:_leftTitleLabel];
    }
    return _leftTitleLabel;
}

- (DeviceRssiView *)rssiView {
    if (!_rssiView) {
        _rssiView = [[DeviceRssiView alloc]init];
        [self.bgView addSubview:_rssiView];
    }
    return _rssiView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = HomeColor_SubTitleColor;
        _contentLabel.font = HomeFont_SubTitleFont;
        _contentLabel.numberOfLines = 2;
        [self.bgView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
