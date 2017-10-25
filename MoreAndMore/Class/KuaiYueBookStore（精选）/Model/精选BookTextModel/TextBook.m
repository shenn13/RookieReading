//
//  TextBook.m
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "TextBook.h"

@implementation TextBook

+(NSArray *)toTextBookAry:(NSArray *)ary
{
    [TextBook setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    return [TextBook objectArrayWithKeyValuesArray:ary];
}

-(Magic_BookText *)toMagicBookText
{
    Magic_BookText *magic = [Magic_BookText MR_createEntity];
    magic.isCollect = [NSNumber numberWithBool:self.isCollect];
    magic.idd = self.idd;
    magic.author = self.author;
    magic.banned = [NSNumber numberWithInteger:self.banned];
    magic.cat = self.cat;
    magic.cover = self.cover;
    magic.latelyFollower = [NSNumber numberWithInteger:self.latelyFollower];
    magic.latelyFollowerBase = [NSNumber numberWithInteger:self.latelyFollowerBase];
    magic.minRetentionRatio = [NSNumber numberWithInteger:self.minRetentionRatio];
    magic.retentionRatio = self.retentionRatio;
    magic.shortIntro = self.shortIntro;
    magic.site = self.site;
    magic.title = self.title;
    return magic;
}

+(TextBook *)toTextBook:(Magic_BookText *)magic
{
    TextBook *book = [TextBook objectWithKeyValues:magic.keyValues];
    book.idd = magic.idd;
    return book;
}

-(void)textBookCollectBookComplete:(void (^)(BOOL))complete
{
    kSelfWeak;
    if (self.isCollect) // 取消收藏
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此书籍将会从您的书架移除,并删除本地缓存数据！" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1)
            {
                BOOL isSuccess = [Magic_BookText MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"idd == %@", weakSelf.idd]];
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
        Magic_BookText *local_textBook = [self toMagicBookText];
        local_textBook.isCollect = @(1);
        
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

-(void)checkItCollected
{
    // 查看是否已经被收藏
    Magic_BookText *magic = [[Magic_BookText MR_findByAttribute:@"idd" withValue:self.idd] lastObject];
    if (magic) {
        self.isCollect = YES;
    }else{
        self.isCollect = NO;
    }
}

+(NSMutableArray *)selectMyCollectBook
{
    NSArray *ary = [Magic_BookText MR_findAll];
    
    return [ary mutableCopy];
}

@end
