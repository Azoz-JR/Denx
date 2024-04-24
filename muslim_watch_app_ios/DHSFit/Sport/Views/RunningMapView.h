//
//  RunningMapView.h
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import <UIKit/UIKit.h>
#import "MkMapAppleNewView.h"
#import "MKMapView+ZoomLevel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RunningMapView : UIView
//地图容器
@property (nonatomic,strong) MkMapAppleNewView *mkMapView;
//当前位置--用于实时定位
@property (nonatomic,assign) MAMapPoint currentPoint;
//上一个纪录点
@property (nonatomic,assign) MAMapPoint oldPoint;
//现在的位置点
@property (nonatomic,assign) MAMapPoint endPoint;
//水平精确度(GPS信号强度参考此值)
@property (assign,nonatomic) CLLocationAccuracy horizontalAccuracy;
//总运动距离 m
@property (nonatomic,assign) CGFloat distance;

//点击时间按钮更新地图frame
- (void)updateMkMapView;
///实时定位
- (void)backCurrentPoint;

- (void)updateHeading:(CLHeading *)newHeading;

@end

NS_ASSUME_NONNULL_END
