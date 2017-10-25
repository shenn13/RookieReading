//
//  UIView+JKPicker.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/11.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "UIView+JKPicker.h"

@implementation UIView (JKPicker)

- (CGFloat)jk_left {
    return self.frame.origin.x;
}

-(void)setJk_left:(CGFloat)jk_left{
    CGRect frame = self.frame;
    frame.origin.x = jk_left;
    self.frame = frame;
}

- (CGFloat)jk_top {
    return self.frame.origin.y;
}

- (void)setJk_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)jk_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setJk_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)jk_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setJk_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)jk_centerX {
    return self.center.x;
}

- (void)setJk_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)jk_centerY {
    return self.center.y;
}

- (void)setJk_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)jk_width {
    return self.frame.size.width;
}

- (void)setJk_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)jk_height {
    return self.frame.size.height;
}

- (void)setJk_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)jk_origin {
    return self.frame.origin;
}

- (void)setJk_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)jk_size {
    return self.frame.size;
}

- (void)setJk_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end

