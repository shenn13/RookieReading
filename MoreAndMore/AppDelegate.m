//
//  AppDelegate.m
//  MoreAndMore
//
//  Created by Silence on 16/6/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+ShareSDK.h"
#import "AppDelegate+NavigationStyle.h"
#import "IQKeyboardManager.h"

#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needLoginAction:) name:NEEDLOGIN_NOTNAME object:nil];
    
    // AFNetWoriking开启网络监测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 键盘统一收回处理
    [self configureBoardManager];
    
    // 注册ShareSDK
    [self registerShareSDK];
    
    // MagicalRecord初始化
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:KUAI_YUE];
    
    [self configApplicationNavigatinBarStyle];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

#pragma mark 键盘收回管理
-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField=60;
    manager.enableAutoToolbar = NO;
}

#pragma mark - 根据实际情况弹出登录控制器

-(void)needLoginAction:(NSNotification *)noti
{
    __weak UIViewController *theVC = nil;
    
    id jumpNavigation = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([jumpNavigation isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBar = (UITabBarController *)jumpNavigation;
        if ([tabBar.selectedViewController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *nav = (UINavigationController *)tabBar.selectedViewController;
            theVC = nav.topViewController;
        }
    }
    
    if ([theVC isKindOfClass:[LoginViewController class]]) return;
    // 登录控制器
    UINavigationController *nav = BoardVCWithID(@"My", @"LOGIN_NAV");
    
    if (theVC.presentedViewController)
    {
        [theVC dismissViewControllerAnimated:NO completion:^{
            [theVC presentViewController:nav animated:YES completion:nil];
        }];
    }
    else
    {
        [theVC presentViewController:nav animated:YES completion:nil];
    }
}

@end
