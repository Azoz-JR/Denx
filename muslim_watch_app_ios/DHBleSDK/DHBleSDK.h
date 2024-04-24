//
//  DHBleSDK.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>


#pragma mark - Manager
#import "DHBleCentralManager.h"
#import "DHBleCommand.h"

//! Project version number for DHBleSDK.
FOUNDATION_EXPORT double DHBleSDKVersionNumber;

//! Project version string for DHBleSDK.
FOUNDATION_EXPORT const unsigned char DHBleSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <DHBleSDK/PublicHeader.h>


#define DHBindedUUID @"DHBindedUUID"
#define DHBindedMacAddress @"DHBindedMacAddress"
#define DHAllBindedMacAddress @"DHAllBindedMacAddress"

#define DHCommandIdentification @"7e"
#define DHCommandProtocolVersion @"01"
#define DHCommandAppFeedback @"ff"
#define DHCommandDeviceFeedback @"fe"

#define DHCommandCodeSuccessfully 0
#define DHCommandCodeFailed 1

#define DHCommandMsgSuccessfully @"Successfully"
#define DHCommandMsgFinished @"Finished"
#define DHCommandMsgFailed @"Failed"
#define DHCommandMsgDisconnected @"Disconnected"
#define DHCommandMsgDataError @"DataError"
#define DHCommandMsgTimeout @"Timeout"

#define DHDecimalValue(a) [DHTool hexDecimalValue:a]
#define DHDecimalString(a) [DHTool hexadecimalString:a]
#define DHDecimalStringLog(a) [DHTool hexadecimalStringLog:a]
#define DHHexToBytes(a) [DHTool hexToBytes:a]
#define DHSaveLog(a) [DHTool saveLog:a]
#define DHTimeInterval [DHTool getTimeZoneInterval]


//#define JLServiceUUID @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
//#define JLCharWriteUUID @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
//#define JLCharNotifyUUID @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

#define RWServiceUUID @"A00A"
#define RWCharWriteUUID @"B002"
#define RWCharNotifyUUID @"B003"

#define JLServiceUUID @"AE00"
#define JLOTAWriteUUID @"AE01"
#define JLOTANotifyUUID @"AE02"

#define JL366X366 @"DHBindedUUID"

#define DHLogStatus @"DHLogStatus"
#define DHIsSaveLog [[NSUserDefaults standardUserDefaults] boolForKey:DHLogStatus]

#define kWeakSelf(type)             __weak typeof(type) weak##type = type;


