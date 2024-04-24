//
//  DataUploadManager.m
//  DHSFit
//
//  Created by DHS on 2022/11/2.
//

#import "DataUploadManager.h"

@implementation DataUploadManager

+ (void)uploadAllHealthData {
    UserModel *userModel = [UserModel currentModel];
    if (userModel.isSyncHealthData) {
        [DataUploadManager uploadDailySteps];
        [DataUploadManager uploadDailySleeps];
        [DataUploadManager uploadDailyHrs];
        [DataUploadManager uploadDailyBps];
        [DataUploadManager uploadDailyBos];
        [DataUploadManager uploadDailyBreaths];
        [DataUploadManager uploadDailyTemps];
    }
    if (userModel.isSyncSportData) {
        [DataUploadManager uploadDailySports];
    }
    if (userModel.isSyncHealthData || userModel.isSyncSportData) {
        [NSObject cancelPreviousPerformRequestsWithTarget:[WeatherManager shareInstance] selector:@selector(delayUploadAllHealthData) object:nil];
        [[WeatherManager shareInstance] performSelector:@selector(delayUploadAllHealthData) withObject:nil afterDelay:3600];
    }
}

+ (void)downloadAllHealthData {
    UserModel *userModel = [UserModel currentModel];
    if (userModel.isSyncHealthData) {
        [DataUploadManager downloadDailySteps];
        [DataUploadManager downloadDailySleeps];
        [DataUploadManager downloadDailyHrs];
        [DataUploadManager downloadDailyBps];
        [DataUploadManager downloadDailyBos];
        [DataUploadManager downloadDailyBreaths];
        [DataUploadManager downloadDailyTemps];
    }
    if (userModel.isSyncSportData) {
        [DataUploadManager downloadDailySports];
    }
}

#pragma mark - 上传数据

+ (void)uploadDailySteps {
    NSArray *stepArray = [DailyStepModel queryUploadModels];
    if (stepArray.count == 0) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DailyStepModel *model in stepArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.userId forKey:@"memberId"];
        [dict setObject:model.macAddr forKey:@"deviceId"];
        [dict setObject:@([model.timestamp integerValue]+DHTimeZoneInterval) forKey:@"date"];
        [dict setObject:@(model.step) forKey:@"step"];
        [dict setObject:@(model.calorie) forKey:@"cal"];
        [dict setObject:@(model.distance) forKey:@"distance"];
        
        NSMutableArray *itemArray = [NSMutableArray array];
        if (model.items.length) {
            NSArray *items = [model.items transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *stepDict = [NSMutableDictionary dictionary];
                [stepDict setObject:item[@"index"] forKey:@"index"];
                [stepDict setObject:item[@"step"] forKey:@"step"];
                [stepDict setObject:item[@"distance"] forKey:@"distance"];
                [stepDict setObject:item[@"calorie"] forKey:@"cal"];
                [itemArray addObject:stepDict];
            }
        }
        [dict setObject:itemArray forKey:@"details"];
        [dataArray addObject:dict];
    }
    [NetworkManager uploadStepWithParam:dataArray andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            for (DailyStepModel *model in stepArray) {
                model.isUpload = YES;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)uploadDailySleeps {
    NSArray *sleepArray = [DailySleepModel queryUploadModels];
    if (sleepArray.count == 0) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DailySleepModel *model in sleepArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.userId forKey:@"memberId"];
        [dict setObject:model.macAddr forKey:@"deviceId"];
        [dict setObject:@([model.timestamp integerValue]+DHTimeZoneInterval) forKey:@"date"];
        [dict setObject:@(model.total) forKey:@"totalTime"];
        [dict setObject:@([model.beginTime integerValue]+DHTimeZoneInterval) forKey:@"startTime"];
        [dict setObject:@([model.endTime integerValue]+DHTimeZoneInterval) forKey:@"endTime"];
        
        NSMutableArray *itemArray = [NSMutableArray array];
        if (model.items.length) {
            NSArray *items = [model.items transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *sleepDict = [NSMutableDictionary dictionary];
                [sleepDict setObject:item[@"status"] forKey:@"type"];
                [sleepDict setObject:item[@"value"] forKey:@"period"];
                [itemArray addObject:sleepDict];
            }
        }
        [dict setObject:itemArray forKey:@"details"];
        [dataArray addObject:dict];
    }
    [NetworkManager uploadSleepWithParam:dataArray andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            for (DailySleepModel *model in sleepArray) {
                model.isUpload = YES;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)uploadDailyHrs {
    NSArray *hrArray = [DailyHeartRateModel queryUploadModels];
    if (hrArray.count == 0) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DailyHeartRateModel *model in hrArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.userId forKey:@"memberId"];
        [dict setObject:model.macAddr forKey:@"deviceId"];
        [dict setObject:@([model.timestamp integerValue]+DHTimeZoneInterval) forKey:@"date"];
        NSMutableArray *itemArray = [NSMutableArray array];
        if (model.items.length) {
            NSArray *items = [model.items transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *hrItem = [NSMutableDictionary dictionary];
                [hrItem setObject:@([[item objectForKey:@"timestamp"] integerValue]+DHTimeZoneInterval) forKey:@"timestamp"];
                [hrItem setObject:[item objectForKey:@"value"] forKey:@"value"];
                [itemArray addObject:hrItem];
            }
        }
        [dict setObject:itemArray forKey:@"details"];
        [dataArray addObject:dict];
    }
    [NetworkManager uploadHeartRateWithParam:dataArray andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            for (DailyHeartRateModel *model in hrArray) {
                model.isUpload = YES;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)uploadDailyBps {
    NSArray *bpArray = [DailyBpModel queryUploadModels];
    if (bpArray.count == 0) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DailyBpModel *model in bpArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.userId forKey:@"memberId"];
        [dict setObject:model.macAddr forKey:@"deviceId"];
        [dict setObject:@([model.timestamp integerValue]+DHTimeZoneInterval) forKey:@"date"];
        NSMutableArray *itemArray = [NSMutableArray array];
        if (model.items.length) {
            NSArray *items = [model.items transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *bpDict = [NSMutableDictionary dictionary];
                [bpDict setObject:@([[item objectForKey:@"timestamp"] integerValue]+DHTimeZoneInterval) forKey:@"timestamp"];
                [bpDict setObject:item[@"systolic"] forKey:@"sbp"];
                [bpDict setObject:item[@"diastolic"] forKey:@"dbp"];
                [itemArray addObject:bpDict];
            }
        }
        [dict setObject:itemArray forKey:@"details"];
        [dataArray addObject:dict];
    }
    [NetworkManager uploadBpWithParam:dataArray andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            for (DailyBpModel *model in bpArray) {
                model.isUpload = YES;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)uploadDailyBos {
    NSArray *boArray = [DailyBoModel queryUploadModels];
    if (boArray.count == 0) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DailyBoModel *model in boArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.userId forKey:@"memberId"];
        [dict setObject:model.macAddr forKey:@"deviceId"];
        [dict setObject:@([model.timestamp integerValue]+DHTimeZoneInterval) forKey:@"date"];
        NSMutableArray *itemArray = [NSMutableArray array];
        if (model.items.length) {
            NSArray *items = [model.items transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *boItem = [NSMutableDictionary dictionary];
                [boItem setObject:@([[item objectForKey:@"timestamp"] integerValue]+DHTimeZoneInterval) forKey:@"timestamp"];
                [boItem setObject:[item objectForKey:@"value"] forKey:@"value"];
                [itemArray addObject:boItem];
            }
        }
        [dict setObject:itemArray forKey:@"details"];
        [dataArray addObject:dict];
    }
    [NetworkManager uploadBoWithParam:dataArray andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            for (DailyBoModel *model in boArray) {
                model.isUpload = YES;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)uploadDailyTemps {
    NSArray *tempArray = [DailyTempModel queryUploadModels];
    if (tempArray.count == 0) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DailyTempModel *model in tempArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.userId forKey:@"memberId"];
        [dict setObject:model.macAddr forKey:@"deviceId"];
        [dict setObject:@([model.timestamp integerValue]+DHTimeZoneInterval) forKey:@"date"];
        NSMutableArray *itemArray = [NSMutableArray array];
        if (model.items.length) {
            NSArray *items = [model.items transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *tempItem = [NSMutableDictionary dictionary];
                [tempItem setObject:@([[item objectForKey:@"timestamp"] integerValue]+DHTimeZoneInterval) forKey:@"timestamp"];
                [tempItem setObject:[item objectForKey:@"value"] forKey:@"value"];
                [itemArray addObject:tempItem];
            }
        }
        [dict setObject:itemArray forKey:@"details"];
        [dataArray addObject:dict];
    }
    [NetworkManager uploadTempWithParam:dataArray andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            for (DailyTempModel *model in tempArray) {
                model.isUpload = YES;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)uploadDailyBreaths {
    NSArray *breathArray = [DailyBreathModel queryUploadModels];
    if (breathArray.count == 0) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DailyBreathModel *model in breathArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.userId forKey:@"memberId"];
        [dict setObject:model.macAddr forKey:@"deviceId"];
        [dict setObject:@([model.timestamp integerValue]+DHTimeZoneInterval) forKey:@"date"];
        NSMutableArray *itemArray = [NSMutableArray array];
        if (model.items.length) {
            NSArray *items = [model.items transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *breathItem = [NSMutableDictionary dictionary];
                [breathItem setObject:@([[item objectForKey:@"timestamp"] integerValue]+DHTimeZoneInterval) forKey:@"timestamp"];
                [breathItem setObject:[item objectForKey:@"value"] forKey:@"value"];
                [itemArray addObject:breathItem];
            }
        }
        [dict setObject:itemArray forKey:@"details"];
        [dataArray addObject:dict];
    }
    [NetworkManager uploadBreathWithParam:dataArray andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            for (DailyBreathModel *model in breathArray) {
                model.isUpload = YES;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)uploadDailySports {
    NSArray *sportArray = [DailySportModel queryUploadModels];
    if (sportArray.count == 0) {
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    for (DailySportModel *model in sportArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSInteger from = model.isDevice ? 1 : 0;
        [dict setObject:model.userId forKey:@"memberId"];
        [dict setObject:model.macAddr forKey:@"deviceId"];
        [dict setObject:@([model.timestamp integerValue]+DHTimeZoneInterval) forKey:@"timestamp"];
        [dict setObject:@(from) forKey:@"from"];
        [dict setObject:@(model.type) forKey:@"type"];
        [dict setObject:@(model.duration) forKey:@"totalTime"];
        [dict setObject:@(model.distance) forKey:@"totalDistance"];
        [dict setObject:@(model.step) forKey:@"totalStep"];
        [dict setObject:@(model.calorie) forKey:@"totalCal"];
        
        NSMutableArray *hrArray = [NSMutableArray array];
        NSMutableArray *metricPaceArray = [NSMutableArray array];
        NSMutableArray *imperialPaceArray = [NSMutableArray array];
        NSMutableArray *stepArray = [NSMutableArray array];
        NSMutableArray *gpsArray = [NSMutableArray array];
        
        if (model.heartRateItems.length) {
            NSArray *items = [model.heartRateItems transToObject];
            [hrArray addObjectsFromArray:items];
        }
        
        if (model.metricPaceItems.length) {
            NSArray *items = [model.metricPaceItems transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *paceItem = [NSMutableDictionary dictionary];
                [paceItem setObject:[item objectForKey:@"index"] forKey:@"index"];
                [paceItem setObject:[item objectForKey:@"value"] forKey:@"pace"];
                [paceItem setObject:[item objectForKey:@"isInt"] forKey:@"isWhole"];
                [metricPaceArray addObject:paceItem];
            }
        }
        
        if (model.imperialPaceItems.length) {
            NSArray *items = [model.imperialPaceItems transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *paceItem = [NSMutableDictionary dictionary];
                [paceItem setObject:[item objectForKey:@"index"] forKey:@"index"];
                [paceItem setObject:[item objectForKey:@"value"] forKey:@"pace"];
                [paceItem setObject:[item objectForKey:@"isInt"] forKey:@"isWhole"];
                [imperialPaceArray addObject:paceItem];
            }
        }
        
        if (model.strideFrequencyItems.length) {
            NSArray *items = [model.strideFrequencyItems transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *stepItem = [NSMutableDictionary dictionary];
                [stepItem setObject:[item objectForKey:@"index"] forKey:@"index"];
                [stepItem setObject:[item objectForKey:@"value"] forKey:@"frequency"];
                [stepArray addObject:stepItem];
            }
        }
        
        if (model.gpsItems.length) {
            NSArray *items = [model.gpsItems transToObject];
            for (NSDictionary *item in items) {
                NSMutableDictionary *gpsItem = [NSMutableDictionary dictionary];
                [gpsItem setObject:[item objectForKey:@"longtitude"] forKey:@"lng"];
                [gpsItem setObject:[item objectForKey:@"latitude"] forKey:@"lat"];
                [gpsArray addObject:gpsItem];
            }
        }
        
        [dict setObject:hrArray forKey:@"heartRates"];
        [dict setObject:metricPaceArray forKey:@"kmPaces"];
        [dict setObject:imperialPaceArray forKey:@"milePaces"];
        [dict setObject:stepArray forKey:@"stepFrequencies"];
        [dict setObject:gpsArray forKey:@"locations"];
        
        [dataArray addObject:dict];
    }
    [NetworkManager uploadSportWithParam:dataArray andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            for (DailySportModel *model in sportArray) {
                model.isUpload = YES;
                [model saveOrUpdate];
            }
        }
    }];
}

#pragma mark - 下载数据

+ (void)downloadDailySteps {
    NSDate *startDate = [[NSDate date] dateAfterDay:-100];
    NSDate *endDate = [[NSDate date] dateAfterDay:1];
    NSString *startTimestamp = [NSDate get1970timeTempWithDateStr:[startDate dateToStringFormat:@"yyyyMMdd"]];
    NSString *endTimestamp = [NSDate get1970timeTempWithDateStr:[endDate dateToStringFormat:@"yyyyMMdd"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@([startTimestamp integerValue]+DHTimeZoneInterval) forKey:@"startDate"];
    [dict setObject:@([endTimestamp integerValue]+DHTimeZoneInterval) forKey:@"endDate"];
    [NetworkManager downloadStepWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dateItem in array) {
                NSInteger timestamp = [[dateItem objectForKey:@"date"] integerValue]-DHTimeZoneInterval;
                DailyStepModel *model = [DailyStepModel queryModel:[NSString stringWithFormat:@"%ld",(long)timestamp]];
                if (!model) {
                    model = [[DailyStepModel alloc] init];
                }
                model.isUpload = YES;
                model.macAddr = [dateItem objectForKey:@"deviceId"];
                model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                model.date = [date dateToStringFormat:@"yyyyMMdd"];
                
                model.step = [[dateItem objectForKey:@"step"] integerValue];
                model.distance = [[dateItem objectForKey:@"distance"] integerValue];
                model.calorie = [[dateItem objectForKey:@"cal"] integerValue];
                
                NSMutableArray *items = [NSMutableArray array];
                for (int i = 0; i < 24; i++) {
                    NSMutableDictionary *item = [NSMutableDictionary dictionary];
                    [item setObject:@(i) forKey:@"index"];
                    [item setObject:@(0) forKey:@"step"];
                    [item setObject:@(0) forKey:@"calorie"];
                    [item setObject:@(0) forKey:@"distance"];
                    [items addObject:item];
                }
                NSArray *details = [dateItem objectForKey:@"details"];
                for (NSDictionary *item in details) {
                    NSInteger index = [[item objectForKey:@"index"] integerValue];
                    NSMutableDictionary *stepItem = [NSMutableDictionary dictionary];
                    [stepItem setObject:@(index) forKey:@"index"];
                    [stepItem setObject:[item objectForKey:@"step"] forKey:@"step"];
                    [stepItem setObject:[item objectForKey:@"distance"] forKey:@"distance"];
                    [stepItem setObject:[item objectForKey:@"cal"] forKey:@"calorie"];
                    [items replaceObjectAtIndex:index withObject:stepItem];
                }
                model.items = [items transToJsonString];
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)downloadDailySleeps {
    NSDate *startDate = [[NSDate date] dateAfterDay:-100];
    NSDate *endDate = [[NSDate date] dateAfterDay:1];
    NSString *startTimestamp = [NSDate get1970timeTempWithDateStr:[startDate dateToStringFormat:@"yyyyMMdd"]];
    NSString *endTimestamp = [NSDate get1970timeTempWithDateStr:[endDate dateToStringFormat:@"yyyyMMdd"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@([startTimestamp integerValue]+DHTimeZoneInterval) forKey:@"startDate"];
    [dict setObject:@([endTimestamp integerValue]+DHTimeZoneInterval) forKey:@"endDate"];
    [NetworkManager downloadSleepWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dateItem in array) {
                NSInteger timestamp = [[dateItem objectForKey:@"date"] integerValue]-DHTimeZoneInterval;
                DailySleepModel *model = [DailySleepModel queryModel:[NSString stringWithFormat:@"%ld",(long)timestamp]];
                if (!model) {
                    model = [[DailySleepModel alloc] init];
                }
                model.isUpload = YES;
                model.macAddr = [dateItem objectForKey:@"deviceId"];
                model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                model.date = [date dateToStringFormat:@"yyyyMMdd"];
                
                model.total = [[dateItem objectForKey:@"totalTime"] integerValue];
                
                NSInteger beginTime = [[dateItem objectForKey:@"startTime"] integerValue]-DHTimeZoneInterval;
                NSInteger endTime = [[dateItem objectForKey:@"endTime"] integerValue]-DHTimeZoneInterval;
                model.beginTime = [NSString stringWithFormat:@"%ld",(long)beginTime];
                model.endTime = [NSString stringWithFormat:@"%ld",(long)endTime];
                
                NSInteger deep = 0;
                NSInteger light = 0;
                NSInteger wake = 0;
                NSInteger wakeCount = 0;
                NSMutableArray *items = [NSMutableArray array];
                NSArray *details = [dateItem objectForKey:@"details"];
                for (NSDictionary *item in details) {
                    NSMutableDictionary *sleepItem = [NSMutableDictionary dictionary];
                    [sleepItem setObject:[item objectForKey:@"type"] forKey:@"status"];
                    [sleepItem setObject:[item objectForKey:@"period"] forKey:@"value"];
                    if ([[item objectForKey:@"type"] integerValue] == 0) {
                        wake += [[item objectForKey:@"period"] integerValue];
                        wakeCount++;
                    } else if ([[item objectForKey:@"type"] integerValue] == 1) {
                        light += [[item objectForKey:@"period"] integerValue];
                    } else {
                        deep += [[item objectForKey:@"period"] integerValue];
                    }
                    [items addObject:sleepItem];
                }
                model.items = items.count ? [items transToJsonString] : @"";
                model.deep = deep;
                model.light = light;
                model.wake = wake;
                model.wakeCount = wakeCount;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)downloadDailyHrs {
    NSDate *startDate = [[NSDate date] dateAfterDay:-100];
    NSDate *endDate = [[NSDate date] dateAfterDay:1];
    NSString *startTimestamp = [NSDate get1970timeTempWithDateStr:[startDate dateToStringFormat:@"yyyyMMdd"]];
    NSString *endTimestamp = [NSDate get1970timeTempWithDateStr:[endDate dateToStringFormat:@"yyyyMMdd"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@([startTimestamp integerValue]+DHTimeZoneInterval) forKey:@"startDate"];
    [dict setObject:@([endTimestamp integerValue]+DHTimeZoneInterval) forKey:@"endDate"];
    [NetworkManager downloadHeartRateWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dateItem in array) {
                NSInteger timestamp = [[dateItem objectForKey:@"date"] integerValue]-DHTimeZoneInterval;
                DailyHeartRateModel *model = [DailyHeartRateModel queryModel:[NSString stringWithFormat:@"%ld",(long)timestamp]];
                if (!model) {
                    model = [[DailyHeartRateModel alloc] init];
                }
                model.isUpload = YES;
                model.macAddr = [dateItem objectForKey:@"deviceId"];
                model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                model.date = [date dateToStringFormat:@"yyyyMMdd"];
                
                NSMutableArray *items = [NSMutableArray array];
                NSMutableArray *valueArray = [NSMutableArray array];
                NSArray *details = [dateItem objectForKey:@"details"];
                for (NSDictionary *item in details) {
                    NSMutableDictionary *hrItem = [NSMutableDictionary dictionary];
                    NSInteger timestamp = [[item objectForKey:@"timestamp"] integerValue]-DHTimeZoneInterval;
                    [hrItem setObject:@(timestamp) forKey:@"timestamp"];
                    [hrItem setObject:[item objectForKey:@"value"] forKey:@"value"];
                    [items addObject:hrItem];
                    [valueArray addObject:[item objectForKey:@"value"]];
                }
                model.items = items.count ? [items transToJsonString] : @"";
                model.avgHr = valueArray.count ? [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
                model.maxHr = valueArray.count ? [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
                model.minHr = valueArray.count ? [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
                model.lastHr = valueArray.count ? [[valueArray lastObject] integerValue] : 0;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)downloadDailyBps {
    NSDate *startDate = [[NSDate date] dateAfterDay:-100];
    NSDate *endDate = [[NSDate date] dateAfterDay:1];
    NSString *startTimestamp = [NSDate get1970timeTempWithDateStr:[startDate dateToStringFormat:@"yyyyMMdd"]];
    NSString *endTimestamp = [NSDate get1970timeTempWithDateStr:[endDate dateToStringFormat:@"yyyyMMdd"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@([startTimestamp integerValue]+DHTimeZoneInterval) forKey:@"startDate"];
    [dict setObject:@([endTimestamp integerValue]+DHTimeZoneInterval) forKey:@"endDate"];
    [NetworkManager downloadBpWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dateItem in array) {
                NSInteger timestamp = [[dateItem objectForKey:@"date"] integerValue]-DHTimeZoneInterval;
                DailyBpModel *model = [DailyBpModel queryModel:[NSString stringWithFormat:@"%ld",(long)timestamp]];
                if (!model) {
                    model = [[DailyBpModel alloc] init];
                }
                model.isUpload = YES;
                model.macAddr = [dateItem objectForKey:@"deviceId"];
                model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                model.date = [date dateToStringFormat:@"yyyyMMdd"];
                
                NSMutableArray *items = [NSMutableArray array];
                NSMutableArray *systolicArray = [NSMutableArray array];
                NSMutableArray *diastolicArray = [NSMutableArray array];
                NSArray *details = [dateItem objectForKey:@"details"];
                for (NSDictionary *item in details) {
                    NSMutableDictionary *bpItem = [NSMutableDictionary dictionary];
                    NSInteger timestamp = [[item objectForKey:@"timestamp"] integerValue]-DHTimeZoneInterval;
                    [bpItem setObject:@(timestamp) forKey:@"timestamp"];
                    [bpItem setObject:[item objectForKey:@"sbp"] forKey:@"systolic"];
                    [bpItem setObject:[item objectForKey:@"dbp"] forKey:@"diastolic"];
                    [items addObject:bpItem];
                    [systolicArray addObject:[item objectForKey:@"sbp"]];
                    [diastolicArray addObject:[item objectForKey:@"dbp"]];
                }
                model.items = items.count ? [items transToJsonString] : @"";
                model.avgSystolic = systolicArray.count ? [[systolicArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
                model.avgDiastolic = diastolicArray.count ? [[diastolicArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
                model.maxSystolic = systolicArray.count ? [[systolicArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
                model.maxDiastolic = diastolicArray.count ? [[diastolicArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
                model.minSystolic = systolicArray.count ? [[systolicArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
                model.minDiastolic = diastolicArray.count ? [[diastolicArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
                model.lastSystolic = systolicArray.count ? [[systolicArray lastObject] integerValue] : 0;
                model.lastDiastolic = diastolicArray.count ? [[diastolicArray lastObject] integerValue] : 0;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)downloadDailyBos {
    NSDate *startDate = [[NSDate date] dateAfterDay:-100];
    NSDate *endDate = [[NSDate date] dateAfterDay:1];
    NSString *startTimestamp = [NSDate get1970timeTempWithDateStr:[startDate dateToStringFormat:@"yyyyMMdd"]];
    NSString *endTimestamp = [NSDate get1970timeTempWithDateStr:[endDate dateToStringFormat:@"yyyyMMdd"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@([startTimestamp integerValue]+DHTimeZoneInterval) forKey:@"startDate"];
    [dict setObject:@([endTimestamp integerValue]+DHTimeZoneInterval) forKey:@"endDate"];
    [NetworkManager downloadBoWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dateItem in array) {
                NSInteger timestamp = [[dateItem objectForKey:@"date"] integerValue]-DHTimeZoneInterval;
                DailyBoModel *model = [DailyBoModel queryModel:[NSString stringWithFormat:@"%ld",(long)timestamp]];
                if (!model) {
                    model = [[DailyBoModel alloc] init];
                }
                model.isUpload = YES;
                model.macAddr = [dateItem objectForKey:@"deviceId"];
                model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                model.date = [date dateToStringFormat:@"yyyyMMdd"];
                
                NSMutableArray *items = [NSMutableArray array];
                NSMutableArray *valueArray = [NSMutableArray array];
                NSArray *details = [dateItem objectForKey:@"details"];
                for (NSDictionary *item in details) {
                    NSMutableDictionary *boItem = [NSMutableDictionary dictionary];
                    NSInteger timestamp = [[item objectForKey:@"timestamp"] integerValue]-DHTimeZoneInterval;
                    [boItem setObject:@(timestamp) forKey:@"timestamp"];
                    [boItem setObject:[item objectForKey:@"value"] forKey:@"value"];
                    [items addObject:boItem];
                    [valueArray addObject:[item objectForKey:@"value"]];
                }
                model.items = items.count ? [items transToJsonString] : @"";
                model.avgBo = valueArray.count ? [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
                model.maxBo = valueArray.count ? [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
                model.minBo = valueArray.count ? [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
                model.lastBo = valueArray.count ? [[valueArray lastObject] integerValue] : 0;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)downloadDailyTemps {
    NSDate *startDate = [[NSDate date] dateAfterDay:-100];
    NSDate *endDate = [[NSDate date] dateAfterDay:1];
    NSString *startTimestamp = [NSDate get1970timeTempWithDateStr:[startDate dateToStringFormat:@"yyyyMMdd"]];
    NSString *endTimestamp = [NSDate get1970timeTempWithDateStr:[endDate dateToStringFormat:@"yyyyMMdd"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@([startTimestamp integerValue]+DHTimeZoneInterval) forKey:@"startDate"];
    [dict setObject:@([endTimestamp integerValue]+DHTimeZoneInterval) forKey:@"endDate"];
    [NetworkManager downloadTempWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dateItem in array) {
                NSInteger timestamp = [[dateItem objectForKey:@"date"] integerValue]-DHTimeZoneInterval;
                DailyTempModel *model = [DailyTempModel queryModel:[NSString stringWithFormat:@"%ld",(long)timestamp]];
                if (!model) {
                    model = [[DailyTempModel alloc] init];
                }
                model.isUpload = YES;
                model.macAddr = [dateItem objectForKey:@"deviceId"];
                model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                model.date = [date dateToStringFormat:@"yyyyMMdd"];
                
                NSMutableArray *items = [NSMutableArray array];
                NSMutableArray *valueArray = [NSMutableArray array];
                NSArray *details = [dateItem objectForKey:@"details"];
                for (NSDictionary *item in details) {
                    NSMutableDictionary *boItem = [NSMutableDictionary dictionary];
                    NSInteger timestamp = [[item objectForKey:@"timestamp"] integerValue]-DHTimeZoneInterval;
                    [boItem setObject:@(timestamp) forKey:@"timestamp"];
                    [boItem setObject:[item objectForKey:@"value"] forKey:@"value"];
                    [items addObject:boItem];
                    [valueArray addObject:[item objectForKey:@"value"]];
                }
                model.items = items.count ? [items transToJsonString] : @"";
                model.avgTemp = valueArray.count ? [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue] : 0;
                model.maxTemp = valueArray.count ? [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue] : 0;
                model.minTemp = valueArray.count ? [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue] : 0;
                model.lastTemp = valueArray.count ? [[valueArray lastObject] integerValue] : 0;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)downloadDailyBreaths {
    NSDate *startDate = [[NSDate date] dateAfterDay:-100];
    NSDate *endDate = [[NSDate date] dateAfterDay:1];
    NSString *startTimestamp = [NSDate get1970timeTempWithDateStr:[startDate dateToStringFormat:@"yyyyMMdd"]];
    NSString *endTimestamp = [NSDate get1970timeTempWithDateStr:[endDate dateToStringFormat:@"yyyyMMdd"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@([startTimestamp integerValue]+DHTimeZoneInterval) forKey:@"startDate"];
    [dict setObject:@([endTimestamp integerValue]+DHTimeZoneInterval) forKey:@"endDate"];
    [NetworkManager downloadBreathWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dateItem in array) {
                NSInteger timestamp = [[dateItem objectForKey:@"date"] integerValue]-DHTimeZoneInterval;
                DailyBreathModel *model = [DailyBreathModel queryModel:[NSString stringWithFormat:@"%ld",(long)timestamp]];
                if (!model) {
                    model = [[DailyBreathModel alloc] init];
                }
                model.isUpload = YES;
                model.macAddr = [dateItem objectForKey:@"deviceId"];
                model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                model.date = [date dateToStringFormat:@"yyyyMMdd"];
                
                NSMutableArray *items = [NSMutableArray array];
                NSMutableArray *valueArray = [NSMutableArray array];
                NSArray *details = [dateItem objectForKey:@"details"];
                for (NSDictionary *item in details) {
                    NSMutableDictionary *breathItem = [NSMutableDictionary dictionary];
                    NSInteger timestamp = [[item objectForKey:@"timestamp"] integerValue]-DHTimeZoneInterval;
                    [breathItem setObject:@(timestamp) forKey:@"timestamp"];
                    [breathItem setObject:[item objectForKey:@"value"] forKey:@"value"];
                    [items addObject:breathItem];
                    [valueArray addObject:[item objectForKey:@"value"]];
                }
                
                model.items = items.count ? [items transToJsonString] : @"";
                model.duration = valueArray.count ? [[valueArray valueForKeyPath:@"@sum.floatValue"] floatValue] : 0;
                [model saveOrUpdate];
            }
        }
    }];
}

+ (void)downloadDailySports {
    NSDate *startDate = [[NSDate date] dateAfterDay:-100];
    NSDate *endDate = [[NSDate date] dateAfterDay:1];
    NSString *startTimestamp = [NSDate get1970timeTempWithDateStr:[startDate dateToStringFormat:@"yyyyMMdd"]];
    NSString *endTimestamp = [NSDate get1970timeTempWithDateStr:[endDate dateToStringFormat:@"yyyyMMdd"]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@([startTimestamp integerValue]+DHTimeZoneInterval) forKey:@"startDate"];
    [dict setObject:@([endTimestamp integerValue]+DHTimeZoneInterval) forKey:@"endDate"];
    [NetworkManager downloadSportWithParam:dict andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        if (resultCode == 0) {
            NSArray *array = (NSArray *)data;
            for (NSDictionary *dateItem in array) {
                NSInteger timestamp = [[dateItem objectForKey:@"timestamp"] integerValue]-DHTimeZoneInterval;
                DailySportModel *model = [DailySportModel queryModel:[NSString stringWithFormat:@"%ld",(long)timestamp]];
                if (!model) {
                    model = [[DailySportModel alloc] init];
                    model.isUpload = YES;
                    model.macAddr = [dateItem objectForKey:@"deviceId"];
                    model.timestamp = [NSString stringWithFormat:@"%ld",(long)timestamp];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    model.date = [date dateToStringFormat:@"yyyyMMdd"];
                    
                    model.isDevice = [[dateItem objectForKey:@"from"] integerValue];
                    model.type = [[dateItem objectForKey:@"type"] integerValue];
                    model.duration = [[dateItem objectForKey:@"totalTime"] integerValue];
                    model.distance = [[dateItem objectForKey:@"totalDistance"] integerValue];
                    model.step = [[dateItem objectForKey:@"totalStep"] integerValue];
                    model.calorie = [[dateItem objectForKey:@"totalCal"] integerValue];
                    
                    NSMutableArray *hrItems = [NSMutableArray array];
                    NSMutableArray *metricPaceItems = [NSMutableArray array];
                    NSMutableArray *imperialPaceItems = [NSMutableArray array];
                    NSMutableArray *stepItems = [NSMutableArray array];
                    NSMutableArray *gpsItems = [NSMutableArray array];
                    
                    NSArray *hrArray = [dateItem objectForKey:@"heartRates"];
                    if (hrArray.count) {
                        [hrItems addObjectsFromArray:hrArray];
                    }
                    
                    NSArray *metricPaceArray = [dateItem objectForKey:@"kmPaces"];
                    for (NSDictionary *item in metricPaceArray) {
                        NSMutableDictionary *paceItem = [NSMutableDictionary dictionary];
                        [paceItem setObject:[item objectForKey:@"index"] forKey:@"index"];
                        [paceItem setObject:[item objectForKey:@"pace"] forKey:@"value"];
                        [paceItem setObject:[item objectForKey:@"isWhole"] forKey:@"isInt"];
                        [metricPaceItems addObject:paceItem];
                    }
                    
                    NSArray *imperialPaceArray = [dateItem objectForKey:@"milePaces"];
                    for (NSDictionary *item in imperialPaceArray) {
                        NSMutableDictionary *paceItem = [NSMutableDictionary dictionary];
                        [paceItem setObject:[item objectForKey:@"index"] forKey:@"index"];
                        [paceItem setObject:[item objectForKey:@"pace"] forKey:@"value"];
                        [paceItem setObject:[item objectForKey:@"isWhole"] forKey:@"isInt"];
                        [imperialPaceItems addObject:paceItem];
                    }
                    
                    NSArray *stepArray = [dateItem objectForKey:@"stepFrequencies"];
                    for (NSDictionary *item in stepArray) {
                        NSMutableDictionary *stepItem = [NSMutableDictionary dictionary];
                        [stepItem setObject:[item objectForKey:@"index"] forKey:@"index"];
                        [stepItem setObject:[item objectForKey:@"frequency"] forKey:@"value"];
                        [stepItems addObject:stepItem];
                    }
                    
                    NSArray *gpsArray = [dateItem objectForKey:@"locations"];
                    for (NSDictionary *item in gpsArray) {
                        NSMutableDictionary *gpsItem = [NSMutableDictionary dictionary];
                        [gpsItem setObject:[item objectForKey:@"lng"] forKey:@"longtitude"];
                        [gpsItem setObject:[item objectForKey:@"lat"] forKey:@"latitude"];
                        [gpsItems addObject:gpsItem];
                    }
                    
                    model.heartRateItems = hrItems.count ? [hrItems transToJsonString] : @"";
                    model.metricPaceItems = metricPaceItems.count ? [metricPaceItems transToJsonString] : @"";
                    model.imperialPaceItems = imperialPaceItems.count ? [imperialPaceItems transToJsonString] : @"";
                    model.strideFrequencyItems = stepItems.count ? [stepItems transToJsonString] : @"";
                    model.gpsItems = gpsItems.count ? [gpsItems transToJsonString] : @"";
                    [model saveOrUpdate];
                }
            }
        }
    }];
}

@end
