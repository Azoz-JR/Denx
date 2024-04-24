//
//  TimerManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/16.
//

#import "TimerManager.h"

@interface TimerManager()

/// 字典
@property (nonatomic, strong)NSMutableDictionary *mDict;

@end

@implementation TimerManager

+ (TimerManager *)shareInstance {
    static TimerManager *_shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _shared = [[self alloc]init];
        _shared.mDict = [NSMutableDictionary dictionary];
    });
    return _shared;
}

- (void)addTimerWithName:(NSString *)name interval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector repeats:(BOOL)repeats {
    [self delTimerWithName:name];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:aTarget selector:aSelector userInfo:nil repeats:repeats];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [self.mDict setValue:timer forKey:name];
}

- (void)delTimerWithName:(NSString *)name {
    NSTimer *timer = self.mDict[name];
    [self.mDict removeObjectForKey:name];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
