//
//  TextReviewModel.h
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TextAuthor.h"

@interface TextReviewModel : NSObject

@property (nonatomic,copy)NSString *idd;

@property (nonatomic,strong)TextAuthor *author;

@property (nonatomic,copy)NSString *content;

@property (nonatomic,copy)NSString *created;
/*
 helpful = {
    no = 3098;
    total = 6718;
    yes = 9816;
 };
 */
@property (nonatomic,strong)NSDictionary *helpful;

@property (nonatomic,assign)NSInteger likeCount;

@property (nonatomic,assign)NSInteger rating;

// distillate:精选  normal
@property (nonatomic,copy)NSString *state;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *replyUserId;

@property (nonatomic,copy)NSString *updated;

/**
 *  书荒互助区（扩展属性）
 */
@property (nonatomic,assign)NSInteger commentCount;


+(NSArray *)toTextReviewModelAry:(NSArray *)ary;

/**
 *  将TextReviewModel转换为SDTimeLineCellModel
 */
+(NSArray *)toSDTimeLineModelAry:(NSArray *)dataAry;


+(NSString *)zhuiShuTimeStrToDescription:(NSString *)time;

/**
 *  创建一个快看评论对象
 */
+(TextReviewModel *)commentWithContent:(NSString *)content isReply:(BOOL)isReply replyComment:(TextReviewModel *)comment;

@end
