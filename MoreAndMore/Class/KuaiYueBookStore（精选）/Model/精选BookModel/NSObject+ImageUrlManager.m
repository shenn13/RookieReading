//
//  NSObject+ImageUrlManager.m
//  MoreAndMore
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "NSObject+ImageUrlManager.h"

@implementation NSObject (ImageUrlManager)

+(NSString *)imageUrlIfNeedExtension:(NSString *)currentUrl extension:(NSString *)ext
{
    if ([currentUrl hasSuffix:@".webp"])
    {
        NSString *theExt = ext;;
        if (ext.length < 1) {
            theExt = PIC_EXTENSION;
        }
        return [NSString stringWithFormat:@"%@%@",currentUrl,theExt];
    }
    return currentUrl;
}

+(NSString *)imageUrlIfNeedDeleteSpecialStr:(NSString *)currentUrl extension:(NSString *)ext
{
    NSString *myExt = ext;
    if (myExt.length < 1) {
        myExt = PIC_EXTENSION;
    }
    
    if ([currentUrl containsString:KEY_JPG])
    {
        currentUrl = [NSObject containObjetNeedReplaceIt:[currentUrl mutableCopy] key:@".webp"];
    }
    
    if ([currentUrl hasSuffix:@".webp"]) // 如果是webP后缀
    {
        NSMutableString *myString = [NSMutableString stringWithString:currentUrl];
        if ([currentUrl containsString:KEY_W640])
        {
            currentUrl = [NSObject containObjetNeedReplaceIt:myString key:KEY_W640];
        }
        if ([currentUrl containsString:KEY_W750])
        {
            currentUrl = [NSObject containObjetNeedReplaceIt:myString key:KEY_W750];
        }
        currentUrl = [NSString stringWithFormat:@"%@%@",currentUrl,myExt];
    }
    else
    {
        if ([currentUrl hasSuffix:KEY_W750])
        {
            NSString *handleString = [NSObject containObjetNeedReplaceIt:[currentUrl mutableCopy] key:KEY_W750];
            
            currentUrl = [NSString stringWithFormat:@"%@%@",handleString,myExt];
        }
    }
    
    return currentUrl;
}

/**
 *  去掉字符串MyString中的key
 */
+(NSMutableString *)containObjetNeedReplaceIt:(NSMutableString *)myString key:(NSString *)key
{
    NSRange range = [myString rangeOfString:key];
    if (range.location != NSNotFound)
    {
        [myString replaceCharactersInRange:range withString:@""];
    }
    return myString;
}


+(NSMutableString *)subFixObjectNeedReplaceIt:(NSMutableString *)myString key:(NSString *)key
{
    if ([myString hasSuffix:key])
    {
        NSRange range = NSMakeRange(myString.length - key.length, key.length);
        [myString replaceCharactersInRange:range withString:@""];
    }
    return myString;
}

@end
