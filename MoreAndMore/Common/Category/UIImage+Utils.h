//
//  UIImage+Utils.h
//  SanLianOrdering
//
//  Created by shiqichao on 14-10-21.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIImage *)stretchableImageWithImageNamed:(NSString *)imageNamed;

- (UIImage *)scaleToSize:(CGSize)newsize;

- (UIImage*)imageTransparent:(UIColor*)color Percent:(float)f;

#pragma mark 图片缩放
- (UIImage *)cutCircleImage;

- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

- (UIImage *)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

#pragma mark 图片压缩
+ (NSData *)compressImage:(UIImage *)aSrcImage       //原始图
              andQuality:(CGFloat)aQuality          //图片压缩质量
              andMaxSize:(CGSize)maxSize             //图片最大尺寸，宽*高
        andMaxDataLength:(NSUInteger)maxDataLength; //返回NSData 的长度,单位是KByte

#pragma mark 图片毛玻璃效果
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

#pragma mark 图片旋转
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
