//
//  NSObject+ImageUrlManager.h
//  MoreAndMore
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_W640  @"-w640"
#define KEY_W750  @"-w750"

#define KEY_JPG   @".jpg"
#define KEY_PNG   @".png"
#define KEY_POINT_W      @".w"

@interface NSObject (ImageUrlManager)

/**
 *  图片URL是否需要添加尾缀
 *  ext传nil则默认为PIC_EXTENSION
 */
+(NSString *)imageUrlIfNeedExtension:(NSString *)currentUrl extension:(NSString *)ext;

/**
 *  是否需要删除多余的部分
 */
+(NSString *)imageUrlIfNeedDeleteSpecialStr:(NSString *)currentUrl extension:(NSString *)ext;

/**
 *  包含某字符
 */
+(NSMutableString *)containObjetNeedReplaceIt:(NSMutableString *)myString key:(NSString *)key;

/**
 *  以某字符结尾
 */
+(NSMutableString *)subFixObjectNeedReplaceIt:(NSMutableString *)myString key:(NSString *)key;

@end
