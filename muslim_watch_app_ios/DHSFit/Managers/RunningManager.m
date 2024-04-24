//
//  RunningManager.m
//  DHSFit
//
//  Created by DHS on 2022/6/7.
//

#import "RunningManager.h"
#import <CoreMotion/CoreMotion.h>

@interface RunningManager ()

/// 定时器
@property (nonatomic, strong) NSTimer *runTimer;
/// 传感器
@property (nonatomic, strong) CMPedometer *pedometer;

@end

@implementation RunningManager

static RunningManager * _shared = nil;

+ (__kindof RunningManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:NULL] init];
    }) ;
    return _shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [RunningManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [RunningManager shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)timerRun {
    self.duration++;
    if ([self.delegate respondsToSelector:@selector(runningTimeAdd:)]) {
        [self.delegate runningTimeAdd:self.duration];
    }
}

- (void)startTimer {
    self.pauseCount = 0;
    self.isAutoPause = NO;
    self.isRunning = YES;
    if (!self.runTimer) {
        self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.runTimer forMode:NSRunLoopCommonModes];
    }
    [self.runTimer setFireDate:[NSDate distantPast]];
    [self startCMPedometer];
    [self controlSport:0];
}

- (void)continueTimer:(BOOL)isAutoContinue {
    self.pauseCount = 0;
    self.isAutoPause = NO;
    self.isRunning = YES;
    if (!self.runTimer) {
        self.runTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.runTimer forMode:NSRunLoopCommonModes];
    }
    [self.runTimer setFireDate:[NSDate distantPast]];
    if (!isAutoContinue) {
        [self startCMPedometer];
    }
    if (!self.isJLRunDeviceControl){ //设备控制的不用再下发控制指令
        [self controlSport:2];
    }
}

- (void)pauseTimer:(BOOL)isAutoPause {
    self.pauseCount = 0;
    self.isAutoPause = isAutoPause;
    self.isRunning = NO;
    if (self.runTimer) {
        [self.runTimer setFireDate:[NSDate distantFuture]];
        if (!self.isAutoPause) {
            [self endCMPedometer];
        }
    }
    if (!self.isJLRunDeviceControl){ //设备控制的不用再下发控制指令
        [self controlSport:1];
    }
}

- (void)stopTimer {
    self.isRunning = NO;
    if (self.runTimer) {
        [self.runTimer invalidate];
        self.runTimer = nil;
    }
    if (!self.isJLRunDeviceControl){ //设备控制的不用再下发控制指令
        [self controlSport:3];
    }
    
}

- (void)controlSport:(NSInteger)controlType {
    
    if (!self.isConnected) {
        return;
    }
    if (!DHDeviceConnected) {
        return;
    }
    DHSportControlModel *model = [[DHSportControlModel alloc] init];
    model.controlType = controlType;
    model.sportType = self.sportType;
    [DHBleCommand controlSport:model block:^(int code, id  _Nonnull data) {
        
    }];
    
}

- (void)controlSportData:(DailySportModel *)model Step:(NSInteger)step Stop:(BOOL)isStop {
    
    if (!self.isConnected) {
        return;
    }
    if (!DHDeviceConnected) {
        return;
    }
    DHSportDataSetModel *dataModel = [[DHSportDataSetModel alloc] init];
    dataModel.isStop = isStop;
    dataModel.duration = model.duration;
    dataModel.step = step;
    dataModel.distance = model.distance;
    dataModel.calorie = model.calorie;
    
    NSInteger metricPace = model.distance > 0 ? 1000.0*model.duration/model.distance : 0;
    NSInteger imperialPace = model.distance > 0 ? 1609.0*model.duration/model.distance : 0;
    dataModel.metricPace = metricPace;
    dataModel.imperialPace = imperialPace;
    
    NSInteger avgStep = 60.0*model.step/model.duration;
    dataModel.strideFrequency = avgStep;
    dataModel.timestamp = [model.timestamp integerValue];
    dataModel.isMap = model.gpsItems.length;
    
    [DHBleCommand controlSportData:dataModel block:^(int code, id  _Nonnull data) {
        
    }];
}


#pragma mark - 计步器

- (CMPedometer *)pedometer {
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc] init];
    }
    return _pedometer;
}

- (void)startCMPedometer {
    if (![CMPedometer isStepCountingAvailable]) {
        return;
    }
    self.pauseCount = 0;
    self.addStep = 0;
    WEAKSELF
    [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        if ([pedometerData.numberOfSteps integerValue] > weakSelf.addStep) {
            weakSelf.addStep = [pedometerData.numberOfSteps integerValue];
            if (weakSelf.isAutoPause && [weakSelf.delegate respondsToSelector:@selector(cotinueRunning)]) {
                [weakSelf.delegate cotinueRunning];
            } else {
                weakSelf.isStepChange = YES;
            }
        }
    }];
}

- (void)endCMPedometer {
    if (![CMPedometer isStepCountingAvailable]) {
        return;
    }
    [self.pedometer stopPedometerUpdates];
    self.totalStep += self.addStep;
}

- (void)initData {
    self.goalModel = [SportGoalSetModel currentModel];
    self.isTimeGoalAchieved = NO;
    self.isDistanceGoalAchieved = NO;
    self.isCalorieGoalAchieved = NO;
    
    self.isAutoPause = NO;
    self.pauseCount = 0;
    
    self.isBigMap = NO;
    self.isRunning = YES;
    
    self.duration = 0;
    self.totalStep = 0;
    self.addStep = 0;
    self.lastStep = 0;
    
    self.metricPaceIndex = 0;
    self.imperialPaceIndex = 0;
    
    self.metricPaceItems = [NSMutableArray array];
    self.imperialPaceItems = [NSMutableArray array];
    self.strideFrequencyItems = [NSMutableArray array];
    self.gpsItems = [NSMutableArray array];
}

+ (NSString *)recordTypeImage:(SportType)type {
    if (type == SportTypeWalk) {
        return @"sport_record_walk";
    }
    if (type == SportTypeRide) {
        return @"sport_record_ride";
    }
    if (type == SportTypeClimb) {
        return @"sport_record_climb";
    }
    if (type == SportTypeRunIndoor || type == SportTypeRunOutdoor) {
        return @"sport_record_run";
    }
    if (type == SportTypeTennis) {
        return @"sport_record_tennis";
    }
    if (type == SportTypeYoga) {
        return @"sport_record_yoga";
    }
    if (type == SportTypeBadminton) {
        return @"sport_record_badminton";
    }
    if (type == SportTypeBasketball) {
        return @"sport_record_basketball";
    }
    if (type == SportTypeJumpingRope) {
        return @"sport_record_jumpingRope";
    }
    if (type == SportTypeFootball) {
        return @"sport_record_football";
    }
    if (type == SportTypeFreeExercise) {
        return @"ic_sport_item_free_exercise";
    }
    if (type == SportTypeTableTennis) {
        return @"ic_sport_item_free_exercise";
    }
    if (type == SportTypeBallet) {
        return @"ic_sport_item_ballet";
    }
    if (type == SportTypeGolf) {
        return @"ic_sport_item_golf";
    }
    if (type == SportTypeSquareDance) {
        return @"ic_sport_item_square_dance";
    }
    if (type == SportTypeBaseball) {
        return @"ic_sport_item_baseball";
    }
    if (type == SportTypeFootball2) {
        return @"ic_sport_item_rugby";
    }
    if (type == SportTypePoppyJump) {
        return @"ic_sport_item_poppy_jump";
    }
    if (type == SportTypeEllipticalMachine) {
        return @"ic_sport_item_elliptical_machine";
    }
    if (type == SportTypeFitness) {
        return @"ic_sport_item_fitness";
    }
    if (type == SportTypeKayak) {
        return @"ic_sport_item_kayak";
    }
    if (type == SportTypeOnFoot) {
        return @"ic_sport_item_on_foot";
    }
    if (type == SportTypeSkiing) {
        return @"ic_sport_item_water_sports";
    }
    if (type == SportTypePaddleBoard) {
        return @"ic_sport_item_paddle_board";
    }
    if (type == SportTypePilates) {
        return @"ic_sport_item_pilates";
    }
    if (type == SportTypeRollerSkating) {
        return @"ic_sport_item_roller_skating";
    }
    if (type == SportTypeBoating) {
        return @"ic_sport_item_boating";
    }
    if (type == SportTypeSailboat) {
        return @"ic_sport_item_sailboat";
    }
    if (type == SportTypeSkateboard) {
        return @"ic_sport_item_skateboard";
    }
    if (type == SportTypeToStretch) {
        return @"ic_sport_item_strench";
    }
    if (type == SportTypeWaterPolo) {
        return @"ic_sport_item_water_polo";
    }
    
    return @"sport_record_walk";
}

+ (NSString *)runningTypeImage:(SportType)type {
    if (type == SportTypeWalk) {
        return @"sport_type_walk";
    }
    if (type == SportTypeRide) {
        return @"sport_type_ride";
    }
    if (type == SportTypeClimb) {
        return @"sport_type_climb";
    }
    if (type == SportTypeRunIndoor || type == SportTypeRunOutdoor) {
        return @"sport_type_run";
    }
    return @"sport_type_walk";
}

+ (NSString *)runningTypeTitle:(SportType)type {
    if (type == SportTypeWalk) {
        return Lang(@"str_tab_sport_walking");
    }
    if (type == SportTypeRide) {
        return Lang(@"str_tab_sport_biking");
    }
    if (type == SportTypeClimb) {
        return Lang(@"str_tab_sport_climing");
    }
    if (type == SportTypeRunIndoor) {
        return Lang(@"str_tab_sport_running_indoor");
    }
    if (type == SportTypeRunOutdoor) {
        return Lang(@"str_tab_sport_running_outdoor");
    }
    if (type == SportTypeSpinning) {
        return Lang(@"str_tab_sport_spinning");
    }
    if (type == SportTypeTennis) {
        return Lang(@"str_tab_sport_tennis");
    }
    if (type == SportTypeWeightLifting) {
        return Lang(@"str_tab_sport_weight_lifting");
    }
    if (type == SportTypeYoga) {
        return Lang(@"str_tab_sport_yoga");
    }
    if (type == SportTypeBadminton) {
        return Lang(@"str_tab_sport_badminton");
    }
    if (type == SportTypeBasketball) {
        return Lang(@"str_tab_sport_basketball");
    }
    if (type == SportTypeJumpingRope) {
        return Lang(@"str_tab_sport_jumprope");
    }
    if (type == SportTypeFreeExercise) {
        return Lang(@"str_tab_free_exercise");
    }
    if (type == SportTypeFootball) {
        return Lang(@"str_tab_sport_football");
    }
    if (type == SportTypeTableTennis) {
        return Lang(@"str_tab_sport_tabletennis");
    }
    if (type == SportTypeBallet) {
        return Lang(@"str_tab_ballet");
    }
    if (type == SportTypeGolf) {
        return Lang(@"str_tab_golf");
    }
    if (type == SportTypeSquareDance) {
        return Lang(@"str_tab_square_dance");
    }
    if (type == SportTypeBaseball) {
        return Lang(@"str_tab_baseball");
    }
    if (type == SportTypeFootball2) {
        return Lang(@"str_tab_rugby");
    }
    if (type == SportTypePoppyJump) {
        return Lang(@"str_tab_poppy_jump");
    }
    if (type == SportTypeEllipticalMachine) {
        return Lang(@"str_tab_elliptical_machine");
    }
    if (type == SportTypeFitness) {
        return Lang(@"str_tab_fitness");
    }
    if (type == SportTypeKayak) {
        return Lang(@"str_tab_kayak");
    }
    if (type == SportTypeOnFoot) {
        return Lang(@"str_tab_on_foot");
    }
    if (type == SportTypeSkiing) {
        return Lang(@"str_tab_snow_sports");
    }
    if (type == SportTypePaddleBoard) {
        return Lang(@"str_tab_paddle_board");
    }
    if (type == SportTypePilates) {
        return Lang(@"str_tab_pilates");
    }
    if (type == SportTypeRollerSkating) {
        return Lang(@"str_tab_roller_skating");
    }
    if (type == SportTypeBoating) {
        return Lang(@"str_tab_boating");
    }
    if (type == SportTypeSailboat) {
        return Lang(@"str_tab_sailboat");
    }
    if (type == SportTypeSkateboard) {
        return Lang(@"str_tab_skateboard");
    }
    if (type == SportTypeToStretch) {
        return Lang(@"str_tab_stretch");
    }
    if (type == SportTypeWaterPolo) {
        return Lang(@"str_tab_water_polo");
    }
    return Lang(@"str_tab_sport_walking");
}

+ (NSString *)runningTypeDataTitle:(SportType)type {
    if (type == SportTypeWalk) {
        return Lang(@"str_walk_total_distance");
    }
    if (type == SportTypeRide) {
        return Lang(@"str_bike_total_distance");
    }
    if (type == SportTypeClimb) {
        return Lang(@"str_cli_total_distance");
    }
    if (type == SportTypeRunIndoor) {
        return Lang(@"str_run_indoor_total_distance");
    }
    if (type == SportTypeRunOutdoor) {
        return Lang(@"str_run_outdoor_total_distance");
    }
    return Lang(@"str_walk_total_distance");
}

+ (NSString *)recordTypeJLImage:(NSInteger)type {
    //球类
    static const uint8_t WORKOUT_TYPE_BALL[] = {
        BLE_ACTIVITY_PING_PONG, BLE_ACTIVITY_TENNIS, BLE_ACTIVITY_VOLLEYBALL, BLE_ACTIVITY_BASEBALL,
        BLE_ACTIVITY_HOCKEY, BLE_ACTIVITY_GOLF, BLE_ACTIVITY_HANDBALL, BLE_ACTIVITY_BILLIARDS,
        BLE_ACTIVITY_SQUASH, BLE_ACTIVITY_BOWLING, BLE_ACTIVITY_RUGBY, BLE_ACTIVITY_SHOT_PUT,
        BLE_ACTIVITY_TENNIS_DOUBLES, BLE_ACTIVITY_WATER_VOLLEYBALL, BLE_ACTIVITY_CRICKET, BLE_ACTIVITY_SOFTBALL,
        BLE_ACTIVITY_CROQUET, BLE_ACTIVITY_JAI_BALL, BLE_ACTIVITY_FLOOR_BALL,BLE_ACTIVITY_BADMINTON,
        BLE_ACTIVITY_TABLE_FOOTBALL, BLE_ACTIVITY_WALLBALL, BLE_ACTIVITY_PUCK, BLE_ACTIVITY_SEPAK_TAKRAW,
        BLE_ACTIVITY_WATER_POLO, BLE_ACTIVITY_SHUTTLE
    };
    for (int i = 0; i < 26; ++i){
        if (type == WORKOUT_TYPE_BALL[i]){
            return @"jl_workout_ball";
        }
    }
    
    //竞赛
    static const uint8_t WORKOUT_TYPE_COMPETITION[] = {
        BLE_ACTIVITY_MARATHON, BLE_ACTIVITY_GYMNASTICS, BLE_ACTIVITY_BOXING, BLE_ACTIVITY_TAEKWONDO,
        BLE_ACTIVITY_MARTIAL_ARTS, BLE_ACTIVITY_KARATE, BLE_ACTIVITY_LONG_JUMP, BLE_ACTIVITY_HIGH_JUMP,
        BLE_ACTIVITY_JAVELIN, BLE_ACTIVITY_RACE_RIDING, BLE_ACTIVITY_OFF_ROAD_BIKE, BLE_ACTIVITY_MOTOCROSS,
        BLE_ACTIVITY_SAILBOAT, BLE_ACTIVITY_KAYAK, BLE_ACTIVITY_ROWING, BLE_ACTIVITY_HAMMER,
        BLE_ACTIVITY_DISCUS, BLE_ACTIVITY_FENCING, BLE_ACTIVITY_THAI, BLE_ACTIVITY_WRESTLING,
        BLE_ACTIVITY_BODY_COMBAT, BLE_ACTIVITY_TAE_BO, BLE_ACTIVITY_TRACK_AND_FIELD, BLE_ACTIVITY_CYCLING_INDOOR,
        BLE_ACTIVITY_BMX, BLE_ACTIVITY_HUNTING, BLE_ACTIVITY_PADDLEBOARD_SURFING, BLE_ACTIVITY_KAYAKING_RAFTING,
        BLE_ACTIVITY_MOTORBOAT, BLE_ACTIVITY_PARKOUR, BLE_ACTIVITY_ATV, BLE_ACTIVITY_PARAGLIDER,
        BLE_ACTIVITY_CURLING, BLE_ACTIVITY_SNOWBOARDING, BLE_ACTIVITY_DOUBLE_BOARD, BLE_ACTIVITY_ALPINE_SKIING,
        BLE_ACTIVITY_CROSS_COUNT, BLE_ACTIVITY_SNOW_MOBILE, BLE_ACTIVITY_SNOW_CAR, BLE_ACTIVITY_SLED,
        BLE_ACTIVITY_JODO, BLE_ACTIVITY_KICKBOXING, BLE_ACTIVITY_FLY_A_KITE, BLE_ACTIVITY_TUGOFWAR,
        BLE_ACTIVITY_KABADDI, BLE_ACTIVITY_RACING_CAR, BLE_ACTIVITY_SEVEN_STONES, BLE_ACTIVITY_KHO_KHO
    };
    
    for (int i = 0; i < 48; ++i){
        if (type == WORKOUT_TYPE_COMPETITION[i]){
            return @"jl_workout_competition";
        }
    }
    
    //跳舞
    static const uint8_t WORKOUT_TYPE_DANCE[] = {
        BLE_ACTIVITY_DANCE, BLE_ACTIVITY_DANCE_STREET, BLE_ACTIVITY_MODERN_DANCE, BLE_ACTIVITY_JAZZ_DANCE,
        BLE_ACTIVITY_SQUARE_DANCE, BLE_ACTIVITY_ZUMBA, BLE_ACTIVITY_BALLET, BLE_ACTIVITY_POLE_DANCING,
        BLE_ACTIVITY_DISCO, BLE_ACTIVITY_TAP_DANCE, BLE_ACTIVITY_BELLY, BLE_ACTIVITY_BALLROOM_DANCE,
        BLE_ACTIVITY_NATIONAL_DANCE, BLE_ACTIVITY_LATIN
    };
    
    for (int i = 0; i < 14; ++i){
        if (type == WORKOUT_TYPE_DANCE[i]){
            return @"jl_workout_dance";
        }
    }
    
    static const uint8_t WORKOUT_TYPE_RELAXATION[] = {
        BLE_ACTIVITY_INDOOR_WALK, BLE_ACTIVITY_JUMP_ROPE, BLE_ACTIVITY_HULA_HOOP, BLE_ACTIVITY_DARTS,
        BLE_ACTIVITY_ROLLER_SKATING, BLE_ACTIVITY_SKI, BLE_ACTIVITY_SKATE, BLE_ACTIVITY_PILATES,
        BLE_ACTIVITY_TREKKING, BLE_ACTIVITY_FRISBEE, BLE_ACTIVITY_SWIMMING, BLE_ACTIVITY_SURF,
        BLE_ACTIVITY_SKATEBOARD, BLE_ACTIVITY_TRAMPOLINE, BLE_ACTIVITY_SCOOTER, BLE_ACTIVITY_WATER_BIKE,
        BLE_ACTIVITY_WATER_SKIING, BLE_ACTIVITY_HORSE_RIDING, BLE_ACTIVITY_ARCHERY, BLE_ACTIVITY_LEG_PRESS,
        BLE_ACTIVITY_FISHING, BLE_ACTIVITY_TAI_CHI, BLE_ACTIVITY_PARACHUTE, BLE_ACTIVITY_BODY_BALANCE
    };
    
    for (int i = 0; i < 24; ++i){
        if (type == WORKOUT_TYPE_RELAXATION[i]){
            return @"jl_workout_relaxation";
        }
    }
    
    //训练
    static const uint8_t WORKOUT_TYPE_FITNESS[] = {
        BLE_ACTIVITY_OUTDOOR, BLE_ACTIVITY_SPINNING, BLE_ACTIVITY_WEIGHTLIFTING, BLE_ACTIVITY_WEIGHTTRANNING,
        BLE_ACTIVITY_CLIMB_STAIRS, BLE_ACTIVITY_STEPPING, BLE_ACTIVITY_SIT_UP, BLE_ACTIVITY_PULL_UP,
        BLE_ACTIVITY_SQUAT, BLE_ACTIVITY_PUSH_UPS, BLE_ACTIVITY_PLANK, BLE_ACTIVITY_ELLIPTICAL,
        BLE_ACTIVITY_DUM_BLE, BLE_ACTIVITY_ROWING_MACHINE, BLE_ACTIVITY_AEROBICS, BLE_ACTIVITY_BODY_EXERCISE,
        BLE_ACTIVITY_ROCK_CLIMBING, BLE_ACTIVITY_MOUNTAIN_CLIMBER, BLE_ACTIVITY_BACK_TRAINING, BLE_ACTIVITY_CROSSFIT,
        BLE_ACTIVITY_HIIT, BLE_ACTIVITY_TRX, BLE_ACTIVITY_STRETCHING, BLE_ACTIVITY_INDOOR_FINESS,
        BLE_ACTIVITY_FLEXIBILITY, BLE_ACTIVITY_UPPER_LIMB_TRAIN, BLE_ACTIVITY_LOWER_LIMB_TRAIN, BLE_ACTIVITY_FREE_EXERCISE,
        BLE_ACTIVITY_BARBELL_TRAINING, BLE_ACTIVITY_PHYSICAL_TRAINING, BLE_ACTIVITY_DEADLIFT, BLE_ACTIVITY_BOBBY_JUMP,
        BLE_ACTIVITY_FUNCTION_TRAIN, BLE_ACTIVITY_WAIST_ABDOMEN_TRAIN
    };
    for (int i = 0; i < 26; ++i){
        if (type == WORKOUT_TYPE_FITNESS[i]){
            return @"jl_workout_fitness";
        }
    }
    
    return @"jl_workout_fitness";
}

+ (NSString *)runningTypeJLTitle:(NSInteger)type {
    NSArray *tTypeArr = @[@"", @"", @"", @"",
                          @"", @"", @"",//7
                          @"str_jl_Running", @"str_jl_Treadmill", @"str_jl_Outdoorrunning", @"str_jl_Cycling",
                          @"str_jl_Swim", @"str_jl_Walking", @"str_jl_Climbing", @"str_jl_Yoga",
                          @"str_jl_Spinning", @"str_jl_Basketball", @"str_jl_Football", @"str_jl_Badminton",
                          @"str_jl_Marathon", @"str_jl_Indoorwalking", @"str_jl_Freemovement", @"str_jl_run_22", @"str_jl_Strengthtraining",
                          @"str_jl_Weightlifting", @"str_jl_Boxing", @"str_jl_Jumprope", @"str_jl_StairClimbing", //27
                          @"str_jl_Ski", @"str_jl_Skate", @"str_jl_Rollerskating", @"str_jl_run_31", @"str_jl_Hulahoop",  //32
                          @"str_jl_Golf", @"str_jl_Beyzbol", @"str_jl_Dance", @"str_jl_Pingpong",
                          @"str_jl_Hockey", @"str_jl_Pilates", @"str_jl_Taekwondo", @"str_jl_Handball",
                          @"str_jl_run_41", @"str_jl_Volleyball", @"str_jl_Tennis", @"str_jl_Darts",
                          @"str_jl_Gymnastics", @"str_jl_Steps", @"str_jl_Ellipticalmachine", @"str_jl_Zumba", //48
                          @"str_jl_Cricket", @"str_jl_Travelbywalking", @"str_jl_Aerobicexercise", @"str_jl_Rowingmachine",
                          @"str_jl_Rugby", @"str_jl_run_54", @"str_jl_Dumbbells", @"str_jl_Bodybuilding",
                          @"str_jl_Karate", @"str_jl_Fencing", @"str_jl_Martialarts", @"str_jl_TaiChi",
                          @"str_jl_Frisbee", @"str_jl_Archery", @"str_jl_Horseriding", @"str_jl_Bowling",
                          @"str_jl_Surf", @"str_jl_Softball", @"str_jl_Squash", @"str_jl_Sailboat", //68
                          @"str_jl_Pullup", @"str_jl_Skateboard", //70
                          @"str_jl_Trampoline", @"str_jl_Fishing", @"str_jl_Poledancing",
                          @"str_jl_Squaredance", @"str_jl_Jazz", @"str_jl_Ballet", @"str_jl_Disco",
                          @"str_jl_Tapdance", @"str_jl_Moderndance", @"str_jl_Pushups", @"str_jl_Scooter", //81
                          @"str_jl_Plank", @"str_jl_Billiards", @"str_jl_Rockclimbing", @"str_jl_DiscusThrow",
                          @"str_jl_HorseRacing", @"str_jl_Wrestling", @"str_jl_Highjump", @"str_jl_Parachute", //89
                          @"str_jl_Shotput", @"str_jl_Longjump", @"str_jl_Javelinthrow", @"str_jl_Hammer",
                          @"str_jl_Squat", @"str_jl_Legpress", @"str_jl_run_96", @"str_jl_Motocross",
                          @"str_jl_Rowing", @"str_jl_Crossfit", @"str_jl_Waterbike", @"str_jl_Kayak",
                          @"str_jl_Croquet", @"str_jl_Floorball", @"str_jl_MuayThai", @"str_jl_Jaiball",
                          @"str_jl_run_106", @"str_jl_Backtraining", @"str_jl_Watervolleyball", @"str_jl_Waterskiing", //25
                          @"str_jl_Mountainclimber", @"str_jl_HIIT", @"str_jl_BODYCOMBAT", @"str_jl_BODYBALANCE",
                          @"str_jl_TRX", @"str_jl_TaeBo",
                          @"str_jl_run_116", @"str_jl_run_117", @"str_jl_run_118",
                          @"str_jl_run_119", @"str_jl_run_120", @"str_jl_run_121", @"str_jl_run_122",
                          @"str_jl_run_123", @"str_jl_run_124", @"str_jl_run_125", @"str_jl_run_126",
                          @"str_jl_run_127", @"str_jl_run_128", @"str_jl_run_129", @"str_jl_run_130",
                          @"str_jl_run_131", @"str_jl_run_132", @"str_jl_run_133", @"str_jl_run_134",
                          @"str_jl_run_135", @"str_jl_run_136", @"str_jl_run_137", @"str_jl_run_138",
                          @"str_jl_run_139", @"str_jl_run_140", @"str_jl_run_141", @"str_jl_run_142",
                          @"str_jl_run_143", @"str_jl_run_144", @"str_jl_run_145", @"str_jl_run_146",
                          @"str_jl_run_147", @"str_jl_run_148", @"str_jl_run_149", @"str_jl_run_150",
                          @"str_jl_run_151", @"str_jl_run_152", @"str_jl_run_153", @"str_jl_run_154",
                          @"str_jl_run_155", @"str_jl_run_156", @"str_jl_run_157", @"str_jl_run_158",
                          @"str_jl_run_159", @"str_jl_run_160", @"str_jl_run_161"];
    
    NSString *tRunTypeTitle = Lang(tTypeArr[type]);
    
    return tRunTypeTitle;
}

/// 步幅
/// @param height 身高cm
+ (NSInteger)kStrideLength:(NSInteger)height {
    if (height >= 30 && height < 100) {
        return (height*0.001+0.2)*100;
    } else if (height >= 100 && height < 150) {
        return (height*0.004+0.1)*100;
    } else if (height >= 150 && height < 180) {
        return (height/300.0)*100;
    } else if (height >= 180 && height < 230) {
        return (height*0.005-0.3)*100;
    }
    return 0.55*100;
}

+ (CGFloat)maxSpeed:(SportType)type {
    if (type == SportTypeWalk) {
        return 4.5;
    } else if (type == SportTypeRide) {
        return 10.0;
    } else if (type == SportTypeClimb) {
        return 5.0;
    }
    return 7.0;
}

+ (CGFloat)minSpeed:(SportType)type {
    if (type == SportTypeWalk) {
        return 3.0;
    } else if (type == SportTypeRide) {
        return 8.0;
    } else if (type == SportTypeClimb) {
        return 4.5;
    }
    return 5.0;
}

+ (CGFloat)kcalValue:(NSInteger)calorie {
    return floor(calorie/1000.0*10)/10;
}

+ (CGFloat)distanceValue:(NSInteger)meter {
    if (ImperialUnit) {
        return floor(0.621*meter/1000.0*100)/100;
    }
    return floor(meter/1000.0*100)/100;
}

+ (CGFloat)tempValue:(NSInteger)celsius {
    if (FahrenheitUnit) {
        return floor(320+celsius/10.0*1.8*10)/10;
    }
    return celsius/10.0;
}

+ (CGFloat)weightValue:(NSInteger)kilogram {
    if (ImperialUnit) {
        return 2.205*kilogram/10.0;
    }
    return kilogram/10.0;
}

+ (CGFloat)heightValue:(CGFloat)cm {
    if (ImperialUnit) {
        return round(cm/2.54);
    }
    return round(cm);
}

+ (CGFloat)formatOneDecimalValue:(CGFloat)value {
    CGFloat resultValue = roundf(value*10)/10;
    return resultValue;
}

+ (NSString *)transformDuration:(NSInteger)second {
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)second/3600,(long)second%3600/60,(long)second%60];
}
    
@end
