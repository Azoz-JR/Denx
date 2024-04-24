//
//  DHTool.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHTool.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation DHTool

+ (uint16_t)queryCrc16:(uint16_t)crc16 value:(uint8_t)value {
    int CRC_TABLE[256] = {
            0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
            0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
            0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
            0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
            0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
            0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
            0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
            0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
            0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
            0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
            0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
            0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
            0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
            0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
            0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
            0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
            0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
            0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
            0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
            0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
            0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
            0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
            0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
            0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
            0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
            0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
            0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
            0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
            0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
            0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
            0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
            0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
        };
    return (crc16 >> 8) ^ CRC_TABLE[(crc16 ^ value) & 0xffu];
}

+ (UInt16)calculateCrc16:(NSData *)data
{
    uint16_t crc16 = 0;
    NSInteger size = data.length;
    Byte *dataBytes = (Byte *)data.bytes;
    for (uint32_t index = 0; index < size; index++){
        //crc16 = queryCrc16(crc16, data[index]);
        crc16 = [self queryCrc16:crc16 value:dataBytes[index]];
    }
    return crc16;
}

+ (DHBleCommandType)typeOfCommand:(NSString *)command {
    unsigned long long decimal = 0;
    NSScanner *scanner = [NSScanner scannerWithString:command];
    [scanner scanHexLongLong:&decimal];
    return (NSInteger)decimal;
}

+ (NSData *)transformCommand:(NSString *)command
                      serial:(NSInteger)serial {
    if (!command) {
        return nil;
    }
    NSMutableData *mData = [NSMutableData data];
    
    NSData *identificationData = DHHexToBytes(DHCommandIdentification);
    NSData *protocolData = DHHexToBytes(DHCommandProtocolVersion);
    NSData *idData = DHHexToBytes(command);
    NSData *securityData = DHHexToBytes(@"00");
    NSData *lengthData = DHHexToBytes(@"00");
    NSString *serialString = [NSString stringWithFormat:@"%04lx",(long)serial];
    NSData *serialData = DHHexToBytes(serialString);
    NSData *verifyCodeData = DHHexToBytes(@"00");
    
    [mData appendData:identificationData];
    [mData appendData:protocolData];
    [mData appendData:idData];
    [mData appendData:securityData];
    [mData appendData:lengthData];
    [mData appendData:serialData];
    [mData appendData:verifyCodeData];
    
    return mData;
}

+ (NSData *)transformCommand:(NSString *)command
                     serial:(NSInteger)serial
                     payload:(NSString *)payload {
    if (!command || !payload) {
        return nil;
    }
    NSMutableData *mData = [NSMutableData data];
    
    NSData *contentData = DHHexToBytes(payload);
    NSData *identificationData = DHHexToBytes(DHCommandIdentification);
    NSData *protocolData = DHHexToBytes(DHCommandProtocolVersion);
    NSData *idData = DHHexToBytes(command);
    NSData *securityData = DHHexToBytes(@"00");
    
    NSString *lengthString = [NSString stringWithFormat:@"%02lx",(long)contentData.length];
    NSString *serialString = [NSString stringWithFormat:@"%04lx",(long)serial];
    NSString *verifyCodeString = [NSString stringWithFormat:@"%02lx",(long)[self verifyCode:contentData]];
    
    NSData *lengthData = DHHexToBytes(lengthString);
    NSData *serialData = DHHexToBytes(serialString);
    NSData *verifyCodeData = DHHexToBytes(verifyCodeString);
    
    [mData appendData:identificationData];
    [mData appendData:protocolData];
    [mData appendData:idData];
    [mData appendData:securityData];
    [mData appendData:lengthData];
    [mData appendData:serialData];
    [mData appendData:verifyCodeData];
    [mData appendData:contentData];
    
    return mData;
}

+ (NSData *)transformCommand:(NSString *)command
                     serial:(NSInteger)serial
                 contentData:(NSData *)contentData {
    if (!command || !contentData) {
        return nil;
    }
    NSMutableData *mData = [NSMutableData data];
    
    NSData *identificationData = DHHexToBytes(DHCommandIdentification);
    NSData *protocolData = DHHexToBytes(DHCommandProtocolVersion);
    NSData *idData = DHHexToBytes(command);
    NSData *securityData = DHHexToBytes(@"00");
    
    NSString *lengthString = [NSString stringWithFormat:@"%02lx",(long)contentData.length];
    NSString *serialString = [NSString stringWithFormat:@"%04lx",(long)serial];
    NSString *verifyCodeString = [NSString stringWithFormat:@"%02lx",(long)[self verifyCode:contentData]];
    
    NSData *lengthData = DHHexToBytes(lengthString);
    NSData *serialData = DHHexToBytes(serialString);
    NSData *verifyCodeData = DHHexToBytes(verifyCodeString);
    
    [mData appendData:identificationData];
    [mData appendData:protocolData];
    [mData appendData:idData];
    [mData appendData:securityData];
    [mData appendData:lengthData];
    [mData appendData:serialData];
    [mData appendData:verifyCodeData];
    [mData appendData:contentData];
    
    return mData;
}

+ (NSData *)transformCommand:(NSString *)command
                     serial:(NSInteger)serial
                       index:(NSInteger)index
                       count:(NSInteger)count
                 contentData:(NSData *)contentData {
    if (!command || !contentData) {
        return nil;
    }
    NSMutableData *mData = [NSMutableData data];
    
    NSData *identificationData = DHHexToBytes(DHCommandIdentification);
    NSData *protocolData = DHHexToBytes(DHCommandProtocolVersion);
    NSData *idData = DHHexToBytes(command);
    NSData *securityData = DHHexToBytes(@"08");

    NSString *lengthString = [NSString stringWithFormat:@"%02lx",(long)contentData.length];
    NSString *serialString = [NSString stringWithFormat:@"%04lx",(long)serial];
    NSString *verifyCodeString = [NSString stringWithFormat:@"%02lx",(long)[self verifyCode:contentData]];
    NSString *countString = [NSString stringWithFormat:@"%04lx",(long)count];
    NSString *indexString = [NSString stringWithFormat:@"%04lx",(long)index];

    NSData *lengthData = DHHexToBytes(lengthString);
    NSData *serialData = DHHexToBytes(serialString);
    NSData *verifyCodeData = DHHexToBytes(verifyCodeString);
    NSData *countData = DHHexToBytes(countString);
    NSData *indexData = DHHexToBytes(indexString);
    
    [mData appendData:identificationData];
    [mData appendData:protocolData];
    [mData appendData:idData];
    [mData appendData:securityData];
    [mData appendData:lengthData];
    [mData appendData:serialData];
    [mData appendData:verifyCodeData];
    
    [mData appendData:countData];
    [mData appendData:indexData];
    [mData appendData:contentData];
    
    return mData;
}

+ (NSInteger)verifyCode:(NSData *)payload {
    Byte *bytes = (Byte *)[payload bytes];
    NSInteger checksum = 0;
    for(int i=0; i<[payload length]; i++) {
        checksum ^= bytes[i];
    }
    return checksum;
}

+ (NSData *)hexToBytes:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (int)hexDecimalValue:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
    {
        return 0;
    }
    
    NSUInteger          dataLength  = [data length];
    NSUInteger result = 0;
    for (int i = 0; i < dataLength; ++i)
    {
        unsigned int v = (unsigned int)dataBuffer[i];
        result = (result << 8) | v;
    }
    return  (int)result;
}

+ (NSString *)hexadecimalString:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer)
    {
        return [NSString string];
    }
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}

+ (NSString *)hexadecimalStringLog:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer)
    {
        return [NSString string];
    }
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x ", (unsigned int)dataBuffer[i]];
    }
    return [NSString stringWithString:[hexString uppercaseString]];
}

+ (NSInteger)transformRepeats:(NSArray *)array {
    if (!array || array.count != 7) {
        array = @[@(0),@(0),@(0),@(0),@(0),@(0),@(0)];
    }
    int repeatNumber = 0;
    for (int i = 0; i < array.count; i++) {
        NSInteger number = [array[i] integerValue];
        if (number == 1) {
            repeatNumber += 0b1<<i;
        }
    }
    return repeatNumber;
}

+ (NSArray *)transformRepeatNumber:(NSInteger)repeatNumber {
    NSMutableArray * repeatArray = [NSMutableArray array];
    for (int i = 0; i < 7; ++i) {
        int check = (0b1 << i);
        BOOL res = (check & repeatNumber);
        NSNumber *resultNumber = res ? @(1) : @(0);
        [repeatArray addObject:resultNumber];
    }
    return repeatArray;
}

+ (NSString *)transformAncs:(DHAncsSetModel *)model {

    int numberA = 0;
    int numberB = 0;
    int numberC = 0;
    int numberD = 0;
    
    if (model.isCall) {
        numberA += 0b1<<0;
    }
    if (model.isSMS) {
        numberA += 0b1<<1;
    }
    if (model.isQQ) {
        numberA += 0b1<<2;
    }
    if (model.isWechat) {
        numberA += 0b1<<3;
    }
    if (model.isWhatsapp) {
        numberA += 0b1<<4;
    }
    if (model.isMessenger) {
        numberA += 0b1<<5;
    }
    if (model.isTwitter) {
        numberA += 0b1<<6;
    }
    if (model.isLinkedin) {
        numberA += 0b1<<7;
    }
    
    if (model.isInstagram) {
        numberB += 0b1<<0;
    }
    if (model.isFacebook) {
        numberB += 0b1<<1;
    }
    if (model.isLine) {
        numberB += 0b1<<2;
    }
    if (model.isWechatWork) {
        numberB += 0b1<<3;
    }
    if (model.isDingding) {
        numberB += 0b1<<4;
    }
    if (model.isEmail) {
        numberB += 0b1<<5;
    }
    if (model.isCalendar) {
        numberB += 0b1<<6;
    }
    if (model.isViber) {
        numberB += 0b1<<7;
    }
    
    if (model.isSkype) {
        numberC += 0b1<<0;
    }
    if (model.isKakaotalk) {
        numberC += 0b1<<1;
    }
    if (model.isTumblr) {
        numberC += 0b1<<2;
    }
    if (model.isSnapchat) {
        numberC += 0b1<<3;
    }
    if (model.isYoutube) {
        numberC += 0b1<<4;
    }
    if (model.isPinterset) {
        numberC += 0b1<<5;
    }
    if (model.isTiktok) {
        numberC += 0b1<<6;
    }
    if (model.isGmail) {
        numberC += 0b1<<7;
    }
    
    if (model.isOther) {
        numberD += 0b1<<7;
    }
    
    NSString * hexStr = [NSString stringWithFormat:@"%02x%02x%02x%02x",numberA,numberB,numberC,numberD];
    return hexStr;

}

+ (id)modelForPayload:(NSData *)payload
          commandType:(DHBleCommandType)commandType {
    id result;
    switch (commandType) {
#pragma mark - 获取类、广播类
        case DHBleCommandTypeFirmwareVersionGet:
        {
            if (payload.length >= 1) {
                DHFirmwareVersionModel *model = [[DHFirmwareVersionModel alloc] init];
                
                NSInteger modelLength = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                if (modelLength > 0 && payload.length >= modelLength+1) {
                    model.deviceModel = [[NSString alloc] initWithData:[payload subdataWithRange:NSMakeRange(1, modelLength)] encoding:NSUTF8StringEncoding];
                    if (payload.length > modelLength+1) {
                        NSInteger firmwareLength = DHDecimalValue([payload subdataWithRange:NSMakeRange(modelLength+1, 1)]);
                        if (firmwareLength > 0 && payload.length >= modelLength+1+firmwareLength+1) {
                            model.firmwareVersion = [[NSString alloc] initWithData:[payload subdataWithRange:NSMakeRange(modelLength+1+1, firmwareLength)] encoding:NSUTF8StringEncoding];
                        }
                    }
                }
                result = model;
            }
        }
            break;
        case DHBleCommandTypeBatteryGet: case DHBleCommandTypeBatteryNotification:
        {
            if (payload.length >= 3) {
                DHBatteryInfoModel *model = [[DHBatteryInfoModel alloc] init];
                model.isLower = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.status = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                model.battery = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
                result = model;
            }
        }
            break;
        case DHBleCommandTypeBindInfoGet:
        {
            if (payload.length >= 2) {
                DHBindSetModel *model = [[DHBindSetModel alloc] init];
                model.isBind = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.bindOS = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                if (payload.length > 2) {
                    model.userId = [[NSString alloc] initWithData:[payload subdataWithRange:NSMakeRange(2, payload.length-2)] encoding:NSUTF16LittleEndianStringEncoding];
                }
                result = model;
            }
        }
            break;
        case DHBleCommandTypeFunctionGet:
        {
            if (payload.length >= 4) {
                DHFunctionInfoModel *model = [[DHFunctionInfoModel alloc] init];
                NSInteger resultNumberA = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                NSInteger resultNumberB = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                NSInteger resultNumberC = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
                NSInteger resultNumberD = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 1)]);

                model.isStep = resultNumberA >> 0 & 0x01;
                model.isSleep = resultNumberA >> 1 & 0x01;
                model.isHeartRate = resultNumberA >> 2 & 0x01;
                model.isBp = resultNumberA >> 3 & 0x01;
                model.isBo = resultNumberA >> 4 & 0x01;
                model.isTemp = resultNumberA >> 5 & 0x01;
                model.isEcg = resultNumberA >> 6 & 0x01;
                model.isBreath = resultNumberA >> 7 & 0x01;
                model.isPressure = NO;
                
                model.isDial = resultNumberB >> 0 & 0x01;
                model.isWallpaper = resultNumberB >> 1 & 0x01;
                model.isAncs = resultNumberB >> 2 & 0x01;
                model.isSedentary = resultNumberB >> 3 & 0x01;
                model.isDrinking = resultNumberB >> 4 & 0x01;
                model.isReminderMode = resultNumberB >> 5 & 0x01;
                model.isAlarm = resultNumberB >> 6 & 0x01;
                model.isGesture = resultNumberB >> 7 & 0x01;
                
                model.isBrightTime = resultNumberC >> 0 & 0x01;
                model.isHeartRateMode = resultNumberC >> 1 & 0x01;
                model.isDisturbMode = resultNumberC >> 2 & 0x01;
                model.isWeather = resultNumberC >> 3 & 0x01;
                model.isContact = resultNumberC >> 4 & 0x01;
                model.isRestore = resultNumberC >> 5 & 0x01;
                model.isOTA = resultNumberC >> 6 & 0x01;
                model.isNFC = resultNumberC >> 7 & 0x01;
                
                model.isQRCode = resultNumberD >> 0 & 0x01;
                model.isRestart = resultNumberD >> 1 & 0x01;
                model.isShutdown = resultNumberD >> 2 & 0x01;
                model.isBle3 = resultNumberD >> 3 & 0x01;
                model.isMenstrualCycle = resultNumberD >> 4 & 0x01;
                model.isLocation = resultNumberD >> 5 & 0x01;
                
                result = model;
            }
        }
            break;
        case DHBleCommandTypeDialInfoGet:
        {
            if (payload.length >= 5) {
                DHDialInfoModel *model = [[DHDialInfoModel alloc] init];
                model.screenType = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.screenWidth = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 2)]);
                model.screenHeight = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 2)]);
                result = model;
            }
        }
            break;
            
        case DHBleCommandTypeAncsGet:
        {
            if (payload.length >= 4) {
                DHAncsSetModel *model = [[DHAncsSetModel alloc] init];
                
                NSInteger resultNumberA = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                NSInteger resultNumberB = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                NSInteger resultNumberC = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
                NSInteger resultNumberD = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 1)]);

                model.isCall = resultNumberA >> 0 & 0x01;
                model.isSMS = resultNumberA >> 1 & 0x01;
                model.isQQ = resultNumberA >> 2 & 0x01;
                model.isWechat = resultNumberA >> 3 & 0x01;
                model.isWhatsapp = resultNumberA >> 4 & 0x01;
                model.isMessenger = resultNumberA >> 5 & 0x01;
                model.isTwitter = resultNumberA >> 6 & 0x01;
                model.isLinkedin = resultNumberA >> 7 & 0x01;
                
                model.isInstagram = resultNumberB >> 0 & 0x01;
                model.isFacebook = resultNumberB >> 1 & 0x01;
                model.isLine = resultNumberB >> 2 & 0x01;
                model.isWechatWork = resultNumberB >> 3 & 0x01;
                model.isDingding = resultNumberB >> 4 & 0x01;
                model.isEmail = resultNumberB >> 5 & 0x01;
                model.isCalendar = resultNumberB >> 6 & 0x01;
                model.isViber = resultNumberB >> 7 & 0x01;
                
                model.isSkype = resultNumberC >> 0 & 0x01;
                model.isKakaotalk = resultNumberC >> 1 & 0x01;
                model.isTumblr = resultNumberC >> 2 & 0x01;
                model.isSnapchat = resultNumberC >> 3 & 0x01;
                model.isYoutube = resultNumberC >> 4 & 0x01;
                model.isPinterset = resultNumberC >> 5 & 0x01;
                model.isTiktok = resultNumberC >> 6 & 0x01;
                model.isGmail = resultNumberC >> 7 & 0x01;
                
                model.isOther = resultNumberD >> 7 & 0x01;
                
                result = model;
            }
        }
            break;
        case DHBleCommandTypeSedentaryGet: case DHBleCommandTypeSedentaryNotification:
        {
            if (payload.length >= 8) {
                DHSedentarySetModel *model = [[DHSedentarySetModel alloc] init];
                model.isOpen = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.interval = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 2)]);
                NSInteger repeatsNumber = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 1)]);
                model.repeats = [self transformRepeatNumber:repeatsNumber];
                model.startHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(4, 1)]);
                model.startMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)]);
                model.endHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(6, 1)]);
                model.endMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(7, 1)]);
                result = model;
            }
        }
            break;
        case DHBleCommandTypeDrinkingGet: case DHBleCommandTypeDrinkingNotification:
        {
            if (payload.length >= 7) {
                DHDrinkingSetModel *model = [[DHDrinkingSetModel alloc] init];
                model.isOpen = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.interval = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 2)]);
                model.startHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 1)]);
                model.startMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(4, 1)]);
                model.endHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)]);
                model.endMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(6, 1)]);
                result = model;
            }
        }
            break;
        case DHBleCommandTypeReminderModeGet: case DHBleCommandTypeReminderModeNotification:
        {
            if (payload.length >= 1) {
                DHReminderModeSetModel *model = [[DHReminderModeSetModel alloc] init];
                model.reminderMode = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                result = model;
            }
        }
            break;
        case DHBleCommandTypeAlarmGet: case DHBleCommandTypeAlarmNotification:
        {
            NSMutableArray *alarms = [NSMutableArray array];
            if (payload.length >= 1) {
                NSInteger alarmCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                if (alarmCount > 0) {
                    NSInteger currentIndex = 1;
                    for (int i = 0; i < alarmCount; i++) {
                        DHAlarmSetModel *model = [[DHAlarmSetModel alloc] init];
                        model.isOpen = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex, 1)]);
                        model.hour = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+1, 1)]);
                        model.minute = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+2, 1)]);
                        NSInteger repeatsNumber = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+3, 1)]);
                        model.repeats = [self transformRepeatNumber:repeatsNumber];
                        model.isRemindLater = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 1)]);
                        NSInteger alarmTypeLength = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+5, 1)]);
                        if (alarmTypeLength > 0) {
                            model.alarmType = [[NSString alloc] initWithData:[payload subdataWithRange:NSMakeRange(currentIndex+6, alarmTypeLength)] encoding:NSUTF8StringEncoding];
                        }
                        [alarms addObject:model];
                        currentIndex = currentIndex+alarmTypeLength+6;
                    }
                }
            }
            result = alarms;
        }
            break;
        case DHBleCommandTypePrayAlarmGet:
        case DHBleCommandTypePrayAlarmNotification:{
            NSMutableArray *prayAlarms = [NSMutableArray array];
            if (payload.length >= 1) {
                NSInteger alarmCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                if (alarmCount > 0) {
                    NSInteger currentIndex = 1;
                    for (int i = 0; i < alarmCount; i++) {
                        DHPrayAlarmSetModel *model = [[DHPrayAlarmSetModel alloc] init];
                        model.alarmType = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex, 1)]);
                        model.isOpen = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex + 1, 1)]);
                        model.hour = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex + 2, 1)]);
                        model.minute = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex + 3, 1)]);
                        
                        [prayAlarms addObject:model];
                        currentIndex = currentIndex + 4;
                    }
                }
            }
            result = prayAlarms;
            break;
        }
        case DHBleCommandTypeGestureGet: case DHBleCommandTypeGestureNotification:
        {
            if (payload.length >= 5) {
                DHGestureSetModel *model = [[DHGestureSetModel alloc] init];
                model.isOpen = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.startHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                model.startMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
                model.endHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 1)]);
                model.endMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(4, 1)]);
                result = model;
            }
        }
            break;
            
        case DHBleCommandTypeBrightTimeGet: case DHBleCommandTypeBrightTimeNotification:
        {
            if (payload.length >= 1) {
                DHBrightTimeSetModel *model = [[DHBrightTimeSetModel alloc] init];
                model.duration = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                result = model;
            }
        }
            break;
        case DHBleCommandTypeHeartRateModeGet: case DHBleCommandTypeHeartRateModeNotification:
        {
            if (payload.length >= 7) {
                DHHeartRateModeSetModel *model = [[DHHeartRateModeSetModel alloc] init];
                model.isOpen = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.interval = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 2)]);
                model.startHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 1)]);
                model.startMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(4, 1)]);
                model.endHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)]);
                model.endMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(6, 1)]);
                result = model;
            }
        }
            break;
        case DHBleCommandTypeDisturbModeGet: case DHBleCommandTypeDisturbModeNotification:
        {
            if (payload.length >= 6) {
                DHDisturbModeSetModel *model = [[DHDisturbModeSetModel alloc] init];
                model.isOpen = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.isAllday = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                model.startHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
                model.startMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 1)]);
                model.endHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(4, 1)]);
                model.endMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)]);
                result = model;
            }
        }
            break;
        case DHBleCommandTypeMacAddressGet:
        {
            if (payload.length >= 7) {
                DHDeviceInfoModel *model = [[DHDeviceInfoModel alloc] init];
                model.macAddr = [self hexRepresentationWithSymbol:@":" data:[payload subdataWithRange:NSMakeRange(0, 6)]];
                NSLog(@"model.macAddr %@", model.macAddr);
                NSInteger length = DHDecimalValue([payload subdataWithRange:NSMakeRange(6, 1)]);
                if (length > 0 && payload.length >= length+7) {
                    model.name = [[NSString alloc] initWithData:[payload subdataWithRange:NSMakeRange(7, length)] encoding:NSUTF16LittleEndianStringEncoding];
                }
                
                result = model;
            }
        }
            break;
        case DHBleCommandTypeClassicBleGet:
        {
            if (payload.length >= 8) {
                DHDeviceInfoModel *model = [[DHDeviceInfoModel alloc] init];
                model.isNeedConnect = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.macAddr = [self hexRepresentationWithSymbol:@":" data:[payload subdataWithRange:NSMakeRange(1, 6)]];
                NSInteger length = DHDecimalValue([payload subdataWithRange:NSMakeRange(7, 1)]);
                if (length > 0 && payload.length >= length+8) {
                    model.name = [[NSString alloc] initWithData:[payload subdataWithRange:NSMakeRange(8, length)] encoding:NSUTF16LittleEndianStringEncoding];
                }
                result = model;
            }
        }
            break;
        case DHBleCommandTypeLocalDialGet:
        {
            if (payload.length >= 3 && payload.length%3 == 0) {
                NSMutableArray *models = [NSMutableArray array];
                for (int i = 0; i < payload.length/3; i+=3) {
                    NSData *item = [payload subdataWithRange:NSMakeRange(i, 3)];
                    DHLocalDialModel *model = [[DHLocalDialModel alloc] init];
                    model.dialType = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 1)]);
                    model.dialId = DHDecimalValue([item subdataWithRange:NSMakeRange(1, 2)]);
                    [models addObject:model];
                }
                result = models;
            }
        }
            break;
        case DHBleCommandTypeOtaInfoGet:
        {
            if (payload.length >= 2) {
                DHOtaInfoModel *model = [[DHOtaInfoModel alloc] init];
                model.isOta = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.isComplete = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                result = model;
            }
        }
            break;
        case DHBleCommandTypeBreathGet:
        {
            if (payload.length >= 2) {
                DHBreathSetModel *model = [[DHBreathSetModel alloc] init];
                model.isOpen = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.times = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                NSMutableArray *hourArray = [NSMutableArray array];
                NSMutableArray *minuteArray = [NSMutableArray array];
                if (model.times > 0 && payload.length >= 2*(model.times+1)) {
                    for (int i = 1; i <= model.times; i++) {
                        NSData *item = [payload subdataWithRange:NSMakeRange(i*2, 2)];
                        NSInteger hour = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 1)]);
                        NSInteger minute = DHDecimalValue([item subdataWithRange:NSMakeRange(1, 1)]);
                        [hourArray addObject:@(hour)];
                        [minuteArray addObject:@(minute)];
                    }
                }
                model.hourArray = hourArray;
                model.minuteArray = minuteArray;
                result = model;
            }
        }
            break;
        case DHBleCommandTypeCustomDialGet:
        {
            if (payload.length >= 7) {
                
                DHCustomDialSyncingModel *model = [[DHCustomDialSyncingModel alloc] init];
                model.timePos = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                
                NSInteger timeUp = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                NSInteger timeDown = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
                
                model.timeUp = [self deviceElementToApp:timeUp];
                model.timeDown = [self deviceElementToApp:timeDown];
                
                NSString *redHex = DHDecimalString([payload subdataWithRange:NSMakeRange(5, 1)]);
                NSString *greenHex = DHDecimalString([payload subdataWithRange:NSMakeRange(4, 1)]);
                NSString *blueHex = DHDecimalString([payload subdataWithRange:NSMakeRange(3, 1)]);
                
                NSString *colorString = [NSString stringWithFormat:@"%@%@%@",redHex,greenHex,blueHex];
                NSData *colorData = DHHexToBytes(colorString);
                
                model.textColor = DHDecimalValue(colorData);
                model.fileData = nil;
                
                result = model;
            }
        }
            break;
        case DHBleCommandTypeMenstrualCycleGet:
        {
            if (payload.length >= 14) {
                DHMenstrualCycleSetModel *model = [[DHMenstrualCycleSetModel alloc] init];
                model.type = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                model.isOpen = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                model.isRemindMenstrualPeriod = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
                model.isRemindOvulationPeriod = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 1)]);
                model.isRemindOvulationPeak = DHDecimalValue([payload subdataWithRange:NSMakeRange(4, 1)]);
                model.isRemindOvulationEnd = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)]);
                
                model.cycleDays = DHDecimalValue([payload subdataWithRange:NSMakeRange(6, 1)]);
                model.menstrualDays = DHDecimalValue([payload subdataWithRange:NSMakeRange(7, 1)]);
                
                model.timestamp = DHDecimalValue([payload subdataWithRange:NSMakeRange(8, 4)])-DHTimeInterval;
                model.remindHour = DHDecimalValue([payload subdataWithRange:NSMakeRange(12, 1)]);
                model.remindMinute = DHDecimalValue([payload subdataWithRange:NSMakeRange(13, 1)]);
                
                result = model;
            }
        }
            break;
            
        case DHBleCommandTypeHealthDataNotification:
        {
            if (payload.length >= 1) {
                NSInteger type = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                DHHealthDataModel *model = [[DHHealthDataModel alloc] init];
                model.type = type;
                if (type == 0 && payload.length >= 9) {
                    model.index = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                    model.step = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 2)]);
                    model.calorie = DHDecimalValue([payload subdataWithRange:NSMakeRange(4, 3)]);
                    model.distance = DHDecimalValue([payload subdataWithRange:NSMakeRange(7, 2)]);
                    result = model;
                    
                    NSLog(@"index %d step %d calorie %d", model.index, model.step, model.calorie);
                } else if (type == 1 && payload.length >= 6) {
                    model.timestamp = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 4)])-DHTimeInterval;
                    model.heartRate = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)]);
                    result = model;
                } else if (type == 2 && payload.length >= 7) {
                    model.timestamp = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 4)])-DHTimeInterval;
                    model.systolic = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)]);
                    model.diastolic = DHDecimalValue([payload subdataWithRange:NSMakeRange(6, 1)]);
                    result = model;
                } else if (type == 3 && payload.length >= 6) {
                    model.timestamp = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 4)])-DHTimeInterval;
                    model.bo = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)]);
                    result = model;
                } else if (type == 4 && payload.length >= 6) {
                    model.timestamp = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 4)])-DHTimeInterval;
                    model.temp = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)])+200;
                    result = model;
                } else if (type == 5 && payload.length >= 6) {
                    model.timestamp = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 4)])-DHTimeInterval;
                    model.breath = DHDecimalValue([payload subdataWithRange:NSMakeRange(5, 1)]);
                    result = model;
                } else if (type == 6 || type == 7) {
                    result = model;
                }
            }
        }
            break;
        case DHBleCommandTypeCameraNotification:
        {
            if (payload.length >= 1) {
                NSString *type = DHDecimalString([payload subdataWithRange:NSMakeRange(0, 1)]);
                result = type;
            }
        }
            break;
        case DHBleCommandTypeFindPhoneNotification:
        {
            if (payload.length >= 1) {
                NSString *type = DHDecimalString([payload subdataWithRange:NSMakeRange(0, 1)]);
                result = type;
            }
        }
            break;
        case DHBleCommandTypeMtuNotification:
        {
            if (payload.length >= 2) {
                NSInteger mtu = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 2)]);
                result = [NSString stringWithFormat:@"%ld",(long)mtu];
            }
        }
            break;
        case DHBleCommandTypeTimeSyncNotification:
        {
            result = @"00";
        }
            break;
        case DHBleCommandTypeLocationNotification:
        {
            result = @"00";
        }
            break;
        case DHBleCommandTypeConnectIntervalNotification:
        {
            if (payload.length >= 2) {
                NSInteger status = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 2)]);
                result = [NSString stringWithFormat:@"%ld",(long)status];
            }
        }
            break;
        case DHBleCommandTypeFileStatusNotification:
        {
            if (payload.length >= 2) {
                NSInteger status = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                NSInteger type = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]); //升级类型: 0:开始，1: 单包,2:全部
//                if (type != 0) {
                    result = [NSString stringWithFormat:@"%ld_%ld",(long)status, type];
//                }
            }
        }
            break;
        case DHBleCommandTypeDialStatusNotification:
        {
            if (payload.length >= 2) {
                NSInteger status = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                NSInteger type = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
//                if (type != 0) {
                    result = [NSString stringWithFormat:@"%ld_%ld",(long)status, type];
//                }
            }
        }
            break;
        case DHBleCommandTypeMapStatusNotification:
        {
            if (payload.length >= 2) {
                NSInteger status = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                NSInteger type = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
                result = [NSString stringWithFormat:@"%ld_%ld",(long)status, type];
            }
        }
            break;
        case DHBleCommandTypeThumbnailStatusNotification:
        {
            if (payload.length >= 2) {
                NSInteger status = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 1)]);
                NSInteger type = DHDecimalValue([payload subdataWithRange:NSMakeRange(1, 1)]);
//                if (type != 0) {
                    result = [NSString stringWithFormat:@"%ld_%ld",(long)status, type];
//                }
            }
        }
            break;
            
            
  
#pragma mark - 同步数据类
        case DHBleCommandTypeDataSyncing:
        {
            if (payload.length >= 4) {
                NSInteger count = 0;
                NSInteger resultNumberA = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
                NSInteger resultNumberB = DHDecimalValue([payload subdataWithRange:NSMakeRange(3, 1)]);
                
                DHDataSyncingModel *model = [[DHDataSyncingModel alloc] init];
                model.isStep = resultNumberA >> 0 & 0x01;
                model.isSleep = resultNumberA >> 1 & 0x01;
                model.isHeartRate = resultNumberA >> 2 & 0x01;
                model.isBp = resultNumberA >> 3 & 0x01;
                model.isBo = resultNumberA >> 4 & 0x01;
                model.isTemp = resultNumberA >> 5 & 0x01;
                model.isBreath = resultNumberA >> 6 & 0x01;
                model.isEcg = resultNumberA >> 7 & 0x01;
                
                model.isSport = resultNumberB >> 0 & 0x01;
                
                if (model.isStep) {
                    count++;
                }
                if (model.isSleep) {
                    count++;
                }
                if (model.isHeartRate) {
                    count++;
                }
                if (model.isBp) {
                    count++;
                }
                if (model.isBo) {
                    count++;
                }
                if (model.isTemp) {
                    count++;
                }
                if (model.isEcg) {
                    count++;
                }
                if (model.isBreath) {
                    count++;
                }
                if (model.isSport) {
                    count++;
                }
                model.count = count;
                result = model;
            }
            
        }
            break;
            
        case DHBleCommandTypeStepSyncing:
        {
            if (payload.length >= 15) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSInteger currentIndex = 0;
                NSInteger itemLength = 8;
                NSInteger itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+13, 2)]);
                NSInteger dayLength = itemCount*itemLength+15;
                while (payload.length >= currentIndex+dayLength) {
                    NSData *dayData = [payload subdataWithRange:NSMakeRange(currentIndex, dayLength)];
                    NSData *itemsData = itemCount > 0 ? [dayData subdataWithRange:NSMakeRange(15, itemCount*itemLength)] : [NSData data];
                    
                    NSMutableArray *items = [NSMutableArray array];
                    for (int i = 0; i < 24; i++) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(i) forKey:@"index"];
                        [dict setObject:@(0) forKey:@"step"];
                        [dict setObject:@(0) forKey:@"calorie"];
                        [dict setObject:@(0) forKey:@"distance"];
                        [items addObject:dict];
                    }
                    
                    for (int j = 0; j < itemCount ; j++) {
                        NSData *item = [itemsData subdataWithRange:NSMakeRange(j*itemLength, itemLength)];
                        NSInteger index = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 1)]);
                        NSInteger step = DHDecimalValue([item subdataWithRange:NSMakeRange(1, 2)]);
                        NSInteger calorie = DHDecimalValue([item subdataWithRange:NSMakeRange(3, 3)]);
                        NSInteger distance = DHDecimalValue([item subdataWithRange:NSMakeRange(6, 2)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(index) forKey:@"index"];
                        [dict setObject:@(step) forKey:@"step"];
                        [dict setObject:@(calorie) forKey:@"calorie"];
                        [dict setObject:@(distance) forKey:@"distance"];
                        
                        [items replaceObjectAtIndex:index withObject:dict];
                    }
                    
                    NSLog(@"DHBleCommandTypeStepSyncing %@", items);
                   
                    DHDailyStepModel *model = [[DHDailyStepModel alloc] init];
                    NSInteger timestamp = DHDecimalValue([dayData subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                    model.date = [self dateToStringFormat:@"yyyyMMdd" date:date];
                    model.step = DHDecimalValue([dayData subdataWithRange:NSMakeRange(4, 3)]);
                    model.calorie = DHDecimalValue([dayData subdataWithRange:NSMakeRange(7, 3)]);
                    model.distance = DHDecimalValue([dayData subdataWithRange:NSMakeRange(10, 3)]);
                    model.items = items;
                    [resultArray addObject:model];
                    
                    currentIndex += dayLength;
                    if (payload.length >= currentIndex+15) {
                        itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+13, 2)]);
                        dayLength = itemCount*itemLength+15;
                    }
                    
                }
                result = resultArray;
            }
        }
            break;
        case DHBleCommandTypeSleepSyncing:
        {
            
            if (payload.length >= 16) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSInteger currentIndex = 0;
                NSInteger itemLength = 2;
                NSInteger itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+14, 2)]);
                NSInteger dayLength = itemCount*itemLength+16;
                while (payload.length >= currentIndex+dayLength) {
                    NSData *dayData = [payload subdataWithRange:NSMakeRange(currentIndex, dayLength)];
                    NSData *itemsData = itemCount > 0 ? [dayData subdataWithRange:NSMakeRange(16, itemCount*itemLength)] : [NSData data];
                    NSMutableArray *items = [NSMutableArray array];
                    for (int j = 0; j < itemCount ; j++) {
                        NSData *item = [itemsData subdataWithRange:NSMakeRange(j*itemLength, itemLength)];
                        NSInteger duration = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 1)]);
                        NSInteger status = DHDecimalValue([item subdataWithRange:NSMakeRange(1, 1)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(status) forKey:@"status"];
                        [dict setObject:@(duration) forKey:@"value"];
                        
                        [items addObject:dict];
                    }
                    
                    DHDailySleepModel *model = [[DHDailySleepModel alloc] init];
                    NSInteger timestamp = DHDecimalValue([dayData subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                    model.date = [self dateToStringFormat:@"yyyyMMdd" date:date];
                    model.duration = DHDecimalValue([dayData subdataWithRange:NSMakeRange(4, 2)]);
                    NSInteger beginTime = itemCount > 0 ? DHDecimalValue([dayData subdataWithRange:NSMakeRange(6, 4)])-DHTimeInterval : 0;
                    model.beginTime = [NSString stringWithFormat:@"%ld",(long)beginTime];
                    NSInteger endTime = itemCount > 0 ? DHDecimalValue([dayData subdataWithRange:NSMakeRange(10, 4)])-DHTimeInterval : 0;
                    model.endTime = [NSString stringWithFormat:@"%ld",(long)endTime];
                    model.items = items;
                    [resultArray addObject:model];
                    
                    currentIndex += dayLength;
                    if (payload.length >= currentIndex+16) {
                        itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+14, 2)]);
                        dayLength = itemCount*itemLength+16;
                    }
                }
                result = resultArray;
            }
        }
            break;
        case DHBleCommandTypeHeartRateSyncing:
        {
            if (payload.length >= 6) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSInteger currentIndex = 0;
                NSInteger itemLength = 5;
                NSInteger itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                NSInteger dayLength = itemCount*itemLength+6;
                while (payload.length >= currentIndex+dayLength) {
                    NSData *dayData = [payload subdataWithRange:NSMakeRange(currentIndex, dayLength)];
                    NSData *itemsData = itemCount > 0 ? [dayData subdataWithRange:NSMakeRange(6, itemCount*itemLength)] : [NSData data];
                    NSMutableArray *items = [NSMutableArray array];
                    for (int j = 0; j < itemCount ; j++) {
                        NSData *item = [itemsData subdataWithRange:NSMakeRange(j*itemLength, itemLength)];
                        NSInteger timestamp = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                        NSInteger value = DHDecimalValue([item subdataWithRange:NSMakeRange(4, 1)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(timestamp) forKey:@"timestamp"];
                        [dict setObject:@(value) forKey:@"value"];
                        
                        [items addObject:dict];
                    }
                    
                    DHDailyHrModel *model = [[DHDailyHrModel alloc] init];
                    NSInteger timestamp = DHDecimalValue([dayData subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                    model.date = [self dateToStringFormat:@"yyyyMMdd" date:date];
                    model.items = items;
                    [resultArray addObject:model];
                    
                    currentIndex += dayLength;
                    if (payload.length >= currentIndex+6) {
                        itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                        dayLength = itemCount*itemLength+6;
                    }
                }
                result = resultArray;
            }
        }
            break;
        case DHBleCommandTypeBloodPressureSyncing:
        {
            
            if (payload.length >= 6) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSInteger currentIndex = 0;
                NSInteger itemLength = 6;
                NSInteger itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                NSInteger dayLength = itemCount*itemLength+6;
                while (payload.length >= currentIndex+dayLength) {
                    NSData *dayData = [payload subdataWithRange:NSMakeRange(currentIndex, dayLength)];
                    NSData *itemsData = itemCount > 0 ? [dayData subdataWithRange:NSMakeRange(6, itemCount*itemLength)] : [NSData data];
                    NSMutableArray *items = [NSMutableArray array];
                    for (int j = 0; j < itemCount ; j++) {
                        NSData *item = [itemsData subdataWithRange:NSMakeRange(j*itemLength, itemLength)];
                        NSInteger timestamp = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                        NSInteger systolic = DHDecimalValue([item subdataWithRange:NSMakeRange(4, 1)]);
                        NSInteger diastolic = DHDecimalValue([item subdataWithRange:NSMakeRange(5, 1)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(timestamp) forKey:@"timestamp"];
                        [dict setObject:@(systolic) forKey:@"systolic"];
                        [dict setObject:@(diastolic) forKey:@"diastolic"];
                        
                        [items addObject:dict];
                    }
                    
                    DHDailyBpModel *model = [[DHDailyBpModel alloc] init];
                    NSInteger timestamp = DHDecimalValue([dayData subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                    model.date = [self dateToStringFormat:@"yyyyMMdd" date:date];
                    model.items = items;
                    [resultArray addObject:model];
                    
                    currentIndex += dayLength;
                    if (payload.length >= currentIndex+6) {
                        itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                        dayLength = itemCount*itemLength+6;
                    }
                }
                result = resultArray;
            }
        }
            break;
        case DHBleCommandTypeBloodOxygenSyncing:
        {
            
            if (payload.length >= 6) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSInteger currentIndex = 0;
                NSInteger itemLength = 5;
                NSInteger itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                NSInteger dayLength = itemCount*itemLength+6;
                while (payload.length >= currentIndex+dayLength) {
                    NSData *dayData = [payload subdataWithRange:NSMakeRange(currentIndex, dayLength)];
                    NSData *itemsData = itemCount > 0 ? [dayData subdataWithRange:NSMakeRange(6, itemCount*itemLength)] : [NSData data];
                    NSMutableArray *items = [NSMutableArray array];
                    for (int j = 0; j < itemCount ; j++) {
                        NSData *item = [itemsData subdataWithRange:NSMakeRange(j*itemLength, itemLength)];
                        NSInteger timestamp = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                        NSInteger value = DHDecimalValue([item subdataWithRange:NSMakeRange(4, 1)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(timestamp) forKey:@"timestamp"];
                        [dict setObject:@(value) forKey:@"value"];
                        
                        [items addObject:dict];
                    }
                    
                    DHDailyBoModel *model = [[DHDailyBoModel alloc] init];
                    NSInteger timestamp = DHDecimalValue([dayData subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                    model.date = [self dateToStringFormat:@"yyyyMMdd" date:date];
                    model.items = items;
                    [resultArray addObject:model];
                    
                    currentIndex += dayLength;
                    if (payload.length >= currentIndex+6) {
                        itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                        dayLength = itemCount*itemLength+6;
                    }
                }
                result = resultArray;
            }
        }
            break;
        case DHBleCommandTypeTempSyncing:
        {
            
            if (payload.length >= 6) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSInteger currentIndex = 0;
                NSInteger itemLength = 5;
                NSInteger itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                NSInteger dayLength = itemCount*itemLength+6;
                while (payload.length >= currentIndex+dayLength) {
                    NSData *dayData = [payload subdataWithRange:NSMakeRange(currentIndex, dayLength)];
                    NSData *itemsData = itemCount > 0 ? [dayData subdataWithRange:NSMakeRange(6, itemCount*itemLength)] : [NSData data];
                    NSMutableArray *items = [NSMutableArray array];
                    for (int j = 0; j < itemCount ; j++) {
                        NSData *item = [itemsData subdataWithRange:NSMakeRange(j*itemLength, itemLength)];
                        NSInteger timestamp = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                        CGFloat value = DHDecimalValue([item subdataWithRange:NSMakeRange(4, 1)])+200;
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(timestamp) forKey:@"timestamp"];
                        [dict setObject:@(value) forKey:@"value"];
                        
                        [items addObject:dict];
                    }
                    
                    DHDailyTempModel *model = [[DHDailyTempModel alloc] init];
                    NSInteger timestamp = DHDecimalValue([dayData subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                    model.date = [self dateToStringFormat:@"yyyyMMdd" date:date];
                    model.items = items;
                    [resultArray addObject:model];
                    
                    currentIndex += dayLength;
                    if (payload.length >= currentIndex+6) {
                        itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                        dayLength = itemCount*itemLength+6;
                    }
                }
                result = resultArray;
            }
        }
            break;
        case DHBleCommandTypeBreathSyncing:
        {
            
            if (payload.length >= 6) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSInteger currentIndex = 0;
                NSInteger itemLength = 5;
                NSInteger itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                NSInteger dayLength = itemCount*itemLength+6;
                while (payload.length >= currentIndex+dayLength) {
                    NSData *dayData = [payload subdataWithRange:NSMakeRange(currentIndex, dayLength)];
                    NSData *itemsData = itemCount > 0 ? [dayData subdataWithRange:NSMakeRange(6, itemCount*itemLength)] : [NSData data];
                    NSMutableArray *items = [NSMutableArray array];
                    for (int j = 0; j < itemCount ; j++) {
                        NSData *item = [itemsData subdataWithRange:NSMakeRange(j*itemLength, itemLength)];
                        NSInteger timestamp = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                        NSInteger value = DHDecimalValue([item subdataWithRange:NSMakeRange(4, 1)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(timestamp) forKey:@"timestamp"];
                        [dict setObject:@(value) forKey:@"value"];
                        
                        [items addObject:dict];
                    }
                    
                    DHDailyBreathModel *model = [[DHDailyBreathModel alloc] init];
                    NSInteger timestamp = DHDecimalValue([dayData subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                    model.date = [self dateToStringFormat:@"yyyyMMdd" date:date];
                    model.items = items;
                    [resultArray addObject:model];
                    
                    currentIndex += dayLength;
                    if (payload.length >= currentIndex+6) {
                        itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+4, 2)]);
                        dayLength = itemCount*itemLength+6;
                    }
                }
                result = resultArray;
            }
        }
            break;
        case DHBleCommandTypeLogSyncing:
        {
            
            if (payload.length >= 3) {
                NSMutableString *logStr = [NSMutableString string];
                NSInteger itemLength = 36;
                //NSInteger totalCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(0, 2)]];
                NSInteger itemCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(2, 1)]);
                if (payload.length >= itemCount*itemLength+3) {
                    for (int i = 0; i < itemCount; i++) {
                        NSData *item = [payload subdataWithRange:NSMakeRange(3+i*itemLength, itemLength)];
                        NSInteger timestamp = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 4)]) - DHTimeInterval;
                        NSString *value = [[NSString alloc] initWithData:[item subdataWithRange:NSMakeRange(4, 32)] encoding:NSUTF8StringEncoding];
                        
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                        NSString *dateStr = [self dateToStringFormat:@"yyyy/MM/dd HH:mm:ss" date:date];
                        [logStr appendFormat:@"%@ %@\n",dateStr,value];
                    }
                }
                result = logStr;
            }
        }
            break;
        case DHBleCommandTypeSportSyncing:
        {
            
            if (payload.length > 17+2) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSInteger currentIndex = 0;
                
                NSInteger paceALength = 4;
                NSInteger paceACount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+17, 2)]);//配速个数（公制）
                
                if (payload.length < currentIndex+17+(2+paceACount*paceALength)+2) {
                    result = resultArray;
                    break;
                }
                NSInteger paceBLength = 4;
                NSInteger paceBCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+17+(2+paceACount*paceALength), 2)]); //配速个数（英制）
                
                if (payload.length < currentIndex+17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength)+2) {
                    result = resultArray;
                    break;
                }
                NSInteger stepLength = 3;
                //步频个数
                NSInteger stepCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength), 2)]);
                
                if (payload.length < currentIndex+17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength)+(2+stepCount*stepLength)+2) {
                    result = resultArray;
                    break;
                }
                NSInteger hrLength = 3;
                //心率个数
                NSInteger hrCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength)+(2+stepCount*stepLength), 2)]);
                
                NSInteger dayLength = (2+paceACount*paceALength)+(2+paceBCount*paceBLength)+(2+stepCount*stepLength)+(2+hrCount*hrLength)+17;
                while (payload.length >= currentIndex+dayLength) {
                    NSData *dayData = [payload subdataWithRange:NSMakeRange(currentIndex, dayLength)];
                    NSData *sumData = [dayData subdataWithRange:NSMakeRange(0, 17)];
                    NSData *paceAData = paceACount ? [dayData subdataWithRange:NSMakeRange(17+2, paceACount*paceALength)] : [NSData data];
                    NSData *paceBData = paceBCount ? [dayData subdataWithRange:NSMakeRange(17+(2+paceACount*paceALength)+2, paceBCount*paceBLength)] : [NSData data];
                    NSData *stepData = stepCount ? [dayData subdataWithRange:NSMakeRange(17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength)+2, stepCount*stepLength)] : [NSData data];
                    NSData *hrData = hrCount ? [dayData subdataWithRange:NSMakeRange(17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength)+(2+stepCount*stepLength)+2, hrCount*hrLength)] : [NSData data];
                    
                    NSMutableArray *metricPaceItems = [NSMutableArray array];
                    for (int j = 0; j < paceACount ; j++) {
                        NSData *item = [paceAData subdataWithRange:NSMakeRange(j*paceALength, paceALength)];
                        NSInteger index = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 1)]);
                        NSInteger value = DHDecimalValue([item subdataWithRange:NSMakeRange(1, 2)]);
                        NSInteger isInt = DHDecimalValue([item subdataWithRange:NSMakeRange(3, 1)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(index) forKey:@"index"];
                        [dict setObject:@(value) forKey:@"value"];
                        [dict setObject:@(isInt) forKey:@"isInt"];
                        
                        [metricPaceItems addObject:dict];
                    }
                    
                    NSMutableArray *imperialPaceItems = [NSMutableArray array];
                    for (int j = 0; j < paceBCount ; j++) {
                        NSData *item = [paceBData subdataWithRange:NSMakeRange(j*paceBLength, paceBLength)];
                        NSInteger index = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 1)]);
                        NSInteger value = DHDecimalValue([item subdataWithRange:NSMakeRange(1, 2)]);
                        NSInteger isInt = DHDecimalValue([item subdataWithRange:NSMakeRange(3, 1)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(index) forKey:@"index"];
                        [dict setObject:@(value) forKey:@"value"];
                        [dict setObject:@(isInt) forKey:@"isInt"];
                        
                        [imperialPaceItems addObject:dict];
                    }
                    
                    NSMutableArray *strideFrequencyItems = [NSMutableArray array];
                    for (int j = 0; j < stepCount ; j++) {
                        NSData *item = [stepData subdataWithRange:NSMakeRange(j*stepLength, stepLength)];
                        NSInteger index = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 2)]);
                        NSInteger value = DHDecimalValue([item subdataWithRange:NSMakeRange(2, 1)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(index) forKey:@"index"];
                        [dict setObject:@(value) forKey:@"value"];
                        [strideFrequencyItems addObject:dict];
                    }
                    
                    NSMutableArray *hrItems = [NSMutableArray array];
                    for (int j = 0; j < hrCount ; j++) {
                        NSData *item = [hrData subdataWithRange:NSMakeRange(j*hrLength, hrLength)];
                        NSInteger index = DHDecimalValue([item subdataWithRange:NSMakeRange(0, 2)]);
                        NSInteger value = DHDecimalValue([item subdataWithRange:NSMakeRange(2, 1)]);
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:@(index) forKey:@"index"];
                        [dict setObject:@(value) forKey:@"value"];
                        [hrItems addObject:dict];
                    }
                    
                    DHDailySportModel *model = [[DHDailySportModel alloc] init];
                    NSInteger timestamp = DHDecimalValue([sumData subdataWithRange:NSMakeRange(0, 4)])-DHTimeInterval;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                    model.date = [self dateToStringFormat:@"yyyyMMdd" date:date];
                    model.type = DHDecimalValue([sumData subdataWithRange:NSMakeRange(4, 1)]);
                    model.duration = DHDecimalValue([sumData subdataWithRange:NSMakeRange(5, 4)]);
                    model.distance = DHDecimalValue([sumData subdataWithRange:NSMakeRange(9, 2)]);
                    model.step = DHDecimalValue([sumData subdataWithRange:NSMakeRange(11, 3)]);
                    model.calorie = DHDecimalValue([sumData subdataWithRange:NSMakeRange(14, 3)]);
                    
                    model.metricPaceItems = metricPaceItems;
                    model.imperialPaceItems = imperialPaceItems;
                    model.strideFrequencyItems = strideFrequencyItems;
                    model.heartRateItems = hrItems;
                    [resultArray addObject:model];
                    
                    currentIndex += dayLength;
                    if (payload.length > currentIndex+17) {
                        paceACount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+17, 2)]);
                        
                        if (payload.length > currentIndex+17+(2+paceACount*paceALength)){
                            paceBCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+17+(2+paceACount*paceALength), 2)]);
                        }
                        else{
                            DHSaveLog(@"paceBCount 异常");
                            return result;
                        }
                        if (payload.length > currentIndex+17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength)){
                            stepCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength), 2)]);
                        }
                        else{
                            DHSaveLog(@"stepCount 异常");
                            return result;
                        }
                        if (payload.length > currentIndex+17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength)+(2+stepCount*stepLength)){
                            hrCount = DHDecimalValue([payload subdataWithRange:NSMakeRange(currentIndex+17+(2+paceACount*paceALength)+(2+paceBCount*paceBLength)+(2+stepCount*stepLength), 2)]);
                        }
                        else{
                            DHSaveLog(@"hrCount 异常");
                            return result;
                        }
                        dayLength = (2+paceACount*paceALength)+(2+paceBCount*paceBLength)+(2+stepCount*stepLength)+(2+hrCount*hrLength)+17;
                    }
                }
                result = resultArray;
            }
        }
            break;
    
        default:
            break;
    }
    if (result) {
        NSMutableString *resultStr = [NSMutableString string];
        if ([result isKindOfClass:[NSArray class]]) {
            NSArray *array = result;
            if (array.count > 0) {
                for (id model in array) {
                    NSString *itemStr = [self modelDescriptionWithIndent:0 Object:model];
                    [resultStr appendString:itemStr];
                }
            } else {
                [resultStr appendString:@"no data"];
            }
        } else if ([result isKindOfClass:[NSString class]]){
            [resultStr appendString:result];
        } else {
            NSString *itemStr = [self modelDescriptionWithIndent:0 Object:result];
            [resultStr appendString:itemStr];
        }
//        DHSaveLog(resultStr);
    }
    
    return result;
}

+ (NSString*)hexRepresentationWithSymbol:(NSString *)symbol data:(NSData *)data {
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    NSMutableString *macAddr = [NSMutableString string];
    for (NSUInteger i = 0; i < nbBytes; i++) {
        [macAddr appendFormat:@"%02x%@",bytes[i], symbol];
    }
    [macAddr deleteCharactersInRange:NSMakeRange(macAddr.length-1, 1)];
    return [macAddr uppercaseString];
}

+ (NSString *)dateToStringFormat:(NSString *)format date:(NSDate *)date {//en_US
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    df.locale =  [NSLocale localeWithLocaleIdentifier:@"en_US"];
    df.dateFormat = format;
    return [df stringFromDate:date];
}

#pragma mark - 日志记录

+ (void)saveLog:(NSString *)log {
    if (DHIsSaveLog) {
        NSLog(@"%@",log);
    }
    if (log.length == 0) {
        return;
    }
    NSString *filePath = [self getLogFilePath];
    if (filePath.length == 0) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *Data = [fileManager contentsAtPath:filePath];
    NSMutableData *write = [NSMutableData dataWithData:Data];

    NSString *resultStr = [NSString stringWithFormat:@"%@ %@", [DHTool dateToStringFormat:@"HH:mm:ss" date:[NSDate date]], log];
    [write appendData:[resultStr dataUsingEncoding:NSUTF8StringEncoding]];
    [write appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [write writeToFile:filePath atomically:YES];
}

+ (NSString *)getLogFilePath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *directoryPath = [documentPath stringByAppendingPathComponent:@"DeviceLog"];
    NSString *filePath = [directoryPath stringByAppendingFormat:@"/%@.txt",[DHTool dateToStringFormat:@"yyyy-MM-dd" date:[NSDate date]]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL isDirectoryExist = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if(!(isDirectoryExist && isDirectory)) {
        BOOL isCreateDirectory = [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!isCreateDirectory){
            return @"";
        }
    }
    
    BOOL isFileExist = [fileManager fileExistsAtPath:filePath];
    if (!isFileExist) {
        BOOL isCreateFile = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        if (!isCreateFile) {
            return @"";
        }
    }

    return filePath;
}

+ (void)checkLogFiles {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *directoryPath = [documentPath stringByAppendingPathComponent:@"DeviceLog"];
    NSString *filePath = [directoryPath stringByAppendingFormat:@"/%@.txt",[DHTool dateToStringFormat:@"yyyy-MM-dd" date:[NSDate date]]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL isDirectoryExist = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if(!(isDirectoryExist && isDirectory)) {
        BOOL isCreateDirectory = [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!isCreateDirectory){
            return;
        }
    }
    
    BOOL isFileExist = [fileManager fileExistsAtPath:filePath];
    if (!isFileExist) {
        BOOL isCreateFile = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        if (!isCreateFile) {
            return;
        }
    }

    NSMutableArray *logArray = [NSMutableArray array];
    NSDirectoryEnumerator *myDirectoryEnumerator = [fileManager enumeratorAtPath:directoryPath];
    NSString *logName = @"";
    while((logName = [myDirectoryEnumerator nextObject])!=nil){
        [logArray addObject:logName];
    }
    
    if (logArray.count > 7) {
        NSString *removePath = [directoryPath stringByAppendingFormat:@"/%@",logArray.firstObject];
        [fileManager removeItemAtPath:removePath error:nil];
    }
}

+ (NSString *)modelDescriptionWithIndent:(NSInteger)level Object:(id)object{
    uint count;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int index = 0; index < level; index ++) {
        [tab appendString:@"\t"];
    }
    [mStr appendString:@"{\n"];
    for (int index = 0; index < count; index ++) {
        NSString *lastSymbol = index + 1 == count ? @"" : @";";
        objc_property_t property = properties[index];
        NSString *name = @(property_getName(property));
        id value = [object valueForKey:name];
        [mStr appendFormat:@"\t%@%@ = %@%@\n",
         tab,
         name,
         value,
         lastSymbol];
    }
    [mStr appendFormat:@"%@}",tab];
    free(properties);
    return [NSString stringWithFormat:@"<%@ : %p> %@",
            NSStringFromClass([object class]),
            object,
            mStr];
}


+ (NSInteger)transformColor:(NSInteger)rgbColor {
    NSInteger red = (rgbColor >> 16 & 0xFF);
    NSInteger green = (rgbColor >> 8 & 0xFF);
    NSInteger blue = (rgbColor >> 0 & 0xFF);
    NSInteger color = (((red)*0x1F/255) << 0 ) | (((green)*0x3F/255) << 5 ) | (((blue)*0x1F/255) << 11 );
    return color;
}


//+ (NSInteger)transformColor:(NSInteger)rgbColor {
//    NSInteger red = (rgbColor >> 16 & 0xFF);
//    NSInteger green = (rgbColor >> 8 & 0xFF);
//    NSInteger blue = (rgbColor >> 0 & 0xFF);
//    NSInteger color = ((red >> 3) << 11) + ((green >> 2) << 5) + ((blue >> 3) << 0);
//    return color;
//}

+ (NSData *)transformCustomDialDataWithAlpha:(NSData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    CGImageRef ImageRef = image.CGImage;
    CFDataRef mDataRef =  CGDataProviderCopyData(CGImageGetDataProvider(ImageRef));
    
    UInt8 *mPixelBuf = (UInt8 *)CFDataGetBytePtr(mDataRef);
    CFIndex length = CFDataGetLength(mDataRef);
    
    NSMutableData *fileData = [NSMutableData data];
    for(int i=0;i<length;i+=4){
        int r = i;
        int g = i+1;
        int b = i+2;
        int a = i+3;
        
        int red   = mPixelBuf[r];
        int green = mPixelBuf[g];
        int blue  = mPixelBuf[b];
        int alapt = mPixelBuf[a];
        
        uint16_t color = [self transformColorWithRed:red Green:green Blue:blue alpha:alapt];
        NSString *colorString = [NSString stringWithFormat:@"%04x",color];
        
        [fileData appendData:DHHexToBytes(colorString)];
    }
    
    CFRelease(mDataRef);
    return fileData;
}

+ (NSData *)transformCustomDialData:(NSData *)data {
    
    UIImage *image = [UIImage imageWithData:data];
    CGImageRef ImageRef = image.CGImage;
    CFDataRef mDataRef =  CGDataProviderCopyData(CGImageGetDataProvider(ImageRef));
    
    UInt8 *mPixelBuf = (UInt8 *)CFDataGetBytePtr(mDataRef);
    CFIndex length = CFDataGetLength(mDataRef);
    
    NSMutableData *fileData = [NSMutableData data];
    for(int i=0;i<length;i+=4){
        int r = i;
        int g = i+1;
        int b = i+2;
        int a = i+3;
        
        int red   = mPixelBuf[r];
        int green = mPixelBuf[g];
        int blue  = mPixelBuf[b];
        int alapt = 255;
        
        uint16_t color = [self transformColorWithRed:red Green:green Blue:blue alpha:alapt];
        NSString *colorString = [NSString stringWithFormat:@"%04x",color];
        
        [fileData appendData:DHHexToBytes(colorString)];
    }
    
    CFRelease(mDataRef);
    return fileData;
}

+ (uint16_t)transformColorWithRed:(int)red Green:(int)green Blue:(int)blue alpha:(int)alpha {
    
    int tRed = red * alpha/255.0;
    int tGreen = green * alpha/255.0;
    int tBlue = blue * alpha /255.0;
    
    uint16_t BGRColor = tRed >> 3;
    BGRColor |= (tGreen & 0xFC) << 3;
    BGRColor |= (tBlue  & 0xF8) << 8;
    
    return BGRColor;
}

+ (NSInteger)appElementToDevice:(NSInteger)appElement {
    NSInteger result = 0;
    switch (appElement) {
        case 1:
            result = 1;
            break;
        case 2:
            result = 2;
            break;
        case 3:
            result = 4;
            break;
        case 4:
            result = 8;
            break;
        default:
            break;
    }
    return result;
}

+ (NSInteger)deviceElementToApp:(NSInteger)deviceElement {
    NSInteger result = 0;
    switch (deviceElement) {
        case 1:
            result = 1;
            break;
        case 2:
            result = 2;
            break;
        case 4:
            result = 3;
            break;
        case 8:
            result = 4;
            break;
        default:
            break;
    }
    return result;
}

+ (NSInteger)getTimeZoneInterval {
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger inteval = [timeZone secondsFromGMT];
    return inteval;
}

@end
