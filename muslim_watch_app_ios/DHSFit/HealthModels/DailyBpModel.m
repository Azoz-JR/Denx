//
//  DailyBpModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import "DailyBpModel.h"

@implementation DailyBpModel

-(instancetype)init{
    if (self = [super init]) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        self.isUpload = NO;
        
        self.date = @"";
        self.timestamp = @"";
        
        self.lastSystolic = 0;
        self.lastDiastolic = 0;
        self.avgSystolic = 0;
        self.avgDiastolic = 0;
        self.maxSystolic = 0;
        self.maxDiastolic = 0;
        self.minSystolic = 0;
        self.minDiastolic = 0;
        self.items = @"";
        
    }
    return self;
}

+ (__kindof DailyBpModel *)currentModel:(NSString *)date {
    DailyBpModel *model =[DailyBpModel findFirstWithFormat:@"WHERE userId = '%@' AND date = '%@'",DHUserId,date];
    if (!model) {
        model = [[DailyBpModel alloc] init];
        model.date = date;
        model.timestamp = [NSDate timeStampFromtimeStr:[NSString stringWithFormat:@"%@000000",date]];
    }
    return model;
}

+ (NSArray *)queryModels:(NSString *)startDateStr endDateStr:(NSString *)endDateStr {
    NSDate *startDate = [startDateStr dateByStringFormat:@"yyyyMMdd"];
    NSDate *endDate = [endDateStr dateByStringFormat:@"yyyyMMdd"];

    NSArray *models =[DailyBpModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDateStr, endDateStr];

    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    NSInteger count = time / (24*60*60) + 1;
    
    NSMutableArray *bpModels = [NSMutableArray array];
    NSMutableArray *dateStrs = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        DailyBpModel *model = [[DailyBpModel alloc] init];
        NSDate *date = [startDate dateAfterDay:i];
        model.date = [date dateToStringFormat:@"yyyyMMdd"];
        [bpModels addObject:model];
        [dateStrs addObject:model.date];
    }
    
    for (DailyBpModel *model in models) {
        NSInteger index = [dateStrs indexOfObject:model.date];
        [bpModels replaceObjectAtIndex:index withObject:model];
    }
    return bpModels;
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
        NSArray *models = [DailyBpModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDate, endDate];
        NSInteger sumSystolic = 0;
        NSInteger sumDiastolic = 0;
        NSInteger count = 0;
        for (DailyBpModel *model in models) {
            if (model.avgSystolic) {
                sumSystolic += model.avgSystolic;
                sumDiastolic += model.avgDiastolic;
                count++;
            }
        }
        NSInteger avgSystolic = 1.0*sumSystolic/count;
        NSInteger avgDiastolic = 1.0*sumDiastolic/count;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@(avgSystolic) forKey:@"systolic"];
        [dict setObject:@(avgDiastolic) forKey:@"diastolic"];
        [valueArray addObject:dict];
    }
    return valueArray;
}

+ (NSArray *)queryUploadModels {
    NSArray *models = [DailyBpModel findWithFormat:@"WHERE userId = '%@' AND isUpload = 0",DHUserId];
    return models;
}

+ (NSArray *)queryVisitorModels {
    NSArray *models = [DailyBpModel findWithFormat:@"WHERE userId = '%@'",DHVisitorId];
    return models;
}

+ (DailyBpModel *)queryModel:(NSString *)timestamp {
    DailyBpModel *model =[DailyBpModel findFirstWithFormat:@"WHERE userId = '%@' and timestamp = '%@'",DHUserId,timestamp];
    return model;
}

+ (NSString *)getTableName{
    return @"t_sync_bp";
}

@end

