//
//  HealthKitManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/18.
//

#import "HealthKitManager.h"
#import <HealthKit/HealthKit.h>

@interface HealthKitManager ()
/// 管理器
@property (nonatomic, strong) HKHealthStore *store;

@end

@implementation HealthKitManager

static HealthKitManager *_shared = nil;

+ (__kindof HealthKitManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    });
    return _shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [HealthKitManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [HealthKitManager shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([HKHealthStore isHealthDataAvailable]) {
            [self.store requestAuthorizationToShareTypes:[self dataTypestowrite] readTypes:[self dataTypesToRead] completion:^(BOOL success, NSError * _Nullable error) {
                
            }];
        }
    }
    return self;
}

- (void)saveOrReplace:(HealthType) healthType value:(NSString *)value startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    [self delete:healthType startDate:startDate endDate:endDate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1.0*NSEC_PER_SEC)),dispatch_get_main_queue(),^{
        [self save:healthType value:value startDate:startDate endDate:endDate];
    });
}

- (void)save:(HealthType) healthType value:(NSString *)value startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    HKQuantitySample *sample;
    HKQuantityType *type;
    HKQuantity *quantity;
    switch (healthType) {
        case HealthTypeStep:
        {
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            quantity = [HKQuantity quantityWithUnit:HKUnit.countUnit doubleValue:[value doubleValue]];
            sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
        }
            break;
        case HealthTypeDistance:
        {
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
            quantity = [HKQuantity quantityWithUnit:HKUnit.meterUnit doubleValue:[value doubleValue]];
            sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
        }
            break;
        case HealthTypeCycling:
        {
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
            quantity = [HKQuantity quantityWithUnit:HKUnit.meterUnit doubleValue:[value doubleValue]];
            sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
        }
            break;
        case HealthTypeCalorie:
        {
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
            quantity = [HKQuantity quantityWithUnit:HKUnit.kilocalorieUnit doubleValue:[value doubleValue]];
            sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
        }
            break;
        case HealthTypeHeartRate:
        {
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
            quantity = [HKQuantity quantityWithUnit:[HKUnit.countUnit unitDividedByUnit:HKUnit.minuteUnit] doubleValue:[value doubleValue]];
            sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
        }
            break;
        case HealthTypeHeight:
        {
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
            quantity = [HKQuantity quantityWithUnit:HKUnit.meterUnit doubleValue:[value doubleValue]];
            sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
        }
            break;
        case HealthTypeWeight:
        {
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
            quantity = [HKQuantity quantityWithUnit:[HKUnit unitFromMassFormatterUnit:NSMassFormatterUnitKilogram] doubleValue:[value doubleValue]];
            sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
        }
            break;
        case HealthTypeTemp:
        {
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
            quantity = [HKQuantity quantityWithUnit:HKUnit.degreeCelsiusUnit doubleValue:[value doubleValue]];
            sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate];
        }
            break;
        default:
            break;
    }
    if (sample) {
        [self.store saveObject:sample withCompletion:^(BOOL success, NSError * _Nullable error) {
            
        }];
    }
}

- (void)delete:(HealthType) healthType startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSPredicate *pre = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:YES];

    HKQuantityType *type;
    switch (healthType) {
        case HealthTypeStep:
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            break;
        case HealthTypeDistance:
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
            break;
        case HealthTypeCycling:
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
            break;
        case HealthTypeCalorie:
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
            break;
        case HealthTypeHeartRate:
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
            break;
        case HealthTypeHeight:
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
            break;
        case HealthTypeWeight:
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
            break;
        case HealthTypeTemp:
            type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
            break;
            
        default:
            break;
    }
    if (type) {
        WEAKSELF
        HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:type predicate:pre limit:HKObjectQueryNoLimit sortDescriptors:@[sort] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
            if (results.count) {
                [weakSelf.store deleteObjects:results withCompletion:^(BOOL success, NSError * _Nullable error) {
                    
                }];
            }
        }];
        [self.store executeQuery:query];
    }
}

- (HKHealthStore *)store {
    if (!_store) {
        _store = [[HKHealthStore alloc] init];
    }
    return _store;
}

- (NSSet *)dataTypestowrite {
    HKQuantityType *step = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *distance = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantityType *cycling = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
    HKQuantityType *calorie = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heartRate = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKQuantityType *height = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weight = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *temp = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    
    return [NSSet setWithArray:@[step,distance,cycling,calorie,heartRate,height,weight,temp]];
}

- (NSSet *)dataTypesToRead {
    
    return [NSSet set];
}

@end
