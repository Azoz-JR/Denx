//
//  ContactSetModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "ContactSetModel.h"

@implementation ContactSetModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.contactIndex = 0;
        self.name = @"";
        self.mobile = @"";
    }
    return self;
}

+ (NSArray <ContactSetModel *>*)queryAllContacts {
    NSArray *contacts =[ContactSetModel findWithFormat:@"WHERE macAddr = '%@' ORDER BY contactIndex ASC",DHMacAddr];
    return contacts;
}

+ (NSString *)getTableName{
    return @"t_device_contact";
}

@end
