//
//  HealthDataManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/13.
//

#import "HealthDataManager.h"

@implementation HealthDataManager

#pragma mark - 基本属性

+ (NSArray *)weeks {
    return @[Lang(@"str_sunday"),
             Lang(@"str_monday"),
             Lang(@"str_tuesday"),
             Lang(@"str_wednesday"),
             Lang(@"str_thursday"),
             Lang(@"str_friday"),
             Lang(@"str_saturday")];
}

+ (UIColor *)mainColor:(HealthDataType)cellType {
    if (cellType == HealthDataTypeStep) {
        return COLOR(@"#69D4E3");
    }
    if (cellType == HealthDataTypeSleep) {
        return COLOR(@"#17FFF1");
    }
    if (cellType == HealthDataTypeHeartRate) {
        return COLOR(@"#DD2A44");
    }
    if (cellType == HealthDataTypeBO) {
        return COLOR(@"#D42725");
    }
    if (cellType == HealthDataTypeTemp) {
        return COLOR(@"#94FF4C");
    }
    if (cellType == HealthDataTypeBreath) {
        return COLOR(@"#7BB5BE");
    }
    return [UIColor whiteColor];
}

+ (UIColor *)sleepMainColor:(SleepDataType)sleepType {
    if (sleepType == SleepDataTypeWake) {
        return COLOR(@"#FFD700");
    }
    if (sleepType == SleepDataTypeLight) {
        return COLOR(@"#041DD8");
    }
    if (sleepType == SleepDataTypeDeep) {
        return COLOR(@"#8A1AFD");
    }
    return COLOR(@"#8A1AFD");
}

+ (NSString *)unitOfType:(HealthDataType)cellType {
    if (cellType == HealthDataTypeStep) {
        return StepUnit;
    }
    if (cellType == HealthDataTypeHeartRate) {
        return HrUnit;
    }
    if (cellType == HealthDataTypeBO) {
        return @"%";
    }
    if (cellType == HealthDataTypeTemp) {
        return TempUnit;
    }
    if (cellType == HealthDataTypeBreath) {
        return MinuteUnit;
    }
    return @"";
}

+ (NSArray *)chartXTitle:(HealthDateType)dateType {
    NSMutableArray *xTitles = [NSMutableArray array];
    if (dateType == HealthDateTypeDay) {
        for (int i = 0; i < 24; i++) {
            NSString *title = i == 23 ? @"23:59" : [NSString stringWithFormat:@"%02ld:00",(long)i];
            [xTitles addObject:title];
        }
    } else if (dateType == HealthDateTypeWeek) {
        [xTitles addObjectsFromArray:[self weeks]];
    } else if (dateType == HealthDateTypeMonth) {
        for (int i = 1; i < 31; i++) {
            NSString *title = [NSString stringWithFormat:@"%ld",(long)i];
            [xTitles addObject:title];
        }
    } else {
        for (int i = 1; i < 13; i++) {
            NSString *title = [NSString stringWithFormat:@"%ld",(long)i];
            [xTitles addObject:title];
        }
    }
    
    
    return xTitles;
    
}

#pragma mark - 详情TableViewCell内容

+ (NSArray *)detailDataCellDayTitles:(HealthDataType)type {
    NSArray *titles = [NSArray array];
    if (type == HealthDataTypeStep) {
        UserModel *model = [UserModel currentModel];
        titles =@[Lang(@"str_total_step"),
                  @"",
                  [NSString stringWithFormat:@"%@:%ld%@",Lang(@"str_target"),(long)model.stepGoal,StepUnit],
                  Lang(@"str_cost_cal"),
                  Lang(@"str_distance")];
    } else if (type == HealthDataTypeSleep) {
        titles =@[Lang(@"str_total_sleep_time"),
                  Lang(@"str_deep_time"),
                  Lang(@"str_light_time"),
                  Lang(@"str_sleep_time"),
                  Lang(@"str_wake_time"),
                  Lang(@"str_wake_times")];
    } else if (type == HealthDataTypeHeartRate) {
        titles =@[Lang(@"str_current_hr"),
                  Lang(@"str_avg_hr"),
                  Lang(@"str_max_hr"),
                  Lang(@"str_min_hr")];
    } else if (type == HealthDataTypeBP) {
        titles =@[Lang(@"str_current_bp"),
                  Lang(@"str_avg_bp"),
                  Lang(@"str_max_bp_sp"),
                  Lang(@"str_min_bp_sp"),
                  Lang(@"str_max_bp_dp"),
                  Lang(@"str_min_bp_dp")];
    } else if (type == HealthDataTypeBO) {
        titles =@[Lang(@"str_current_bo"),
                  Lang(@"str_avg_bo"),
                  Lang(@"str_max_bo"),
                  Lang(@"str_min_bo")];
    } else if (type == HealthDataTypeTemp) {
        titles =@[Lang(@"str_current_bt"),
                  Lang(@"str_avg_bt"),
                  Lang(@"str_max_bt"),
                  Lang(@"str_min_bt")];
    }
    return titles;
}

+ (NSArray *)detailDataCellWeekTitles:(HealthDataType)type {
    NSArray *titles= [NSArray array];
    if (type == HealthDataTypeStep) {
        titles =@[Lang(@"str_total_step"),
                  Lang(@"str_day_avg_step"),
                  Lang(@"str_total_cal"),
                  Lang(@"str_day_avg_cal"),
                  Lang(@"str_total_distance"),
                  Lang(@"str_day_avg_distance")];
    } else if (type == HealthDataTypeSleep) {
        titles =@[Lang(@"str_total_sleep_time"),
                  Lang(@"str_day_avg_sleep_time"),
                  Lang(@"str_deep_time"),
                  Lang(@"str_day_avg_deep_time"),
                  Lang(@"str_light_time"),
                  Lang(@"str_day_avg_light_time"),
                  Lang(@"str_wake_times"),
                  Lang(@"str_day_avg_wake_time")];
    } else if (type == HealthDataTypeHeartRate) {
        titles =@[Lang(@"str_day_avg_hr"),
                  Lang(@"str_max_hr"),
                  Lang(@"str_min_hr")];
    } else if (type == HealthDataTypeBP) {
        titles =@[Lang(@"str_day_avg_bp"),
                  Lang(@"str_max_bp_sp"),
                  Lang(@"str_min_bp_sp"),
                  Lang(@"str_max_bp_dp"),
                  Lang(@"str_min_bp_dp")];
    } else if (type == HealthDataTypeBO) {
        titles =@[Lang(@"str_day_avg_bo"),
                  Lang(@"str_max_bo"),
                  Lang(@"str_min_bo")];
    } else if (type == HealthDataTypeTemp) {
        titles =@[Lang(@"str_day_avg_bt"),
                  Lang(@"str_max_bt"),
                  Lang(@"str_min_bt")];
    } else if (type == HealthDataTypeBreath) {
        titles =@[Lang(@"str_total_training_time"),
                  Lang(@"str_average_training_time")];
    }
    return titles;
}

+ (NSArray *)detailDescCellTitles:(HealthDataType)type {
    NSArray *titles = [NSArray array];
    if (type == HealthDataTypeSleep) {
        titles =@[Lang(@"str_scien_tips"),
                  Lang(@"str_avg_sleep_time"),
                  Lang(@"str_avg_deep_sleep_percent"),
                  Lang(@"str_avg_light_sleep_percent"),
                  Lang(@"str_avg_wake_sleep_percent"),
                  Lang(@"str_avg_flow_sleep_time"),
                  Lang(@"str_avg_flow_wake_time"),
                  Lang(@"str_medical_tips")];
    } else if (type == HealthDataTypeHeartRate) {
        titles =@[Lang(@"str_scien_tips"),
                  Lang(@"str_range_hr"),
                  Lang(@"str_fast_hr"),
                  Lang(@"str_slow_hr"),
                  Lang(@"str_medical_tips")];
    } else if (type == HealthDataTypeBP) {
        titles =@[Lang(@"str_scien_tips"),
                  Lang(@"str_perface_bp_sp"),
                  Lang(@"str_perface_bp_dp"),
                  Lang(@"str_normal_bp_sp"),
                  Lang(@"str_normal_bp_dp"),
                  Lang(@"str_medical_tips")];
    } else if (type == HealthDataTypeBO) {
        titles =@[Lang(@"str_scien_tips"),
                  Lang(@"str_normal_bo_range"),
                  Lang(@"str_light_bo"),
                  Lang(@"str_middle_bo"),
                  Lang(@"str_weight_bo"),
                  Lang(@"str_medical_tips")];
    } else if (type == HealthDataTypeTemp) {
        titles =@[Lang(@"str_scien_tips"),
                  Lang(@"str_normal_bt_range"),
                  Lang(@"str_slow_bt"),
                  Lang(@"str_middle_bt"),
                  Lang(@"str_height_bt"),
                  Lang(@"str_medical_tips")];
    }
    return titles;
}

+ (NSArray *)detailDescCellSubTitles:(HealthDataType)type {
    NSArray *titles = [NSArray array];
    if (type == HealthDataTypeSleep) {
        titles = @[@"",
                   [NSString stringWithFormat:@"6-9%@",HourUnit],
                   @"20-60%",
                   @"<55%",
                   @"10-33%",
                   @"21:00-24:00",
                   @"06:00-08:00",
                   @""];
    } else if (type == HealthDataTypeHeartRate) {
        titles = @[@"",
                   [NSString stringWithFormat:@"60-100%@",HrUnit],
                   [NSString stringWithFormat:@">100%@",HrUnit],
                   [NSString stringWithFormat:@"<60%@",HrUnit],
                   @""];
    } else if (type == HealthDataTypeBP) {
        titles = @[@"",
                   [NSString stringWithFormat:@"<120%@",BpUnit],
                   [NSString stringWithFormat:@"<80%@",BpUnit],
                   [NSString stringWithFormat:@"90-140%@",BpUnit],
                   [NSString stringWithFormat:@"60-90%@",BpUnit],
                   @""];
    } else if (type == HealthDataTypeBO) {
        titles = @[@"",
                   @"SpO2≥95%",
                   @"80%≤SpO2＜95%",
                   @"70%≤SpO2＜80%",
                   @"SpO2＜70%",
                   @""];
    } else if (type == HealthDataTypeTemp) {
        titles = @[@"",
                   [NSString stringWithFormat:@"%.01f-%.01f%@",TempValue(360),TempValue(370),TempUnit],
                   [NSString stringWithFormat:@"%.01f-%.0f%@",TempValue(371),TempValue(380),TempUnit],
                   [NSString stringWithFormat:@"%.01f-%.01f%@",TempValue(381),TempValue(390),TempUnit],
                   [NSString stringWithFormat:@"%.01f-%.0f%@",TempValue(391),TempValue(410),TempUnit],
                   @""];
    }
    
    return titles;
}

#pragma mark - 日、周、月、年原始数据

+ (id)dayChartDatas:(NSDate *)date type:(HealthDataType)type {
    id model;
    NSString *dateStr = [date dateToStringFormat:@"yyyyMMdd"];
    switch (type) {
        case HealthDataTypeStep:
        {
            model = [DailyStepModel currentModel:dateStr];
        }
            break;
        case HealthDataTypeSleep:
        {
            model = [DailySleepModel currentModel:dateStr];
        }
            break;
        case HealthDataTypeHeartRate:
        {
            model = [DailyHeartRateModel currentModel:dateStr];
        }
            break;
        case HealthDataTypeBP:
        {
            model = [DailyBpModel currentModel:dateStr];
        }
            break;
        case HealthDataTypeBO:
        {
            model = [DailyBoModel currentModel:dateStr];
        }
            break;
        case HealthDataTypeTemp:
        {
            model = [DailyTempModel currentModel:dateStr];
        }
            break;
        case HealthDataTypeBreath:
        {
            model = [DailyBreathModel currentModel:dateStr];
        }
            break;
        default:
            break;
    }
    
    return model;
}

+ (NSArray *)weekChartDatas:(NSDate *)date type:(HealthDataType)type {
    
    NSArray *dates = [date getweekBeginAndEndWithFirstDay:1];
    NSDate *startDate = dates.firstObject;
    NSDate *endDate = dates.lastObject;
    
    NSString *startDateStr = [startDate dateToStringFormat:@"yyyyMMdd"];
    NSString *endDateStr = [endDate dateToStringFormat:@"yyyyMMdd"];
    
    NSArray *models = [NSArray array];
    switch (type) {
        case HealthDataTypeStep:
        {
            models = [DailyStepModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeSleep:
        {
            models = [DailySleepModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeHeartRate:
        {
            models = [DailyHeartRateModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeBP:
        {
            models = [DailyBpModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeBO:
        {
            models = [DailyBoModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeTemp:
        {
            models = [DailyTempModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeBreath:
        {
            models = [DailyBreathModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        default:
            break;
    }
    
    return models;
}

+ (NSArray *)monthChartDatas:(NSDate *)date type:(HealthDataType)type {
    
    NSArray *dates = [date getMonthBeginAndEnd];
    NSDate *startDate = dates.firstObject;
    NSDate *endDate = dates.lastObject;
    NSString *startDateStr = [startDate dateToStringFormat:@"yyyyMMdd"];
    NSString *endDateStr = [endDate dateToStringFormat:@"yyyyMMdd"];
    
    NSArray *models = [NSArray array];
    switch (type) {
        case HealthDataTypeStep:
        {
            models = [DailyStepModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeSleep:
        {
            models = [DailySleepModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeHeartRate:
        {
            models = [DailyHeartRateModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeBP:
        {
            models = [DailyBpModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeBO:
        {
            models = [DailyBoModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeTemp:
        {
            models = [DailyTempModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeBreath:
        {
            models = [DailyBreathModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        default:
            break;
    }
    return models;
}

+ (NSArray *)yearChartDatas:(NSDate *)date type:(HealthDataType)type {
    NSString *startDateStr = [NSString stringWithFormat:@"%04ld0101",(long)date.year];
    NSString *endDateStr = [NSString stringWithFormat:@"%04ld1231",(long)date.year];
    
    NSArray *models = [NSArray array];
    switch (type) {
        case HealthDataTypeStep:
        {
            models = [DailyStepModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeSleep:
        {
            models = [DailySleepModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeHeartRate:
        {
            models = [DailyHeartRateModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeBP:
        {
            models = [DailyBpModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeBO:
        {
            models = [DailyBoModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeTemp:
        {
            models = [DailyTempModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        case HealthDataTypeBreath:
        {
            models = [DailyBreathModel queryModels:startDateStr endDateStr:endDateStr];
        }
            break;
        default:
            break;
    }
    return models;
}

#pragma mark - 日、周、月、年图表数据

+ (ChartViewModel *)dayChartModel:(NSDate *)date type:(HealthDataType)type {
    ChartViewModel *chartModel = [[ChartViewModel alloc] init];
    chartModel.xTitles = [self chartXTitle:HealthDateTypeDay];
    
    NSMutableArray *yTitles = [NSMutableArray array];
    NSMutableArray *xPaths = [NSMutableArray array];
    NSMutableArray *yPaths = [NSMutableArray array];
    NSMutableArray *yPaths1 = [NSMutableArray array];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSInteger maxValue = 0;
    
    NSString *dateStr = [date dateToStringFormat:@"yyyyMMdd"];
    switch (type) {
        case HealthDataTypeStep:
        {
            DailyStepModel *model = [DailyStepModel currentModel:dateStr];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"step"] integerValue] > maxValue) {
                        maxValue = [item[@"step"] integerValue];
                    }
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:item[@"step"] forKey:@"value"];
                    [dict setObject:[NSString stringWithFormat:@"%02ld:00",(long)i] forKey:@"date"];
                    [dataArray addObject:dict];
                    
                    [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/24]];
                }
                for (int i = 0; i < dataArray.count; i++) {
                    NSDictionary *item = dataArray[i];
                    [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
                }
            }
        }
            break;
        case HealthDataTypeSleep:
        {
            DailySleepModel *model = [DailySleepModel currentModel:dateStr];
            NSInteger timestamp = [model.beginTime integerValue];
            NSInteger endtimestamp = [model.endTime integerValue];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                NSMutableArray *xTitles = [NSMutableArray array];
                NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endtimestamp];
                [xTitles addObject:[NSString stringWithFormat:@"%02ld:%02ld",(long)beginDate.hour,(long)beginDate.minute]];
                [xTitles addObject:[NSString stringWithFormat:@"%02ld:%02ld",(long)endDate.hour,(long)endDate.minute]];
                chartModel.xTitles = xTitles;
                
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"value"] integerValue] > maxValue) {
                        maxValue = [item[@"value"] integerValue];
                    }
                    
                    [dataArray addObject:item];
                    if ([item[@"status"] integerValue] == 0) {
                        [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*2/3]];
                    } else if ([item[@"status"] integerValue] == 1) {
                        [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*1/3]];
                    } else {
                        [yPaths addObject:@"0"];
                    }
                }
            }
            
            
        }
            break;
        case HealthDataTypeHeartRate:
        {
            DailyHeartRateModel *model = [DailyHeartRateModel currentModel:dateStr];
            NSInteger allTime = 24*60;
            NSInteger beginTimestamp = [[NSDate get1970timeTempWithDateStr:dateStr] integerValue];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                [dataArray addObjectsFromArray:array];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"value"] integerValue] > maxValue) {
                        maxValue = [item[@"value"] integerValue];
                    }
                    NSInteger timestamp = [item[@"timestamp"] integerValue];
                    NSInteger interval = (timestamp-beginTimestamp)/60;
                    [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*interval/allTime]];
                }
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
                }
            }
        }
            break;
        case HealthDataTypeBP:
        {
            DailyBpModel *model = [DailyBpModel currentModel:dateStr];
            NSInteger allTime = 24*60;
            NSInteger beginTimestamp = [[NSDate get1970timeTempWithDateStr:dateStr] integerValue];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                [dataArray addObjectsFromArray:array];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"systolic"] integerValue] > maxValue) {
                        maxValue = [item[@"systolic"] integerValue];
                    }
                    NSInteger timestamp = [item[@"timestamp"] integerValue];
                    NSInteger interval = (timestamp-beginTimestamp)/60;
                    [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*interval/allTime]];
                    
                }
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"systolic"] integerValue]/maxValue]];
                    [yPaths1 addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"diastolic"] integerValue]/maxValue]];
                }
            }
        }
            break;
        case HealthDataTypeBO:
        {
            DailyBoModel *model = [DailyBoModel currentModel:dateStr];
            NSInteger allTime = 24*60;
            NSInteger beginTimestamp = [[NSDate get1970timeTempWithDateStr:dateStr] integerValue];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                [dataArray addObjectsFromArray:array];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"value"] integerValue] > maxValue) {
                        maxValue = [item[@"value"] integerValue];
                    }
                    NSInteger timestamp = [item[@"timestamp"] integerValue];
                    NSInteger interval = (timestamp-beginTimestamp)/60;
                    [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*interval/allTime]];
                }
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
                }
            }
        }
            break;
            
        case HealthDataTypeTemp:
        {
            DailyTempModel *model = [DailyTempModel currentModel:dateStr];
            NSInteger allTime = 24*60;
            NSInteger beginTimestamp = [[NSDate get1970timeTempWithDateStr:dateStr] integerValue];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                [dataArray addObjectsFromArray:array];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    CGFloat temp = [item[@"value"] integerValue] > 0 ? TempValue([item[@"value"] integerValue]) : 0;
                    if (ceil(temp) > maxValue) {
                        maxValue = ceil(temp);
                    }
                    NSInteger timestamp = [item[@"timestamp"] integerValue];
                    NSInteger interval = (timestamp-beginTimestamp)/60;
                    [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*interval/allTime]];
                }
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    CGFloat temp = [item[@"value"] integerValue] > 0 ? TempValue([item[@"value"] integerValue]) : 0;
                    [yPaths addObject:[NSString stringWithFormat:@"%f",temp/maxValue]];
                }
            }
        }
            break;
        case HealthDataTypeBreath:
        {
            DailyBreathModel *model = [DailyBreathModel currentModel:dateStr];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                [dataArray addObjectsFromArray:array];
            }
        }
            break;
        default:
            break;
    }
    if (maxValue > 0) {
        NSInteger yCount = 3;
        for (int i = 0; i < yCount; i++) {
            if (i == yCount-1) {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)maxValue]];
            } else {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)(i+1)*maxValue/yCount]];
            }
        }
    }
    chartModel.yTitles = yTitles;
    chartModel.xPaths = xPaths;
    chartModel.yPaths = yPaths;
    chartModel.yPaths1 = yPaths1;
    chartModel.dataArray = dataArray;
    
    return chartModel;
}

+ (ChartViewModel *)weekChartModel:(NSDate *)date type:(HealthDataType)type {
    
    ChartViewModel *chartModel = [[ChartViewModel alloc] init];
    chartModel.xTitles = [self weeks];
    
    NSMutableArray *yTitles = [NSMutableArray array];
    NSMutableArray *xPaths = [NSMutableArray array];
    NSMutableArray *yPaths = [NSMutableArray array];
    NSMutableArray *yPaths1 = [NSMutableArray array];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSInteger maxValue = 0;
    NSInteger dataCount = 7;
    
    NSArray *dates = [date getweekBeginAndEndWithFirstDay:1];
    NSDate *startDate = dates.firstObject;
    NSDate *endDate = dates.lastObject;
    
    NSString *startDateStr = [startDate dateToStringFormat:@"yyyyMMdd"];
    NSString *endDateStr = [endDate dateToStringFormat:@"yyyyMMdd"];
    
    NSArray *models = [NSArray array];
    NSInteger sum = 0;
    switch (type) {
        case HealthDataTypeStep:
        {
            models = [DailyStepModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyStepModel *model = models[i];
                sum += model.step;
                if (model.step > maxValue) {
                    maxValue = model.step;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.step) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/dataCount]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeSleep:
        {
            models = [DailySleepModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailySleepModel *model = models[i];
                NSInteger total = model.deep+model.light;
                sum += total;
                if (total > maxValue) {
                    maxValue = total;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(total) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/dataCount]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeHeartRate:
        {
            models = [DailyHeartRateModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyHeartRateModel *model = models[i];
                sum += model.avgHr;
                if (model.avgHr > maxValue) {
                    maxValue = model.avgHr;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.avgHr) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeBP:
        {
            models = [DailyBpModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyBpModel *model = models[i];
                sum += model.avgSystolic;
                if (model.avgSystolic > maxValue) {
                    maxValue = model.avgSystolic;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.avgSystolic) forKey:@"systolic"];
                [dict setObject:@(model.avgDiastolic) forKey:@"diastolic"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"systolic"] integerValue]/maxValue]];
                [yPaths1 addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"diastolic"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeBO:
        {
            models = [DailyBoModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyBoModel *model = models[i];
                sum += model.avgBo;
                if (model.avgBo > maxValue) {
                    maxValue = model.avgBo;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.avgBo) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeTemp:
        {
            models = [DailyTempModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyTempModel *model = models[i];
                sum += model.avgTemp;
                CGFloat temp = model.avgTemp > 0 ? TempValue(model.avgTemp) : 0;
                if (ceil(temp) > maxValue) {
                    maxValue = ceil(temp);
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.avgTemp) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                CGFloat temp = [item[@"value"] floatValue] > 0 ? TempValue([item[@"value"] floatValue]) : 0;
                [yPaths addObject:[NSString stringWithFormat:@"%f",temp/maxValue]];
            }
        }
            break;
        case HealthDataTypeBreath:
        {
            models = [DailyBreathModel queryModels:startDateStr endDateStr:endDateStr];
            maxValue = 10;
            for (int i = 0; i < models.count; i++) {
                DailyBreathModel *model = models[i];
                sum += model.duration;
                if (model.duration > maxValue) {
                    maxValue = model.duration;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.duration) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/dataCount]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        default:
            break;
    }
    
    if (maxValue > 0) {
        NSInteger yCount = 3;
        for (int i = 0; i < yCount; i++) {
            if (i == yCount-1) {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)maxValue]];
            } else {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)(i+1)*maxValue/yCount]];
            }
        }
    }
    chartModel.yTitles = yTitles;
    chartModel.xPaths = xPaths;
    chartModel.yPaths = yPaths;
    chartModel.yPaths1 = yPaths1;
    chartModel.dataArray = sum > 0 ? dataArray : [NSArray array];
    return chartModel;
}

+ (ChartViewModel *)monthChartModel:(NSDate *)date type:(HealthDataType)type {
    
    ChartViewModel *chartModel = [[ChartViewModel alloc] init];
    
    NSMutableArray *xTitles = [NSMutableArray array];
    NSMutableArray *yTitles = [NSMutableArray array];
    NSMutableArray *xPaths = [NSMutableArray array];
    NSMutableArray *yPaths = [NSMutableArray array];
    NSMutableArray *yPaths1 = [NSMutableArray array];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSInteger maxValue = 0;
    
    NSArray *dates = [date getMonthBeginAndEnd];
    NSDate *startDate = dates.firstObject;
    NSDate *endDate = dates.lastObject;
    NSString *startDateStr = [startDate dateToStringFormat:@"yyyyMMdd"];
    NSString *endDateStr = [endDate dateToStringFormat:@"yyyyMMdd"];
    
    NSArray *models = [NSArray array];
    NSInteger sum = 0;
    NSInteger dataCount = endDate.day;
    for (int i = 1; i <= dataCount; i++) {
        [xTitles addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    chartModel.xTitles = xTitles;
    
    switch (type) {
        case HealthDataTypeStep:
        {
            models = [DailyStepModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyStepModel *model = models[i];
                sum += model.step;
                if (model.step > maxValue) {
                    maxValue = model.step;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.step) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/dataCount]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeSleep:
        {
            models = [DailySleepModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailySleepModel *model = models[i];
                NSInteger total = model.deep+model.light;
                sum += total;
                if (total > maxValue) {
                    maxValue = total;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(total) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/dataCount]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeHeartRate:
        {
            models = [DailyHeartRateModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyHeartRateModel *model = models[i];
                sum += model.avgHr;
                if (model.avgHr > maxValue) {
                    maxValue = model.avgHr;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.avgHr) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
            
        }
            break;
        case HealthDataTypeBP:
        {
            models = [DailyBpModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyBpModel *model = models[i];
                sum += model.avgSystolic;
                if (model.avgSystolic > maxValue) {
                    maxValue = model.avgSystolic;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.avgSystolic) forKey:@"systolic"];
                [dict setObject:@(model.avgDiastolic) forKey:@"diastolic"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"systolic"] integerValue]/maxValue]];
                [yPaths1 addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"diastolic"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeBO:
        {
            models = [DailyBoModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyBoModel *model = models[i];
                sum += model.avgBo;
                if (model.avgBo > maxValue) {
                    maxValue = model.avgBo;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.avgBo) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeTemp:
        {
            models = [DailyTempModel queryModels:startDateStr endDateStr:endDateStr];
            for (int i = 0; i < models.count; i++) {
                DailyTempModel *model = models[i];
                sum += model.avgTemp;
                CGFloat temp = model.avgTemp > 0 ? TempValue(model.avgTemp) : 0;
                if (ceil(temp) > maxValue) {
                    maxValue = ceil(temp);
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.avgTemp) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                CGFloat temp = [item[@"value"] floatValue] > 0 ? TempValue([item[@"value"] floatValue]) : 0;
                [yPaths addObject:[NSString stringWithFormat:@"%f",temp/maxValue]];
            }
        }
            break;
        case HealthDataTypeBreath:
        {
            models = [DailyBreathModel queryModels:startDateStr endDateStr:endDateStr];
            maxValue = 10;
            for (int i = 0; i < models.count; i++) {
                DailyBreathModel *model = models[i];
                sum += model.duration;
                if (model.duration > maxValue) {
                    maxValue = model.duration;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.duration) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/dataCount]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        default:
            break;
    }
    
    if (maxValue > 0) {
        NSInteger yCount = 3;
        for (int i = 0; i < yCount; i++) {
            if (i == yCount-1) {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)maxValue]];
            } else {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)(i+1)*maxValue/yCount]];
            }
        }
    }
    chartModel.yTitles = yTitles;
    chartModel.xPaths = xPaths;
    chartModel.yPaths = yPaths;
    chartModel.yPaths1 = yPaths1;
    chartModel.dataArray = sum > 0 ? dataArray : [NSArray array];
    return chartModel;
}

+ (ChartViewModel *)yearChartModel:(NSDate *)date type:(HealthDataType)type {
    
    ChartViewModel *chartModel = [[ChartViewModel alloc] init];
    
    NSMutableArray *xTitles = [NSMutableArray array];
    NSMutableArray *yTitles = [NSMutableArray array];
    NSMutableArray *xPaths = [NSMutableArray array];
    NSMutableArray *yPaths = [NSMutableArray array];
    NSMutableArray *yPaths1 = [NSMutableArray array];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSInteger maxValue = 0;
    NSArray *valueArray = [NSArray array];
    
    NSInteger dataCount = 12;
    for (int i = 1; i <= dataCount; i++) {
        [xTitles addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    chartModel.xTitles = xTitles;
    NSInteger sum = 0;
    switch (type) {
        case HealthDataTypeStep:
        {
            valueArray = [DailyStepModel queryYearModels:date];
            for (int i = 0; i < valueArray.count; i++) {
                NSInteger value = [valueArray[i] integerValue];
                sum += value;
                if (value > maxValue) {
                    maxValue = value;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(value) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/dataCount]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeSleep:
        {
            valueArray = [DailySleepModel queryYearModels:date];
            for (int i = 0; i < valueArray.count; i++) {
                NSInteger value = [valueArray[i] integerValue];
                sum += value;
                if (value > maxValue) {
                    maxValue = value;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(value) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/dataCount]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeHeartRate:
        {
            valueArray = [DailyHeartRateModel queryYearModels:date];
            for (int i = 0; i < valueArray.count; i++) {
                NSInteger value = [valueArray[i] integerValue];
                sum += value;
                if (value > maxValue) {
                    maxValue = value;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(value) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
            
        }
            break;
        case HealthDataTypeBP:
        {
            valueArray = [DailyBpModel queryYearModels:date];
            for (int i = 0; i < valueArray.count; i++) {
                NSDictionary *item = valueArray[i];
                NSInteger systolic = [item[@"systolic"] integerValue];
                NSInteger diastolic = [item[@"diastolic"] integerValue];
                sum += systolic;
                if (systolic > maxValue) {
                    maxValue = systolic;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(systolic) forKey:@"systolic"];
                [dict setObject:@(diastolic) forKey:@"diastolic"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"systolic"] integerValue]/maxValue]];
                [yPaths1 addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"diastolic"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeBO:
        {
            valueArray = [DailyBoModel queryYearModels:date];
            for (int i = 0; i < valueArray.count; i++) {
                NSInteger value = [valueArray[i] integerValue];
                sum += value;
                if (value > maxValue) {
                    maxValue = value;
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(value) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        case HealthDataTypeTemp:
        {
            valueArray = [DailyTempModel queryYearModels:date];
            for (int i = 0; i < valueArray.count; i++) {
                sum += [valueArray[i] integerValue];
                CGFloat value = [valueArray[i] integerValue] > 0 ? TempValue([valueArray[i] integerValue]) : 0;
                if (ceil(value) > maxValue) {
                    maxValue = ceil(value);
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@([valueArray[i] integerValue]) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/(dataCount-1)]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                CGFloat temp = [item[@"value"] floatValue] > 0 ? TempValue([item[@"value"] floatValue]) : 0;
                [yPaths addObject:[NSString stringWithFormat:@"%f",temp/maxValue]];
            }
        }
            break;
        case HealthDataTypeBreath:
        {
            valueArray = [DailyBreathModel queryYearModels:date];
            maxValue = 10;
            for (int i = 0; i < valueArray.count; i++) {
                NSInteger value = [valueArray[i] integerValue];
                sum += value;
                if (value > maxValue) {
                    maxValue = value;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(value) forKey:@"value"];
                [dataArray addObject:dict];
                
                [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/dataCount]];
            }
            for (int i = 0; i < dataArray.count; i++) {
                NSDictionary *item = dataArray[i];
                [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
            }
        }
            break;
        default:
            break;
    }
    
    if (maxValue > 0) {
        NSInteger yCount = 3;
        for (int i = 0; i < yCount; i++) {
            if (i == yCount-1) {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)maxValue]];
            } else {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)(i+1)*maxValue/yCount]];
            }
        }
    }
    chartModel.yTitles = yTitles;
    chartModel.xPaths = xPaths;
    chartModel.yPaths = yPaths;
    chartModel.yPaths1 = yPaths1;
    chartModel.dataArray = sum > 0 ? dataArray : [NSArray array];
    return chartModel;
}

#pragma mark - 主页图表数据

+ (ChartViewModel *)homeCellChartModel:(NSDate *)date type:(HealthDataType)type {
    ChartViewModel *chartModel = [[ChartViewModel alloc] init];
    chartModel.xTitles = [self chartXTitle:HealthDateTypeDay];
    
    NSMutableArray *yTitles = [NSMutableArray array];
    NSMutableArray *xPaths = [NSMutableArray array];
    NSMutableArray *yPaths = [NSMutableArray array];
    NSMutableArray *yPaths1 = [NSMutableArray array];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSInteger maxValue = 0;
    
    NSString *dateStr = [date dateToStringFormat:@"yyyyMMdd"];
    switch (type) {
        case HealthDataTypeStep:
        {
            DailyStepModel *model = [DailyStepModel currentModel:dateStr];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"step"] integerValue] > maxValue) {
                        maxValue = [item[@"step"] integerValue];
                    }
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:item[@"step"] forKey:@"value"];
                    [dict setObject:[NSString stringWithFormat:@"%02ld:00",(long)i] forKey:@"date"];
                    [dataArray addObject:dict];
                    
                    [xPaths addObject:[NSString stringWithFormat:@"%f",1.0*i/24]];
                }
                for (int i = 0; i < dataArray.count; i++) {
                    NSDictionary *item = dataArray[i];
                    [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
                }
            }
        }
            break;
        case HealthDataTypeSleep:
        {
            DailySleepModel *model = [DailySleepModel currentModel:dateStr];
            NSInteger timestamp = [model.beginTime integerValue];
            NSInteger endtimestamp = [model.endTime integerValue];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                NSMutableArray *xTitles = [NSMutableArray array];
                NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endtimestamp];
                [xTitles addObject:[NSString stringWithFormat:@"%02ld:%02ld",(long)beginDate.hour,(long)beginDate.minute]];
                [xTitles addObject:[NSString stringWithFormat:@"%02ld:%02ld",(long)endDate.hour,(long)endDate.minute]];
                chartModel.xTitles = xTitles;
                
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"value"] integerValue] > maxValue) {
                        maxValue = [item[@"value"] integerValue];
                    }
                    
                    [dataArray addObject:item];
                    if ([item[@"status"] integerValue] == 0) {
                        [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*2/3]];
                    } else if ([item[@"status"] integerValue] == 1) {
                        [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*1/3]];
                    } else {
                        [yPaths addObject:@"0"];
                    }
                }
            }
        }
            break;
        case HealthDataTypeHeartRate:
        {
            DailyHeartRateModel *model = [DailyHeartRateModel currentModel:dateStr];
            CGFloat allTime = 23.0;
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                if (array.count > 24) {
                    array = [array subarrayWithRange:NSMakeRange(array.count-24, 24)];
                }
                [dataArray addObjectsFromArray:array];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"value"] integerValue] > maxValue) {
                        maxValue = [item[@"value"] integerValue];
                    }
                    [xPaths addObject:[NSString stringWithFormat:@"%f",i/allTime]];
                }
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
                }
            }
        }
            break;
        case HealthDataTypeBP:
        {
            DailyBpModel *model = [DailyBpModel currentModel:dateStr];
            CGFloat allTime = 23.0;
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                if (array.count > 24) {
                    array = [array subarrayWithRange:NSMakeRange(array.count-24, 24)];
                }
                [dataArray addObjectsFromArray:array];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"systolic"] integerValue] > maxValue) {
                        maxValue = [item[@"systolic"] integerValue];
                    }
                    [xPaths addObject:[NSString stringWithFormat:@"%f",i/allTime]];
                    
                }
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"systolic"] integerValue]/maxValue]];
                    [yPaths1 addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"diastolic"] integerValue]/maxValue]];
                }
            }
        }
            break;
        case HealthDataTypeBO:
        {
            DailyBoModel *model = [DailyBoModel currentModel:dateStr];
            CGFloat allTime = 23.0;
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                if (array.count > 24) {
                    array = [array subarrayWithRange:NSMakeRange(array.count-24, 24)];
                }
                [dataArray addObjectsFromArray:array];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    if ([item[@"value"] integerValue] > maxValue) {
                        maxValue = [item[@"value"] integerValue];
                    }
                    [xPaths addObject:[NSString stringWithFormat:@"%f",i/allTime]];
                }
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    [yPaths addObject:[NSString stringWithFormat:@"%f",1.0*[item[@"value"] integerValue]/maxValue]];
                }
            }
        }
            break;
        case HealthDataTypeTemp:
        {
            DailyTempModel *model = [DailyTempModel currentModel:dateStr];
            CGFloat allTime = 23.0;
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                if (array.count > 24) {
                    array = [array subarrayWithRange:NSMakeRange(array.count-24, 24)];
                }
                [dataArray addObjectsFromArray:array];
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    CGFloat temp = [item[@"value"] integerValue] > 0 ? TempValue([item[@"value"] integerValue]) : 0;
                    if (ceil(temp) > maxValue) {
                        maxValue = ceil(temp);
                    }
                    [xPaths addObject:[NSString stringWithFormat:@"%f",i/allTime]];
                }
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *item = array[i];
                    CGFloat temp = [item[@"value"] integerValue] > 0 ? TempValue([item[@"value"] integerValue]) : 0;
                    [yPaths addObject:[NSString stringWithFormat:@"%f",temp/maxValue]];
                }
            }
        }
            break;
        case HealthDataTypeBreath:
        {
            DailyBreathModel *model = [DailyBreathModel currentModel:dateStr];
            if (model.items.length) {
                NSArray *array = [model.items transToObject];
                [dataArray addObjectsFromArray:array];
            }
        }
            break;
        default:
            break;
    }
    if (maxValue > 0) {
        NSInteger yCount = 3;
        for (int i = 0; i < yCount; i++) {
            if (i == yCount-1) {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)maxValue]];
            } else {
                [yTitles addObject:[NSString stringWithFormat:@"%ld",(long)(i+1)*maxValue/yCount]];
            }
        }
    }
    chartModel.yTitles = yTitles;
    chartModel.xPaths = xPaths;
    chartModel.yPaths = yPaths;
    chartModel.yPaths1 = yPaths1;
    chartModel.dataArray = dataArray;
    
    return chartModel;
}

+ (NSInteger)sportTotalDistance:(SportType)type {
    NSInteger sum = 0;
    NSArray *array = [DailySportModel queryModels:type];
    if (array.count) {
        for (DailySportModel *model in array) {
            sum += model.distance;
        }
    }
    return sum;
}

#pragma mark - 保存某天的健康数据

+ (void)saveDailyStepModel:(DHDailyStepModel *)model {
    DailyStepModel *stepModel = [DailyStepModel currentModel:model.date];
    stepModel.timestamp = model.timestamp;
    if (stepModel.step != model.step) {
        stepModel.isUpload = NO;
    }
    stepModel.distance = model.distance;
    stepModel.calorie = model.calorie;
    stepModel.step = model.step;
    if (model.items.count) {
        for (int i = 0; i < model.items.count; i++) {
            NSDictionary *item = model.items[i];
            NSDate *startDate = [[NSString stringWithFormat:@"%@%02ld0000",model.date,(long)i] dateByStringFormat:@"yyyyMMddHHmmss"];
            NSDate *endDate = [[NSString stringWithFormat:@"%@%02ld5959",model.date,(long)i] dateByStringFormat:@"yyyyMMddHHmmss"];
            [[HealthKitManager shareInstance] saveOrReplace:HealthTypeStep value:[NSString stringWithFormat:@"%@",item[@"step"]] startDate:startDate endDate:endDate];
            [[HealthKitManager shareInstance] saveOrReplace:HealthTypeDistance value:[NSString stringWithFormat:@"%@",item[@"distance"]] startDate:startDate endDate:endDate];
            [[HealthKitManager shareInstance] saveOrReplace:HealthTypeCalorie value:[NSString stringWithFormat:@"%.01f",KcalValue([item[@"calorie"] integerValue])] startDate:startDate endDate:endDate];
        }
        
        
        stepModel.items = [model.items transToJsonString];
    } else {
        stepModel.items = @"";
    }
    [stepModel saveOrUpdate];
}

+ (void)saveDailySleepModel:(DHDailySleepModel *)model {
    DailySleepModel *sleepModel = [DailySleepModel currentModel:model.date];
    sleepModel.timestamp = model.timestamp;
    if (sleepModel.total != model.duration) {
        sleepModel.isUpload = NO;
    }
    sleepModel.total = model.duration;
    sleepModel.beginTime = model.beginTime;
    sleepModel.endTime = model.endTime;
    if (model.items.count) {
        NSInteger deep = 0;
        NSInteger light = 0;
        NSInteger wake = 0;
        NSInteger wakeCount = 0;
        for (int i = 0; i < model.items.count; i++) {
            NSDictionary *item = model.items[i];
            NSInteger status = [item[@"status"] integerValue];
            NSInteger value = [item[@"value"] integerValue];
            if (status == 0) {
                wake += value;
                wakeCount++;
            } else if (status == 1) {
                light += value;
            } else {
                deep += value;
            }
        }
        sleepModel.items = [model.items transToJsonString];
        sleepModel.deep = deep;
        sleepModel.light = light;
        sleepModel.wake = wake;
        sleepModel.wakeCount = wakeCount;
    } else {
        sleepModel.items = @"";
        sleepModel.deep = 0;
        sleepModel.light = 0;
        sleepModel.wake = 0;
        sleepModel.wakeCount = 0;
    }
    [sleepModel saveOrUpdate];
}

+ (void)saveDailyHrModel:(DHDailyHrModel *)model {
    DailyHeartRateModel *hrModel = [DailyHeartRateModel currentModel:model.date];
    hrModel.timestamp = model.timestamp;
    if (hrModel.items.length) {
        NSArray *array = [hrModel.items transToObject];
        if (array.count != model.items.count) {
            hrModel.isUpload = NO;
        }
    } else {
        if (model.items.count) {
            hrModel.isUpload = NO;
        }
    }
    if (model.items.count) {
        NSMutableArray *valueArray = [NSMutableArray array];
        for (int i = 0; i < model.items.count; i++) {
            NSDictionary *item = model.items[i];
            NSInteger timestamp = [item[@"timestamp"] integerValue];
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:timestamp+1];
            [[HealthKitManager shareInstance] saveOrReplace:HealthTypeHeartRate value:[NSString stringWithFormat:@"%@",item[@"value"]] startDate:startDate endDate:endDate];
            
            [valueArray addObject:item[@"value"]];
            if (i == model.items.count-1) {
                hrModel.lastHr = [item[@"value"] integerValue];
            }
        }
        hrModel.items = [model.items transToJsonString];
        hrModel.avgHr = [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue];
        hrModel.maxHr = [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue];
        hrModel.minHr = [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue];
    } else {
        hrModel.items = @"";
        hrModel.avgHr = 0;
        hrModel.maxHr = 0;
        hrModel.minHr = 0;
        hrModel.lastHr = 0;
    }
    [hrModel saveOrUpdate];
}

+ (void)saveDailyBpModel:(DHDailyBpModel *)model {
    DailyBpModel *bpModel = [DailyBpModel currentModel:model.date];
    bpModel.timestamp = model.timestamp;
    if (bpModel.items.length) {
        NSArray *array = [bpModel.items transToObject];
        if (array.count != model.items.count) {
            bpModel.isUpload = NO;
        }
    } else {
        if (model.items.count) {
            bpModel.isUpload = NO;
        }
    }
    if (model.items.count) {
        NSMutableArray *systolicArray = [NSMutableArray array];
        NSMutableArray *diastolicArray = [NSMutableArray array];
        for (int i = 0; i < model.items.count; i++) {
            NSDictionary *item = model.items[i];
            [systolicArray addObject:item[@"systolic"]];
            [diastolicArray addObject:item[@"diastolic"]];
            if (i == model.items.count-1) {
                bpModel.lastSystolic = [item[@"systolic"] integerValue];
                bpModel.lastDiastolic = [item[@"diastolic"] integerValue];
            }
        }
        bpModel.items = [model.items transToJsonString];
        bpModel.avgSystolic = [[systolicArray valueForKeyPath:@"@avg.floatValue"] floatValue];
        bpModel.avgDiastolic = [[diastolicArray valueForKeyPath:@"@avg.floatValue"] floatValue];
        bpModel.maxSystolic = [[systolicArray valueForKeyPath:@"@max.floatValue"] floatValue];
        bpModel.maxDiastolic = [[diastolicArray valueForKeyPath:@"@max.floatValue"] floatValue];
        bpModel.minSystolic = [[systolicArray valueForKeyPath:@"@min.floatValue"] floatValue];
        bpModel.minDiastolic = [[diastolicArray valueForKeyPath:@"@min.floatValue"] floatValue];
        
    } else {
        bpModel.items = @"";
        bpModel.avgSystolic = 0;
        bpModel.avgDiastolic = 0;
        bpModel.maxSystolic = 0;
        bpModel.maxDiastolic = 0;
        bpModel.minSystolic = 0;
        bpModel.minDiastolic = 0;
        bpModel.lastSystolic = 0;
        bpModel.lastDiastolic = 0;
    }
    [bpModel saveOrUpdate];
}

+ (void)saveDailyBoModel:(DHDailyBoModel *)model {
    DailyBoModel *boModel = [DailyBoModel currentModel:model.date];
    boModel.timestamp = model.timestamp;
    if (boModel.items.length) {
        NSArray *array = [boModel.items transToObject];
        if (array.count != model.items.count) {
            boModel.isUpload = NO;
        }
    } else {
        if (model.items.count) {
            boModel.isUpload = NO;
        }
    }
    if (model.items.count) {
        NSMutableArray *valueArray = [NSMutableArray array];
        for (int i = 0; i < model.items.count; i++) {
            NSDictionary *item = model.items[i];
            [valueArray addObject:item[@"value"]];
            if (i == model.items.count-1) {
                boModel.lastBo = [item[@"value"] integerValue];
            }
        }
        boModel.items = [model.items transToJsonString];
        boModel.avgBo = [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue];
        boModel.maxBo = [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue];
        boModel.minBo = [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue];
    } else {
        boModel.items = @"";
        boModel.avgBo = 0;
        boModel.maxBo = 0;
        boModel.minBo = 0;
        boModel.lastBo = 0;
    }
    [boModel saveOrUpdate];
}

+ (void)saveDailyTempModel:(DHDailyTempModel *)model {
    DailyTempModel *tempModel = [DailyTempModel currentModel:model.date];
    tempModel.timestamp = model.timestamp;
    if (tempModel.items.length) {
        NSArray *array = [tempModel.items transToObject];
        if (array.count != model.items.count) {
            tempModel.isUpload = NO;
        }
    } else {
        if (model.items.count) {
            tempModel.isUpload = NO;
        }
    }
    if (model.items.count) {
        NSMutableArray *valueArray = [NSMutableArray array];
        for (int i = 0; i < model.items.count; i++) {
            NSDictionary *item = model.items[i];
            NSInteger timestamp = [item[@"timestamp"] integerValue];
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:timestamp+1];
            [[HealthKitManager shareInstance] saveOrReplace:HealthTypeTemp value:[NSString stringWithFormat:@"%.1f",[item[@"value"] integerValue]/10.0] startDate:startDate endDate:endDate];
            
            [valueArray addObject:item[@"value"]];
            if (i == model.items.count-1) {
                tempModel.lastTemp = [item[@"value"] integerValue];
            }
        }
        tempModel.items = [model.items transToJsonString];
        tempModel.avgTemp = [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue];
        tempModel.maxTemp = [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue];
        tempModel.minTemp = [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue];
    } else {
        tempModel.items = @"";
        tempModel.avgTemp = 0;
        tempModel.maxTemp = 0;
        tempModel.minTemp = 0;
        tempModel.lastTemp = 0;
    }
    [tempModel saveOrUpdate];
}

+ (void)saveDailyBreathModel:(DHDailyBreathModel *)model {
    DailyBreathModel *breathModel = [DailyBreathModel currentModel:model.date];
    breathModel.timestamp = model.timestamp;
    if (breathModel.items.length) {
        NSArray *array = [breathModel.items transToObject];
        if (array.count != model.items.count) {
            breathModel.isUpload = NO;
        }
    } else {
        if (model.items.count) {
            breathModel.isUpload = NO;
        }
    }
    if (model.items.count) {
        NSMutableArray *valueArray = [NSMutableArray array];
        for (int i = 0; i < model.items.count; i++) {
            NSDictionary *item = model.items[i];
            [valueArray addObject:item[@"value"]];
            
        }
        NSInteger duration = [[valueArray valueForKeyPath:@"@sum.floatValue"] floatValue];
        if (duration != breathModel.duration) {
            breathModel.isUpload = NO;
        }
        breathModel.items = [model.items transToJsonString];
        breathModel.duration = duration;
    } else {
        breathModel.items = @"";
        breathModel.duration = 0;
    }
    [breathModel saveOrUpdate];
}

+ (void)saveDailyPressureModel:(DHDailyPressureModel *)model {
    DailyPressureModel *tempModel = [DailyPressureModel currentModel:model.date];
    tempModel.timestamp = model.timestamp;
    
    NSMutableArray *jlDayAllItems = [NSMutableArray array];

    if (tempModel.items.length) {
        NSArray *array = [tempModel.items transToObject];
        if (array.count != model.items.count) {
            tempModel.isUpload = NO;
        }
        if (model.isJLType){  //杰里数据是同步就清理表盘,需把以前同步的衔接起来
            [jlDayAllItems addObjectsFromArray:array];
        }
    } else {
        if (model.items.count) {
            tempModel.isUpload = NO;
        }
    }
    if (model.items.count) {
        NSMutableArray *valueArray = [NSMutableArray array];
        [jlDayAllItems addObjectsFromArray:model.items];
        for (int i = 0; i < jlDayAllItems.count; i++) {
            NSDictionary *item = jlDayAllItems[i];
            NSInteger timestamp = [item[@"timestamp"] integerValue];
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:timestamp + 1];
//            [[HealthKitManager shareInstance] saveOrReplace:HealthTypeStress value:[NSString stringWithFormat:@"%.1f",[item[@"value"] integerValue]/10.0] startDate:startDate endDate:endDate];
            
            [valueArray addObject:item[@"value"]];
            if (i == jlDayAllItems.count - 1) {
                tempModel.lastBo = [item[@"value"] integerValue];
            }
        }
        tempModel.items = [jlDayAllItems transToJsonString];
        tempModel.avgBo = [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue];
        tempModel.maxBo = [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue];
        tempModel.minBo = [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue];
    } else {
        tempModel.items = @"";
        tempModel.avgBo = 0;
        tempModel.maxBo = 0;
        tempModel.minBo = 0;
        tempModel.lastBo = 0;
    }
    [tempModel saveOrUpdate];
}

+ (void)saveDailySportModel:(DHDailySportModel *)model {
    DailySportModel *sportModel = [DailySportModel currentModel:model.timestamp];
    sportModel.isDevice = YES;
    sportModel.isJLRunType = model.isJLRunType;
    sportModel.timestamp = model.timestamp;
    sportModel.date = model.date;
    sportModel.type = model.type;
    sportModel.duration = model.duration;
    sportModel.distance = model.distance;
    sportModel.calorie = model.calorie;
    sportModel.step = model.step;
    
    sportModel.sportHeight = model.sportHeight;
    sportModel.sportPress = model.sportPress;
    sportModel.sportStepFreq = model.sportStepFreq;
    sportModel.sportSpeed = model.sportSpeed;
    sportModel.pace = model.pace;
    sportModel.heartMax = model.heartMax;
    sportModel.heartMin = model.heartMin;
    sportModel.heartAve = model.heartAve;
    sportModel.viewType = model.viewType;
    sportModel.maxStepFreq = model.maxStepFreq;
    sportModel.minStepFreq = model.minStepFreq;
    sportModel.sportMaxPace = model.sportMaxPace;
    sportModel.sportMinPace = model.sportMinPace;
    
    sportModel.metricPaceItems = model.metricPaceItems.count ? [model.metricPaceItems transToJsonString] : @"";
    sportModel.imperialPaceItems = model.imperialPaceItems.count ? [model.imperialPaceItems transToJsonString] : @"";
    sportModel.strideFrequencyItems = model.strideFrequencyItems.count ? [model.strideFrequencyItems transToJsonString] : @"";
    sportModel.heartRateItems = model.heartRateItems.count ? [model.heartRateItems transToJsonString] : @"";
    sportModel.gpsItems = @"";
    
    [sportModel saveOrUpdate];
}

#pragma mark - 保存主动广播的健康数据item

+ (void)saveDailyStepItem:(DHHealthDataModel *)model {
    if ([NSDate date].hour == 0 && model.index != 0) {
        return;
    }
    NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
    DailyStepModel *stepModel = [DailyStepModel currentModel:dateStr];
    
    NSMutableArray *items = [NSMutableArray array];
    if (stepModel.items.length) {
        NSArray *array = [stepModel.items transToObject];
        if (array.count) {
            [items addObjectsFromArray:array];
        }
    } else {
        for (int i = 0; i < 24; i++) {
            NSDictionary *item = @{@"index":@(i),@"distance":@0,@"calorie":@0,@"step":@0};
            [items addObject:item];
        }
    }
    
    NSDictionary *item = @{@"index":@(model.index),@"distance":@(model.distance),@"calorie":@(model.calorie),@"step":@(model.step)};
    [items replaceObjectAtIndex:model.index withObject:item];
    
    NSMutableArray *distanceArray = [NSMutableArray array];
    NSMutableArray *calorieArray = [NSMutableArray array];
    NSMutableArray *stepArray = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dict = items[i];
        [distanceArray addObject:dict[@"distance"]];
        [calorieArray addObject:dict[@"calorie"]];
        [stepArray addObject:dict[@"step"]];
    }
    stepModel.isUpload = NO;
    stepModel.distance = [[distanceArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    stepModel.calorie = [[calorieArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    stepModel.step = [[stepArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    stepModel.items = [items transToJsonString];
    [stepModel saveOrUpdate];
}

+ (void)saveDailyHrItem:(DHHealthDataModel *)model {
    NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
    DailyHeartRateModel *hrModel = [DailyHeartRateModel currentModel:dateStr];
    hrModel.isUpload = NO;
    NSMutableArray *items = [NSMutableArray array];
    if (hrModel.items.length) {
        NSArray *array = [hrModel.items transToObject];
        if (array.count) {
            [items addObjectsFromArray:array];
        }
    }
    
    NSDictionary *item = @{@"timestamp":@(model.timestamp),@"value":@(model.heartRate)};
    [items addObject:item];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dict = items[i];
        [valueArray addObject:dict[@"value"]];
    }
    
    hrModel.lastHr = model.heartRate;
    hrModel.avgHr = [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue];
    hrModel.maxHr = [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue];
    hrModel.minHr = [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue];
    hrModel.items = [items transToJsonString];
    [hrModel saveOrUpdate];
}

+ (void)saveDailyBpItem:(DHHealthDataModel *)model {
    NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
    DailyBpModel *bpModel = [DailyBpModel currentModel:dateStr];
    bpModel.isUpload = NO;
    NSMutableArray *items = [NSMutableArray array];
    if (bpModel.items.length) {
        NSArray *array = [bpModel.items transToObject];
        if (array.count) {
            [items addObjectsFromArray:array];
        }
    }
    
    NSDictionary *item = @{@"timestamp":@(model.timestamp),@"systolic":@(model.systolic),@"diastolic":@(model.diastolic)};
    [items addObject:item];
    
    NSMutableArray *systolicArray = [NSMutableArray array];
    NSMutableArray *diastolicArray = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dict = items[i];
        [systolicArray addObject:dict[@"systolic"]];
        [diastolicArray addObject:dict[@"diastolic"]];
    }
    
    bpModel.lastSystolic = model.systolic;
    bpModel.lastDiastolic = model.diastolic;
    bpModel.avgSystolic = [[systolicArray valueForKeyPath:@"@avg.floatValue"] floatValue];
    bpModel.avgDiastolic = [[diastolicArray valueForKeyPath:@"@avg.floatValue"] floatValue];
    bpModel.maxSystolic = [[systolicArray valueForKeyPath:@"@max.floatValue"] floatValue];
    bpModel.maxDiastolic = [[diastolicArray valueForKeyPath:@"@max.floatValue"] floatValue];
    bpModel.minSystolic = [[systolicArray valueForKeyPath:@"@min.floatValue"] floatValue];
    bpModel.minDiastolic = [[diastolicArray valueForKeyPath:@"@min.floatValue"] floatValue];
    bpModel.items = [items transToJsonString];
    [bpModel saveOrUpdate];
    
}

+ (void)saveDailyBoItem:(DHHealthDataModel *)model {
    NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
    DailyBoModel *boModel = [DailyBoModel currentModel:dateStr];
    boModel.isUpload = NO;
    NSMutableArray *items = [NSMutableArray array];
    if (boModel.items.length) {
        NSArray *array = [boModel.items transToObject];
        if (array.count) {
            [items addObjectsFromArray:array];
        }
    }
    
    NSDictionary *item = @{@"timestamp":@(model.timestamp),@"value":@(model.bo)};
    [items addObject:item];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dict = items[i];
        [valueArray addObject:dict[@"value"]];
    }
    
    boModel.lastBo = model.bo;
    boModel.avgBo = [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue];
    boModel.maxBo = [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue];
    boModel.minBo = [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue];
    boModel.items = [items transToJsonString];
    [boModel saveOrUpdate];
    
}

+ (void)saveDailyTempItem:(DHHealthDataModel *)model {
    NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
    DailyTempModel *tempModel = [DailyTempModel currentModel:dateStr];
    tempModel.isUpload = NO;
    
    NSMutableArray *items = [NSMutableArray array];
    if (tempModel.items.length) {
        NSArray *array = [tempModel.items transToObject];
        if (array.count) {
            [items addObjectsFromArray:array];
        }
    }
    
    NSDictionary *item = @{@"timestamp":@(model.timestamp),@"value":@(model.temp)};
    [items addObject:item];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dict = items[i];
        [valueArray addObject:dict[@"value"]];
    }
    
    tempModel.lastTemp = model.temp;
    tempModel.avgTemp = [[valueArray valueForKeyPath:@"@avg.floatValue"] floatValue];
    tempModel.maxTemp = [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue];
    tempModel.minTemp= [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue];
    tempModel.items = [items transToJsonString];
    [tempModel saveOrUpdate];
}

+ (void)saveDailyBreathItem:(DHHealthDataModel *)model {
    NSString *dateStr = [[NSDate date] dateToStringFormat:@"yyyyMMdd"];
    DailyBreathModel *breathModel = [DailyBreathModel currentModel:dateStr];
    breathModel.isUpload = NO;
    NSMutableArray *items = [NSMutableArray array];
    if (breathModel.items.length) {
        NSArray *array = [breathModel.items transToObject];
        if (array.count) {
            [items addObjectsFromArray:array];
        }
    }
    
    NSDictionary *item = @{@"timestamp":@(model.timestamp),@"value":@(model.breath)};
    [items addObject:item];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dict = items[i];
        [valueArray addObject:dict[@"value"]];
    }
    
    breathModel.duration = [[valueArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    breathModel.items = [items transToJsonString];
    [breathModel saveOrUpdate];
    
}


@end
