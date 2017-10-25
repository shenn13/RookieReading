//
//  ZXDocumentTool.h
//  MoreAndMore
//
//  Created by Silence on 16/6/13.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DocumentType){
    DocumentTypeOfDefault = 1,
    DocumentTypeOfCache,
    DocumentTypeOfTemp,
    DocumentTypeOfLibrary
};

@interface ZXDocumentTool : NSObject

/*!
 * 根据类型获取自己所需的路径
 */
+(NSString *)pathWithType:(DocumentType)type Name:(NSString *)name;

/*!
 * DocumentTypeOfDefault
 * 在应用中建立的文件，如数据库等可以放在这里，iTunes备份和恢复的时候会包括此目录。
 */
+(NSString *)getDocuments;

/*!
 * DocumentTypeOfCache
 * 存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除。
 */
+(NSString *)getCache;

/*!
 * DocumentTypeOfTemp
 * 存放及时传送的临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除。
 */
+(NSString *)getTemp;

/*!
 * DocumentTypeOfConfig
 * 应用程序偏好设置，我们经常使用的NSUserDefault就保存在该目录下的一个Plist文件中，iTnues还会同步此文件。
 */
+(NSString *)getLibrary;



@end
