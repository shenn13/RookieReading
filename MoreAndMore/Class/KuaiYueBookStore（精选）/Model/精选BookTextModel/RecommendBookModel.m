//
//  RecommendBookModel.m
//  MoreAndMore
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "RecommendBookModel.h"

@implementation RecommendBookModel

+(NSArray *)toRecommendBookAry:(NSArray *)ary
{
    [RecommendBookModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"id"};
    }];

    return [RecommendBookModel objectArrayWithKeyValuesArray:ary];
}

+(NSMutableArray *)toRecommendBookAry2:(NSArray *)ary
{
    [RecommendBookModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"idd":@"_id"};
    }];
    
    return [RecommendBookModel objectArrayWithKeyValuesArray:ary];
}

@end
