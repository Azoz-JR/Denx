//
//  ConfigureModel.m
//  DHSFit
//
//  Created by DHS on 2022/6/5.
//

#import "ConfigureModel.h"

@implementation ConfigureModel

static ConfigureModel * _shared = nil;

+ (__kindof ConfigureModel *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    }) ;
    return _shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [ConfigureModel shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [ConfigureModel shareInstance];
}

- (NSInteger)getTimeZoneInterval {
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger inteval = [timeZone secondsFromGMT];
    return inteval;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appStatus = 0;
        self.distanceUnit = 0;
        self.tempUnit = 0;
        self.weatherTime = 0;
        self.dataUploadTime = 0;
        self.agreementTime = 0;
        
        self.userId = @"";
        self.token = @"";
        self.macAddr = @"";
        self.visitorId = @"";
        self.longitude = @"";
        self.latitude = @"";
        
        self.isCamera = NO;
        self.isWeather = NO;
        self.isNeedConnect = NO;
        
        self.timeZoneInterval = [self getTimeZoneInterval];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_appStatus forKey:@"appStatus"];
    [aCoder encodeInteger:_distanceUnit forKey:@"distanceUnit"];
    [aCoder encodeInteger:_tempUnit forKey:@"tempUnit"];
    [aCoder encodeInteger:_weatherTime forKey:@"weatherTime"];
    [aCoder encodeInteger:_agreementTime forKey:@"agreementTime"];
    
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_macAddr forKey:@"macAddr"];
    [aCoder encodeObject:_visitorId forKey:@"visitorId"];
    [aCoder encodeObject:_longitude forKey:@"longitude"];
    [aCoder encodeObject:_latitude forKey:@"latitude"];
    
    [aCoder encodeBool:_isCamera forKey:@"isCamera"];
    [aCoder encodeBool:_isWeather forKey:@"isWeather"];
    [aCoder encodeBool:_isNeedConnect forKey:@"isNeedConnect"];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.appStatus = [aDecoder decodeIntegerForKey:@"appStatus"];
        self.distanceUnit = [aDecoder decodeIntegerForKey:@"distanceUnit"];
        self.tempUnit = [aDecoder decodeIntegerForKey:@"tempUnit"];
        self.weatherTime = [aDecoder decodeIntegerForKey:@"weatherTime"];
        self.agreementTime = [aDecoder decodeIntegerForKey:@"agreementTime"];
        
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.macAddr = [aDecoder decodeObjectForKey:@"macAddr"];
        self.visitorId = [aDecoder decodeObjectForKey:@"visitorId"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        
        self.isCamera = [aDecoder decodeBoolForKey:@"isCamera"];
        self.isWeather = [aDecoder decodeBoolForKey:@"isWeather"];
        self.isNeedConnect = [aDecoder decodeBoolForKey:@"isNeedConnect"];
    }
    
    return self;
}

+ (void)archiveraModel
{
    [NSKeyedArchiver archiveRootObject:[ConfigureModel shareInstance] toFile:[self getPath]];
}

+ (void)unarchiverModel
{
    [NSKeyedUnarchiver unarchiveObjectWithFile:[self getPath]];
}

+ (NSString *)getPath
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * dirPath = [path stringByAppendingPathComponent:@"Configure"];
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager]fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!isExist || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    NSString * filePath = [dirPath stringByAppendingPathComponent:@"configure.data"];
    return filePath;
}

+ (CGFloat)qiblaAngleFrom:(double)lat lon:(double)lon
{
    CGFloat phiK = 21.4 * M_PI / 180.0;
    CGFloat lambdaK = 39.8 * M_PI / 180.0;
    CGFloat phi = lat * M_PI / 180.0;
    CGFloat lambda = lon * M_PI / 180.0;
     
    CGFloat qiblaAngle = 180.0 / M_PI * atan2(sin(lambdaK - lambda), cos(phi) * tan(phiK) - sin(phi) * cos(lambdaK - lambda));
    if (qiblaAngle < 0){
        qiblaAngle += 360;
    }
    
    NSLog(@"qiblaAngleFrom %.2f lat %lf lon %lf", qiblaAngle, lat, lon);

    return qiblaAngle;
}

@end
