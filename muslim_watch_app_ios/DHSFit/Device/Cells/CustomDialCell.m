//
//  CustomDialCell.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "CustomDialCell.h"

@interface CustomDialCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *leftTitleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation CustomDialCell

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size
{
    if (size.width == 0 && size.height == 0){
        size = CGSizeMake(102, 119);
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);//创建图片
    CGContextRef context = UIGraphicsGetCurrentContext();//创建图片上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);//设置当前填充颜色的图形上下文
    CGContextFillRect(context, rect);//填充颜色
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    CGFloat screenHeight = DHDialHeight;
    CGFloat screenWidth = DHDialWidth;
    NSInteger imageWidth = (kScreenWidth-30-80)/3.0;
    NSInteger imageHeight = 1.0*imageWidth*screenHeight/screenWidth;
    
    self.contentView.backgroundColor = HomeColor_BackgroundColor;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-10);
    }];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.top.offset(0);
        make.height.offset(44);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTitleLabel.mas_bottom).offset(5);
        make.left.offset(20);
        make.width.offset(imageWidth);
        make.height.offset(imageHeight);
    }];
    if ([DHBluetoothManager shareInstance].dialInfoModel.screenType == 0){ //方形
        self.leftImageView.layer.cornerRadius = 10.0;
    }
    else{
        self.leftImageView.layer.cornerRadius = imageWidth/2.0;
    }
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.right.offset(-10);
    }];
   
}

- (void)customDialClick:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(onCustomDial)]) {
            [self.delegate onCustomDial];
        }
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius = 10.0;
        _bgView.layer.masksToBounds = YES;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customDialClick:)];
        [_bgView addGestureRecognizer:tap];
        [self.contentView addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = HomeColor_TitleColor;
        _leftTitleLabel.font = HomeFont_TitleFont;
        _leftTitleLabel.text = Lang(@"str_dial_custom");
        [self.bgView addSubview:_leftTitleLabel];
    }
    return _leftTitleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.textColor = HomeColor_TitleColor;
        _subTitleLabel.font = HomeFont_ContentFont;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.text = Lang(@"str_dial_custom_tips");
        [self.bgView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.backgroundColor = [UIColor blackColor];
//        _leftImageView.layer.cornerRadius = 10.0;
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.backgroundColor = HomeColor_DialColor;
        [self.bgView addSubview:_leftImageView];
    }
    return _leftImageView;
}


@end
