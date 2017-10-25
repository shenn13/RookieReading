//
//  NSObject+ZXHUD.m
//  topLicaiPro
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 wusu. All rights reserved.
//

#import "NSObject+ZXHUD.h"

#import <objc/runtime.h>

static void *HUD_KEY = &HUD_KEY;

@implementation NSObject (ZXHUD)

-(void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, &HUD_KEY, HUD, OBJC_ASSOCIATION_RETAIN);
}

-(MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, &HUD_KEY);
}

+(MBProgressHUD *)configHUDStyle:(NSString *)text inView:(UIView *)view
{
    MBProgressHUD *HUD;
    if ([view isKindOfClass:[UIWindow class]])
    {
        HUD = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)view];
        HUD.userInteractionEnabled = YES;
    }
    else
    {
        HUD = [[MBProgressHUD alloc] initWithView:view];
        HUD.userInteractionEnabled = NO;
    }
    HUD.labelColor = [UIColor whiteColor];
    HUD.labelFont = FONT_BOLD(15);
    HUD.removeFromSuperViewOnHide = YES;
    // 背景色
    HUD.color = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    HUD.labelText = text;
    HUD.animationType = MBProgressHUDAnimationZoomOut;
    return HUD;
}

-(void)showText:(NSString *)text inView:(UIView *)view
{
    if (self.HUD) {
        [self.HUD hide:NO];
        self.HUD = nil;
    }
    
    MBProgressHUD *HUD = [UIView configHUDStyle:text inView:view];
    HUD.mode = MBProgressHUDModeText;
    [view addSubview:HUD];
    self.HUD = HUD;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}


-(void)showTextWithState:(ActivityHUDState)state inView:(UIView *)view text:(NSString *)text
{
    if (self.HUD) {
        [self.HUD hide:NO];
        self.HUD = nil;
    }
    MBProgressHUD *HUD = [UIView configHUDStyle:text inView:view];
    HUD.mode = MBProgressHUDModeCustomView;
    
    UIImage *image = nil;
    switch (state) {
        case 0:
            image = [UIImage imageNamed:@"MBHUD_Warn"];
            break;
        case 1:
            image = [UIImage imageNamed:@"MBHUD_Success"];
            break;
        default:
            break;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    HUD.customView =imageView;
    [view addSubview:HUD];
    self.HUD = HUD;

    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

-(void)startActivityWithText:(NSString *)text
{
    if (self.HUD) {
        [self.HUD hide:NO];
        self.HUD = nil;
    }
    
    MBProgressHUD *HUD = [UIView configHUDStyle:text inView:KEY_WINDOW];
    HUD.activityIndicatorColor = [UIColor whiteColor];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [KEY_WINDOW addSubview:HUD];
    self.HUD = HUD;
    
    // 菊花控件最多展示20秒
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(20);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

- (void)stopActivityWithText:(NSString *)text state:(ActivityHUDState)state
{
    if (text != nil && text.length > 0)
    {
        UIImage *image = nil;
        switch (state) {
            case 0:
                image = [UIImage imageNamed:@"MBHUD_Warn"];
                break;
            case 1:
                image = [UIImage imageNamed:@"MBHUD_Success"];
                break;
            default:
                break;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.labelText = text;
        self.HUD.customView = imageView;
        [self.HUD hide:YES afterDelay:1.f];
    }
    else
    {
        [self.HUD hide:NO];
    }
}


@end
