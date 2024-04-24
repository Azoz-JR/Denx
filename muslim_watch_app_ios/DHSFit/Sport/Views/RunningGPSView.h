//
//  RunningGPSView.h
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import <UIKit/UIKit.h>
#import "RunningMapView.h"
#import "RunningDataView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RunningGPSViewDelegate <NSObject>

@optional

- (void)onBack;
- (void)onLocation;

@end

@interface RunningGPSView : UIView
/// 模型
@property (nonatomic, strong) DailySportModel *model;
/// 代理
@property (nonatomic, weak) id<RunningGPSViewDelegate> delegate;
/// 地图视图
@property (nonatomic, strong) RunningMapView *mapView;
/// 数据视图
@property (nonatomic, strong) RunningDataView *dataView;

@end

NS_ASSUME_NONNULL_END
