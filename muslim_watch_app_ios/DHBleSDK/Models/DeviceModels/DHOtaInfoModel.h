//
//  DHOtaInfoModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHOtaInfoModel : NSObject

/// 是否正在升级（0.否 1.是）
@property (nonatomic, assign) BOOL isOta;
/// 固件是否完整（0.否 1.是）
@property (nonatomic, assign) BOOL isComplete;

@end

NS_ASSUME_NONNULL_END
