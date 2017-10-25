//
//  TextReviewModel.m
//  MoreAndMore
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "TextReviewModel.h"

#import "SDTimeLineCellModel.h"

@implementation TextReviewModel

+(NSArray *)toTextReviewModelAry:(NSArray *)ary
{
    [TextAuthor setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    [TextReviewModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    return [TextReviewModel objectArrayWithKeyValuesArray:ary];
}

+(NSArray *)toSDTimeLineModelAry:(NSArray *)dataAry
{
    NSMutableArray *newAry = [NSMutableArray arrayWithCapacity:0];
    for (TextReviewModel *reviewModel in dataAry)
    {
        SDTimeLineCellModel *model = [[SDTimeLineCellModel alloc] init];
        
        model.appType = AppApiTypeOfZhuiShu;
        
        model.modelType = TimeLineModelTypeOfTextOrImg;
        
        model.state = reviewModel.state;
        
        model.iconName = ZHUISHU_IMG(reviewModel.author.avatar);
        
        model.name = reviewModel.author.nickname;
        model.msgContent = [NSString stringWithFormat:@"#%@# %@",reviewModel.title,reviewModel.content];
        if (reviewModel.title.length < 1) {
            model.msgContent = reviewModel.content;
        }
        if (reviewModel.content.length < 1) {
            model.msgContent = reviewModel.title;
        }
        
        model.picNamesArray = @[];
        model.likeItemsArray = [@[] mutableCopy];
        model.commentItemsArray= [@[] mutableCopy];
        
        model.liked = NO;
        model.showDel = NO;
        
        model.likesCount = [NSString stringWithFormat:@"%ld",reviewModel.likeCount];
        
        model.replyUserId = reviewModel.replyUserId;
        
        model.timeDescription = [TextReviewModel zhuiShuTimeStrToDescription:reviewModel.created];
        
        [newAry addObject:model];
        
    }
    return newAry;
}

+(NSString *)zhuiShuTimeStrToDescription:(NSString *)time
{
    if (time.length > 0)
    {
        NSArray *component = [time componentsSeparatedByString:@"T"];
        NSString *timeString = [NSString stringWithFormat:@"%@ %@",component[0],[[component[1] componentsSeparatedByString:@"."] firstObject]];
        
        NSDate *theDate = [NSString stringToDateWithFromat:FORMAT_THREE string:timeString];
        time = [NSString timeIntervalToTimeDescription:theDate.timeIntervalSince1970 * 1000.f format:FORMAT_ONE];
    }
    
    return time;
}


+(TextReviewModel *)commentWithContent:(NSString *)content isReply:(BOOL)isReply replyComment:(TextReviewModel *)comment
{
    TextReviewModel *reviewModel = [[TextReviewModel alloc] init];
    reviewModel.idd = @"66666";
    
    // 作者
    SingletonUser *user = [SingletonUser sharedSingletonUser];
    TextAuthor *author = [[TextAuthor alloc] init];
    author.avatar = user.userInfo.avatar;
    author.idd = user.userInfo.userId;
    author.gender = user.userInfo.sex ? @"female" : @"male";
    author.lv = 1;
    author.nickname = user.userInfo.userName;
    
    reviewModel.author = author;
    reviewModel.content = content;
    
    //2016-10-03T05:04:17.675Z
    NSString *theTime = [NSString dateToStringWithFormat:@"yyyy-MM-dd\'T'HH:mm:ss.\'666Z'" date:[NSDate date]];
    
    reviewModel.created = theTime;
    reviewModel.updated = theTime;
    reviewModel.likeCount = 0;
    reviewModel.state = @"normal";
    reviewModel.rating = 0;
    reviewModel.commentCount = 0;
    
    if (isReply)
    {
        reviewModel.content = [NSString stringWithFormat:@"回复@%@:%@",comment.author.nickname,content];
        reviewModel.replyUserId = reviewModel.author.idd;
    }

    return reviewModel;
}

@end
