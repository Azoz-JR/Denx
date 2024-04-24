//
//  RootTabBarController.m
//  DHSFit
//
//  Created by DHS on 2022/5/31.
//

#import "RootTabBarController.h"
#import "HomePageViewController.h"
#import "SportViewController.h"
#import "DeviceViewController.h"
#import "MineViewController.h"
#import "QuranHomeController.h"
#import "HBDNavigationController.h"
#import "MuslimFit-Swift.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

#pragma mark - vc lift cycle 生命周期

- (UIColor * _Nullable)extracted {
    return HomeColor_MainColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomePageViewController * home = [[HomePageViewController alloc] init];
    home.title = Lang(@"str_tab_home");
    home.tabBarItem.image = [DHImage(@"tabbar_home_unSelected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    home.tabBarItem.selectedImage = DHImage(@"tabbar_home_selected");
    home.isHideNavigationView = YES;
    home.isHomeViewController = YES;
    home.navLeftImage = @"public_nav_disconnected";
    home.navTitle = Lang(@"str_disconnected");
    home.navRightImage = @"public_nav_share";
    home.navRightImage2 = @"public_nav_refresh";
    
    UINavigationController *homeVC = [[UINavigationController alloc] initWithRootViewController:home];
    
    SportViewController *sport = [[SportViewController alloc] init];
    sport.title = Lang(@"str_tab_sport");
    sport.tabBarItem.image = [DHImage(@"tabbar_sport_unSelected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    sport.tabBarItem.selectedImage = DHImage(@"tabbar_sport_selected");
    sport.navLeftImage = @"public_nav_record";
    sport.navTitle = @"";
    sport.navRightImage = @"mine_main_settings";
    UINavigationController *sportVC = [[UINavigationController alloc]initWithRootViewController:sport];

    DeviceViewController *device = [[DeviceViewController alloc] init];
    device.title = Lang(@"str_tab_device");
    device.tabBarItem.image = [DHImage(@"tabbar_device_unSelected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    device.tabBarItem.selectedImage = DHImage(@"tabbar_device_selected");
    device.isHideNavigationView = YES;
    device.isHomeViewController = YES;
    device.navLeftImage = @"public_nav_disconnected";
    device.navTitle = Lang(@"str_disconnected");
    device.navRightImage = @"public_nav_search";
    device.navRightImage2 = @"public_nav_scan";
    //device.isHideNavRightButton = YES;
    UINavigationController *deviceVC = [[UINavigationController alloc] initWithRootViewController:device];
    
//    QuranHomeController *quranHomeC = [[QuranHomeController alloc] initWithNibName:@"QuranHomeController" bundle:nil];
//    quranHomeC.title = Lang(@"str_muslim");
//    quranHomeC.tabBarItem.image = [DHImage(@"tabbar_mosilin_unSelected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    quranHomeC.tabBarItem.selectedImage = DHImage(@"tabbar_mosilin_selected");
////    quranHomeC.isHideNavigationView = YES;
////    quranHomeC.isHomeViewController = NO;
//
//    HBDNavigationController *quranNavVC = [[HBDNavigationController alloc] initWithRootViewController:quranHomeC];
    
//    mulsimViewController *mulsimHomeC = [[mulsimViewController alloc]
//                                         initWithNibName:@"mulsimViewController" bundle:nil];
    MuslimViewController *MuslimHomeC = [[MuslimViewController alloc]
                                         init];
    MuslimHomeC.title = Lang(@"str_muslim");
    MuslimHomeC.tabBarItem.image = [DHImage(@"tabbar_mosilin_unSelected")imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    MuslimHomeC.tabBarItem.selectedImage = DHImage((@"tabbar_mosilin_selected"));
    HBDNavigationController *MuslimNavVC = [[HBDNavigationController alloc]initWithRootViewController:MuslimHomeC];
    
    
    MineViewController *mine = [[MineViewController alloc] init];
    mine.title = Lang(@"str_tab_mine");
    mine.tabBarItem.image = [DHImage(@"tabbar_mine_unSelected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mine.tabBarItem.selectedImage = DHImage(@"tabbar_mine_selected");
    mine.isHideNavigationView = YES;
    UINavigationController *mineVC = [[UINavigationController alloc]initWithRootViewController:mine];
    self.viewControllers = @[homeVC, sportVC, deviceVC, MuslimNavVC, mineVC];
//    self.viewControllers = @[homeVC, sportVC, deviceVC, quranNavVC, mineVC];

    UIImage *image = [HomeColor_BlockColor colorToImage];
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundImage = image;
        appearance.backgroundImageContentMode = UIViewContentModeScaleToFill;
        
        UITabBarItemAppearance *itemAppearance = [[UITabBarItemAppearance alloc] init];
        itemAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorNamed:@"D_#C3C4C2"]};
        itemAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName:HomeColor_MainColor};
        appearance.stackedLayoutAppearance = itemAppearance;
        self.tabBar.standardAppearance = appearance;
        
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    }
    else if (@available(iOS 10.0, *)) {
        [self.tabBar setBackgroundImage:[image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
        
        self.tabBar.tintColor = [self extracted];
        self.tabBar.unselectedItemTintColor = [UIColor colorNamed:@"D_#C3C4C2"];
    }
    
    self.tabBar.tintColor = HomeColor_MainColor;
    [UITabBar appearance].translucent = NO;
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    [textAttrs setObject:[UIColor colorNamed:@"D_#C3C4C2"] forKey:NSForegroundColorAttributeName];
    [textAttrs setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    
    NSMutableDictionary *textAttrs1 = [NSMutableDictionary dictionary];
    [textAttrs1 setObject:HomeColor_MainColor forKey:NSForegroundColorAttributeName];
    [textAttrs1 setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
     
    [[UITabBarItem appearance] setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:textAttrs1 forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
}


@end
