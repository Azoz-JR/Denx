//
//  LocationManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject

/// 单例
+ (__kindof LocationManager *)shareInstance;

/// 开始连续定位
- (void)startUpdatingLocation;

/// 定位信息回调
@property (nonatomic, copy) void (^locationBlock)(CLLocation * location);

/// 定位方向回调
@property (nonatomic, copy) void (^headingBlock)(CLHeading * heading);

///  结束连续定位
- (void)endUpdatingLocation;


@end

NS_ASSUME_NONNULL_END
