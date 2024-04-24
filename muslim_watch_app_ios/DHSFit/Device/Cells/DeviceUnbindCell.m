//
//  DeviceUnbindCell.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "DeviceUnbindCell.h"

@interface DeviceUnbindCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DeviceUnbindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor redColor];
        _titleLabel.font = HomeFont_TitleFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = Lang(@"str_unbind");
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
