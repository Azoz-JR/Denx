//
//  GradientPolylineOverlay.m
//  MapHunter
//
//  Created by YiGan on 14/11/2016.
//  Copyright © 2016 ganyi. All rights reserved.
//

#import "GradientPolylineOverlay.h"
#import <pthread.h>

#define INITIAL_POINT_SPACE 1000
#define MINIMUM_DELTA_METERS 10.0

@implementation GradientPolylineOverlay{
    
}

@synthesize points, pointCount, velocity;
-(id) initWithPoints:(CLLocationCoordinate2D*)_points velocity:(float *)_velocity count:(NSUInteger)_count{
    self = [super init];
    if (self){
        pointCount = _count;
        self.points = malloc(sizeof(MKMapPoint)*pointCount);
        for (int i=0; i<_count; i++){
            self.points[i] = MKMapPointForCoordinate(_points[i]);
        }
        
        self.velocity = malloc(sizeof(float)*pointCount);
        for (int i=0; i<_count;i++){
            self.velocity[i] = _velocity[i];
        }
        
        //bite off up to 1/4 of the world to draw into
        MKMapPoint origin = points[0];
        origin.x -= MKMapSizeWorld.width/8.0;
        origin.y -= MKMapSizeWorld.height/8.0;
        MKMapSize size = MKMapSizeWorld;
        size.width /=4.0;
        size.height /=4.0;
        boundingMapRect = (MKMapRect) {origin, size};
        MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
        boundingMapRect = MKMapRectIntersection(boundingMapRect, worldRect);
        
        // initialize read-write lock for drawing and updates
        pthread_rwlock_init(&rwLock,NULL);
    }
    return self;
}


-(id) initWithStartCoordinate:(CLLocationCoordinate2D)startCoord endCoordinate: (CLLocationCoordinate2D)endCoord startVelcity: (float)startVelcity endVelcity: (float)endVelcity{
    self = [super init];
    if (self){
        //initialize point storage and place this first coordinate in it
        pointSpace = INITIAL_POINT_SPACE;
        points = malloc(sizeof(MKMapPoint)*pointSpace);
        points[0] = MKMapPointForCoordinate(startCoord);
        points[1] = MKMapPointForCoordinate(endCoord);
        velocity = malloc(sizeof(float)*pointSpace);
        velocity[0] = startVelcity;
        velocity[1] = endVelcity;
        pointCount = 2;
        
        //bite off up to 1/4 of the world to draw into
        MKMapPoint origin = points[0];
        origin.x -= MKMapSizeWorld.width/8.0;
        origin.y -= MKMapSizeWorld.height/8.0;
        MKMapSize size = MKMapSizeWorld;
        size.width /=4.0;
        size.height /=4.0;
        boundingMapRect = (MKMapRect) {origin, size};
        MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
        boundingMapRect = MKMapRectIntersection(boundingMapRect, worldRect);
        
        // initialize read-write lock for drawing and updates
        pthread_rwlock_init(&rwLock,NULL);
    }
    return self;
}

-(void)dealloc{
    free(points);
    free(velocity);
    pthread_rwlock_destroy(&rwLock);
}

//center
-(CLLocationCoordinate2D)coordinate{
    return MKCoordinateForMapPoint(points[0]);
}

-(MKMapRect)boundingMapRect{
    return boundingMapRect;
}

-(void) lockForReading{
    pthread_rwlock_rdlock(&rwLock);
}

-(void) unlockForReading{
    pthread_rwlock_unlock(&rwLock);
}


-(MKMapRect)addCoordinate:(CLLocationCoordinate2D)coord velcity:(float)newVelcity{
    //Acquire the write lock because we are going to changing the list of points
    pthread_rwlock_wrlock(&rwLock);
    
    //Convert a CLLocationCoordinate2D to an MKMapPoint
    MKMapPoint newPoint = MKMapPointForCoordinate(coord);
    MKMapPoint prevPoint = points[pointCount-1];
    
    
    //Get the distance between this new point and previous point
    CLLocationDistance metersApart = MKMetersBetweenMapPoints(newPoint, prevPoint);
    MKMapRect updateRect = MKMapRectNull;
    
    if (metersApart > MINIMUM_DELTA_METERS){//MINIMUM_DELTA_METERS
        //Grow the points array if necessary
        if (pointSpace == pointCount){
            pointSpace *= 2;
            points = realloc(points, sizeof(MKMapPoint) * pointSpace);
            velocity = realloc(velocity, sizeof(float) * pointSpace);
        }
        
        //Add the new point to points array
        points[pointCount] = newPoint;
        velocity[pointCount] = newVelcity;
        pointCount++;
        
        //Compute MKMapRect bounding prevPoint and newPoint
        double minX = MIN(newPoint.x,prevPoint.x);
        double minY = MIN(newPoint.y,prevPoint.y);
        double maxX = MAX(newPoint.x, prevPoint.x);
        double maxY = MAX(newPoint.y, prevPoint.y);
        
        updateRect = MKMapRectMake(minX, minY, maxX - minX, maxY - minY);
    }
    
    pthread_rwlock_unlock(&rwLock);
    
    return updateRect;
}

@end
