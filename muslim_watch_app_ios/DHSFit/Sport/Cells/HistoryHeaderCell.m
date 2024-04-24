//
//  HistoryHeaderCell.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "HistoryHeaderCell.h"

@implementation HistoryHeaderCell

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.centerY.equalTo(self);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitleLabel.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = HomeColor_TitleColor;
        _leftTitleLabel.font = HomeFont_TitleFont;
        [self addSubview:_leftTitleLabel];
    }
    return _leftTitleLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeCenter;
        _leftImageView.image = DHImage(@"home_date_right");
        _leftImageView.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
        [self addSubview:_leftImageView];
    }
    return _leftImageView;
}

@end
