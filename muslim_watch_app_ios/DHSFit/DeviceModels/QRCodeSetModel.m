//
//  QRCodeSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/8/9.
//

#import "QRCodeSetModel.h"

@implementation QRCodeSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;

    }
    return self;
}

+ (__kindof QRCodeSetModel *)currentModel:(NSInteger)appType {
    QRCodeSetModel *model =[QRCodeSetModel findFirstWithFormat:@"WHERE macAddr = '%@' and appType = '%ld'",DHMacAddr,appType];
    if (!model) {
        model = [[QRCodeSetModel alloc] init];
        model.appType = appType;
        model.title = Lang(@"str_qrcode");
        model.url = @"";
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_device_qrcode";
}

@end
