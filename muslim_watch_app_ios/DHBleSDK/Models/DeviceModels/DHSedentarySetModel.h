//
//  DHSedentarySetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHSedentarySetModel : NSObject

/// 开关（0.关 1.开）
@property (nonatomic, assign) BOOL isOpen;
/// 开始小时（0-23）
@property (nonatomic, assign) NSInteger startHour;
/// 开始分钟（0-59）
@property (nonatomic, assign) NSInteger startMinute;
/// 结束小时（0-23）
@property (nonatomic, assign) NSInteger endHour;
/// 结束分钟（0-59）
@property (nonatomic, assign) NSInteger endMinute;
/// 重复 例：@[@0,@0,@0,@0,@0,@0,@1]; 按顺序从周日到周六，0.未选中 1.选中，示例代表周六重复提醒
@property (nonatomic,strong) NSArray <NSNumber *>*repeats;
/// 提醒频率（0-255）
@property (nonatomic, assign) NSInteger interval;

- (NSData *)valueWithJL;

@end

NS_ASSUME_NONNULL_END
