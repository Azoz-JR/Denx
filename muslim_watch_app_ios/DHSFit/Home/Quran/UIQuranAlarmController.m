//
//  UIQuranAlarmController.m
//  DHSFit
//
//  Created by qiao liwei on 2023/5/22.
//

#import "UIQuranAlarmController.h"
#import "QuranAlarmCell.h"
#import "PrayAlarmSetModel.h"
#import <UserNotifications/UserNotifications.h>
#import "PrayTime.h"
#import "DHTool.h"


@interface UIQuranAlarmController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *quranAlarmTb;

@property (nonatomic, strong) IBOutlet UILabel *alarmCountDownLb;
@property (nonatomic, strong) IBOutlet UILabel *alarmWeekLb;
@property (nonatomic, strong) IBOutlet UILabel *alarmDateLb;
@property (nonatomic, strong) IBOutlet UIImageView *alarmHeadBgIv;
@property (weak, nonatomic) IBOutlet UISegmentedControl *notificationSoundSegment;

@property (nonatomic, strong) NSArray *alarmImageArr;
@property (nonatomic, strong) NSArray *alarmTitleArr;
@property (nonatomic, strong) NSArray *alarmHeadImageArr;
@property (nonatomic, strong) NSTimer *alarmCountDownTimer;
@property (nonatomic, assign) NSInteger alarmCountDownNum;

@property(nonatomic, strong) NSMutableArray <PrayAlarmSetModel *>*alarmArray;
/// 是否12小时制
@property (nonatomic, assign) BOOL isHasAMPM;
/// 小时数组
@property (nonatomic, strong) NSMutableArray *hourArray;
/// 分钟数组
@property (nonatomic, strong) NSMutableArray *minuteArray;
/// AMPM
@property (nonatomic, strong) NSArray *splitArray;

@property (nonatomic, strong) NSArray *prayersTimesArray;

@property (nonatomic, strong) NSArray *bodies;

@property (nonatomic, strong) NSMutableArray *selectedBodies;

@property (nonatomic, strong) NSMutableArray *triggers;

@property (nonatomic, strong) NSMutableArray *contents;

@property (nonatomic, strong) UNMutableNotificationContent *content;

@property (nonatomic, strong) NSCalendar *islamicCalendar;
@property (nonatomic, assign) NSInteger dayNum;
@property (nonatomic, strong) IBOutlet UILabel *sunsetLabel;
@property (nonatomic, strong) PrayTime *mPrayTime;

@end

@implementation UIQuranAlarmController
- (IBAction)notificationSoundAction:(id)sender {
    switch (self.notificationSoundSegment.selectedSegmentIndex) {
        case 0:
            self.content.sound = UNNotificationSound.defaultSound;
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"Adhan"];
            break;
        case 1:
            self.content.sound = [UNNotificationSound soundNamed:@"azan.wav"];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"Adhan"];
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [DHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationController.isNavigationBarHidden = NO;
    [[self navigationController] setNavigationBarHidden:NO];
    
    self.hbd_barHidden = NO;
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barShadowHidden = YES;
    self.hbd_barAlpha = 0.0;
    self.hbd_barTintColor = [UIColor whiteColor];
    
    self.title = Lang(@"str_prayer");
    
    self.alarmImageArr = @[@"mu_alarm_1", @"mu_alarm_2", @"mu_alarm_3", @"mu_alarm_4", @"mu_alarm_5"];
    self.alarmTitleArr = @[Lang(@"str_fajr"), Lang(@"str_dhuhr"), Lang(@"str_asr"), Lang(@"str_maghreb"), Lang(@"str_lsha")];
    self.alarmHeadImageArr = @[@"muslim_alarm_head_1", @"muslim_alarm_head_2", @"muslim_alarm_head_3", @"muslim_alarm_head_4", @"muslim_alarm_head_5"];
    
    [[OnceLocationManager shareInstance] startOnceRequestLocationWithBlock:^(NSString * _Nonnull locationStr) {
        NSLog(@"startOnceRequestLocationWithBlock %@", locationStr);
    }];
    
    self.content = [[UNMutableNotificationContent alloc] init];
    
    self.triggers = [NSMutableArray array];
    
    self.contents = [NSMutableArray array];
    
    self.selectedBodies = [NSMutableArray array];
    
//    self.prayersTimesArray = @[@"14:33",@"17:25",@"17:16",@"4:14",@"4:15"];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Adhan"]) {
        self.notificationSoundSegment.selectedSegmentIndex = 1;
        self.content.sound = [UNNotificationSound soundNamed:@"azan.wav"];
    } else {
        self.notificationSoundSegment.selectedSegmentIndex = 0;
        self.content.sound = UNNotificationSound.defaultSound;
    }
    
    self.prayersTimesArray = @[[[NSUserDefaults standardUserDefaults] stringForKey:@"fajr"], 
                               [[NSUserDefaults standardUserDefaults] stringForKey:@"dhuhr"],
                               [[NSUserDefaults standardUserDefaults] stringForKey:@"asr"],
                               [[NSUserDefaults standardUserDefaults] stringForKey:@"maghrib"],
                               [[NSUserDefaults standardUserDefaults] stringForKey:@"ishaA"] ];
    
    self.bodies = @[@"Al-fajr", @"Al-Dhuhr", @"Al-Asr", @"Al-Maghreb", @"Al-Isha"];
    
    [self.quranAlarmTb registerNib:[UINib nibWithNibName:@"QuranAlarmCell" bundle:nil] forCellReuseIdentifier:@"QuranAlarmCell"];
    
    self.alarmCountDownNum = 0;
    
    //    [PrayAlarmSetModel deleteAllPrayAlarms];
    
    self.islamicCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamicUmmAlQura];

    [self getPrayAlarms];
    [self addObservers];
    
    self.dayNum = 0; //0为今天
    self.mPrayTime = [[PrayTime alloc] init];
    [self viewLoadTestData];
    
    [self calculateRecentAlarmClock];
        
    
    __weak UIQuranAlarmController *weakSelf = self;
    [DHBleCommand getPrayAlarms:^(int code, NSArray *data) {
        if (code == 0){
            int tAlarmIndex = 0;
            for (PrayAlarmSetModel *tAlarmModel in self.alarmArray){
                DHPrayAlarmSetModel *tBleAlarmModel = data[tAlarmIndex];
                tAlarmModel.isOpen = tBleAlarmModel.isOpen;
                ++tAlarmIndex;
            }
            [weakSelf.quranAlarmTb reloadData];
        }
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self timerClean];
}

- (void)getPrayAlarms {
    self.alarmArray = [NSMutableArray array];
    NSArray *array = [PrayAlarmSetModel queryAllPrayAlarms];
    if (array.count) {
        [self.alarmArray addObjectsFromArray:array];
    }
    else{
        //保存5个关闭的闹钟
        for (int i = 0; i < 5; i++){
            PrayAlarmSetModel *alarmModel = [[PrayAlarmSetModel alloc] init];
            
            alarmModel.isOpen = 0;
            alarmModel.hour = 0;
            alarmModel.minute = 0;
            alarmModel.alarmType = i;
            alarmModel.alarmBody = @"";
            [self.alarmArray addObject:alarmModel];
        }
        
        [PrayAlarmSetModel saveObjects:self.alarmArray];
    }
    
    [self.quranAlarmTb reloadData];
}

- (void)saveModel:(id)data {
    [PrayAlarmSetModel deleteAllPrayAlarms];
    NSArray *alarms = data;
    self.alarmArray = [NSMutableArray array];
    if (alarms.count) {
        for (int i = 0; i < alarms.count; i++) {
            DHPrayAlarmSetModel *model = alarms[i];
            PrayAlarmSetModel *alarmModel = [[PrayAlarmSetModel alloc] init];
            
            alarmModel.isOpen = model.isOpen;
            alarmModel.hour = model.hour;
            alarmModel.minute = model.minute;
            alarmModel.alarmType = model.alarmType;
            alarmModel.alarmBody = model.alarmBody;
            [self.alarmArray addObject:alarmModel];
        }
        [PrayAlarmSetModel saveObjects:self.alarmArray];
    }
    
}

- (void)addObservers {
    //程序进入前台
    [DHNotificationCenter addObserver:self selector:@selector(handleWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    //状态更新
    [DHNotificationCenter addObserver:self selector:@selector(alarmChange) name:BluetoothNotificationPrayAlarmChange object:nil];
}

- (void)alarmChange {
    NSArray *array = [PrayAlarmSetModel queryAllPrayAlarms];
    if (array.count) {
        [self.alarmArray removeAllObjects];
        [self.alarmArray addObjectsFromArray:array];
    }
    
    [self.quranAlarmTb reloadData];
    
    [self calculateRecentAlarmClock];
}

- (void)initData {
    self.isHasAMPM = NO;//[BaseTimeModel isHasAMPM];
    [self.quranAlarmTb reloadData];
}

- (void)handleWillEnterForeground {
    if ([BaseTimeModel isHasAMPM] != self.isHasAMPM) {
        self.isHasAMPM = [BaseTimeModel isHasAMPM];
        [self updateTimeData];
    }
}

- (void)updateTimeData {
    if (self.alarmArray.count == 0) {
        return;
    }
}

- (void)alarmSwitchChange:(UISwitch *)sender
{
    NSInteger sectionIndex = sender.tag;
    PrayAlarmSetModel *tAlarmModel = self.alarmArray[sectionIndex];
    tAlarmModel.isOpen = sender.isOn;
    
    tAlarmModel.hour = [[[self.prayersTimesArray[sectionIndex] componentsSeparatedByString:@":"] objectAtIndex:0] integerValue];
    
    //    tAlarmModel.hour = [hour integerValue];
    tAlarmModel.minute = [[[self.prayersTimesArray[sectionIndex] componentsSeparatedByString:@":"] objectAtIndex:1] integerValue];
    
//    [tAlarmModel.alarmBody addObjectsFromArray:self.bodies[sectionIndex]];
    if (sender.isOn) {
        [self.selectedBodies addObject:self.bodies[sectionIndex]];
    } else {
        [self.selectedBodies removeObject:self.bodies[sectionIndex]];
    }
    
//    tAlarmModel.alarmBody = self.bodies[sectionIndex];
    
    NSLog(@"%@", self.alarmArray[sectionIndex]);
    
//    [tAlarmModel.alarmBody addObject:self.bodies[sectionIndex]];
    
    NSLog(@"%@", self.bodies[sectionIndex]);
    
    [self calculateRecentAlarmClock];
    [self sendAlarmToDev];
    [self localNotification:tAlarmModel];
}

- (void)sendAlarmToDev{
    
    NSMutableArray *models = [NSMutableArray array];
    for (int i = 0; i < self.alarmArray.count; i++) {
        PrayAlarmSetModel *model = self.alarmArray[i];
        DHPrayAlarmSetModel *alarmModel = [[DHPrayAlarmSetModel alloc] init];
        alarmModel.alarmType = model.alarmType;
        alarmModel.isOpen = model.isOpen;
        alarmModel.hour = model.hour;
        alarmModel.minute = model.minute;
        [models addObject:alarmModel];
    }
    
    [self saveModel:models];
    
    
    if (!DHDeviceConnected) {
        SHOWHUD(Lang(@"str_device_disconnected"))
        return;
    }
    
    SHOWINDETERMINATE
    WEAKSELF
    [DHBleCommand setPrayAlarms:models block:^(int code, id  _Nonnull data) {
        if (code == 0) {
            SHOWHUD(Lang(@"str_save_success"))
            [weakSelf saveModel:models];
        } else {
            SHOWHUD(Lang(@"str_save_fail"))
        }
    }];
}

- (void)localNotification:(PrayAlarmSetModel *)tAlarmModel
{
    
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
//    [self.selectedBodies removeAllObjects];
    
//    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //    content.title = @"祈祷闹钟";
    //    content.body = @"祈祷闹钟到了";
//    self.content.sound = UNNotificationSound.defaultSound;
    self.content.badge = 0;
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now];
    [components setHour: tAlarmModel.hour];
    [components setMinute: tAlarmModel.minute];
//    content.body = tAlarmModel.alarmBody;
    
//    [self.selectedBodies addObject:self.bodies[]];
    
    //    [self.triggers addObject:[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:true]];
    
    //    self.triggers = @[[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:true]];
    
    //self.triggers = @[[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:true]]; //the on that working
    
    //    [self.triggers addObject:[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:true]];
    
    if (tAlarmModel.isOpen) {
        [self.triggers addObject:[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:true]];
        NSLog(@"%@",self.triggers);
        
    } else {
        [self.triggers removeObject:[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:true]];
        NSLog(@"%@",self.triggers);
        
    }
    
    //    [self.triggers add]
    
    //    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0 repeats:NO];
    
    //    NSArray *bodies = @[@"Al-fajr", @"Al-Dhuhr", @"Al-Asr", @"Al-Maghreb", @"Al-Isha"];
    
    //    UNMutableNotificationContent *content = UNMutableNotificationContent();
    
    //    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    for (int i = 0; i < self.triggers.count; i++) {
        
        self.content.body = self.selectedBodies[i];
        
        //        NSString *identifier = @"Local Notification %02d", x;
        
        NSString *identifier = [NSString stringWithFormat:@"Local Notification%02d", i];
        
        
        //        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: triggers[x])
        //
        //        UNUserNotificationCenter.current().add(request) { error in
        //            if let error = error {
        //                print("Error \(error.localizedDescription)")
        //            }
        //        }
        
//        [[UNUserNotificationCenter currentNotificationCenter]getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
//            NSLog(@"count%lu",(unsigned long)requests.count);
//            if (requests.count>0) {
//                UNNotificationRequest *pendingRequest = [requests objectAtIndex:0];
//                if ([pendingRequest.identifier isEqualToString:@"identifier"]) {
//                    [[UNUserNotificationCenter currentNotificationCenter]removePendingNotificationRequestsWithIdentifiers:@[pendingRequest.identifier]];
//                }
//            }
//
//        }];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:self.content trigger:self.triggers[i]];
        
        //        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:identifier];
        
        //        [[UNUserNotificationCenter currentNotificationCenter] remove]
        
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
        
    }
    
    //    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"timeInterval" content:content trigger:trigger];
    //    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    //
    //    }];
}

- (void)calculateRecentAlarmClock
{
    NSCalendar *tCalendar = [NSCalendar currentCalendar];
    NSDateComponents *tDateComp = [tCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
    
    PrayAlarmSetModel *tMinAlarm = nil;
    NSInteger tAlarmCountMin = 999999;
    int tAlarmMinIndex = 0;
    NSMutableArray *tAlarmDateArr = [NSMutableArray arrayWithCapacity:0];
    NSLog(@"self.alarmArray.count count %d", self.alarmArray.count);
    
    for (int i = 0; i < self.alarmArray.count; i++) {
        PrayAlarmSetModel *model = self.alarmArray[i];
        tDateComp.hour = model.hour;
        tDateComp.minute = model.minute;
        NSDate *tAlarmdate = [tCalendar dateFromComponents:tDateComp];
        double tAlarmDateTimeInterval = [tAlarmdate timeIntervalSince1970];
        if (tAlarmDateTimeInterval <= [[NSDate date] timeIntervalSince1970]){
            tAlarmDateTimeInterval = tAlarmDateTimeInterval + 24*3600;
            [tAlarmDateArr addObject:@(tAlarmDateTimeInterval)];
        }
        else{
            [tAlarmDateArr addObject:@(tAlarmDateTimeInterval)];
        }
        
        if (model.isOpen){
            if ((tAlarmDateTimeInterval - [[NSDate date] timeIntervalSince1970]) < tAlarmCountMin){
                
                tAlarmMinIndex = i;
                tAlarmCountMin = (tAlarmDateTimeInterval - [[NSDate date] timeIntervalSince1970]);
                tMinAlarm = model;
            }
        }
    }
    
    if (tMinAlarm != nil){
        NSLog(@"tAlarmMinIndex %d", tAlarmMinIndex);
        self.alarmCountDownNum = tAlarmCountMin;
        self.alarmHeadBgIv.image = [UIImage imageNamed:self.alarmHeadImageArr[tAlarmMinIndex%5]];
        [self timerStart];
    }
    else{
        [self timerClean];
        self.alarmCountDownNum = 0;
        self.alarmCountDownLb.text = @"00:00:00";
        self.alarmHeadBgIv.image = [UIImage imageNamed:@"muslim_alarm_head_1"];
    }
}

- (IBAction)preButtonClick:(id)sender
{
    self.dayNum -= 1;
    [self viewLoadTestData];
}

- (IBAction)nextButtonClick:(id)sender
{
    self.dayNum += 1;
    [self viewLoadTestData];
}

- (void)viewLoadTestData
{
    NSDate *tTestDate = [[NSDate date] dateByAddingTimeInterval:self.dayNum * 3600 * 24];
    
    NSDateFormatter *tDateF = [[NSDateFormatter alloc] init];
    [tDateF setDateFormat:@"MM/dd EEEE"];
    self.alarmWeekLb.text = [tDateF stringFromDate:tTestDate];
    
    NSDateComponents *tIslamicDateComp = [self.islamicCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:tTestDate];
    
    self.alarmDateLb.text = [NSString stringWithFormat:@"%@ %04ld-%02ld-%02ld", Lang(@"str_islamic"), tIslamicDateComp.year, tIslamicDateComp.month, tIslamicDateComp.day];

    
    NSCalendar *curCalendar = [NSCalendar currentCalendar];
    NSDateComponents *tDateComp = [curCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:tTestDate];
    
    [self.mPrayTime setCalcMethod:(int)self.mPrayTime.MWL];
    [self.mPrayTime setTimeFormat:(int)self.mPrayTime.Time24];
    
    NSInteger tTimeZone = [self.mPrayTime getTimeZone];
    double tLatitude = [[ConfigureModel shareInstance].latitude doubleValue];
    double tLongitude = [[ConfigureModel shareInstance].longitude doubleValue];
    
    NSMutableArray *tarr = [self.mPrayTime getPrayerTimes:tDateComp andLatitude:tLatitude andLongitude:tLongitude andtimeZone:tTimeZone];
    self.sunsetLabel.text = [NSString stringWithFormat:@"%@: %@ %@: %@", Lang(@"str_jl_denx_sunrise"), tarr[1], Lang(@"str_jl_denx_sunset"), tarr[4]];// @"日出: --:-- 日落: --:--";
    NSLog(@"PrayTime %@ tLatitude %lf tLongitude %lf", tarr, tLatitude, tLongitude);

    
    self.prayersTimesArray = @[tarr[0],
                               tarr[2],
                               tarr[3],
                               tarr[5],
                               tarr[6]];
    
    NSMutableArray *tTempAlarmArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *tPrayerStr in self.prayersTimesArray){
        DHPrayAlarmSetModel *alarmModel = [[DHPrayAlarmSetModel alloc] init];
        NSArray *tPrayerHourMin = [tPrayerStr componentsSeparatedByString:@":"];
        alarmModel.alarmType = 0;
        alarmModel.isOpen = 1;
        alarmModel.hour = [tPrayerHourMin[0] intValue];
        alarmModel.minute = [tPrayerHourMin[1] intValue];
        [tTempAlarmArr addObject:alarmModel];
    }
    
    [self saveModel:tTempAlarmArr];
    
    [self.quranAlarmTb reloadData];
}



#pragma mark- 计数器操作
- (void)timerStart{
    if (self.alarmCountDownTimer){
        [self.alarmCountDownTimer invalidate];
        self.alarmCountDownTimer = nil;
    }
    self.alarmCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerOut:) userInfo:nil repeats:YES];
}
- (void)timerOut:(NSTimer *)timer
{
    _alarmCountDownNum -= 1;
    self.alarmCountDownLb.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", _alarmCountDownNum/3600, (_alarmCountDownNum/60)%60, _alarmCountDownNum%60];
    if (_alarmCountDownNum == 0){ //闹钟到时
        [self timerClean];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //        [self testAlertView];
        
        [self performSelector:@selector(calculateRecentAlarmClock) withObject:nil afterDelay:1.0];
    }
    
}
- (void)timerClean{
    if (self.alarmCountDownTimer){
        [self.alarmCountDownTimer invalidate];
        self.alarmCountDownTimer = nil;
    }
}

- (void)testAlertView
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"祈祷闹钟";
    content.body = @"祈祷闹钟到了";
    content.sound = UNNotificationSound.defaultSound;
    content.badge = 0;
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"timeInterval" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuranAlarmCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"QuranAlarmCell" forIndexPath:indexPath];
    tCell.alarmIconIv.image = [UIImage imageNamed:self.alarmImageArr[indexPath.section]];
    
    //    PrayAlarmSetModel *tAlarmModel = self.alarmArray[indexPath.section];
    //    tCell.alarmTimeLb.text = [NSString stringWithFormat:@"%@ %2@", self.alarmTitleArr[indexPath.section], self.prayersTimesArray[indexPath.section]];
    
    //    PrayAlarmSetModel *tAlarmModel = self.alarmArray[indexPath.section];
    //    tCell.alarmTimeLb.text = [NSString stringWithFormat:@"%@ %2@", self.alarmTitleArr[indexPath.section], [[NSUserDefaults standardUserDefaults] stringForKey:@"fajr"]];
    
    
    PrayAlarmSetModel *tAlarmModel = self.alarmArray[indexPath.section];
    tCell.alarmTimeLb.text = [NSString stringWithFormat:@"%@ %2@", self.alarmTitleArr[indexPath.section], self.prayersTimesArray[indexPath.section]];
    
    
//    switch (indexPath.section) {
//        case 0:
//            tCell.alarmTimeLb.text = self.prayersTimesArray[indexPath.section];
//        case 1:
//            tCell.alarmTimeLb.text = self.prayersTimesArray[indexPath.section];
//        case 2:
//            tCell.alarmTimeLb.text = self.prayersTimesArray[indexPath.section];
//        case 3:
//            tCell.alarmTimeLb.text = self.prayersTimesArray[indexPath.section];
//        case 4:
//            tCell.alarmTimeLb.text = self.prayersTimesArray[indexPath.section];
//        default:
//            break;
//    }
    
    
    //    tCell.alarmTimeLb.text = [NSString stringWithFormat:@"%@ %02d:%02d", self.alarmTitleArr[indexPath.section], tAlarmModel.hour, tAlarmModel.minute];
    
    [tCell.alarmSwitch setOn:tAlarmModel.isOpen];
    tCell.alarmSwitch.tag = indexPath.section;
    [tCell.alarmSwitch addTarget:self action:@selector(alarmSwitchChange:) forControlEvents:UIControlEventValueChanged];
    
    return tCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    PrayAlarmSetModel *tAlarmModel = self.alarmArray[indexPath.section];
    //
    //    [self showPickerView:tAlarmModel section:indexPath.section];
}
@end
