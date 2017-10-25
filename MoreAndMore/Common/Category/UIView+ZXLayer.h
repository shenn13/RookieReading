//
//  UIView+ZXLayer.h
//  schoolfriends
//
//  Created by Silence on 16/6/24.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * 颜色渐变方向
 */
typedef NS_ENUM(NSInteger,ZXLayerDirection){
    ZXLayerDirectionOfTopToBottom,  // 从上往下
    ZXLayerDirectionOfLeftToRight  // 从左往右
};

@interface UIView (ZXLayer)

/*!
 * 为UIView添加一个颜色渐变层
 */
-(void)grandientLayerWithDirection:(ZXLayerDirection)direction color:(UIColor *)color toColor:(UIColor *)toColor;

@end
