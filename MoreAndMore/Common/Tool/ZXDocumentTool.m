//
//  ZXDocumentTool.m
//  MoreAndMore
//
//  Created by Silence on 16/6/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "ZXDocumentTool.h"

@implementation ZXDocumentTool

+(NSString *)pathWithType:(DocumentType)type Name:(NSString *)name
{
    NSString *mainPath = nil;
    switch (type) {
        case DocumentTypeOfDefault:
            mainPath = [ZXDocumentTool getDocuments];
            break;
        case DocumentTypeOfCache:
            mainPath = [ZXDocumentTool getCache];
            break;
        case DocumentTypeOfTemp:
            mainPath = [ZXDocumentTool getTemp];
            break;
        case DocumentTypeOfLibrary:
            mainPath = [ZXDocumentTool getLibrary];
            break;
        default:
            NSLog(@"为找到相应类型的路径");
            break;
    }
    if (mainPath.length > 0) {
        mainPath = [mainPath stringByAppendingPathComponent:name];
    }
    return mainPath;
}

/*!
 * 在应用中建立的文件，如数据库等可以放在这里，iTunes备份和恢复的时候会包括此目录。
 */
+(NSString *)getDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

/*!
 * 存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除。
 */
+(NSString *)getCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths[0];
}

/*!
 * 存放及时传送的临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除。
 */
+(NSString *)getTemp
{
    return NSTemporaryDirectory();
}

/*!
 * 应用程序偏好设置，我们经常使用的NSUserDefault就保存在该目录下的一个Plist文件中，iTnues还会同步此文件。
 */
+(NSString *)getLibrary
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}


+(BOOL)isExistInPath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

@end
