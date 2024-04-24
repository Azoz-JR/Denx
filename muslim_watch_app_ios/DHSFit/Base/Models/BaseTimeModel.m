//
//  BaseTimeModel.m
//  DHSFit
//
//  Created by DHS on 2022/7/2.
//

#import "BaseTimeModel.h"

@implementation BaseTimeModel

+ (NSInteger)timeSplitIndex:(NSInteger)hour {
    if (hour >= 12) {
        return 1;
    }
    return 0;
}

+ (NSInteger)timeHourIndex:(NSInteger)hour {
    NSInteger hourIndex = hour;
    if (hour > 12) {
        hourIndex -= 12;
    } else if (hour == 0) {
        hourIndex = 12;
    }
    return hourIndex-1;
}

+ (NSInteger)transHour:(NSInteger)hourIndex splitIndex:(NSInteger)splitIndex {
    NSInteger resultHour = 0;
    if (splitIndex == 0) {
        resultHour = hourIndex == 11 ? 0 : hourIndex+1;
    } else {
        resultHour = hourIndex == 11 ? 12 : hourIndex+1+12;
    }
    return resultHour;
}

+ (NSString *)transTimeStr:(NSInteger)hour minute:(NSInteger)minute isHasAMPM:(BOOL)isHasAMPM {
    NSString *timeStr;
    if (isHasAMPM) {
        if (hour == 0) {
            timeStr = [NSString stringWithFormat:@"%02ld:%02ld AM",(long)hour+12, (long)minute];
        } else if (hour == 12) {
            timeStr = [NSString stringWithFormat:@"%02ld:%02ld PM",(long)hour, (long)minute];
        } else if (hour > 12) {
            timeStr = [NSString stringWithFormat:@"%02ld:%02ld PM",(long)hour-12, (long)minute];
        } else {
            timeStr = [NSString stringWithFormat:@"%02ld:%02ld AM",(long)hour, (long)minute];
        }
    } else {
        timeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)hour, (long)minute];
    }
    return timeStr;
}

+ (NSString *)repeatsTitle:(NSArray *)repeats {
    if (repeats.count != 7) {
        return @"";
    }
    NSMutableString *result = [NSMutableString string];
    NSArray *weekArray = @[Lang(@"str_sunday"),
                           Lang(@"str_monday"),
                           Lang(@"str_tuesday"),
                           Lang(@"str_wednesday"),
                           Lang(@"str_thursday"),
                           Lang(@"str_friday"),
                           Lang(@"str_saturday")];
    
    if ([DHBleCentralManager isJLProtocol]){
        weekArray = @[Lang(@"str_monday"),
                      Lang(@"str_tuesday"),
                      Lang(@"str_wednesday"),
                      Lang(@"str_thursday"),
                      Lang(@"str_friday"),
                      Lang(@"str_saturday"),
                      Lang(@"str_sunday")];
    }
    NSInteger sum = 0;
    for (int i = 0; i < repeats.count; i++) {
        if ([repeats[i] integerValue] == 1) {
            [result appendString:weekArray[i]];
            [result appendString:@","];
            sum++;
        }
    }
    if (sum == 0) {
        return Lang(@"str_no_repeat");
    }
    if (sum == 7) {
        return Lang(@"str_every_day");
    }
    [result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
    return result;
}

+ (BOOL)isHasAMPM {
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = (containsA.location != NSNotFound);
    return hasAMPM;
}

@end
