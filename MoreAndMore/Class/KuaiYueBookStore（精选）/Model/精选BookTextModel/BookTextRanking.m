//
//  BookTextRanking.m
//  MoreAndMore
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookTextRanking.h"

@implementation BookTextRanking

+(BookTextRanking *)toBookTextRanking:(NSDictionary *)dict
{
    [TextBook setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    [BookTextRanking setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id",@"idd2":@"id"};
    }];
    
    [BookTextRanking setupObjectClassInArray:^NSDictionary *{
        return @{@"books":@"TextBook"};
    }];
    
    BookTextRanking *ranking = [BookTextRanking objectWithKeyValues:dict];
    
    for (TextBook *textBook in ranking.books)
    {
        // 查看是否已经被收藏
        [textBook checkItCollected];
    }
    return ranking;
}

@end
