//
//  DailyStepModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "DailyStepModel.h"

@implementation DailyStepModel

-(instancetype)init{
    if (self = [super init]) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        self.isUpload = NO;
        
        self.date = @"";
        self.timestamp = @"";
        
        self.distance = 0;
        self.calorie = 0;
        self.step = 0;
        self.items = @"";
        
    }
    return self;
}

+ (__kindof DailyStepModel *)currentModel:(NSString *)date {
    DailyStepModel *model =[DailyStepModel findFirstWithFormat:@"WHERE userId = '%@' and date = '%@'",DHUserId,date];
    if (!model) {
        model = [[DailyStepModel alloc] init];
        model.date = date;
        model.timestamp = [NSDate timeStampFromtimeStr:[NSString stringWithFormat:@"%@000000",date]];
    }
    return model;
}


+ (NSArray *)queryModels:(NSString *)startDateStr endDateStr:(NSString *)endDateStr {
    NSDate *startDate = [startDateStr dateByStringFormat:@"yyyyMMdd"];
    NSDate *endDate = [endDateStr dateByStringFormat:@"yyyyMMdd"];

    NSArray *models = [DailyStepModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDateStr, endDateStr];

    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    NSInteger count = time / (24*60*60) + 1;//一头 一尾 少一天
    
    NSMutableArray *stepModels = [NSMutableArray array];
    NSMutableArray *dateStrs = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        DailyStepModel *model = [[DailyStepModel alloc] init];
        NSDate *date = [startDate dateAfterDay:i];
        model.date = [date dateToStringFormat:@"yyyyMMdd"];
        [stepModels addObject:model];
        [dateStrs addObject:model.date];
    }
    
    for (DailyStepModel *model in models) {
        NSInteger index = [dateStrs indexOfObject:model.date];
        [stepModels replaceObjectAtIndex:index withObject:model];
    }
    return stepModels;
}

+ (NSArray *)queryYearModels:(NSDate *)date {
    NSString *startDate;
    NSString *endDate;
    NSInteger dayCount = 31;
    BOOL isLeapYear = (((date.year%4 == 0)&&(date.year%100 != 0))||(date.year%400 == 0));
    NSMutableArray *valueArray = [NSMutableArray array];
    for (int i = 1; i < 13; i++) {
        if (i == 2) {
            dayCount = isLeapYear ? 29 : 28;
        } else if (i == 4 ||
            i == 6 ||
            i == 9 ||
            i == 11) {
            dayCount = 30;
        }
        startDate = [NSString stringWithFormat:@"%04ld%02ld%02ld",(long)date.year,(long)i,(long)1];
        endDate = [NSString stringWithFormat:@"%04ld%02ld%02ld",(long)date.year,(long)i,(long)dayCount];
        NSArray *models = [DailyStepModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDate, endDate];
        NSInteger sum = 0;
        for (DailyStepModel *model in models) {
            if (model.step) {
                sum += model.step;
            }
        }
        [valueArray addObject:@(sum)];
    }
    return valueArray;
}

+ (NSArray *)queryUploadModels {
    NSArray *models = [DailyStepModel findWithFormat:@"WHERE userId = '%@' AND isUpload = 0",DHUserId];
    return models;
}

+ (NSArray *)queryVisitorModels {
    NSArray *models = [DailyStepModel findWithFormat:@"WHERE userId = '%@'",DHVisitorId];
    return models;
}

+ (DailyStepModel *)queryModel:(NSString *)timestamp {
    DailyStepModel *model = [DailyStepModel findFirstWithFormat:@"WHERE userId = '%@' and timestamp = '%@'",DHUserId,timestamp];
    return model;
}

+ (NSString *)getTableName {
    return @"t_sync_step";
}

@end
