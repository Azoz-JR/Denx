//
//  OnceLocationManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/20.
//

#import "OnceLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface OnceLocationManager()<CLLocationManagerDelegate>

/// 是否需要地理编码
@property (nonatomic, assign) BOOL isNeedGeocoder;
/// 管理器
@property (nonatomic, strong) CLLocationManager *onceManager;
/// 定位信息
@property (nonatomic, copy, nullable) void(^onceLocation)(NSString *locationStr);

@end

@implementation OnceLocationManager

+ (__kindof OnceLocationManager *)shareInstance
{
    static dispatch_once_t once;
    static OnceLocationManager * _shared = nil;
    dispatch_once( &once, ^{
        _shared = [[self alloc] init];
    } );
    return _shared;
}

#pragma mark --更新手机位置信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = (CLLocation *)[locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    if (!self.isNeedGeocoder) {
        return;
    }
    WEAKSELF
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        weakSelf.isNeedGeocoder = NO;
        NSString *locationStr = [NSString stringWithFormat:@"%f,%f",location.coordinate.longitude,location.coordinate.latitude];
        if (weakSelf.onceLocation) {
            [ConfigureModel shareInstance].longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            [ConfigureModel shareInstance].latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            [ConfigureModel archiveraModel];
            weakSelf.onceLocation(locationStr);
            weakSelf.onceLocation = nil;
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [[OnceLocationManager shareInstance] checkLocationStatus];
}


- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager{
    [[OnceLocationManager shareInstance] checkLocationStatus];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (self.onceLocation) {
        self.onceLocation(@"");
        self.onceLocation = nil;
    }
}

#pragma mark --定位

-(void)startOnceRequestLocationWithBlock:(void(^)(NSString *locationStr))block{
    self.isNeedGeocoder = YES;
    self.onceLocation = block;
    [self.onceManager requestLocation];
}

//- (void)checkLocationStatus{
//    if ([CLLocationManager locationServicesEnabled]) {
//        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
//            [self.onceManager requestAlwaysAuthorization];
//        }
//    }
//}

- (void)checkLocationStatus {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([CLLocationManager locationServicesEnabled]) {
            if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.onceManager requestAlwaysAuthorization];
                });
            }
        }
    });
}

+ (BOOL)locationServicesEnabled {
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] >=3)) {
        return YES;
    } else {
        return NO;
    }
}
 
-(CLLocationManager *)onceManager{
    if (!_onceManager){
        _onceManager = [[CLLocationManager alloc] init];
        _onceManager.pausesLocationUpdatesAutomatically = NO;
        _onceManager.delegate = self;
    }
    [_onceManager requestWhenInUseAuthorization];
    [_onceManager requestAlwaysAuthorization];
    return _onceManager;
}

@end
