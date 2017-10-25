//
//  BookReviewModel.m
//  MoreAndMore
//
//  Created by apple on 16/10/3.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookReviewModel.h"

#import "TextBook.h"

@implementation BookReviewModel

+(NSMutableArray *)toBookReviewModelAry:(NSArray *)ary
{
    [ReviewBook setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    [BookReviewModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    NSMutableArray *newAry = [BookReviewModel objectArrayWithKeyValuesArray:ary];
    
    for (BookReviewModel *model in newAry)
    {
        NSArray *titleAry = @[@"全部类型",
                                     @"玄幻奇幻",
                                     @"武侠仙侠",
                                     @"都市异能",
                                     @"历史军事",
                                     @"游戏竞技",
                                     @"科幻灵异",
                                     @"穿越架空",
                                     @"豪门总裁",
                                     @"现代言情",
                                     @"古代言情",
                                     @"幻想言情",
                                     @"耿美同人"];
        NSArray *tagAry = @[@"all",
                                   @"xhqh",
                                   @"wxxx",
                                   @"dsyn",
                                   @"lsjs",
                                   @"yxjj",
                                   @"khly",
                                   @"cyjk",
                                   @"hmzc",
                                   @"xdyq",
                                   @"gdyq",
                                   @"hxyq",
                                   @"gmtr"];
        NSInteger index = [tagAry indexOfObject:model.book.type];
        if (index != NSNotFound) {
            model.book.typeDesc = titleAry[index];
        }else{
            model.book.typeDesc = @"其他";
        }
    }
    
    return newAry;
}

-(TextBook *)toTextBook
{
    TextBook *textBook = [[TextBook alloc] init];
    textBook.idd = self.book.idd;
    textBook.author = @"";
    textBook.banned = 0;
    textBook.cat = @"";
    textBook.cover = self.book.cover;
    textBook.latelyFollower = 0;
    textBook.latelyFollowerBase= 0;
    textBook.minRetentionRatio = 0;
    textBook.retentionRatio = @"";
    textBook.shortIntro = self.title;
    textBook.site = self.book.site;
    textBook.title = self.book.title;
    return textBook;
}

@end
