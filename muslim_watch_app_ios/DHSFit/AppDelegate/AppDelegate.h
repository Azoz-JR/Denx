//
//  AppDelegate.h
//  DHSFit
//
//  Created by DHS on 2022/5/30.
//

#import <UIKit/UIKit.h>
#import "Reach.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (BOOL)connected;
- (BOOL)networkConnected;

@property (strong, nonatomic) UIWindow * window;

@end

