//
//  VisitorModel.m
//  DHSFit
//
//  Created by DHS on 2022/9/2.
//

#import "VisitorModel.h"

@implementation VisitorModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.userId = @"";
        
        self.name = @"visitor";
        self.avatar = @"";
        self.gender = 1;
        self.height = 170.0;
        self.weight = 65.0;
        self.stepGoal = 5000;
        self.birthday = [NSDate get1970timeTempWithYear:[NSDate date].year-25 andMonth:[NSDate date].month andDay:[NSDate date].day];
        
    }
    return self;
}

+ (__kindof VisitorModel *)currentModel {
    VisitorModel *model = [VisitorModel findFirstWithFormat:@"WHERE userId = '%@'",DHVisitorId];
    if (!model) {
        model = [[VisitorModel alloc] init];
    }
    return model;
}

+ (NSString *)getTableName{
    return @"t_user_visitor";
}


@end
