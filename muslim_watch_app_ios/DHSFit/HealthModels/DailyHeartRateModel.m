//
//  DailyHeartRateModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "DailyHeartRateModel.h"

@implementation DailyHeartRateModel

-(instancetype)init{
    if (self = [super init]) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        self.isUpload = NO;
        
        self.date = @"";
        self.timestamp = @"";
        
        self.avgHr = 0;
        self.maxHr = 0;
        self.minHr = 0;
        self.lastHr = 0;
        self.items = @"";
        
    }
    return self;
}

+ (__kindof DailyHeartRateModel *)currentModel:(NSString *)date {
    DailyHeartRateModel *model =[DailyHeartRateModel findFirstWithFormat:@"WHERE userId = '%@' AND date = '%@'",DHUserId,date];
    if (!model) {
        model = [[DailyHeartRateModel alloc] init];
        model.date = date;
        model.timestamp = [NSDate timeStampFromtimeStr:[NSString stringWithFormat:@"%@000000",date]];
    }
    return model;
}

+ (NSArray *)queryModels:(NSString *)startDateStr endDateStr:(NSString *)endDateStr {
    NSDate *startDate = [startDateStr dateByStringFormat:@"yyyyMMdd"];
    NSDate *endDate = [endDateStr dateByStringFormat:@"yyyyMMdd"];

    NSArray *models =[DailyHeartRateModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDateStr, endDateStr];

    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    NSInteger count = time / (24*60*60) + 1;
    
    NSMutableArray *hrModels = [NSMutableArray array];
    NSMutableArray *dateStrs = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        DailyHeartRateModel *model = [[DailyHeartRateModel alloc] init];
        NSDate *date = [startDate dateAfterDay:i];
        model.date = [date dateToStringFormat:@"yyyyMMdd"];
        [hrModels addObject:model];
        [dateStrs addObject:model.date];
    }
    
    for (DailyHeartRateModel *model in models) {
        NSInteger index = [dateStrs indexOfObject:model.date];
        [hrModels replaceObjectAtIndex:index withObject:model];
    }
    return hrModels;
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
        NSArray *models = [DailyHeartRateModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDate, endDate];
        NSInteger sum = 0;
        NSInteger count = 0;
        for (DailyHeartRateModel *model in models) {
            if (model.avgHr) {
                sum += model.avgHr;
                count++;
            }
        }
        NSInteger avgHr = 1.0*sum/count;
        [valueArray addObject:@(avgHr)];
    }
    return valueArray;
}

+ (NSArray *)queryUploadModels {
    NSArray *models = [DailyHeartRateModel findWithFormat:@"WHERE userId = '%@' AND isUpload = 0",DHUserId];
    return models;
}

+ (NSArray *)queryVisitorModels {
    NSArray *models = [DailyHeartRateModel findWithFormat:@"WHERE userId = '%@'",DHVisitorId];
    return models;
}

+ (DailyHeartRateModel *)queryModel:(NSString *)timestamp {
    DailyHeartRateModel *model =[DailyHeartRateModel findFirstWithFormat:@"WHERE userId = '%@' and timestamp = '%@'",DHUserId,timestamp];
    return model;
}

+ (NSString *)getTableName{
    return @"t_sync_heartrate";
}

@end
