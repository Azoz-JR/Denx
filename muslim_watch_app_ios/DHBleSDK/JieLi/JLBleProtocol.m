//
//  JLBleProtocol.m
//  DHSFit
//
//  Created by DHS on 2023/10/5.
//

#import "JLBleProtocol.h"
#import "DHTool.h"

#define MAGIC 0xAB

@implementation JLBleProtocol


- (instancetype)init{
    if (self = [super init]){
        _magic = MAGIC;
    }
    return self;
}

- (instancetype)initDataCmd:(BleCommand)cmd
                        key:(BleKey)key
                     opType:(BleKeyFlag)optype
                      value:(NSData *)data
{
    if (self = [super init]){
        _magic = MAGIC;
        _cmdtype = cmd;
        _keytype = key;
        _protocolFlag = 0x01;
        _keyFlag = optype;
        _value = data;
        _payloadLen = data.length + 3;
    }
    
    return self;
}

- (instancetype)initAckCmd:(BleCommand)cmd
                       key:(BleKey)key
                    opType:(BleKeyFlag)optype
                     value:(NSData *)data
{
    if (self = [super init]){
        _magic = MAGIC;
        _cmdtype = cmd;
        _keytype = key;
        _protocolFlag = 0x11;
        _keyFlag = optype;
        _value = data;
        _payloadLen = data.length + 3;
    }
    return self;
}

- (NSData *)packProtocolData
{
    NSMutableData *tData = [NSMutableData dataWithCapacity:0];
    [tData appendBytes:&_magic length:1];
    [tData appendBytes:&_protocolFlag length:1];
    UInt16 tPackLen = htons(_payloadLen);
    [tData appendBytes:&tPackLen length:2];

    NSMutableData *tPayloadData = [NSMutableData dataWithCapacity:0];
    UInt8 tKeyType = (_keytype & 0xff);
    [tPayloadData appendBytes:&_cmdtype length:1];
    [tPayloadData appendBytes:&tKeyType length:1];
    [tPayloadData appendBytes:&_keyFlag length:1];
    if (_value && _value.length > 0){
        [tPayloadData appendData:_value];
    }
    
    UInt16 tCrc16 = [DHTool calculateCrc16:tPayloadData];
    tCrc16 = htons(tCrc16);
//    NSLog(@"packProtocolData crc16 %04X", tCrc16);
    [tData appendBytes:&tCrc16 length:2];
    [tData appendData:tPayloadData];
    
//    NSLog(@"packProtocolData %@", tData);
    
    return tData;
}

+ (BOOL)checkReceiveFinish:(NSData *)recvData
{
    int tOffset = 0;
    UInt8 tMagic = 0;
    UInt8 tProtocolflag = 0;
    UInt16 tPayloadLen = 0;
    
    [recvData getBytes:&tMagic range:NSMakeRange(tOffset++, 1)];
    [recvData getBytes:&tProtocolflag range:NSMakeRange(tOffset++, 1)];
    [recvData getBytes:&tPayloadLen range:NSMakeRange(tOffset, 2)];
    tPayloadLen = ntohs(tPayloadLen);
    
    if (tMagic == MAGIC && tPayloadLen + 6 == recvData.length){
        return YES;
    }
    return NO;
}

+ (JLBleProtocol *)unpackProtocolHead:(NSData *)recvData
{
    JLBleProtocol *tProtocolModel = [[JLBleProtocol alloc] init];
    int tOffset = 0;
    UInt8 tMagic = 0;
    UInt8 tProtocolflag = 0;
    UInt16 tPayloadLen = 0;
    UInt16 tCRC16 = 0;
    UInt8 tCmd = 0;
    UInt16 tKey = 0;
    UInt8 tKeyflag = 0;
    [recvData getBytes:&tMagic range:NSMakeRange(tOffset++, 1)];
    [recvData getBytes:&tProtocolflag range:NSMakeRange(tOffset++, 1)];
    [recvData getBytes:&tPayloadLen range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    [recvData getBytes:&tCRC16 range:NSMakeRange(tOffset, 2)];
    tOffset += 2;
    [recvData getBytes:&tCmd range:NSMakeRange(tOffset++, 1)];
    [recvData getBytes:&tKey range:NSMakeRange(tOffset - 1, 2)];
    tOffset += 1;
    [recvData getBytes:&tKeyflag range:NSMakeRange(tOffset++, 1)];
    
    tPayloadLen = ntohs(tPayloadLen);
    tKey = ntohs(tKey);
    
    tProtocolModel.magic = tMagic;
    tProtocolModel.protocolFlag = tProtocolflag;
    tProtocolModel.payloadLen = tPayloadLen;
    tProtocolModel.crc16 = tCRC16;
    tProtocolModel.cmdtype = tCmd;
    tProtocolModel.keytype = tKey;
    tProtocolModel.keyFlag = tKeyflag;
    
    if (tPayloadLen + 6 == recvData.length){
        NSLog(@"数据接收完成 recvData.length %d tPayloadLen %d", recvData.length, tPayloadLen);
        tProtocolModel.value = [recvData subdataWithRange:NSMakeRange(tOffset - 3, tPayloadLen)];
    }
    else{
        NSLog(@"数据未接收完成 recvData.length %d tPayloadLen %d", recvData.length, tPayloadLen);
    }
    
    NSLog(@"unpackProtocolHead %@", tProtocolModel);

    return tProtocolModel;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"protocolFlag %02x payloadLen %02x crc %04x cmdtype %02x keytype %04x keyFlag %02x value %@", _protocolFlag, _payloadLen, _crc16, _cmdtype, _keytype, _keyFlag, _value];
}

@end
