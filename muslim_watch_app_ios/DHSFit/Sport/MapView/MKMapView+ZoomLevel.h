//
//  MKMapView+ZoomLevel.h
//  AijuVeryFit
//
//  Created by aiju_huangjing1 on 16/8/23.
//  Copyright © 2016年 morris. All rights reserved.
//  设置地图缩放等级扩展

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
