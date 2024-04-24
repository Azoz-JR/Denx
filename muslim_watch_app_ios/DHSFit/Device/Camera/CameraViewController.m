//
//  CameraViewController.m
//  DHBleSDKDemo
//
//  Created by DHS on 2022/7/26.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SCCaptureSessionManager.h"

@interface CameraViewController ()

/// 切换闪光灯
@property (nonatomic, strong) UIButton *flashButton;
/// 切换摄像头
@property (nonatomic, strong) UIButton *switchButton;
/// 取消
@property (nonatomic, strong) UIButton *cancelButton;
/// 拍照
@property (nonatomic, strong) UIButton *takePictureButton;


/// 对焦
@property (nonatomic, strong) UIImageView *focusImageView;

@property (nonatomic, assign) int alphaTimes;

@property (nonatomic) CGPoint currTouchPoint;

@property (nonatomic, strong) SCCaptureSessionManager *captureManager;

@end

@implementation CameraViewController

#pragma mark - vc lift cycle 生命周期

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [BaseView showCameraUnauthorized];
        return;
    }
    [self performSelector:@selector(addFocusView) withObject:nil afterDelay:0.5];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [self addObservers];
    
}

#pragma mark - custom action for UI 界面处理有关

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    SCCaptureSessionManager *manager = [[SCCaptureSessionManager alloc] init];
    [manager configureWithParentLayer:self.view previewRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.captureManager = manager;
    [_captureManager.session startRunning];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasFlash]) {
        [device lockForConfiguration:nil];
        device.flashMode = AVCaptureFlashModeOn;
        [device unlockForConfiguration];
    }
    
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(HomeViewSpace_Left);
        make.top.offset(40);
        make.height.width.offset(40);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-HomeViewSpace_Right);
        make.top.offset(40);
        make.height.width.offset(40);
    }];
    
    
    [self.takePictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.offset(-(kBottomHeight+25));
        make.height.width.offset(60);
        
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.centerY.equalTo(self.takePictureButton);
        make.height.offset(30);
    }];
}

- (void)addObservers {
    //监听相机关闭
    [DHNotificationCenter addObserver:self selector:@selector(cameraTurnOffNotification) name:BluetoothNotificationCameraTurnOff object:nil];
    //监听拍照
    [DHNotificationCenter addObserver:self selector:@selector(cameraTakePictureNotification) name:BluetoothNotificationCameraTakePicture object:nil];
}

- (void)cameraTurnOffNotification {
    [DHBluetoothManager shareInstance].isTakingPictures = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)cameraTakePictureNotification {
    [self takePictureClick:nil];
}

#pragma mark - event Response 事件响应(手势 通知)

- (void)cancelClick:(UIButton *)sender
{
    [DHBleCommand controlCamera:0 block:^(int code, id  _Nonnull data) {
        
    }];
    [DHBluetoothManager shareInstance].isTakingPictures = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePictureClick:(UIButton *)sender
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusRestricted && authStatus != AVAuthorizationStatusDenied) {
        [_captureManager takePicture:^(UIImage *stillImage)
         {
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 SHOWHUD(Lang(@"str_take_photo_ok"))
                 [self saveImageToPhotoAlbum:stillImage];
             });
         }];
    }
}

- (void)switchClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    [_captureManager switchCamera:sender.selected];
}

- (void)flashClick:(UIButton*)sender
{
    [_captureManager switchFlashMode:sender];
}

- (void)saveImageToPhotoAlbum:(UIImage*)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark ---------------------对焦--------------------------

- (void)addFocusView {
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:DHImage(@"device_camera_focus")];
    imgView.alpha = 0;
    imgView.frame = CGRectMake(0, 0, kScreenWidth/3.f, kScreenWidth/3.f);
    [self.view addSubview:imgView];
    self.focusImageView = imgView;
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    device.focusMode = AVCaptureFocusModeAutoFocus;
    [device setFlashMode:AVCaptureFlashModeAuto];
    
    if (device && [device isFocusPointOfInterestSupported]) {
        [device addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
#endif
    
    [_captureManager focusInPoint:self.view.center];
    
    [_focusImageView setCenter:self.view.center];
    
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        _focusImageView.alpha = HIGH_ALPHA;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusInPoint:self.view.center];
    }];
#else
    WEAKSELF
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weakSelf.focusImageView.alpha = 1.f;
        weakSelf.focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            weakSelf.focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}

#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        if (!isAdjustingFocus) {
            _alphaTimes = -1;
        }
    }
}

- (void)showFocusInPoint:(CGPoint)touchPoint {
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        int alphaNum = (_alphaTimes % 2 == 0 ? HIGH_ALPHA : LOW_ALPHA);
        self.focusImageView.alpha = alphaNum;
        _alphaTimes++;
    } completion:^(BOOL finished) {
        if (_alphaTimes != -1) {
            [self showFocusInPoint:_currTouchPoint];
        } else {
            self.focusImageView.alpha = 0.0f;
        }
    }];
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _alphaTimes = -1;
    
    UITouch *touch = [touches anyObject];
    _currTouchPoint = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(_captureManager.previewLayer.bounds, _currTouchPoint) == NO) {
        return;
    }
    
    [_captureManager focusInPoint:_currTouchPoint];
    
    [_focusImageView setCenter:_currTouchPoint];
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
    WEAKSELF
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        weakSelf.focusImageView.alpha = HIGH_ALPHA;
        weakSelf.focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [weakSelf showFocusInPoint:weakSelf.currTouchPoint];
    }];
#else
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weakSelf.focusImageView.alpha = 1.f;
        weakSelf.focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            weakSelf.focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        SHOWHUD(Lang(@"str_save_fail"))
    }
}

#pragma mark - get and set 属性的set和get方法

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton addTarget:self action:@selector(flashClick:) forControlEvents:UIControlEventTouchUpInside];
        [_flashButton setImage:DHImage(@"device_flash_on") forState:UIControlStateNormal];
        [self.view addSubview:_flashButton];
    }
    return _flashButton;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
        [_switchButton setImage:DHImage(@"device_camera_change") forState:UIControlStateNormal];
        [self.view addSubview:_switchButton];
    }
    return _switchButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:Lang(@"str_cancel") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = HomeFont_ButtonFont;
        [_cancelButton setTitleColor:HomeColor_TitleColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIButton *)takePictureButton {
    if (!_takePictureButton) {
        _takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePictureButton addTarget:self action:@selector(takePictureClick:) forControlEvents:UIControlEventTouchUpInside];
        [_takePictureButton setImage:DHImage(@"device_camera_photograph") forState:UIControlStateNormal];
        [self.view addSubview:_takePictureButton];
    }
    return _takePictureButton;
}

@end

