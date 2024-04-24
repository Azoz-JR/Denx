//
//  RunningMapView.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "RunningMapView.h"

@implementation RunningMapView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark 创建苹果地图
- (void)setupSubViews {
    self.backgroundColor = HomeColor_BackgroundColor;
    self.distance = 0;
    
    self.mkMapView = [[MkMapAppleNewView alloc] init];
    self.mkMapView.type = MapTypeRunning;
    self.mkMapView.mk_mapView.showsUserLocation = YES;
    self.mkMapView.mk_mapView.userTrackingMode = MKUserTrackingModeNone;
    
    [self addSubview:self.mkMapView];
    [self sendSubviewToBack:self.mkMapView];

    [self.mkMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - get and set 属性的set和get方法

-(void)setEndPoint:(MAMapPoint)endPoint{
    //传入之前已经进行GPS信号值过滤了
    if ([RunningManager shareInstance].gpsItems.count > 0) {
        CLLocationDistance distance = MAMetersBetweenMapPoints(_endPoint,endPoint);
        //如果新点和旧点的距离大于10公里则不保存，并删除最后一个点
        if (distance > 10000) {
            return;
        }
        self.distance += distance;
         
    }
    
    self.currentPoint = endPoint;
    _oldPoint = _endPoint;
    _endPoint = endPoint;
        
    RailModel *railModel = [[RailModel alloc]init];
    CLLocationCoordinate2D cor = MACoordinateForMapPoint(endPoint);
    railModel.latitude = cor.latitude;
    railModel.longtitude = cor.longitude;
    [[RunningManager shareInstance].gpsItems addObject:railModel];
    
    if ([RunningManager shareInstance].gpsItems.count > 1) {
        NSArray *array = [[RunningManager shareInstance].gpsItems subarrayWithRange:NSMakeRange([RunningManager shareInstance].gpsItems.count-2, 2)];
        [_mkMapView drawMkMapKitViewWithArray:array];
    }
}

- (void)updateHeading:(CLHeading *)newHeading {
    [_mkMapView updateHeading:newHeading];
}

#pragma mark - event Response 事件响应(手势 通知)

- (void)backCurrentPoint{
    if (self.currentPoint.x > 0) {
        if (![RunningManager shareInstance].isBigMap) {
            CLLocationCoordinate2D cord = MACoordinateForMapPoint(self.currentPoint);
            [self.mkMapView.mk_mapView setCenterCoordinate:cord zoomLevel:kMAP_ZOOM_LEVEL_SELECTED animated:YES];
        } else {
            CLLocationCoordinate2D cord = MACoordinateForMapPoint(self.currentPoint);
            [self.mkMapView.mk_mapView setCenterCoordinate:cord zoomLevel:kMAP_ZOOM_LEVEL_NORMAL animated:YES];
        }
        [RunningManager shareInstance].isBigMap = ![RunningManager shareInstance].isBigMap;
        
    }
}

#pragma mark - custom action for UI 界面处理有关

- (void)updateMkMapView{
    WEAKSELF
    [UIView animateWithDuration:.25 animations:^{
        weakSelf.mkMapView.frame = weakSelf.bounds;
        weakSelf.mkMapView.mk_mapView.frame = weakSelf.bounds;
    }];
}

@end
