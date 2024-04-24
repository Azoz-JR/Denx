//
//  QRCodeSetModel.h
//  DHSFit
//
//  Created by DHS on 2022/8/9.
//

#import <DHFoundation/DHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeSetModel : DHBaseModel

/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// MAC地址
@property (nonatomic, copy) NSString *macAddr;

// APP类型（0.QQ 1.微信 2.WHATSAPP 3.TWITTER 4.FACEBOOK 5.待定 6.待定 7.其他）
@property (nonatomic, assign) NSInteger appType;
// 名称
@property (nonatomic, copy) NSString *title;
// 内容
@property (nonatomic, copy) NSString *url;

+ (__kindof QRCodeSetModel *)currentModel:(NSInteger)appType;

@end

NS_ASSUME_NONNULL_END
