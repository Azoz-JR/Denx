//
//  JLSendModel.h
//  DHSFit
//
//  Created by DHS on 2023/10/6.
//

#import <Foundation/Foundation.h>
#import "DHBleCommandEnums.h"

#define JLMTU (509 - 3)

NS_ASSUME_NONNULL_BEGIN

@interface JLSendModel : NSObject
@property (nonatomic, assign) BleKey sendBleKey;
@property (nonatomic, assign) int sendOffset;
@property (nonatomic, assign) BOOL needWaitData;//是否需要等待数据返回,一般只需等ACK返回;
@property (nonatomic, strong) NSData *sendData;


- (instancetype)initBleKey:(BleKey)blekey sendData:(NSData *)data;

- (instancetype)initBleKey:(BleKey)blekey wait:(BOOL)waitData sendData:(NSData *)data;

- (BOOL)sendFinished;
- (NSData *)nextFrame;

@end

NS_ASSUME_NONNULL_END
