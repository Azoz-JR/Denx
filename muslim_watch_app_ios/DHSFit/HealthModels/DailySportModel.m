//
//  DailySportModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/6.
//

#import "DailySportModel.h"

@implementation DailySportModel

-(instancetype)init{
    if (self = [super init]) {
        self.userId = DHUserId;
        self.macAddr = DHMacAddr;
        
        self.date = @"";
        self.timestamp = @"";
        self.isUpload = NO;
        self.isDevice = NO;
        
        self.type = 0;
        self.duration = 0;
        self.distance = 0;
        self.calorie = 0;
        self.step = 0;
        
        self.metricPaceItems = @"";
        self.imperialPaceItems = @"";
        self.strideFrequencyItems = @"";
        self.heartRateItems = @"";
        self.gpsItems = @"";
        
    }
    return self;
}

+ (__kindof DailySportModel *)currentModel:(NSString *)timestamp {
    DailySportModel *model =[DailySportModel findFirstWithFormat:@"WHERE userId = '%@' AND timestamp = '%@'",DHUserId,timestamp];
    if (!model) {
        model = [[DailySportModel alloc] init];
    }
    return model;
}

+ (DailySportModel *)queryModel:(NSString *)timestamp {
    DailySportModel *model =[DailySportModel findFirstWithFormat:@"WHERE userId = '%@' AND timestamp = '%@'",DHUserId,timestamp];
    return model;
}

+ (NSArray *)queryModels:(SportType)sportType {
    NSArray *models =[DailySportModel findWithFormat:@"WHERE userId = '%@' and type = '%ld' ORDER BY timestamp DESC",DHUserId, sportType];
    return models;
}

+ (NSArray *)queryAllSports {
    NSArray *models =[DailySportModel findWithFormat:@"WHERE userId = '%@' ORDER BY timestamp DESC",DHUserId];
    return models;
}

+ (NSArray *)queryUploadModels {
    NSArray *models = [DailySportModel findWithFormat:@"WHERE userId = '%@' AND isUpload = 0",DHUserId];
    return models;
}

+ (NSArray *)queryVisitorModels {
    NSArray *models = [DailySportModel findWithFormat:@"WHERE userId = '%@'",DHVisitorId];
    return models;
}

+ (NSString *)getTableName{
    return @"t_sync_sport";
}

@end
