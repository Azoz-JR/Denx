//
//  DialMarketListCell.m
//  DHSFit
//
//  Created by DHS on 2022/10/22.
//

#import "DialMarketListCell.h"

@interface DialMarketListCell ()

@property (nonatomic, strong) UIImageView *dialImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DialMarketListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.contentView.backgroundColor = HomeColor_BackgroundColor;

    [self.dialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.offset(-40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dialImageView.mas_bottom).offset(10);
        make.left.right.offset(0);
    }];

}

- (void)setModel:(DialMarketSetModel *)model {
    _model = model;
    
    if (model.imagePath.length) {
        [self.dialImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath]];
    }
    self.titleLabel.text = model.name;
}

- (UIImageView *)dialImageView {
    if (!_dialImageView) {
        _dialImageView = [[UIImageView alloc] init];
        _dialImageView.image = DHImage(@"device_dial_placeholder");
        _dialImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_dialImageView];
    }
    return _dialImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HomeColor_SubTitleColor;
        _titleLabel.font = HomeFont_SubTitleFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"";
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
