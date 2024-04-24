//
//  DHQRCodeSetModel.h
//  DHBleSDK
//
//  Created by DHS on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHQRCodeSetModel : NSObject

// APP类型（0.QQ 1.微信 2.WHATSAPP 3.TWITTER 4.FACEBOOK 5.待定 6.待定 7.其他）
@property (nonatomic, assign) NSInteger appType;
// 名称
@property (nonatomic, copy) NSString *title;
// 内容
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
