//
//  MineHeaderView.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()

/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 图片
@property (nonatomic, strong) UIImageView *imageView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setModel:(UserModel *)model {
    self.titleLabel.text = model.name;
    NSData *avatar = [DHFile queryLocalImageWithFolderName:DHAvatarFolder fileName:[NSString stringWithFormat:@"%@.png",DHUserId]];
    if (model.avatar.length) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:DHImage(@"mine_main_avatar")];
    } else if (avatar) {
        self.imageView.image = [UIImage imageWithData:avatar];
    } else {
        self.imageView.image = DHImage(@"mine_main_avatar");
    }
}

- (void)setNickName:(NSString *)nickName {
    self.titleLabel.text = nickName;
}

- (void)setAvatarImage:(UIImage *)avatarImage {
    self.imageView.image = avatarImage;
}

- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(100);
        make.top.offset(30);
        make.centerX.equalTo(self.bgView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
    }];

}

- (void)avatarClick:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(onAvatar)]) {
        [self.delegate onAvatar];
    }
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 50.0;
        _imageView.layer.masksToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick:)];
        [_imageView addGestureRecognizer:tap];
        [self.bgView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = HomeColor_TitleColor;
        _titleLabel.font = HomeFont_TitleFont;
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
