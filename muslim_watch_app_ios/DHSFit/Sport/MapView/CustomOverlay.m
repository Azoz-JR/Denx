//
//  CustomOverlay.m
//  AijuVeryFit
//
//  Created by aiju_huangjing1 on 2017/1/10.
//  Copyright © 2017年 morris. All rights reserved.
//

#import "CustomOverlay.h"

@interface CustomOverlay ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) MKMapRect boundingMapRect;

@end

@implementation CustomOverlay

@synthesize coordinate      = _coordinate;
@synthesize boundingMapRect = _boundingMapRect;

#pragma mark - Initalize

- (id)initWithRect:(MKMapRect)rect
{
    if (self = [super init])
    {
        self.boundingMapRect = rect;
    }
    
    return self;
}

@end
