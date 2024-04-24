//
//  DialMarketSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/17.
//

#import "DialMarketSetModel.h"

@implementation DialMarketSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.imagePath = @"";
        self.filePath = @"";
        self.thumbnailPath = @"";
        self.name = @"";
        self.desc = @"";
        
        self.price = 0;
        self.downlaod = 0;
        self.fileSize = 0;
        self.dialId = 0;

    }
    return self;
}

+ (NSArray <DialMarketSetModel *>*)queryAllDials {
    NSArray *dials =[DialMarketSetModel findWithFormat:@"WHERE macAddr = '%@' and userId = '%@'",DHMacAddr,DHUserId];
    return dials;
}

+ (NSString *)getTableName{
    return @"t_device_dialmarket";
}

@end
