//
//  RunningViewController.h
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "MWBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RunningViewController : MWBaseController

/// 运动类型
@property (nonatomic, assign) SportType sportType;
/// 是否轨迹类型
@property (nonatomic, assign) BOOL isGPS;
/// 是否连接设备
@property (nonatomic, assign) BOOL isConnected;

@end

NS_ASSUME_NONNULL_END
