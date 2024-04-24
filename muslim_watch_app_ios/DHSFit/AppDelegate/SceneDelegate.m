//
//  SceneDelegate.m
//  MuslimFit
//
//  Created by Karim on 14/07/2023.
//

#import <Foundation/Foundation.h>
#import "SceneDelegate.h"
#import "LaunchViewController.h"
#import "SignHomeViewController.h"
#import "RootTabBarController.h"
#import "DataUploadManager.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    NSLog(@"scene willConnectToSession");

    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    
//    [[NSNotificationCenter defaultCenter]
//            postNotificationName:@"RegisterFont"
//            object:nil];
    
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
    
    [self addObservers];
    
    
    [self.window makeKeyAndVisible];
    windowScene.delegate = self;
    
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, so any non-reusable resources should be released.
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
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

@end
