//
//  BookImageComent.h
//  MoreAndMore
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "SDTimeLineCellModel.h"

@interface BookImageComent : NSObject

@property (nonatomic,copy)NSString *comic_id;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,assign)NSInteger created_at;
@property (nonatomic,copy)NSString *idd;
@property (nonatomic,assign)BOOL is_liked;
@property (nonatomic,assign)NSInteger likes_count;
@property (nonatomic,copy)NSString *replied_comment_id;
@property (nonatomic,copy)NSString *replied_user_id;

@property (nonatomic,retain)User *user;

+(NSArray *)toBookImageComent:(NSArray *)dataAry;

/**
 *  将BookImageComent转换为SDTimeLineCellModel
 */
+(NSArray *)toSDTimeLineModelAry:(NSArray *)dataAry;

/**
 *  创建一个快看评论对象
 */
+(BookImageComent *)commentWithContent:(NSString *)content isReply:(BOOL)isReply replyComment:(BookImageComent *)comment;

@end
