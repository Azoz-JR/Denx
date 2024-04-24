//
//  UserModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/1.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.userId = DHUserId;
        self.account = @"";
        self.openId = @"";
        
        self.name = @"";
        self.avatar = @"";
        self.gender = 1;
        self.height = 170.0;
        self.weight = 65.0;
        self.stepGoal = 5000;
        self.birthday = [NSDate get1970timeTempWithYear:[NSDate date].year-25 andMonth:[NSDate date].month andDay:[NSDate date].day];
        
        self.isSyncUserData = YES;
        self.isSyncSportData = YES;
        self.isSyncHealthData = YES;
    }
    return self;
}

+ (__kindof UserModel *)currentModel {
    static UserModel *_shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSArray *all = [UserModel findAll];
        if (all.count) {
            _shared = [all firstObject];
        }
        else{
            _shared = [[UserModel alloc] init];
            _shared.pk = 0;
        }
    });
    return _shared;
}

+ (__kindof UserModel *)visitorModel {
    UserModel *model = [UserModel findFirstWithFormat:@"WHERE userId = '%@'", DHVisitorId];
    if (!model) {
        model = [[UserModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_user_info";
}

@end
