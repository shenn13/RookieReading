//
//  ZXBaseTabBarController.m
//  MoreAndMore
//
//  Created by Silence on 16/6/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXBaseTabBarController.h"

@interface ZXBaseTabBarController ()
{
    BOOL _isAnimation;
}

@end

@implementation ZXBaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
