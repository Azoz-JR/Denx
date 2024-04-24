//
//  DHBreathSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHBreathSetModel : NSObject

/// 开关（0.关 1.开）
@property (nonatomic, assign) BOOL isOpen;
/// 次数（固定5次）
@property (nonatomic, assign) NSInteger times;
/// 小时集合 例：@[@10,@12,@14,@16,@18] （0-23）
@property (nonatomic, strong) NSArray *hourArray;
/// 分钟集合 例：@[@0,@0,@0,@0,@0] （0-59）
@property (nonatomic, strong) NSArray *minuteArray;

@end

NS_ASSUME_NONNULL_END
