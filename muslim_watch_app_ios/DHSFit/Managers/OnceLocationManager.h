//
//  OnceLocationManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/20.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface OnceLocationManager : NSObject

/// 单例
+ (__kindof OnceLocationManager *)shareInstance;

/// 获取定位权限是否可用
+ (BOOL)locationServicesEnabled;

/// 单次定位
-(void)startOnceRequestLocationWithBlock:(void(^)(NSString *locationStr))block;

@end

NS_ASSUME_NONNULL_END
