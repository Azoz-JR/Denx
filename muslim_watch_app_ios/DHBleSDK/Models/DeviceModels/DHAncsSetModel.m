//
//  DHAncsSetModel.m
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import "DHAncsSetModel.h"

@implementation DHAncsSetModel


- (NSData *)valueWithJL
{
    UInt32 tNtfValue = 0xffffffff;
    if (!self.isOther){
        tNtfValue &= ~(1<<0);
    }
    if (!self.isCall){
        tNtfValue &= ~(1<<1);
    }
    if (!self.isSMS){
        tNtfValue &= ~(1<<2);
    }
    if (!self.isEmail){
        tNtfValue &= ~(1<<3);
    }
    if (!self.isSkype){
        tNtfValue &= ~(1<<4);
    }
    if (!self.isFacebook){
        tNtfValue &= ~(1<<5);
    }
    if (!self.isWhatsapp){
        tNtfValue &= ~(1<<6);
    }
    if (!self.isLine){
        tNtfValue &= ~(1<<7);
    }
    if (!self.isInstagram){
        tNtfValue &= ~(1<<8);
    }
    if (!self.isKakaotalk){
        tNtfValue &= ~(1<<9);
    }
    if (!self.isGmail){
        tNtfValue &= ~(1<<10);
    }
    if (!self.isTwitter){
        tNtfValue &= ~(1<<11);
    }
    if (!self.isLinkedin){
        tNtfValue &= ~(1<<12);
    }
    if (!self.isJLSinaWeiBo){
        tNtfValue &= ~(1<<13);
    }
    if (!self.isQQ){
        tNtfValue &= ~(1<<14);
    }
    if (!self.isWechat){
        tNtfValue &= ~(1<<15);
    }
    if (!self.isJLBand){
        tNtfValue &= ~(1<<16);
    }
    if (!self.isJLTelegram){
        tNtfValue &= ~(1<<17);
    }
    if (!self.isJLBetween){
        tNtfValue &= ~(1<<18);
    }
    if (!self.isJLNavercafe){
        tNtfValue &= ~(1<<19);
    }
    if (!self.isYoutube){
        tNtfValue &= ~(1<<20);
    }
    
    if (!self.isJLNetflix){
        tNtfValue &= ~(1<<21);
    }
    
    tNtfValue &= ~(1<<31); //镜像手机（消息全部推送)
    
//    tNtfValue = 0xffffffff;
    
    return [NSData dataWithBytes:&tNtfValue length:4];
}


@end
