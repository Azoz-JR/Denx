//
//  UICompassController.m
//  DHSFit
//
//  Created by qiao liwei on 2023/5/22.
//

#import "UICompassController.h"

@interface UICompassController ()<CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet UIView *compassBgView;
@property (nonatomic, strong) IBOutlet UIImageView *compassBGIv;
@property (nonatomic, strong) IBOutlet UIImageView *compassPointIv;
@property (nonatomic, strong) IBOutlet UIImageView *okQiblaIv;
@property (nonatomic, strong) IBOutlet UILabel *okQiblaLb;

@property (nonatomic, strong) IBOutlet UILabel *angleQiblaLabel;
@property (nonatomic, strong) IBOutlet UILabel *angleQiblaToDeviceLabel;

@property (nonatomic, assign) CGFloat qiblaAngle;

@end

@implementation UICompassController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hbd_barHidden = NO;
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barShadowHidden = YES;
    self.hbd_barAlpha = 0.0;
    self.hbd_barTintColor = [UIColor whiteColor];
    
    
    self.okQiblaIv.hidden = YES;
    self.okQiblaLb.hidden = YES;
    
    self.qiblaAngle = 0;
    
    self.title = Lang(@"str_compass");
    
    [self createLocationManager];
    
    [self updateQiblaAngle];
}

//创建初始化定位装置
- (void)createLocationManager{
    
    //attention 注意开启手机的定位服务，隐私那里的
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    //  定位频率,每隔多少米定位一次
    // 距离过滤器，移动了几米之后，才会触发定位的代理函数
    self.locationManager.distanceFilter = 0;
    
    // 定位的精度，越精确，耗电量越高
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//导航
    
    //请求允许在前台获取用户位置的授权
    [self.locationManager requestWhenInUseAuthorization];
    
    //允许后台定位更新,进入后台后有蓝条闪动
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    
//    //判断定位设备是否能用和能否获得导航数据
//    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager headingAvailable]){
//        [self.locationManager startUpdatingLocation];//开启定位服务
//        [self.locationManager startUpdatingHeading];//开始获得航向数据
//    }
//    else{
//        [SVProgressHUD showErrorWithStatus:@"需开启定位才能使用此功能"];
//        NSLog(@"不能获得航向数据");
//    }
    
}

- (void)startLocationAndHeadingUpdates {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager headingAvailable]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.locationManager startUpdatingLocation];
                [self.locationManager startUpdatingHeading];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"需开启定位才能使用此功能"];
                NSLog(@"不能获得航向数据");
            });
        }
    });
}

- (void)updateQiblaAngle{
    double tLat = [[ConfigureModel shareInstance].latitude doubleValue];
    double tLon = [[ConfigureModel shareInstance].longitude doubleValue];
    
    CGFloat phiK = 21.4 * M_PI / 180.0;
    CGFloat lambdaK = 39.8 * M_PI / 180.0;
    CGFloat phi = tLat * M_PI / 180.0;
    CGFloat lambda = tLon * M_PI / 180.0;

    CGFloat _qiblaAngle = 180.0 / M_PI * atan2(sin(lambdaK - lambda), cos(phi) * tan(phiK) - sin(phi) * cos(lambdaK - lambda));
    
    self.qiblaAngle = [self heading:round(_qiblaAngle) fromOrirntation:UIDeviceOrientationPortrait];
    
    self.angleQiblaLabel.text = [NSString stringWithFormat:@"Qibla Angle %d°", (int)self.qiblaAngle];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- CLLocationManagerDelegate
// Delegate method called when authorization status changes
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startLocationAndHeadingUpdates];
    } else {
        // Handle case where authorization is not granted
    }
}

// 定位成功之后的回调方法，只要位置改变，就会调用这个方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *tLastLocation = locations.lastObject;
    if (tLastLocation){
        [ConfigureModel shareInstance].latitude = [NSString stringWithFormat:@"%lf", tLastLocation.coordinate.latitude];
        [ConfigureModel shareInstance].longitude = [NSString stringWithFormat:@"%lf", tLastLocation.coordinate.longitude];
    }
    NSLog(@"didUpdateLocations %zd", locations.count);
    
    [self updateQiblaAngle];
}

//获得地理和地磁航向数据，从而转动地理刻度表
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    NSLog(@"didUpdateHeading %f", newHeading.magneticHeading);
    //获得当前设备
    UIDevice *device =[UIDevice currentDevice];
    
    //    判断磁力计是否有效,负数时为无效，越小越精确
    if (newHeading.headingAccuracy > 0)
    {
        //地磁航向数据-》magneticHeading
        float magneticHeading = [self heading:newHeading.magneticHeading fromOrirntation:device.orientation];
        
        //地磁北方向
        float heading = -1.0f *M_PI *newHeading.magneticHeading /180.0f;
        float qiblaheading = -1.0f *M_PI * self.qiblaAngle /180.0f;
        
        double toDeviceAngle = 2*M_PI - heading + qiblaheading;
        self.compassPointIv.transform = CGAffineTransformMakeRotation(toDeviceAngle);

        //旋转变换
        [self resetDirection:heading];
        
        [self updateHeading:newHeading magneticHeading:magneticHeading];
    }
}

- (void)resetDirection:(float)heading{
    self.compassBGIv.transform = CGAffineTransformMakeRotation(heading);
}

//返回当前手机（摄像头)朝向方向
- (void)updateHeading:(CLHeading *)newHeading magneticHeading:(float)magneticHeading{
    
    CLLocationDirection theHeading = ((newHeading.magneticHeading > 0) ?
                                       newHeading.magneticHeading : newHeading.trueHeading);
    
    int angle = (int)theHeading;
    float tToDeviceAngle = [self heading:(360 - self.qiblaAngle + angle) fromOrirntation:UIDeviceOrientationPortrait];
    self.angleQiblaToDeviceLabel.text = [NSString stringWithFormat:@"Device Angle to Qibla %.0f°", tToDeviceAngle];
    
    if (tToDeviceAngle > 0 && tToDeviceAngle < 5){
        self.okQiblaIv.hidden = NO;
        self.okQiblaLb.hidden = NO;
    }
    else{
        self.okQiblaIv.hidden = YES;
        self.okQiblaLb.hidden = YES;
    }

}


- (float)heading:(float)heading fromOrirntation:(UIDeviceOrientation)orientation{
    
    float realHeading =heading;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            realHeading = heading - 180.0f;
            break;
        case UIDeviceOrientationLandscapeLeft:
            realHeading = heading + 90.0f;
            break;
        case UIDeviceOrientationLandscapeRight:
            realHeading = heading - 90.0f;
            break;
        default:
            break;
    }
    if (realHeading > 360.0f)
    {
        realHeading -= 360.0f;
    }
    else if (realHeading < 0.0f)
    {
        realHeading += 360.0f;
    }
    return realHeading;
}

//判断设备是否需要校验，受到外来磁场干扰时
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}


- (void)dealloc{
    
    [self.locationManager stopUpdatingHeading];//停止获得航向数据，省电
    
    self.locationManager.delegate=nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    [self.locationManager stopUpdatingHeading];//停止获得航向数据，省电
    
    self.locationManager.delegate=nil;
    
}
@end
