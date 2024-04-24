//
//  DailyTempModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/11.
//

#import "DailyTempModel.h"

@implementation DailyTempModel

-(instancetype)init{
    if (self = [super init]) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.avgTemp = 0;
        self.maxTemp = 0;
        self.minTemp = 0;
        self.lastTemp = 0;
        
        self.date = @"";
        self.timestamp = @"";
        self.items = @"";
        self.isUpload = NO;
    }
    return self;
}

+ (__kindof DailyTempModel *)currentModel:(NSString *)date {
    DailyTempModel *model =[DailyTempModel findFirstWithFormat:@"WHERE userId = '%@' AND date = '%@'",DHUserId,date];
    if (!model) {
        model = [[DailyTempModel alloc] init];
        model.date = date;
        model.timestamp = [NSDate timeStampFromtimeStr:[NSString stringWithFormat:@"%@000000",date]];
    }
    return model;
}

+ (NSArray *)queryModels:(NSString *)startDateStr endDateStr:(NSString *)endDateStr {
    NSDate *startDate = [startDateStr dateByStringFormat:@"yyyyMMdd"];
    NSDate *endDate = [endDateStr dateByStringFormat:@"yyyyMMdd"];

    NSArray *models =[DailyTempModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDateStr, endDateStr];

    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    NSInteger count = time / (24*60*60) + 1;
    
    NSMutableArray *tempModels = [NSMutableArray array];
    NSMutableArray *dateStrs = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        DailyTempModel *model = [[DailyTempModel alloc] init];
        NSDate *date = [startDate dateAfterDay:i];
        model.date = [date dateToStringFormat:@"yyyyMMdd"];
        [tempModels addObject:model];
        [dateStrs addObject:model.date];
    }
    
    for (DailyTempModel *model in models) {
        NSInteger index = [dateStrs indexOfObject:model.date];
        [tempModels replaceObjectAtIndex:index withObject:model];
    }
    return tempModels;
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
        NSArray *models = [DailyTempModel findWithFormat:@"WHERE userId = '%@' and date >= '%@' and date <= '%@'",DHUserId, startDate, endDate];
        NSInteger sum = 0;
        NSInteger count = 0;
        for (DailyTempModel *model in models) {
            if (model.avgTemp) {
                sum += model.avgTemp;
                count++;
            }
        }
        NSInteger avgTemp = 1.0*sum/count;
        [valueArray addObject:@(avgTemp)];
    }
    return valueArray;
}

+ (NSArray *)queryUploadModels {
    NSArray *models = [DailyTempModel findWithFormat:@"WHERE userId = '%@' AND isUpload = 0",DHUserId];
    return models;
}

+ (NSArray *)queryVisitorModels {
    NSArray *models = [DailyTempModel findWithFormat:@"WHERE userId = '%@'",DHVisitorId];
    return models;
}

+ (DailyTempModel *)queryModel:(NSString *)timestamp {
    DailyTempModel *model =[DailyTempModel findFirstWithFormat:@"WHERE userId = '%@' and timestamp = '%@'",DHUserId,timestamp];
    return model;
}

+ (NSString *)getTableName{
    return @"t_sync_temp";
}

@end
