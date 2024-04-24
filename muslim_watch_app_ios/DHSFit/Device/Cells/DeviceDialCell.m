//
//  DeviceDialCell.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "DeviceDialCell.h"

@interface DeviceDialCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *leftTitleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation DeviceDialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dialArray = [NSArray array];
//        [self setupSubViews];
    }
    return self;
}

- (void)setDialArray:(NSArray *)dialArray {
    NSLog(@"setDialArray %zd", dialArray.count);
    _dialArray = dialArray;
    if (dialArray.count < 3) {
        for (int i = 0; i < 3; i++) {
            UIImageView *itemImageView = [self.bottomView viewWithTag:1000+i];
            UILabel *itemLabel = [self.bottomView viewWithTag:2000+i];
            itemImageView.image = DHImage(@"device_dial_placeholder");
            itemLabel.text = @"";
        }
    } else {
        for (int i = 0; i < dialArray.count; i++) {
            UIImageView *itemImageView = [self.bottomView viewWithTag:1000+i];
            UILabel *itemLabel = [self.bottomView viewWithTag:2000+i];
            DialMarketSetModel *model = dialArray[i];
            if (model.imagePath.length) {
                [itemImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath]];
            }
            itemLabel.text = @"";
//            itemLabel.text = model.name;
        }
    }
}

- (void)moreDialsClick:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(onMoreDials)]) {
            [self.delegate onMoreDials];
        }
    }
}

- (void)dialClick:(UITapGestureRecognizer *)sender {
    if (self.dialArray.count < 3) {
        if ([self.delegate respondsToSelector:@selector(onDial:)]) {
            [self.delegate onDial:nil];
        }
        return;
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        DialMarketSetModel *model = self.dialArray[sender.view.tag-1000];
        if ([self.delegate respondsToSelector:@selector(onDial:)]) {
            [self.delegate onDial:model];
        }
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
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(44);
    }];
    
//    self.topView.backgroundColor = [UIColor redColor];
//    self.bottomView.backgroundColor = [UIColor blueColor];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.bottom.offset(0);
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
    
    CGFloat screenHeight = DHDialHeight;
    CGFloat screenWidth = DHDialWidth;
    NSInteger imageWidth = (kScreenWidth-30-80)/3.0;
    NSInteger imageHeight = 1.0*imageWidth*screenHeight/screenWidth;
    
    NSLog(@"setupSubViews screenWidth %lf screenHeight %lf imageWidth %d imageHeight %d", screenWidth, screenHeight, imageWidth, imageHeight);
    CGFloat imageSpace = 20.0;
    UIImageView *lastView;
    for (int i = 0; i < 3; i++) {

        UIImageView *itemImageView = [self.bottomView viewWithTag:1000+i];
        if (itemImageView == nil){
            itemImageView = [[UIImageView alloc] init];
            [self.bottomView addSubview:itemImageView];
        }
        itemImageView.contentMode = UIViewContentModeScaleAspectFill;
        itemImageView.tag = 1000+i;
        itemImageView.userInteractionEnabled = YES;
        itemImageView.image = DHImage(@"device_dial_placeholder");
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialClick:)];
        [itemImageView addGestureRecognizer:tap];

        
        UILabel *itemLabel = [self.bottomView viewWithTag:2000+i];
        if (itemLabel == nil){
            itemLabel = [[UILabel alloc] init];
            [self.bottomView addSubview:itemLabel];
        }
        itemLabel.textColor = HomeColor_SubTitleColor;
        itemLabel.font = HomeFont_SubTitleFont;
        itemLabel.textAlignment = NSTextAlignmentCenter;
        itemLabel.tag = 2000+i;
        itemLabel.text = @"";
        
        if (i == 0) {
            [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(imageSpace);
                make.top.offset(15);
                make.width.offset(imageWidth);
                make.height.offset(imageHeight);
            }];
        } else {
            [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(imageSpace);
                make.top.offset(15);
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HomeColor_BlockColor;
        [self.bgView addSubview:_bottomView];
    }
    return _bottomView;
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = HomeColor_TitleColor;
        _leftTitleLabel.font = HomeFont_TitleFont;
        _leftTitleLabel.numberOfLines = 2;
        _leftTitleLabel.text = Lang(@"str_dial_market");
        [self.topView addSubview:_leftTitleLabel];
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
