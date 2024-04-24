//
//  AppQRCodeViewController.m
//  DHSFit
//
//  Created by DHS on 2022/8/8.
//

#import "AppQRCodeViewController.h"
#import <CoreImage/CoreImage.h>

@interface AppQRCodeViewController ()

#pragma mark UI
/// 背景图
@property (nonatomic, strong) UIView *bgView;
/// 头像
@property (nonatomic, strong) UIImageView *leftImageView;
/// 昵称
@property (nonatomic, strong) UILabel *leftTitleLabel;
/// 二维码
@property (nonatomic, strong) UIImageView *qrcodeImageView;
/// 运动数据
@property (nonatomic, strong) UIView *dataView;
/// 底部文案
@property (nonatomic, strong) UILabel *bottomLabel;

#pragma mark Data
/// 用户模型
@property (nonatomic, strong) UserModel *model;
/// 运动模型
@property (nonatomic, strong) DailyStepModel *stepModel;
/// 视图高度
@property (nonatomic, assign) NSInteger viewH;

@end

@implementation AppQRCodeViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    self.model = [UserModel currentModel];
    self.stepModel = [HealthDataManager dayChartDatas:[NSDate date] type:HealthDataTypeStep];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    self.viewH = 250+kScreenWidth/2.0;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.offset(self.viewH);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.width.height.offset(80);
    }];
    
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.centerY.equalTo(self.leftImageView);
        make.right.offset(-10);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.bottom.offset(-20);
    }];
    
    [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(self.bottomLabel.mas_top).offset(-10);
        make.height.offset(50);
    }];

    NSArray *titles = @[Lang(@"str_step"),Lang(@"str_cal"),Lang(@"str_distance")];
    CGFloat multiplied = 1.0/titles.count;
    UIView *lastView;
    for (int i = 0; i < titles.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = HomeColor_BlockColor;
        [self.dataView addSubview:itemView];
        
        if (i == 0) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.offset(0);
                make.width.equalTo(self.dataView).multipliedBy(multiplied);
            }];
        } else {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right);
                make.top.bottom.offset(0);
                make.width.equalTo(self.dataView).multipliedBy(multiplied);
            }];
        }

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = HomeColor_SubTitleColor;
        titleLabel.font = HomeFont_ContentFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = titles[i];
        [itemView addSubview:titleLabel];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.textColor = HomeColor_TitleColor;
        valueLabel.font = HomeFont_ContentFont;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        [itemView addSubview:valueLabel];
        
        if (i == 0) {
            valueLabel.text = [NSString stringWithFormat:@"%ld%@",(long)self.stepModel.step,StepUnit];
        } else if (i == 1) {
            valueLabel.text = [NSString stringWithFormat:@"%.01f%@",KcalValue(self.stepModel.calorie),CalorieUnit];
        } else {
            valueLabel.text = [NSString stringWithFormat:@"%.02f%@",DistanceValue(self.stepModel.distance),DistanceUnit];
        }
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(25);
        }];
        
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(25);
        }];

        lastView = itemView;
    }
    
    self.qrcodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2.0, kScreenWidth/2.0)];
    self.qrcodeImageView.image = DHImage(@"mine_qrcode_download");
    //self.qrcodeImageView.image = [self createQRCodeWithUrl:@"http://www.ruiwo168.com/app/download.html"];
    self.qrcodeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bgView addSubview:self.qrcodeImageView];
    self.qrcodeImageView.center = CGPointMake((kScreenWidth-30)/2.0, self.viewH/2.0);
}

- (UIImage *)createQRCodeWithUrl:(NSString *)url {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = url;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    // 转成高清格式
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:kScreenWidth/2.0];
    
    // 添加logo
    qrcode = [self drawImage:DHImage(@"mine_about_logo_1") inImage:qrcode];
    
    return qrcode;
}

// 将二维码转成高清的格式
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *resultImage = [UIImage imageWithCGImage:scaledImage];
    
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    return resultImage;
}

// 添加logo
- (UIImage *)drawImage:(UIImage *)newImage inImage:(UIImage *)sourceImage {
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //画 自己想要画的内容(添加的图片)
    CGContextDrawPath(context, kCGPathStroke);
    // 注意logo的尺寸不要太大,否则可能无法识别
    CGRect rect = CGRectMake(imageSize.width / 2 - 20, imageSize.height / 2 - 20, 40, 40);
//    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [newImage drawInRect:rect];
    
    //返回绘制的新图形
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)navRightButtonClick:(UIButton *)sender {
    [self onShare];
}

- (void)onShare {
    UIImage *imageToShare = [self snapshotScreen];
    NSArray *activityItems = @[imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError) {
        
    };
    
    activityVC.excludedActivityTypes = @[
        UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,
        UIActivityTypeMessage,UIActivityTypeMail,
        UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,
        UIActivityTypePrint,UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (UIImage *)snapshotScreen {
    UIGraphicsBeginImageContextWithOptions(self.bgView.bounds.size, NO,[UIScreen mainScreen].scale);
    [self.bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - get and set 属性的set和get方法

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HomeColor_BlockColor;
        _bgView.layer.cornerRadius =10.0;
        _bgView.layer.masksToBounds = YES;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.layer.cornerRadius = 40.0;
        _leftImageView.layer.masksToBounds = YES;
        NSData *avatar = [DHFile queryLocalImageWithFolderName:DHAvatarFolder fileName:[NSString stringWithFormat:@"%@.png",DHUserId]];
        if (self.model.avatar.length) {
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:DHImage(@"mine_main_avatar")];
        } else if (avatar) {
            _leftImageView.image = [UIImage imageWithData:avatar];
        } else {
            _leftImageView.image = DHImage(@"mine_main_avatar");
        }
        [self.bgView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = HomeColor_TitleColor;
        _leftTitleLabel.font = HomeFont_ContentFont;
        _leftTitleLabel.text = self.model.name;
        [self.bgView addSubview:_leftTitleLabel];
    }
    return _leftTitleLabel;
}

- (UIView *)dataView {
    if (!_dataView) {
        _dataView = [[UIView alloc] init];
        _dataView.backgroundColor = [UIColor clearColor];
        [self.bgView addSubview:_dataView];
    }
    return _dataView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.textColor = HomeColor_TitleColor;
        _bottomLabel.font = HomeFont_SubTitleFont;
        _bottomLabel.text = Lang(@"str_join_me");
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_bottomLabel];
    }
    return _bottomLabel;
}

@end
