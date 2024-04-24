//
//  QRCodeEditViewController.m
//  DHSFit
//
//  Created by DHS on 2022/8/9.
//

#import "QRCodeEditViewController.h"

@interface QRCodeEditViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

#pragma mark UI

@property (nonatomic, strong) UIImageView *qrcodeImageView;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UITextField *titleTF;

@property (nonatomic, strong) UIButton *changeButton;

@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIImagePickerController *pickerController;

#pragma mark Data

@property (nonatomic, strong) QRCodeSetModel *model;

@property (nonatomic, copy) NSString *lastTextFieldContent;

@end

@implementation QRCodeEditViewController

#pragma mark - vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setupUI];
    [self addGeusterHideKeyboard];
}

#pragma mark - custom action for DATA 数据处理有关

- (void)initData {
    self.model = [QRCodeSetModel currentModel:self.appType];
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(20);
        make.width.height.offset(kScreenWidth/3.0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.top.equalTo(self.qrcodeImageView.mas_bottom).offset(20);
        make.height.offset(50);
    }];
    
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.right.offset(0);
    }];
    
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.top.equalTo(self.titleView.mas_bottom).offset(10);
    }];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.top.equalTo(self.changeButton.mas_bottom).offset(10);
    }];
    
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.right.offset(-HomeViewSpace_Right);
        make.height.offset(50);
        make.top.equalTo(self.clearButton.mas_bottom).offset(10);
    }];
    
    
    self.titleTF.text = self.model.title;
}

- (void)changeClick:(UIButton *)sender {
    self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }
    [self.navigationController presentViewController:self.pickerController animated:YES completion:nil];
}

- (void)checkResult:(NSString *)result {
    
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    if (data.length > 256) {
        SHOWHUD(Lang(@"str_qrcode_length_out_limit"))
        return;
    }
    self.model.url = result;
    self.qrcodeImageView.image = [self createQRCodeWithUrl:result];
}

- (void)saveModel {
    [self.model saveOrUpdate];
}

- (void)clearClick:(UIButton *)sender {
    if (self.model.url.length) {
        [self.model deleteObject];
        self.model.title = @"";
        self.model.url = @"";
        
        self.qrcodeImageView.image = DHImage(@"device_main_qrcode");
        self.titleTF.text = @"";
    }
}

- (void)confirmClick:(UIButton *)sender {
    if (self.model.url.length == 0) {
        SHOWHUD(Lang(@"str_please_input_qrcode"))
        return;
    }
    self.model.title = self.titleTF.text.length ? self.titleTF.text : Lang(@"str_qrcode");
    
    DHQRCodeSetModel *qrModel = [[DHQRCodeSetModel alloc] init];
    qrModel.appType = self.model.appType;
    qrModel.title = self.model.title;
    qrModel.url = self.model.url;
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setQRCode:qrModel block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            SHOWHUD(Lang(@"str_save_success"))
            [weakSelf saveModel];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            SHOWHUD(Lang(@"str_save_fail"))
        }
    }];
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
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:kScreenWidth/3.0];

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

- (void)addGeusterHideKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willEndEditing)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)willEndEditing{
    [self.view endEditing:NO];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.lastTextFieldContent = textField.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        NSData *data = [textField.text dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 20) {
            textField.text = self.lastTextFieldContent;
        } else {
            self.lastTextFieldContent = textField.text;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark --- UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        
        
    }
}

#pragma mark --- UIImagePickerControllerDelegate



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count == 0) {
        [picker dismissViewControllerAnimated:YES completion:^{
            SHOWHUD(Lang(@"str_search_qrcode_error"))
        }];
    } else {
        NSString *resultStr;
        for (int index = 0; index < [features count]; index ++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            resultStr = feature.messageString;
        }
        WEAKSELF
        [picker dismissViewControllerAnimated:YES completion:^{
            if (resultStr) {
                [weakSelf checkResult:resultStr];
            } else {
                SHOWHUD(Lang(@"str_search_qrcode_error"))
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }];
}

#pragma mark - get and set 属性的set和get方法

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = HomeColor_BlockColor;
        _titleView.layer.cornerRadius = 10.0;
        _titleView.layer.masksToBounds = YES;
        [self.view addSubview:_titleView];
    }
    return _titleView;
}

- (UITextField *)titleTF {
    if (!_titleTF) {
        _titleTF = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:Lang(@"str_please_input_name") attributes:@{NSForegroundColorAttributeName:HomeColor_PlaceholderColor,NSFontAttributeName:HomeFont_TitleFont}];
        _titleTF.attributedPlaceholder = attrString;
        _titleTF.tintColor = HomeColor_TitleColor;
        _titleTF.borderStyle = UITextBorderStyleNone;
        _titleTF.returnKeyType = UIReturnKeyDone;
        _titleTF.font = HomeFont_TitleFont;
        _titleTF.textColor = HomeColor_TitleColor;
        _titleTF.textAlignment = NSTextAlignmentCenter;
        _titleTF.delegate = self;
        _titleTF.tag = 1000;
        [_titleTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.titleView addSubview:_titleTF];
    }
    return _titleTF;
}

- (UIImageView *)qrcodeImageView {
    if (!_qrcodeImageView) {
        _qrcodeImageView = [[UIImageView alloc] init];
        _qrcodeImageView.backgroundColor = [UIColor whiteColor];
        _qrcodeImageView.contentMode = UIViewContentModeScaleAspectFill;
        if (self.model.url.length) {
            _qrcodeImageView.image = [self createQRCodeWithUrl:self.model.url];
        } else {
            _qrcodeImageView.image = DHImage(@"device_main_qrcode");
        }
    }
    [self.view addSubview:_qrcodeImageView];
    return _qrcodeImageView;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeButton.layer.cornerRadius = 10.0;
        _changeButton.layer.masksToBounds = YES;
        [_changeButton setTitle:Lang(@"str_replace") forState:UIControlStateNormal];
        [_changeButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        _changeButton.backgroundColor = HomeColor_MainColor;
        [_changeButton addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_changeButton];
    }
    return _changeButton;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.layer.cornerRadius = 10.0;
        _clearButton.layer.masksToBounds = YES;
        [_clearButton setTitle:Lang(@"str_clear") forState:UIControlStateNormal];
        [_clearButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        _clearButton.backgroundColor = HomeColor_MainColor;
        [_clearButton addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_clearButton];
    }
    return _clearButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 10.0;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton setTitle:Lang(@"str_save") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        _confirmButton.backgroundColor = HomeColor_MainColor;
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

- (UIImagePickerController *)pickerController {
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _pickerController.delegate = self;
    }
    return _pickerController;
}

@end
