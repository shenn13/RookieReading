//
//  AppDelegate+NavigationStyle.m
//  MoreAndMore
//
//  Created by Silence on 16/6/4.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "AppDelegate+NavigationStyle.h"

@implementation AppDelegate (NavigationStyle)

-(void)configApplicationNavigatinBarStyle
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    UIImage *image = [UIImage imageNamed:@"menu_bk_partten"];
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTintColor:[UIColor whiteColor]];
    
    navigationBar.translucent = NO;
    
    // NSStrokeColorAttributeName:[[UIColor whiteColor]colorWithAlphaComponent:0.8]

    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont boldSystemFontOfSize:16]};
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    /**!
     *  NSFontAttributeName;(字体)
     
     *  NSParagraphStyleAttributeName;(段落)
     --> 该属性所对应的值是一个 NSParagraphStyle 对象。该属性在一段文本上应用多个属性。如果不指定该属性，则默认为 NSParagraphStyle 的defaultParagraphStyle 方法返回的默认段落属性。
     
     *  NSForegroundColorAttributeName;(字体颜色)
     *  NSBackgroundColorAttributeName;(字体背景色)
     *  NSLigatureAttributeName;(连字符)
     *  NSKernAttributeName;(字间距)
     *  NSStrikethroughStyleAttributeName;(删除线)
     *  NSUnderlineStyleAttributeName;(下划线)
     *  NSStrokeColorAttributeName;(边线颜色)
     *  NSStrokeWidthAttributeName;(边线宽度)
     *  NSShadowAttributeName;(阴影: NSShadow 对象)
     *  NSVerticalGlyphFormAttributeName;(横竖排版:0 表示横排文本 1 表示竖排文本)
     */
    // 隐藏导航栏返回按钮文本
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    // 底部导航栏风格
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.tintColor = THEME_COLOR;
    [tabBar setBackgroundColor:THEME_TINTCOLOR];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    /**
     *  主窗口背景色
     */
    self.window.backgroundColor = [UIColor whiteColor];
    /*
    UIImage *backImage = [[UIImage imageNamed:@"MIDAUTUMNIMAGE"
                           ]
                          blurredImageWithRadius:10
                          iterations:5
                          tintColor:[UIColor blackColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = backImage;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.backImageView = imageView;
    [self.window addSubview:imageView];
    */
    [self.window makeKeyAndVisible];
}

@end
