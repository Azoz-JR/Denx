//
//  LocationManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import "LocationManager.h"

@interface LocationManager()<AMapLocationManagerDelegate>

@property(nonatomic,retain)AMapLocationManager *locationManager;

@end

@implementation LocationManager

+ (__kindof LocationManager *)shareInstance
{
    static dispatch_once_t once;
    static LocationManager * _shared = nil;
    dispatch_once( &once, ^{
        _shared = [[self alloc] init];
        [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
        [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
        [AMapServices sharedServices].apiKey = @"9d6df4bde64ec3f9e1919bbd13e4501b";
    });
    return _shared;
}

- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 10;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0) {
            [_locationManager setAllowsBackgroundLocationUpdates:YES];
        }
    }
    return _locationManager;
}

#pragma mark --定位

- (void)startUpdatingLocation{
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}

- (void)endUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
}

#pragma mark AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0)  return;
    if (self.headingBlock) {
        self.headingBlock(newHeading);
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager {
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    if (location.horizontalAccuracy > 0 && location.horizontalAccuracy <= 9999) {
        if (self.locationBlock) {
            self.locationBlock(location);
        }
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}


@end
