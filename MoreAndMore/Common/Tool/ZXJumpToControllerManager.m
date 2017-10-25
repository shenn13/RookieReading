//
//  ZXJumpToControllerManager.m
//  MoreAndMore
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXJumpToControllerManager.h"

@implementation ZXJumpToControllerManager

singleton_implementation(ZXJumpToControllerManager)

- (UINavigationController *)jumpNavigation
{
    id jumpNavigation = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([jumpNavigation isKindOfClass:[UINavigationController class]])
    {
        _jumpNavigation = (UINavigationController *)jumpNavigation;
    }
    else if ([jumpNavigation isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBar = (UITabBarController *)jumpNavigation;
        if ([tabBar.selectedViewController isKindOfClass:[UINavigationController class]])
        {
            _jumpNavigation = tabBar.selectedViewController;
        }
        if (tabBar.selectedViewController.presentedViewController && [tabBar.selectedViewController.presentedViewController isKindOfClass:[UINavigationController class]])
        {
            _jumpNavigation = (UINavigationController *)tabBar.selectedViewController.presentedViewController;
        }
    }
    return _jumpNavigation;
}

@end
