//
//  LocalDialSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/7/4.
//

#import "LocalDialSetModel.h"

@implementation LocalDialSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.dialIndex = 0;
        self.dialType = 0;
        self.dialId = 0;
    }
    return self;
}

+ (NSArray <LocalDialSetModel *>*)queryAllDials {
    NSArray *dials =[LocalDialSetModel findWithFormat:@"WHERE macAddr = '%@' ORDER BY dialIndex ASC",DHMacAddr];
    return dials;
}

+ (void)deleteAllDials {
    NSArray *array = [LocalDialSetModel queryAllDials];
    if (array.count) {
        [LocalDialSetModel deleteObjects:array];
    }
}

+ (NSString *)getTableName{
    return @"t_device_localdial";
}

@end
