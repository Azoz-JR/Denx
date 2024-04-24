//
//  MWBaseTableCell.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "MWBaseTableCell.h"

@interface MWBaseTableCell ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 左icon
@property (nonatomic, strong) UIImageView *leftImageView;
/// 小标题
@property (nonatomic, strong) UILabel *subTitleLabel;
/// 内容
@property (nonatomic, strong) UILabel *contentLabel;
/// 右icon
@property (nonatomic, strong) UIImageView *rightImageView;
/// 小红点
@property (nonatomic, strong) UIView *redPointView;

@end

@implementation MWBaseTableCell

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
    self.subTitleLabel.text = model.subTitle;
    self.contentLabel.text = model.contentTitle;
    if (model.leftImage.length) {
        self.leftImageView.image = DHImage(model.leftImage);
    } else if (model.contentTitle.length) {
        [self.leftTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
            make.right.equalTo(self.subTitleLabel.mas_left).offset(-5);
            make.centerY.equalTo(self.bgView).offset(-15);
        }];
    } else {
        [self.leftTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(HomeViewSpace_Left);
        }];
    }
    if (model.rightImage.length) {
        self.rightImageView.image = DHImage(model.rightImage);
    } else {
        self.rightImageView.image = [[UIImage alloc] init];
    }
    if (!model.isHideSwitch) {
        self.switchView.on = model.isOpen;
    }
    
    self.leftImageView.hidden = !model.leftImage.length;
    self.redPointView.hidden = model.isHideRedPoint;
    self.switchView.hidden = model.isHideSwitch;
    self.rightImageView.hidden = model.isHideArrow;
    self.avatarView.hidden = model.isHideAvatar;
}

- (void)setIsHeader:(BOOL)isHeader {
    _isHeader = isHeader;
    if (isHeader) {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-20);
        }];
    } else {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-10);
        }];
    }
}

- (void)setupSubViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.width.height.offset(25);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(12);
        make.right.offset(-10);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView.mas_left).offset(-10);
        make.top.offset(15);
        make.bottom.offset(-15);
        make.width.equalTo(self.avatarView.mas_height);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.rightImageView.mas_left).offset(-10);
        make.width.offset(80);
    }];

    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.offset(45);
        make.right.equalTo(self.subTitleLabel.mas_left).offset(-5);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.equalTo(self.leftTitleLabel.mas_bottom).offset(10);
        make.width.equalTo(self.leftTitleLabel);
    }];
    
    [self.redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(8);
        make.right.equalTo(self.rightImageView.mas_left).offset(2);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(self.bgView);
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

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeCenter;
        [self.bgView addSubview:_leftImageView];
    }
    return _leftImageView;
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

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = HomeColor_SubTitleColor;
        _subTitleLabel.font = HomeFont_SubTitleFont;
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        [self.bgView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
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

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeRight;
        [self.bgView addSubview:_rightImageView];
    }
    return _rightImageView;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.layer.cornerRadius = 30.0;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.hidden = YES;
        [self.bgView addSubview:_avatarView];
    }
    return _avatarView;
}



- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = HomeColor_MainColor;
        [self.bgView addSubview:_switchView];
    }
    return _switchView;
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
