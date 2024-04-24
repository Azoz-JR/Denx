//
//  DialMaketCell.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "DialMaketCell.h"

@interface DialMaketCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomViewA;

@property (nonatomic, strong) UIView *bottomViewB;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation DialMaketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setDialArray:(NSArray *)dialArray {
    if (dialArray.count < 1) {
        return;
    }
    [self setupSubViews];
    
    _dialArray = dialArray;
    for (int i = 0; i < dialArray.count; i++) {
        UIImageView *itemImageView = [self.bgView viewWithTag:1000+i];
        UILabel *itemLabel = [self.bgView viewWithTag:2000+i];
        DialMarketSetModel *model = dialArray[i];
        if (model.imagePath.length) {
            [itemImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath]];
        }
        itemLabel.hidden = YES;
//        itemLabel.text = model.name;
    }
    
    for (int j = dialArray.count; j < 6; j++){
        UIImageView *itemImageView = [self.bgView viewWithTag:1000+j];
        UILabel *itemLabel = [self.bgView viewWithTag:2000+j];
        itemImageView.hidden = YES;
        itemLabel.hidden = YES;
    }
}

- (void)moreDialsClick:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(onMoreDials:Type:)]) {
            [self.delegate onMoreDials:self.leftTitleLabel.text Type:self.dialType];
        }
    }
}

- (void)dialClick:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        DialMarketSetModel *model = self.dialArray[sender.view.tag-1000];
        if ([self.delegate respondsToSelector:@selector(onDial:)]) {
            [self.delegate onDial:model];
        }
    }
}



- (void)setupSubViews {
    CGFloat screenHeight = DHDialHeight;
    CGFloat screenWidth = DHDialWidth;
    NSInteger imageWidth = (kScreenWidth-30-80)/3.0;
    NSInteger imageHeight = 1.0*imageWidth*screenHeight/screenWidth;
    CGFloat imageSpace = 20.0;
    
    for (UIView *subView in self.contentView.subviews){
        [subView removeFromSuperview];
    }
    self.bgView = nil;
    self.topView = nil;
    self.bottomViewA = nil;
    self.bottomViewB = nil;
    self.rightImageView = nil;
    self.subTitleLabel = nil;
    self.leftTitleLabel = nil;
    
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(44);
    }];
    
    [self.bottomViewA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(5);
        make.left.right.offset(0);
        make.height.offset(imageHeight+40);
    }];
    
    [self.bottomViewB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomViewA.mas_bottom).offset(5);
        make.left.right.offset(0);
        make.height.offset(imageHeight+40);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(12);
        make.right.offset(-10);
        make.centerY.equalTo(self.topView);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.rightImageView.mas_left).offset(-10);
        make.width.offset(80);
        
    }];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.subTitleLabel.mas_left).offset(-5);
    }];
    
    
    UIImageView *lastView;
    for (int i = 0; i < 3; i++) {
        UIImageView *itemImageView = [[UIImageView alloc] init];
        itemImageView.contentMode = UIViewContentModeScaleAspectFill;
        itemImageView.image = DHImage(@"device_dial_placeholder");
        itemImageView.tag = 1000+i;
        itemImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialClick:)];
        [itemImageView addGestureRecognizer:tap];
        [self.bottomViewA addSubview:itemImageView];
        
        UILabel *itemLabel = [[UILabel alloc]init];
        itemLabel.textColor = HomeColor_SubTitleColor;
        itemLabel.font = HomeFont_SubTitleFont;
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.tag = 2000+i;
        itemLabel.text = @"";
        [self.bottomViewA addSubview:itemLabel];
        
        if (i == 0) {
            [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(imageSpace);
                make.top.offset(0);
                make.width.offset(imageWidth);
                make.height.offset(imageHeight);
            }];
        } else {
            [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(imageSpace);
                make.top.offset(0);
                make.width.offset(imageWidth);
                make.height.offset(imageHeight);
            }];
        }
        
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemImageView.mas_bottom).offset(10);
            make.centerX.equalTo(itemImageView);
            make.width.equalTo(itemImageView.mas_width);
        }];
        lastView = itemImageView;
    }
    
    for (int i = 0; i < 3; i++) {
        UIImageView *itemImageView = [[UIImageView alloc] init];
        itemImageView.contentMode = UIViewContentModeScaleAspectFill;
        itemImageView.image = DHImage(@"device_dial_placeholder");
        itemImageView.tag = 1003+i;
        itemImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialClick:)];
        [itemImageView addGestureRecognizer:tap];
        [self.bottomViewB addSubview:itemImageView];
        
        UILabel *itemLabel = [[UILabel alloc]init];
        itemLabel.textColor = HomeColor_SubTitleColor;
        itemLabel.font = HomeFont_SubTitleFont;
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.tag = 2003+i;
        itemLabel.text = @"";
        [self.bottomViewB addSubview:itemLabel];
        
        if (i == 0) {
            [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(imageSpace);
                make.top.offset(0);
                make.width.offset(imageWidth);
                make.height.offset(imageHeight);
            }];
        } else {
            [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(imageSpace);
                make.top.offset(0);
                make.width.offset(imageWidth);
                make.height.offset(imageHeight);
            }];
        }
        
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemImageView.mas_bottom).offset(10);
            make.centerX.equalTo(itemImageView);
            make.width.equalTo(itemImageView.mas_width);
        }];
        
        lastView = itemImageView;
    }

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

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = HomeColor_BlockColor;
        _topView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreDialsClick:)];
        [_topView addGestureRecognizer:tap];
        [self.bgView addSubview:_topView];
    }
    return _topView;
}

- (UIView *)bottomViewA {
    if (!_bottomViewA) {
        _bottomViewA = [[UIView alloc] init];
        _bottomViewA.backgroundColor = HomeColor_BlockColor;
        [self.bgView addSubview:_bottomViewA];
    }
    return _bottomViewA;
}

- (UIView *)bottomViewB {
    if (!_bottomViewB) {
        _bottomViewB = [[UIView alloc] init];
        _bottomViewB.backgroundColor = HomeColor_BlockColor;
        [self.bgView addSubview:_bottomViewB];
    }
    return _bottomViewB;
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = HomeColor_TitleColor;
        _leftTitleLabel.font = HomeFont_TitleFont;
        _leftTitleLabel.text = Lang(@"str_dial_new");
        [self.topView addSubview:_leftTitleLabel];
    }
    return _leftTitleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = HomeColor_SubTitleColor;
        _subTitleLabel.font = HomeFont_SubTitleFont;
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.text = Lang(@"str_more");
        [self.topView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeRight;
        _rightImageView.image = DHImage(@"public_cell_arrow");
        [self.topView addSubview:_rightImageView];
    }
    return _rightImageView;
}

@end
