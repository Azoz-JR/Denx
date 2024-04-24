//
//  MkMapAppleNewView.m
//  AijuVeryFit
//
//  Created by aiju_huangjing1 on 2016/9/20.
//  Copyright © 2016年 morris. All rights reserved.
//

#import "MkMapAppleNewView.h"
#import "GradientPolylineRenderer.h"
#import "CustomOverlayRenderer.h"

@interface MkMapAppleNewView(){
    CLLocationDegrees minLat;
    CLLocationDegrees maxLat;
    CLLocationDegrees minLon;
    CLLocationDegrees maxLon;
}

@end

@implementation MkMapAppleNewView

#pragma mark - vc lift cycle 生命周期

- (void)updateHeading:(CLHeading *)newHeading {
    CLLocationDirection heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading;
    CGFloat rotation =  heading/180 * M_PI;
    self.userHeadingView.arrowImageView.transform = CGAffineTransformMakeRotation(rotation);
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    self.isShowMake = YES;
    self.lineColor = [UIColor greenColor];
    
    self.mk_mapView = [[MKMapView alloc] init];
    self.mk_mapView.delegate = self;
    
    [self addSubview:self.mk_mapView];
    
    [self.mk_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - custom action for UI 界面处理有关

- (void)addMapHiddenImageOverlay{
    //添加图片遮盖层
    self.mapHiddenImageOverlay = [[CustomOverlay alloc] initWithRect:self.mk_mapView.visibleMapRect];
    [self.mk_mapView addOverlay:self.mapHiddenImageOverlay level:1];
}

- (void)drawMapRunning:(NSArray *)drawArray{
    RailModel *railModel = [drawArray lastObject];
    CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(railModel.latitude, railModel.longtitude);
    if (![RunningManager shareInstance].isBigMap) {
        [_mk_mapView setCenterCoordinate:cord zoomLevel:kMAP_ZOOM_LEVEL_NORMAL animated:YES];
    }
    
    if (!_hasStartPoint) {
        RailModel *railModel = [drawArray firstObject];
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(railModel.latitude, railModel.longtitude);
        pointAnnotation.title = @"start";
        [_mk_mapView addAnnotation:pointAnnotation];
        _hasStartPoint = YES;
        
        NSMutableArray *smoothTrackArray = [NSMutableArray arrayWithArray:drawArray];
        double count = smoothTrackArray.count;
        CLLocationCoordinate2D *points;
        float *velocity;
        points = malloc(sizeof(CLLocationCoordinate2D)*count);
        velocity = malloc(sizeof(float)*count);
        
        for(int i=0;i<count;i++){
            if (i==0) {
                RailModel *model = smoothTrackArray[i];
                CLLocationDegrees latitude  = model.latitude;
                CLLocationDegrees longitude = model.longtitude ;
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                points[i] = coordinate;
                velocity[i] = 2.0;
            }
            else if(i == 1){
                RailModel *model = smoothTrackArray[0];
                CLLocationDegrees latitude  = model.latitude;
                CLLocationDegrees longitude = model.longtitude ;
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                model = smoothTrackArray[1];
                latitude  = model.latitude;
                longitude = model.longtitude ;
                CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude, longitude);
                
                
                points[i] = coordinate1;
                
                float speed = 2.0;
                velocity[i] = speed;
                
                
                if (!self.polyline){
                    self.polyline = [[GradientPolylineOverlay alloc] initWithStartCoordinate:coordinate endCoordinate:coordinate1 startVelcity:velocity[0] endVelcity:velocity[1]];
                }
            }
        }
    }
    else{
        RailModel *model = drawArray[0];
        CLLocationDegrees latitude  = model.latitude;
        CLLocationDegrees longitude = model.longtitude ;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        
        model = drawArray[1];
        latitude  = model.latitude;
        longitude = model.longtitude ;
        CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude, longitude);

        float speed = 2.0;
        
        [self.polyline addCoordinate:coordinate1 velcity:speed];
    }
    
    if (self.polyline) {
        [self.mk_mapView addOverlay:self.polyline level:1];
    }
}

- (void)drawMkMapKitViewWithArray:(NSArray *)drawArray{
    
    if (drawArray.count > 0) {
        _railModelArray = [NSArray arrayWithArray:drawArray];
        
        if (_type == MapTypeRunning) {
            [self drawMapRunning:drawArray];
        } else {
            //初始化标注点参数
            if (drawArray.count>=3){
                self.totalDistance = 0;
                self.lastMarkDistance = 0;
                self.markNO = 1;
            }
            [self drawMapViewWith:drawArray];
        }
    }
}

- (void)drawMapViewWith:(NSArray *)drawArray{
    
    RailModel *model;
    if (self.railModelArray.count>0) {
        model = self.railModelArray[0];
    }
    else{
        model = [[RailModel alloc] init];
        model.latitude = 22.686619;
        model.longtitude = 113.980951;
    }
    
    if (!self.poCircle) {
        self.poCircle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(model.latitude, model.longtitude ) radius:100000000000];
    }
    
    [self.mk_mapView addOverlay:self.poCircle level:1];
    
    self.annidationArray = [NSMutableArray array];
    NSMutableArray *anniArray = [NSMutableArray array];
    RailModel *railModel = [drawArray lastObject];
    
    CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(railModel.latitude, railModel.longtitude);
    if (cord.latitude>cord.longitude) {
        cord = CLLocationCoordinate2DMake(railModel.longtitude, railModel.latitude);
    }
    //添加起点终点
    railModel = [drawArray firstObject];
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(railModel.latitude, railModel.longtitude);
    pointAnnotation.title = @"start";
    [_mk_mapView addAnnotation:pointAnnotation];
    
    railModel = [drawArray lastObject];
    MKPointAnnotation *pointAnnotation1 = [[MKPointAnnotation alloc] init];
    pointAnnotation1.coordinate = CLLocationCoordinate2DMake(railModel.latitude, railModel.longtitude);
    pointAnnotation1.title = @"end";
    [_mk_mapView addAnnotation:pointAnnotation1];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *smoothTrackArray = [NSMutableArray arrayWithArray:drawArray];
        double count = smoothTrackArray.count;
        CLLocationCoordinate2D *points;
        float *velocity;
        points = malloc(sizeof(CLLocationCoordinate2D)*count);
        velocity = malloc(sizeof(float)*count);
 
        @autoreleasepool{
            for (int i = 0; i <count; i++) {
                if (i==0) {
                    RailModel *model = smoothTrackArray[i];
                    CLLocationDegrees latitude  = model.latitude;
                    CLLocationDegrees longitude = model.longtitude ;
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    
                    points[i] = coordinate;
                    velocity[i] = 2.0;
                }
                else {
                    RailModel *model = smoothTrackArray[i-1];
                    CLLocationDegrees latitude  = model.latitude;
                    CLLocationDegrees longitude = model.longtitude ;
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    
                    model = smoothTrackArray[i];
                    latitude  = model.latitude;
                    longitude = model.longtitude ;
                    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude, longitude);
                    
                    points[i] = coordinate1;
                    
                    CGFloat distance = [weakSelf obtainDistanceFromStartPoint:coordinate toEndPoint:coordinate1];
                    //添加每公里标注点
                    if (drawArray.count>=3 && weakSelf.isShowMake) {
                        if (weakSelf.annidationArray.count<=0) {
                            weakSelf.totalDistance += distance;
                            CGFloat perKm = 1000.0;
                            ;
                            if (ImperialUnit) {
                                perKm = 1609.0;
                            }
                            if (weakSelf.totalDistance-weakSelf.lastMarkDistance>=perKm) {
                                weakSelf.lastMarkDistance = weakSelf.totalDistance;
                                MKPointAnnotation *pointAnnotationPerKm = [[MKPointAnnotation alloc] init];
                                pointAnnotationPerKm.coordinate =coordinate1;
                                NSInteger maxDis = MAX((int)weakSelf.totalDistance/(NSInteger)perKm, weakSelf.markNO);
                                pointAnnotationPerKm.title = [NSString stringWithFormat:@"%ld",(long)maxDis];
                                [anniArray addObject:pointAnnotationPerKm];
                                weakSelf.markNO++;
                            }
                        }
                    }
                    
                    float speed = 2.0;
                    velocity[i] = speed;
                    if (velocity[0] == 0) {
                        velocity[0] = speed;
                    }
                }
            }
        }
        
        [weakSelf.annidationArray addObjectsFromArray:anniArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mk_mapView removeAnnotations:weakSelf.annidationArray];
            [weakSelf.mk_mapView addAnnotations:weakSelf.annidationArray];
            if (!weakSelf.polyline){
                weakSelf.polyline = [[GradientPolylineOverlay alloc] initWithPoints:points velocity:velocity count:count];
            }
            [weakSelf.mk_mapView removeOverlay:weakSelf.polyline];
            
            [weakSelf.mk_mapView addOverlay:weakSelf.polyline level:1];
            [weakSelf setMapRegin:drawArray andIsCenter:NO];
        });
    });
}

//添加灰色轨迹
- (void)addLightGrayLine{
    if (self.grayPolyLine) {
        [_mk_mapView removeOverlay:self.grayPolyLine];
    }
    int count = (int)_railModelArray.count;
    CLLocationCoordinate2D cllocation[count];
    for (int i = 0 ;i<_railModelArray.count;i++) {
        RailModel *model= _railModelArray[i];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(model.latitude, model.longtitude);
        cllocation[i] = coor;
    }
    
    self.grayPolyLine = [MKPolyline polylineWithCoordinates:cllocation count:_railModelArray.count];
    [_mk_mapView addOverlay:self.grayPolyLine];
}
//使轨迹在地图可视范围内.
- (void)setMapRegin:(NSArray *)drawArray andIsCenter:(BOOL)isCenter{
    //解析数据
    for (int i=0; i<drawArray.count; i++) {
        RailModel *model =  drawArray[i];
        if (i==0) {
            //以第一个坐标点做初始值
            minLat = model.latitude;
            maxLat = model.latitude;
            minLon = model.longtitude;
            maxLon = model.longtitude;
        }else{
            //对比筛选出最小纬度，最大纬度；最小经度，最大经度
            minLat = MIN(minLat, model.latitude);
            maxLat = MAX(maxLat, model.latitude);
            minLon = MIN(minLon, model.longtitude);
            maxLon = MAX(maxLon, model.longtitude);
        }
    }
    //动态的根据坐标数据的区域，来确定地图的显示中心点和缩放级别
    if (drawArray.count > 0) {
        //计算中心点
        CLLocationCoordinate2D centCoor;
        if (isCenter) {
            centCoor.latitude = (CLLocationDegrees)((maxLat+minLat) * 0.5f);
        }
        else{
            centCoor.latitude = (CLLocationDegrees)((maxLat+minLat) * 0.5f-(maxLat - minLat)*3.0f/7);
        }
        
        centCoor.longitude = (CLLocationDegrees)((maxLon+minLon) * 0.5f);
        MKCoordinateSpan span;
        //计算地理位置的跨度
        span.latitudeDelta = (maxLat - minLat)*2.6;
        span.longitudeDelta = (maxLon - minLon)*2.6 ;
        //得出数据的坐标区域
        MKCoordinateRegion region = MKCoordinateRegionMake(centCoor, span);
        
        [_mk_mapView setRegion:region animated:YES];
    }
}

- (NSDate *)timestampToDetailDate:(NSInteger)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return date;
}

- (CGFloat)obtainDistanceFromStartPoint:(CLLocationCoordinate2D)startPoint toEndPoint:(CLLocationCoordinate2D)endPoint{
    //第一个坐标
    CLLocation *current=[[CLLocation alloc] initWithLatitude:startPoint.latitude longitude:startPoint.longitude];
    //第二个坐标
    CLLocation *before=[[CLLocation alloc] initWithLatitude:endPoint.latitude longitude:endPoint.longitude];
    // 计算距离
    CLLocationDistance meters=[current distanceFromLocation:before];
    return meters;
}

#pragma mark - xxxxxx delegate 各种delegate回调

#pragma mark - MKMap Delegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    if([overlay isKindOfClass:[GradientPolylineOverlay class]]){
        GradientPolylineRenderer *polylineRenderer = [[GradientPolylineRenderer alloc] initWithOverlay:overlay andMaxSpeed:self.maxSpeed andMinSpeed:self.minSpeed];
        polylineRenderer.lineWidth = 10.f;
        return polylineRenderer;
    }
    if([overlay isKindOfClass:[CustomOverlay class]]){
        //遮挡地图图片
        CustomOverlayRenderer *renderer = [[CustomOverlayRenderer alloc] initWithOverlay:overlay];
        return renderer;
    }
    
    return [[MKOverlayRenderer alloc] init];
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    if (fullyRendered) {
        [self delayPerformBlock:^(id  _Nonnull object) {
            [self mapLoadOver];
        } WithTime:1.5];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    if (([views.lastObject isKindOfClass:NSClassFromString(@"_MKUserLocationView")] || [views.lastObject isKindOfClass:NSClassFromString(@"MKUserLocationView")])&& self.type == MapTypeRunning) {
        //[views.lastObject isKindOfClass:NSClassFromString(@"MKUserLocationView")] iOS13.6版本无法替换系统icon，覆盖上去不好看，所以不改
        DHUserLocationHeadingView *headingView = [[DHUserLocationHeadingView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
        headingView.center = CGPointMake(views.lastObject.width/2, views.lastObject.height / 2);
        headingView.tag = 312;
        if (![views.lastObject viewWithTag:312]) {
            [views.lastObject addSubview:headingView];
            _userHeadingView = headingView;
        }
    }
}

- (void)mapLoadOver{
    if (_mapLoadOverBlock) {
        _mapLoadOverBlock();
    }
}

#pragma mark mapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        
        MKAnnotationView *aView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (aView == nil) {
            aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        for (UIView *sView in aView.subviews) {
            [sView removeFromSuperview];
        }
        aView.canShowCallout= NO; //设置气泡可以弹出，默认为NO
        aView.draggable = NO; //设置标注可以拖动，默认为NO
        
        if ([[annotation title] isEqualToString:@"start"]) {
            aView.image = DHImage(@"sport_map_start");
        }
        else  if ([[annotation title] isEqualToString:@"end"]){
            aView.image = DHImage(@"sport_map_end");
        }else{
            if (_isPrivate) {
                aView.image = DHImage(@"sport_map_km_black");
            }
            else{
                aView.image = DHImage(@"sport_map_km");
            }
            
            UILabel *kmLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, aView.width-4, aView.height-2)];
            kmLabel.tag = 100;
            kmLabel.text = [annotation title];
            kmLabel.textAlignment = NSTextAlignmentCenter;
            kmLabel.textColor = [UIColor whiteColor];
            kmLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];
            kmLabel.numberOfLines = 0;
            kmLabel.adjustsFontSizeToFitWidth = YES;
            [aView addSubview:kmLabel];
        }
        return aView;
    }
    return nil;
}

@end
