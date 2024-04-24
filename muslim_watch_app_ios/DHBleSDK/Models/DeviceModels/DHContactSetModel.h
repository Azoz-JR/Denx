//
//  DHContactSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHContactSetModel : NSObject

/// 联系人
@property (nonatomic, copy) NSString *name;
/// 联系方式
@property (nonatomic, copy) NSString *mobile;

- (NSData *)valueWithJL;

@end

NS_ASSUME_NONNULL_END
