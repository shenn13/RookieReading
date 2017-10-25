//
//  Topic.m
//  MoreAndMore
//
//  Created by Silence on 16/7/12.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "Topic.h"
#import "NSObject+ImageUrlManager.h"

#import "MJExtension.h"

@implementation Topic

+(NSArray *)toTopicsArr:(NSArray *)ary
{
    // Topic
    [Topic setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id",@"topic_description":@"description"};
    }];
    
    NSMutableArray *dataAry = [Topic objectArrayWithKeyValuesArray:ary];
    for (Topic *topic in dataAry)
    {
        [Topic handleImageUrl:topic];
        // V2版本idd为空
        if (topic.idd.length < 1 && topic.target_id.length > 0) {
            topic.idd = topic.target_id;
        }
    }
    // 检测是否已经被收藏
    for (Topic *topic in dataAry)
    {
        // 查看是否已经被收藏
        Magic_Topic *local_topic = [[Magic_Topic MR_findByAttribute:@"idd" withValue:topic.idd] lastObject];
        if (local_topic) {
            topic.is_favourite = YES;
        }else{
            topic.is_favourite = NO;
        }
    }
    
    return dataAry;
}

+(Topic *)handleImageUrl:(Topic *)topic
{
    topic.pic = [Topic imageUrlIfNeedExtension:topic.pic extension:PIC_EXTENSION];

    topic.cover_image_url = [Topic imageUrlIfNeedDeleteSpecialStr:topic.cover_image_url extension:PIC_EXTENSION];
    
    return topic;
}

+(Topic *)topicWithMagic:(Magic_Topic *)magic
{
    Topic *topic = [Topic objectWithKeyValues:magic.keyValues];
    return topic;
}

-(Magic_Topic *)magicTopic
{

    Magic_Topic *magic = [Magic_Topic MR_createEntity];
    
    magic.comics_count = [NSNumber numberWithInteger:self.comics_count];
    magic.comments_count = [NSNumber numberWithInteger:self.comments_count];
    magic.cover_image_url = self.cover_image_url;
    magic.created_at = self.created_at;
    magic.discover_image_url = self.discover_image_url;
    magic.idd = self.idd;
    magic.is_favourite = [NSNumber numberWithBool:self.is_favourite];
    magic.label_color = self.label_color;
    magic.label_id = [NSNumber numberWithInteger:self.label_id];
    magic.label_text = self.label_text;
    magic.label_text_color = self.label_text_color;
    magic.likes_count = [NSNumber numberWithInteger:self.likes_count];
    magic.order = [NSNumber numberWithInteger:self.order];
    magic.pic = self.pic;
    magic.recommended_text = self.recommended_text;
    magic.target_id = self.target_id;
    magic.title = self.title;
    magic.topic_description = self.topic_description;
    magic.type = [NSNumber numberWithInteger:self.type];
    magic.updated_at = [NSNumber numberWithInteger:self.updated_at];
    magic.user_id = self.user_id;
    magic.vertical_image_url = self.vertical_image_url;
    
    magic.user = [Magic_User MR_createEntity];
    magic.user.grade = [NSNumber numberWithInteger:self.user.grade];
    magic.user.avatar_url = self.user.avatar_url;
    magic.user.reg_type = self.user.reg_type;
    magic.user.idd = self.user.idd;
    magic.user.nickname = self.user.nickname;
    magic.user.pub_feed = [NSNumber numberWithInteger:self.user.pub_feed];
    return magic;
    
}

-(void)topicCollectBookComplete:(void (^)(BOOL isSuccess))complete
{
    kSelfWeak;
    if (self.is_favourite) // 取消收藏
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此书籍将会从您的书架移除,并删除本地缓存数据！" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                BOOL isSuccess = [Magic_Topic MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"idd == %@", weakSelf.idd]];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    if (!error){
                        NSLog(@"取消收藏成功!");
                    }
                }];
                if (complete) {
                    complete(isSuccess);
                }
            }
        }];
    }
    else  // 收藏
    {
        Magic_Topic *local_topic = [self magicTopic];
        local_topic.is_favourite = @(1);
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            if (error) {
                NSLog(@"收藏图书错误:%@",error);
            }
            BOOL isSuccess = error ? NO : YES;
            if (complete) {
                complete(isSuccess);
            }
        }];
    }
}

+(NSMutableArray *)selectMyCollectBook
{
    NSArray *ary = [Magic_Topic MR_findAll];
    
    return [ary mutableCopy];
}

@end
