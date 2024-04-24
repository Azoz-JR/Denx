//
//  JLSendModel.m
//  DHSFit
//
//  Created by DHS on 2023/10/6.
//

#import "JLSendModel.h"

@implementation JLSendModel

- (instancetype)initBleKey:(BleKey)blekey sendData:(NSData *)data
{
    if (self = [super init]){
        _sendBleKey = blekey;
        _needWaitData = NO;
        _sendOffset = 0;
        _sendData = data;
    }
    
    return self;
}

- (instancetype)initBleKey:(BleKey)blekey wait:(BOOL)waitData sendData:(NSData *)data
{
    if (self = [super init]){
        _sendBleKey = blekey;
        _needWaitData = waitData;
        _sendOffset = 0;
        _sendData = data;
    }
    
    return self;
}

- (BOOL)sendFinished
{
    if (self.sendOffset >= self.sendData.length){
        return YES;
    }
    
    return NO;
}

- (NSData *)nextFrame
{
    NSData *willSendData = nil;
    if (self.sendData.length - self.sendOffset <= JLMTU){
        willSendData = [self.sendData subdataWithRange:NSMakeRange(self.sendOffset, self.sendData.length - self.sendOffset)];
        self.sendOffset = (int)self.sendData.length;
        return willSendData;
    }
    else{
        willSendData = [self.sendData subdataWithRange:NSMakeRange(self.sendOffset, JLMTU)];
        self.sendOffset += JLMTU;
        return willSendData;
    }
}

@end
