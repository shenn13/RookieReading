//
//  TextBook.h
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Magic_BookText.h"

@interface TextBook : NSObject

@property (nonatomic,assign)BOOL isCollect;

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,copy)NSString *author;

@property (nonatomic,assign)NSInteger banned;

@property (nonatomic,copy)NSString *cat;

@property (nonatomic,copy)NSString *cover;

@property (nonatomic,assign)NSInteger latelyFollower;
@property (nonatomic,assign)NSInteger latelyFollowerBase;
@property (nonatomic,assign)NSInteger minRetentionRatio;

@property (nonatomic,copy)NSString *retentionRatio;

@property (nonatomic,copy)NSString *shortIntro;

@property (nonatomic,copy)NSString *site;

@property (nonatomic,copy)NSString *title;

+(NSArray *)toTextBookAry:(NSArray *)ary;

-(Magic_BookText *)toMagicBookText;

+(TextBook *)toTextBook:(Magic_BookText *)magic;

/**
 *  收藏、取消收藏书籍(文字书籍)
 */
-(void)textBookCollectBookComplete:(void(^)(BOOL isSuccess))complete;

/**
 *  数组里面的对象：Magic_TextBook
 */
+(NSMutableArray *)selectMyCollectBook;

-(void)checkItCollected;

@end
