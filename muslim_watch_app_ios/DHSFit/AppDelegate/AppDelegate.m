//
//  AppDelegate.m
//  DHSFit
//
//  Created by DHS on 2022/5/30.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "SignHomeViewController.h"
#import "RootTabBarController.h"
#import "DataUploadManager.h"
#import "MuslimFit-Swift.h"
#import "MuslimFit-Bridging-Header.h"
//#import "NoorFont.h"
//#import <NoorFont/NoorFont-Swift.h>
//#import <NoorFont/NoorFont.h>
#import "NoorFont.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (BOOL)networkConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)notificationCenter:(NSNotification *) notification
{
    printf("test notification");
    [[NSNotificationCenter defaultCenter]
            postNotificationName:@"RegisterFont"
            object:nil];
}

- (void)clearCoreData:(NSNotification *) notification
{
    
    printf("test notification");
    
//    if ([self.connected] == true) {
        [[NSNotificationCenter defaultCenter]
                postNotificationName:@"ClearCoreData"
                object:nil];
//    }
        
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [[NSNotificationCenter defaultCenter]
//            postNotificationName:@"RegisterFont"
//            object:nil];
    
//    FontName.registerFonts()
//    LoggingSystem.bootstrap(StreamLogHandler.standardError)
//    AsyncTextLabelSystem.bootstrap(FixedTextNode.init)
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(notificationCenter:)
            name:@"TestNotification"
            object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"deviceLang"] != LanguageManager.shareInstance.getHttpLanguageType) {
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
//        networkStatus != NotReachable;
        
        if (networkStatus != NotReachable) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                    selector:@selector(clearCoreData:)
                    name:@"ClearCore"
                    object:nil];
        } else {
            printf("there's no internet");
        }
    }
    
    NSLog(@"didFinishLaunchingWithOptions");
//    [NSThread sleepForTimeInterval:2.0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [ConfigureModel unarchiverModel];
    [UserModel currentModel];
    switch (DHAppStatus) {
        case 0:
        {
            LaunchViewController *vc = [[LaunchViewController alloc] init];
            vc.isHideNavigationView = YES;
            UINavigationController *launchVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.window setRootViewController:launchVC];
        }
            break;
        case 1:
        {
            SignHomeViewController *vc = [[SignHomeViewController alloc] init];
            vc.isHideNavigationView = YES;
            UINavigationController *launchVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.window setRootViewController:launchVC];
        }
            break;
        default:
        {
            RootTabBarController *rootVC = [[RootTabBarController alloc] init];
            [self.window setRootViewController:rootVC];
        }
            break;
    }
    
    [self registerHUD];
    [self registerNetwork];
    [self initBleSDK];
//    [self addObservers];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error)
            {
                NSLog(@"请求授权成功");
            }
            else
            {
                NSLog(@"请求授权失败");
            }
    }];
    center.delegate = self;
    
    return YES;
}

//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    
//}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    [DHBluetoothManager shareInstance].isActive = YES;
    if (![DHBleCentralManager isJLProtocol]){
        [[DHBluetoothManager shareInstance] setAppStatus];
        [[DHBluetoothManager shareInstance] setTime];
        [[DHBluetoothManager shareInstance] setUnit]; //24小时与12小时制切换
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");

//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fontFlag"];
    
    [DHBluetoothManager shareInstance].isActive = NO;
    if (![DHBleCentralManager isJLProtocol]){
        [[DHBluetoothManager shareInstance] setAppStatus];
    }
}

-(UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window{
    return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[DHBleCentralManager shareInstance] clearData];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fontFlag"];
}

-(void)registerHUD{
    
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setErrorImage:DHImage(@"nil")];
    [SVProgressHUD setSuccessImage:DHImage(@"nil")];
    [SVProgressHUD setInfoImage:DHImage(@"nil")];
    [SVProgressHUD setCornerRadius:10];
    [SVProgressHUD setBackgroundColor:COLORANDALPHA(@"#494958", 0.9)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:HomeFont_TitleFont];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setMaximumDismissTimeInterval:8];
}

- (void)registerNetwork {
    //旧的：http://api.dhouse88.com:8000
    [DHNetworkFunc shareInstance].baseURL = @"http://api.denxwholesale.com:8000";
    
    if (DHAppStatus == 3) {
        [self delayPerformBlock:^(id  _Nonnull object) {
            [self queryUserInform];
        } WithTime:1.0];
    }
}

- (void)queryUserInform {
    [DHBluetoothManager shareInstance].isAppLaunch = YES;
    WEAKSELF
    [NetworkManager queryUserInformWithParameter:[NSDictionary dictionary] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        [DHBluetoothManager shareInstance].isAppLaunch = NO;
        if (resultCode == 401 || resultCode == 1010 || resultCode == 1011 ) {
            NSString *errorStr = [NetworkManager transformErrorCode:resultCode];
            SHOWHUD(errorStr)
            [AccountManager userSignout];
            [weakSelf userSignout];
        } else {
            [weakSelf querySwitchInform];
        }
    }];
}

- (void)querySwitchInform {
    WEAKSELF
    [NetworkManager querySwitchWithParam:[NSDictionary dictionary] andBlock:^(NSInteger resultCode, NSString * _Nonnull message, id  _Nonnull data) {
        //[DataUploadManager downloadAllHealthData];
        [weakSelf performSelector:@selector(delayUploadAllHealthData) withObject:nil afterDelay:3.0];
    }];
}

- (void)delayUploadAllHealthData {
    [DataUploadManager uploadAllHealthData];
}

- (void)initBleSDK {
    [DHBleCentralManager setLogStatus:YES];
    [DHBleCentralManager initWithServiceUuids:@[@"A00A"]];
    [DHBluetoothManager shareInstance];
}

- (void)addObservers {
    //用户登录
    [DHNotificationCenter addObserver:self selector:@selector(userSignin) name:AppNotificationUserSignin object:nil];
    //用户退出登录
    [DHNotificationCenter addObserver:self selector:@selector(userSignout) name:AppNotificationUserSignout object:nil];
}

- (void)userSignin {
    RootTabBarController *rootVC = [[RootTabBarController alloc] init];
    [self.window setRootViewController:rootVC];
}

- (void)userSignout {
    SignHomeViewController *vc = [[SignHomeViewController alloc] init];
    vc.isHideNavigationView = YES;
    UINavigationController *launchVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window setRootViewController:launchVC];
}

#pragma mark- UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"userNotificationCenter willPresentNotification");
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

@end
