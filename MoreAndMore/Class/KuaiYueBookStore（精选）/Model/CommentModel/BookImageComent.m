//
//  BookImageComent.m
//  MoreAndMore
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookImageComent.h"
#import "MJExtension.h"

#import "NSString+DateUtil.h"
#import "NSObject+ImageUrlManager.h"

@implementation BookImageComent

+(NSArray *)toBookImageComent:(NSArray *)dataAry
{
    // User
    [User setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    [BookImageComent setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];
    
    return [BookImageComent objectArrayWithKeyValuesArray:dataAry];
}

+(NSArray *)toSDTimeLineModelAry:(NSArray *)dataAry
{
    NSMutableArray *newAry = [NSMutableArray arrayWithCapacity:0];
    for (BookImageComent *imageComment in dataAry)
    {
        SDTimeLineCellModel *model = [[SDTimeLineCellModel alloc] init];
        
        model.appType = AppApiTypeOfKuaiKan;
        
        model.modelType = TimeLineModelTypeOfTextOrImg;
        
        model.iconName = [NSObject subFixObjectNeedReplaceIt:[NSMutableString stringWithString:imageComment.user.avatar_url] key:KEY_POINT_W];
        
        model.name = imageComment.user.nickname;
        model.msgContent = imageComment.content;
        
        model.picNamesArray = @[];
        model.likeItemsArray = [@[] mutableCopy];
        model.commentItemsArray= [@[] mutableCopy];
        
        model.liked = NO;
        model.showDel = NO;
        
        model.likesCount = [NSString stringWithFormat:@"%ld",imageComment.likes_count];
        
        model.replyUserId = imageComment.replied_user_id;
        
        if (imageComment.created_at > 0)
        {
            model.timeDescription = [NSString timeIntervalToTimeDescription:imageComment.created_at * 1000 format:FORMAT_ONE];
        }
        
        [newAry addObject:model];
        
    }
    return newAry;
}

+(BookImageComent *)commentWithContent:(NSString *)content isReply:(BOOL)isReply replyComment:(BookImageComent *)comment
{
    BookImageComent *newComment = [[BookImageComent alloc] init];
    newComment.content = content;
    
    newComment.comic_id = comment.comic_id;
    newComment.created_at = [[NSDate date] timeIntervalSince1970];
    newComment.idd = @"666666";
    newComment.is_liked = NO;
    newComment.likes_count = 0;
    
    User *user = [[User alloc] init];
    
    SingletonUser *singleUser = [SingletonUser sharedSingletonUser];
    
    user.idd = singleUser.userInfo.userId;
    user.avatar_url = singleUser.userInfo.avatar;
    user.grade = singleUser.userInfo.isAuth ;
    user.nickname = singleUser.userInfo.userName;
    
    newComment.user = user;
    
    if (isReply) {
        newComment.replied_comment_id = comment.idd;
        newComment.replied_user_id = comment.user.idd;
    }
    
    return newComment;
}

@end
