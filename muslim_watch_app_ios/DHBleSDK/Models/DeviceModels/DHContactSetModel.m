//
//  DHContactSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHContactSetModel.h"

@implementation DHContactSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"";
        self.mobile = @"";
    }
    return self;
}

- (NSData *)valueWithJL
{
    NSMutableData *contactData = [NSMutableData dataWithCapacity:0];
    char tNameByte[24] = {0};
    char tMobileByte[16] = {0};
    
    char *tContactName = (char *)self.name.UTF8String;
    char *tContactMobile = (char *)self.mobile.UTF8String;
    if (strlen(tContactName) > 23){
//        strcpy(tNameByte, tContactName);
        strncpy(tNameByte, tContactName, 23);
    }
    else{
        strcpy(tNameByte, tContactName);
    }
    if (strlen(tContactMobile) > 15){
        strncpy(tMobileByte, tContactMobile, 15);
    }
    else{
        strcpy(tMobileByte, tContactMobile);
    }
    
    [contactData appendBytes:tNameByte length:24];
    [contactData appendBytes:tMobileByte length:16];
    
    return contactData;
}

@end
