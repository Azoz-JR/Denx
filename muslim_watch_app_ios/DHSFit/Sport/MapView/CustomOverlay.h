//
//  CustomOverlay.h
//  AijuVeryFit
//
//  Created by aiju_huangjing1 on 2017/1/10.
//  Copyright © 2017年 morris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomOverlay : NSObject<MKOverlay>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKMapRect boundingMapRect;

- (id)initWithRect:(MKMapRect)rect;

@end
