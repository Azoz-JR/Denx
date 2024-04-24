//
//  TimerManager.h
//  DHSFit
//
//  Created by DHS on 2022/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerManager : NSObject

+(TimerManager *)shareInstance;

/// 开始一个定时器
- (void)addTimerWithName:(NSString *)name interval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector repeats:(BOOL)repeats;

/// 停止并删除
- (void)delTimerWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
