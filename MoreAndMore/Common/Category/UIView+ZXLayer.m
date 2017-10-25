//
//  UIView+ZXLayer.m
//  schoolfriends
//
//  Created by Silence on 16/6/24.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "UIView+ZXLayer.h"

@implementation UIView (ZXLayer)

-(void)grandientLayerWithDirection:(ZXLayerDirection)direction color:(UIColor *)color toColor:(UIColor *)toColor
{
    //初始化Bottom渐变层
    CAGradientLayer *bgLayer = [CAGradientLayer layer];
    bgLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height);
    //设置渐变颜色方向(从上往下)
    if (direction == ZXLayerDirectionOfTopToBottom)
    {
        bgLayer.startPoint = CGPointMake(0, 0);
        bgLayer.endPoint = CGPointMake(0, 1);
    }
    else if (direction == ZXLayerDirectionOfLeftToRight)
    {
        bgLayer.startPoint = CGPointMake(0, 0);
        bgLayer.endPoint  = CGPointMake(1, 0);
    }
    
    //设定颜色组
    bgLayer.colors = @[(__bridge id)color.CGColor,
                       (__bridge id)toColor.CGColor];
    
    //设定颜色分割点
    bgLayer.locations  = @[@(0.0f) ,@(1.0f)];
    
    [self.layer insertSublayer:bgLayer atIndex:0];
}

@end
