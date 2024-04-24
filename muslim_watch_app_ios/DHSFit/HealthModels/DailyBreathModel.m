//
//  DailyBreathModel.m
//  DHSFit
//
//  Created by DHS on 2022/8/10.
//

#import "DailyBreathModel.h"

@implementation DailyBreathModel

-(instancetype)init{
    if (self = [super init]) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.duration = 0;
        
        self.date = @"";
        self.timestamp = @"";
        self.items = @"";
        self.isUpload = NO;
    }
    return self;
}

+ (__kindof DailyBreathModel *)currentModel:(NSString *)date {
    DailyBreathModel *model =[DailyBreathModel findFirstWithFormat:@"WHERE userId = '%@' AND date = '%@'",DHUserId,date];
    if (!model) {
        model = [[DailyBreathModel alloc] init];
        model.date = date;
        model.timestamp = [NSDate timeStampFromtimeStr:[NSString stringWithFormat:@"%@000000",date]];
    }
    return model;
}

+ (NSArray *)queryModels:(NSString *)startDateStr endDateStr:(NSString *)endDateStr {
    NSDate *startDate = [startDateStr dateByStringFormat:@"yyyyMMdd"];
    NSDate *endDate = [endDateStr dateByStringFormat:@"yyyyMMdd"];

    NSArray *models =[DailyBreathModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDateStr, endDateStr];

    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    NSInteger count = time / (24*60*60) + 1;
    
    NSMutableArray *breathModels = [NSMutableArray array];
    NSMutableArray *dateStrs = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        DailyBreathModel *model = [[DailyBreathModel alloc] init];
        NSDate *date = [startDate dateAfterDay:i];
        model.date = [date dateToStringFormat:@"yyyyMMdd"];
        [breathModels addObject:model];
        [dateStrs addObject:model.date];
    }
    
    for (DailyBreathModel *model in models) {
        NSInteger index = [dateStrs indexOfObject:model.date];
        [breathModels replaceObjectAtIndex:index withObject:model];
    }
    return breathModels;
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
        NSArray *models = [DailyBreathModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDate, endDate];
        NSInteger sum = 0;
        NSInteger count = 0;
        for (DailyBreathModel *model in models) {
            if (model.duration) {
                sum += model.duration;
                count++;
            }
        }
        NSInteger avgBreath = 1.0*sum/count;
        [valueArray addObject:@(avgBreath)];
    }
    return valueArray;
}

+ (NSArray *)queryUploadModels {
    NSArray *models = [DailyBreathModel findWithFormat:@"WHERE userId = '%@' AND isUpload = 0",DHUserId];
    return models;
}

+ (NSArray *)queryVisitorModels {
    NSArray *models = [DailyBreathModel findWithFormat:@"WHERE userId = '%@'",DHVisitorId];
    return models;
}

+ (DailyBreathModel *)queryModel:(NSString *)timestamp {
    DailyBreathModel *model =[DailyBreathModel findFirstWithFormat:@"WHERE userId = '%@' and timestamp = '%@'",DHUserId,timestamp];
    return model;
}

+ (NSString *)getTableName{
    return @"t_sync_breath";
}

@end
