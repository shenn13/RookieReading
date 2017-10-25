//
//  CBReaderStyle.h
//  MoreAndMore
//
//  Created by apple on 2017/2/24.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CBReaderStyle : NSObject

+(instancetype)shareStyle;

// 页面转场效果
@property (nonatomic,assign)UIPageViewControllerTransitionStyle transitionType;
// 页面转场方向
@property (nonatomic,assign)UIPageViewControllerNavigationOrientation orientation;

// 文本字体大小
@property (nonatomic,strong)UIFont *font;
// 文本颜色
@property (nonatomic,strong)UIColor *textColor;

// 背景颜色
@property (nonatomic,strong,readonly)NSArray *backColorPool;
@property (nonatomic,strong)UIColor *backColor;

+(NSDictionary *)coreTextAttributes;

@end
