//
//  UIImage+Utils.m
//  SanLianOrdering
//
//  Created by shiqichao on 14-10-21.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import "UIImage+Utils.h"

#import <Accelerate/Accelerate.h>

@implementation UIImage (Utils)

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)stretchableImageWithImageNamed:(NSString *)imageNamed
{
    UIImage *img=[UIImage imageNamed:imageNamed];
    img=[img stretchableImageWithLeftCapWidth:15 topCapHeight:12];
    return img;
}

/** 设置圆形图片 */
- (UIImage *)cutCircleImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获取上下文
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    // 设置圆形
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctr, rect);
    // 裁剪
    CGContextClip(ctr);
    // 将图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 修改图片大小尺寸
- (UIImage *)scaleToSize:(CGSize)newsize
{
    // 创建一个bitmap的context
    
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(newsize);
    
    // 绘制改变大小的图片
    
    [self drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
    
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

- (UIImage*)imageTransparent:(UIColor*)color Percent:(float)f
{
    // 分配内存
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    // 遍历像素
    // int pixelNum = imageWidth * imageHeight*f;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < imageHeight;i++)
    {
        for(int i = 0;i<imageWidth;i++)
        {
            if ((*pCurPtr & 0xFFFFFF00) == 0xff440000)
                // 将白色变成透明
            {
                uint8_t* ptr = (uint8_t*)pCurPtr;
                ptr[0] = 0x00;
                ptr[1] = 0xff;
                ptr[2] = 0x00;
            }
        }
    }

    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
}

+(NSData *)compressImage:(UIImage *)aSrcImage       //原始图
              andQuality:(CGFloat)aQuality          //图片压缩质量
              andMaxSize:(CGSize)maxSize             //图片最大尺寸，宽*高
        andMaxDataLength:(NSUInteger)maxDataLength{
    
    if (aSrcImage == nil) {
        return nil;
    }
    int imageSize = (int)maxDataLength;
    NSData *ret = nil;
    
    if (aQuality>1 || aQuality < 0.3){
        aQuality = 0.65;
    }
    
    NSLog(@"<_compressAndSend> ========== Start ==========");
    UIImage *image = aSrcImage;
    CGSize sizeBig = aSrcImage.size;
    CGFloat maxLength = (maxSize.width > maxSize.height ? maxSize.width : maxSize.height);
    double rateW = maxLength/sizeBig.width;
    double rateH = maxLength/sizeBig.height;
    double rate = rateW<rateH?rateW:rateH;
    
    image = [aSrcImage scaledImageWithWidth:sizeBig.width*rate andHeight:sizeBig.height*rate];
    NSLog(@"<_compressAndSend> 图片尺寸压缩到 = %f x %f",image.size.width,image.size.height);
    
    //原始图片文件体积
    NSData *data = UIImageJPEGRepresentation(image,aQuality);
    //    NSLog(@"<_compressAndSend> 原始图片文件大小%u,直接发送",[data length]);
    
    //如果文件体积小于  直接发送
    if ([data length] < 1024 * imageSize){
        NSLog(@"<_compressAndSend> 图片文件体积小于%ldK,直接发送",(unsigned long)maxDataLength);
        ret = data;
    }else{
        NSLog(@"<_compressAndSend> 图片文件体积大于%ldK,准备压缩后发送",(unsigned long)maxDataLength);
        NSData *data  = UIImageJPEGRepresentation(image,aQuality);
        NSInteger i = 1;
        while([data length] > 1024 *imageSize)
        {
            NSLog(@"<_compressAndSend> 正在进行第%ld次压缩,压缩前文件体积：%lu",(long)i,(unsigned long)[data length]);
            
            rate = rate * 0.8;
            image = [aSrcImage scaledImageWithWidth:sizeBig.width * rate andHeight:sizeBig.height * rate];
            data = UIImageJPEGRepresentation(image,aQuality);
            NSLog(@"<_compressAndSend> 第%ld次压缩完成,压缩后文件体积：%lu",(long)i,(unsigned long)[data length]);
            i++;
        }
        ret = data;
    }
    return ret;
}


- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGRect rect = CGRectIntegral(CGRectMake(0, 0, aWidth,aHeight));
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGSize endSize = CGSizeMake(aWidth, aHeight);
    CGRect backRect = CGRectMake(0, 0, aWidth, aHeight);
    float imagex =0;
    float imagey =0;
    
    BOOL needBack = NO;
    if (self.size.width > self.size.height)
    {
        aWidth = aWidth > self.size.width ? self.size.width : aWidth;
        imagex =0;
        float ff = self.size.width/aWidth;
        aHeight = self.size.height/ff;
        imagey = (aWidth-aHeight)/2;
        needBack =YES;
        backRect = CGRectMake(0, 0, aWidth, aWidth);
        endSize = CGSizeMake(aWidth, aWidth);
    }
    else if(self.size.width < self.size.height)
    {
        aHeight = aHeight > self.size.height ? self.size.height : aHeight;
        imagey =0;
        float ff = self.size.height /aHeight;
        aWidth = self.size.width/ff;
        imagex = (aHeight-aWidth)/2;
        needBack =YES;
        backRect = CGRectMake(0, 0, aHeight, aHeight);
        endSize = CGSizeMake(aHeight, aHeight);
    }
    else
    {
        aWidth = aWidth > self.size.width ? self.size.width : aWidth;
        aHeight = aHeight > self.size.height ? self.size.height : aHeight;
    }
    CGRect rect = CGRectMake(imagex, imagey, aWidth,aHeight);
    UIGraphicsBeginImageContext(endSize);  //rect.size);
    
    if (needBack)
    {
        // get a reference to that context we created
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIColor *color = [UIColor blackColor];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextAddRect(context, backRect);
        CGContextDrawPath(context,kCGPathFill);
    }
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    //模糊度,
    if ((blur < 0.1f) || (blur > 2.0f)) {
        blur = 0.5f;
    }
    
    //boxSize必须大于0
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    NSLog(@"boxSize:%i",boxSize);
    //图像处理
    CGImageRef img = image.CGImage;
    //需要引入#import <Accelerate/Accelerate.h>
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
