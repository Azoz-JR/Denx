//
//  WeatherManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherManager : NSObject

@property (nonatomic, assign) NSInteger requestCount;

/// 单例
+ (__kindof WeatherManager *)shareInstance;

/// 单次定位，并发送天气设置
- (void)getLocationInfoAndRequestWeather;

/// 延迟上传健康数据
- (void)delayUploadAllHealthData;

- (void)requestLocation;

@end

NS_ASSUME_NONNULL_END
