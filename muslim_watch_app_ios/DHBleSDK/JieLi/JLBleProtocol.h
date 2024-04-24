//
//  JLBleProtocol.h
//  DHSFit
//
//  Created by DHS on 2023/10/5.
//

#import <Foundation/Foundation.h>
#import "DHBleCommandEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLBleProtocol : NSObject
@property (nonatomic, assign) UInt8 magic;
@property (nonatomic, assign) UInt8 protocolFlag;
@property (nonatomic, assign) UInt16 payloadLen;
@property (nonatomic, assign) UInt16 crc16;
@property (nonatomic, assign) BleCommand cmdtype;
@property (nonatomic, assign) BleKey keytype;
@property (nonatomic, assign) BleKeyFlag keyFlag;
@property (nonatomic, strong) NSData *value;


- (instancetype)initDataCmd:(BleCommand)cmd key:(BleKey)key opType:(BleKeyFlag)optype value:(NSData *)data;

- (instancetype)initAckCmd:(BleCommand)cmd key:(BleKey)key opType:(BleKeyFlag)optype value:(NSData *)data;

- (NSData *)packProtocolData;

+ (JLBleProtocol *)unpackProtocolHead:(NSData *)recvData;

+ (BOOL)checkReceiveFinish:(NSData *)recvData;

@end

NS_ASSUME_NONNULL_END
