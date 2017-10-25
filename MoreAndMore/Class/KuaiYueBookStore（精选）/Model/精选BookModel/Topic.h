//
//  Topic.h
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#import "Magic_Topic.h"
#import "Magic_User.h"

@interface Topic : NSObject

@property (nonatomic,assign)NSInteger comics_count;
@property (nonatomic,copy)NSString *cover_image_url;
@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,copy)NSString *discover_image_url;

@property (nonatomic,assign)BOOL is_favourite;
@property (nonatomic,assign)NSInteger label_id;

@property (nonatomic,assign)NSInteger order;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,assign)NSInteger updated_at;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *vertical_image_url;
/*!
 * 转换：description -> topic_description
 */
@property (nonatomic,copy)NSString *topic_description;
/*!
 * 转换：id -> idd
 */
@property (nonatomic,copy)NSString *idd;
/*!
 * user对象
 */
@property (nonatomic,strong)User *user;


/**
 *  V2新增字段
 */
@property (nonatomic,assign)NSInteger comments_count;
@property (nonatomic,assign)NSInteger likes_count;

@property (nonatomic,copy)NSString *label_color;
@property (nonatomic,copy)NSString *label_text;
@property (nonatomic,copy)NSString *label_text_color;
@property (nonatomic,copy)NSString *recommended_text;
@property (nonatomic,copy)NSString *target_id;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,copy)NSString *pic;


+(NSArray *)toTopicsArr:(NSArray *)ary;

+(Topic *)handleImageUrl:(Topic *)topic;

+(Topic *)topicWithMagic:(Magic_Topic *)magic;

-(Magic_Topic *)magicTopic;

/**
 *  收藏、取消收藏书籍
 */
-(void)topicCollectBookComplete:(void(^)(BOOL isSuccess))complete;

/**
 *  数组里面的对象：Magic_Topic
 */
+(NSMutableArray *)selectMyCollectBook;

@end
