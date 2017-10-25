//
//  UIView+ZXFrame.h
//  MoreAndMore
//
//  Created by Silence on 16/6/1.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZXFrame)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;

@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
