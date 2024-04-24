//
//  MkMapAppleNewView.h
//  AijuVeryFit
//
//  Created by aiju_huangjing1 on 2016/9/20.
//  Copyright © 2016年 morris. All rights reserved.
//

typedef enum {
    MapTypeTimeLine,
    MapTypeRunning,
    MapTypeRunDetail
}MapType;

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GradientPolylineOverlay.h"
#import "CustomOverlay.h"
#import "MKMapView+ZoomLevel.h"
#import "DHUserLocationHeadingView.h"

#define kMAP_ZOOM_LEVEL_NORMAL 16.0
#define kMAP_ZOOM_LEVEL_SELECTED 18.0

@interface MkMapAppleNewView : UIView<MKMapViewDelegate>

//主地图view
@property (nonatomic,strong) MKMapView *mk_mapView;
//半透明蒙层
@property (nonatomic,strong) MKCircleRenderer *circleRenderer;
//线色
@property (nonatomic,strong) UIColor *lineColor;
//轨迹主线
@property (nonatomic,strong) GradientPolylineOverlay *polyline;
//线
@property (nonatomic,strong) MKPolyline *grayPolyLine;
//RailModel数组
@property (nonatomic,strong) NSArray *railModelArray;

//自身蓝圈
@property (nonatomic,strong) MKCircle *poCircle;
//总距离
@property (nonatomic,assign) CGFloat totalDistance;
//上一个标记点距离
@property (nonatomic,assign) CGFloat lastMarkDistance;
//标记点数字
@property (nonatomic,assign) int markNO;
//每公里标记数组
@property (nonatomic,strong) NSMutableArray *annidationArray;


@property (nonatomic,assign) MapType type;

@property (nonatomic, assign) CGFloat maxSpeed;

@property (nonatomic, assign) CGFloat minSpeed;


@property (nonatomic,assign) BOOL hasStartPoint;

@property (nonatomic,assign) BOOL cutScreen;

@property (nonatomic, strong) DHUserLocationHeadingView *userHeadingView;

- (void)updateHeading:(CLHeading *)newHeading;

- (void)setMapRegin:(NSArray *)drawArray andIsCenter:(BOOL)isCenter;

//是否需要保持隐私
@property (nonatomic,assign) BOOL isPrivate;
//存放是否显示公里牌,默认YES，只有当运动详情是手机发起时为NO；
@property (nonatomic,assign) BOOL isShowMake;

@property (nonatomic,strong)CustomOverlay *mapHiddenImageOverlay;

//通过经纬度画轨迹线和公里标记
-(void)drawMkMapKitViewWithArray:(NSArray *)drawArray;

- (void)addMapHiddenImageOverlay;
//添加灰色轨迹
- (void)addLightGrayLine;
//地图加载完成Block
@property (nonatomic, copy) void (^mapLoadOverBlock) (void);

@end
